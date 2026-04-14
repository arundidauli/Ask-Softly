create table if not exists public.requests (
  request_id text primary key,
  sender_token text not null,
  sender_name text,
  receiver_name text,
  question text,
  created_at timestamptz not null default now()
);

alter table public.requests enable row level security;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'requests'
      and policyname = 'allow_anon_insert_requests'
  ) then
    create policy "allow_anon_insert_requests"
    on public.requests
    for insert
    to anon
    with check (true);
  end if;
end
$$;

do $$
begin
  if exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'responses'
      and policyname = 'allow_anon_select_responses'
  ) then
    drop policy "allow_anon_select_responses" on public.responses;
  end if;
end
$$;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'responses'
      and policyname = 'allow_sender_token_select_responses'
  ) then
    create policy "allow_sender_token_select_responses"
    on public.responses
    for select
    to anon
    using (
      exists (
        select 1
        from public.requests rq
        where rq.request_id = responses.request_id
          and rq.sender_token = ((current_setting('request.headers', true))::json ->> 'x-sender-token')
      )
    );
  end if;
end
$$;
