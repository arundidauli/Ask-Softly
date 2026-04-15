# Repository Guidelines

## Project Structure & Module Organization
This repository is a static, mobile-first web app. Keep runtime code at the root for now:

- `index.html`: app shell, meta tags, inline config, and static markup.
- `app.js`: sender/receiver flow logic, URL state, Supabase integration, and UI behavior.
- `styles.css`: shared visual system and responsive styles.
- `questions.js`: relationship- and language-specific prompt data.
- `supabase/migrations/`: schema and RLS changes; add one migration per database change.
- `supabase/config.toml`: local Supabase CLI configuration.

## Build, Test, and Development Commands
There is no package manifest or bundled build step. Use simple local serving and Supabase CLI commands:

- `python3 -m http.server 8000`: serve the app locally at `http://localhost:8000`.
- `open index.html`: quick manual check when a local server is not required.
- `supabase start`: boot the local Supabase stack.
- `supabase db reset`: apply migrations from `supabase/migrations/` to a fresh local database.
- `netlify deploy --prod --dir .`: deploy the static site after validation.

## Coding Style & Naming Conventions
Use 2-space indentation in HTML, CSS, and JavaScript. Prefer `const`/`let`, early returns, and small DOM-focused helpers over deeply nested branches. Use `camelCase` for variables and functions, kebab-case for CSS classes, and uppercase snake case only for shared config constants such as `SUPABASE_URL`. Keep copy changes aligned with the product tone: warm, direct, and mobile-first.

## Testing Guidelines
No automated test suite exists yet, so every change requires manual verification. Test both sender and receiver flows, short-link loading (`?req=...`), WhatsApp fallback, and Supabase-backed answer capture. For UI work, verify layout and animation behavior on a narrow mobile viewport before shipping. If a change affects data access, validate the related migration and RLS behavior locally with Supabase.

## Commit & Pull Request Guidelines
Recent commits use short, imperative, sentence-case summaries such as `Fix receiver identity clarity and resilient inbox answer retrieval.` Follow that pattern and keep each commit scoped to one change. PRs should include:

- a concise summary of user-visible behavior
- linked issue or task reference when available
- screenshots or screen recordings for UI changes
- notes for config or migration changes, especially under `supabase/migrations/`
