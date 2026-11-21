# Architecture

## Big picture

```
 free sources ──► content pipeline (Python) ──► level files (JSON) ──► app assets / Storage
                                                                       │
                       ┌───────────────────────────────────────────────┘
                       ▼
   Flutter app (Android + web)
   ┌───────────────────────────────────────────────┐
   │ features/*  screens                            │
   │ core/providers.dart  Riverpod wiring           │
   │ repositories  content | srs | progress | ...   │
   │ local DB (sembast)  ◄── offline-first          │
   └────────────────────┬──────────────────────────┘
                        │ sync_service.dart (when online and signed in)
                        ▼
   Supabase (free tier): Auth + Postgres with row level security
```

## Two kinds of data

| | Course content | Learner data |
|---|---|---|
| What | levels, units, lessons, words, sentences, grammar, texts | settings, card states, review logs, lesson progress, study sessions, writing |
| Where | JSON level files bundled in `app/assets/content/` | local DB on the device, mirrored to Supabase |
| Who writes | the pipeline | the app |
| Ids | stable: `a1.u01.l03`, `a1.vocab.heissen`, `a1.sent.s001` | rows keyed by those ids |

Keeping them apart means a content update never touches progress.

## Offline-first sync

- Every write goes to the local database first, marked `_dirty`.
- `SyncService` runs on app start, when the network returns, every 5 minutes,
  and 10 seconds after local changes.
- **Push**: upsert every dirty row to Supabase with the user's id, then mark it
  clean if it didn't change meanwhile.
- **Pull**: fetch rows with `updated_at` newer than the last pull (minus a
  5-minute overlap for clock differences). A local row that is dirty and newer
  wins; otherwise the server row replaces it.
- Review logs and study sessions are append-only, so they never conflict.
- Without Supabase settings, or signed out, sync is off and the app still works.

## Spaced repetition

`lib/srs/fsrs.dart` implements FSRS-4.5 with the default weights. Each card
stores stability, difficulty, state and due date. Ratings: Again, Hard, Good,
Easy. Desired retention (default 0.9) is a user setting. Every answer is logged
in `review_logs`, which later lets us fit personal weights.

## Localisation

- UI strings: `app/lib/l10n/app_{en,nl,es}.arb`, generated with `flutter gen-l10n`.
- Course explanations: every content record carries `en`, `nl` and `es`; the
  "explanation language" setting picks one, independent of the UI language.
- German audio: device text-to-speech now; recorded audio (Tatoeba, Common
  Voice) or Piper files when the pipeline provides them.

## Adding a feature module

1. Create `app/lib/features/<name>/<name>_screen.dart`.
2. Add a route in `app/lib/core/router.dart`.
3. Wrap study screens in `StudyTimer(activity: ...)` so time counts toward goals.
4. Add any new strings to all three `.arb` files.
5. If it stores learner data: add a table + RLS policy in a new migration, a
   `SyncedTable` in `local_db.dart`, and write with `putLocal`.
