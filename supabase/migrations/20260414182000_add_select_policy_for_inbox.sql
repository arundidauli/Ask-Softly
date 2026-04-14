do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'responses'
      and policyname = 'allow_anon_select_responses'
  ) then
    create policy "allow_anon_select_responses"
    on public.responses
    for select
    to anon
    using (true);
  end if;
end
$$;
