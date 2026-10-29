# Build Your First AI Project in 60 Minutes – Growth Engine
Registration + referral leaderboard + AI project evaluator. Static front end, Supabase (database), Vercel function (AI).

## Setup (≈10 min)
1. **Supabase**: new project → SQL editor → run `schema.sql`. Copy Project URL + anon key into `config.js`.
2. **Push** this folder to your GitHub repo (`git add . && git commit -m "growth engine v2" && git push`).
3. **Vercel**: Import the repo → add env var `ANTHROPIC_API_KEY` → Deploy. (GitHub Pages can't hold the API key, so use Vercel for the evaluator.)
4. Open the site, register, check the Supabase `registrations` table.

Referral links look like `https://your-site.vercel.app/?ref=ABC123`.
