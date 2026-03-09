# Sailboat Market Analyzer

A tool for evaluating and comparing bluewater sailboat designs, tracking live listings, and generating AI-powered buying analysis. Built for sailors navigating the multi-year process of finding the right boat.

## What it does

1. **Scored design database** — 30+ bluewater-capable sailboat designs scored across 7 use cases (bluewater, coastal, singlehand, liveaboard, upwind, downwind, Pacific-ready). Scores are computed from real design specs: displacement ratios, capsize screening, motion comfort, rig type, keel/rudder configuration, and more.

2. **Preference filtering** — filter designs by cockpit type, rig, size range, budget, and exclusions (teak decks, canoe stern). Preferences are saved per user.

3. **Live BoatTrader integration** — search current-for-sale listings for any design. Track listings to your watchlist with price, location, and specs.

4. **AI analysis prompts** — generate comprehensive prompts that include your buyer profile, preferences, full design specs, score breakdowns, and listing URLs. Paste into [claude.ai](https://claude.ai) for expert-level buying analysis including price evaluation, refit estimates, survey focus areas, and delivery logistics.

5. **Named sessions** — save and resume exploration sessions ("PNW Singlehand", "Caribbean Bluewater"). Each session preserves your use case, preferences, step, and tracked listings.

## Tech stack

- **Frontend**: SvelteKit + Svelte 5 (runes), Tailwind CSS v4
- **Backend**: Supabase (Postgres, Auth with magic link, Row-Level Security)
- **Data**: BoatTrader undocumented API for live listings
- **Deployment**: Vercel (adapter-auto)

## Getting started

```sh
# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Fill in SUPABASE_URL, SUPABASE_ANON_KEY, BOATTRADER_API_KEY

# Run database migrations
npx supabase db push

# Start dev server
npm run dev
```

## Environment variables

| Variable | Description |
|---|---|
| `PUBLIC_SUPABASE_URL` | Supabase project URL |
| `PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous key |
| `BOATTRADER_API_KEY` | BoatTrader API key for listing search |

## Project structure

```
src/
  lib/
    seed-data.ts        # 30+ boat designs with full specs
    scoring.ts          # Use-case scoring algorithms
    prompt-builder.ts   # AI prompt generation (boat detail page)
    boattrader.ts       # BoatTrader API client
    session.svelte.ts   # Session state management (Svelte 5 runes)
    auth.svelte.ts      # Auth state management
    comp-finder.ts      # Comparable sales scoring
    types.ts            # TypeScript interfaces
    utils.ts            # Formatting helpers
    components/         # Svelte components
  routes/
    +page.svelte        # Guided flow (Use Case → Preferences → Designs → Listings)
    boats/[id]/         # Boat detail with scores, listings, and prompt
    guide/              # User guide
    api/boattrader/     # Server-side BoatTrader proxy
    auth/callback/      # Supabase auth callback
supabase/
  migrations/           # Database schema
```

## Database schema

- **user_preferences** — cockpit, rig, size, budget, exclusions per user
- **listings** — community-submitted boat listings with condition data
- **comps** — reported sale prices for comparable sales
- **watchlist** — tracked BoatTrader listings with price history
- **price_history** — price snapshots for watchlist items
- **exploration_sessions** — named sessions with saved state

## Scoring

Each boat is scored 0–100 across use cases. Key factors:

| Factor | Bluewater weight | Singlehand weight |
|---|---|---|
| D/L Ratio | High | Medium |
| Capsize Screening | High | Medium |
| Rudder Type | High | Medium |
| Cockpit Type | Medium | High |
| Rig Type | Medium | High |
| Self-Steering | Low | High |
| LOA | Low | High |

See the [in-app guide](/guide) for a full explanation of scores and metrics.
