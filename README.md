# 3Lang

Learn German from A1 to C1 in 2 years, with explanations in **English, Dutch
and Spanish**. One Flutter codebase runs on **Android** and the **web**, works
offline, and syncs your progress between devices through Supabase. Everything
uses free tiers and openly licensed content.

Course plan: [Step 1 – course and content architecture](https://claude.ai/artifact/Ttcd9jvsW6yCZg9Bm8YJkK)
(24 months, ~1,250 hours at about 2 hours a day, 6 days a week).

## What's in the repo

```
app/                 Flutter app (Android + web)
  lib/
    core/            env config, providers (Riverpod), router, theme, shared widgets
    data/
      models/        content records (level file) and learner records (synced)
      local/         offline database (sembast: file on Android, IndexedDB on web)
      repositories/  content, settings, flashcards (FSRS), progress, writing
      sync/          two-way Supabase sync (push dirty rows, pull changes)
    srs/fsrs.dart    FSRS-4.5 spaced repetition scheduler
    services/        device text-to-speech, LanguageTool writing checks
    features/
      home/          today: goal, streak, due cards, next lesson
      course/        2-year path, units, lesson player and exercises
      flashcards/    spaced-repetition review
      listening/     dictation
      reading/       texts with glossary and questions
      writing/       free writing checked by LanguageTool
      speaking/      shadowing (listen and repeat)
      progress/      streak, hours, words known, last 7 days
      settings/      app language, explanation language, goals, account, credits
      auth/          email sign-in (only needed for sync)
    l10n/            UI strings: app_en.arb, app_nl.arb, app_es.arb
  assets/content/    bundled level files (a1.json) and course_outline.json
  test/              FSRS, content, streak and screen tests
supabase/migrations/ database schema with row level security
content/
  schema/            JSON Schema for level files
  outline/           A1–C1 outline: 66 units, themes, grammar topics, months
  pipeline/          8-stage Python pipeline from free sources to level files
docs/ARCHITECTURE.md how the pieces fit together
```

## What works today (A1 first slice)

- A1 units 1 to 4 end to end: greetings and introductions, family and
  numbers, home and living, food and drink. Each unit has two vocabulary
  lessons, a grammar lesson, a listening dictation, a reading text with
  questions and a unit review: 100 words and 72 example sentences, all with
  English, Dutch and Spanish.
- Finishing a lesson adds its words to your flashcards, scheduled by FSRS.
- Listening, reading, writing (LanguageTool) and speaking practice screens.
- Study time is tracked for the daily goal, streak and total hours.
- The whole UI switches between English, Nederlands and Español; translations
  and grammar explanations follow a separate "explanation language" setting.
- Everything is saved on the device first. Sync turns on when you add Supabase
  settings and sign in.

Levels A2–C1 appear in the course screen as planned themes until their content
is built with the pipeline.

## Run it

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install)
(stable channel; developed with Flutter 3.50).

```bash
cd app
flutter pub get
flutter run -d chrome          # web
flutter run                    # Android phone or emulator
flutter test                   # tests
```

That runs fully offline with no account. To turn on sync:

1. Create a free project at [supabase.com](https://supabase.com).
2. In the SQL editor, run `supabase/migrations/20261121000000_init.sql`
   (or `supabase db push` with the Supabase CLI).
3. Copy `app/env.example.json` to `app/env.json` and fill in the project URL
   and publishable (anon) key from Project Settings → API. `env.json` is
   git-ignored.
4. Run with `flutter run --dart-define-from-file=env.json`.
5. In the app: Settings → Account and sync → sign in or create an account.
   Sign in with the same account on your phone and in the browser.

### Build for release

```bash
flutter build apk --release --dart-define-from-file=env.json       # Android
flutter build web --release --dart-define-from-file=env.json       # web, output in build/web
```

The web build is a static site: host `build/web` for free on GitHub Pages,
Cloudflare Pages, Netlify or Vercel.

## Content

Course content is plain JSON, one file per level, described by
`content/schema/level.schema.json`. The app never changes it; your progress
points at stable ids like `a1.vocab.haus`, so content can be updated without
touching anyone's progress.

To grow the course, run the pipeline in `content/pipeline/` (see its README):
it downloads Tatoeba, Wiktionary and frequency data, tags words by level, fills
translations, attaches audio, builds lessons, lets you review drafts in a local
web page, and publishes the level file into the app.

Sources and licences: Tatoeba (CC BY 2.0 FR), Wiktionary via kaikki.org
(CC BY-SA), Mozilla Common Voice (CC0), FrequencyWords (CC BY-SA), Piper TTS,
Argos Translate, LanguageTool's free API. Goethe-Institut word lists are used
only as a level checklist and Deutsche Welle is linked, never copied.

## Next steps

1. Write A1 units 5 to 12, or run the pipeline on your own computer (Tatoeba
   and kaikki.org downloads are blocked in the cloud build environment).
2. Add `speech_to_text` to the speaking screen for automatic pronunciation checks.
3. Serve level files from Supabase Storage so new levels arrive without an app update.
4. Re-fit FSRS weights from your own review history after a few months.
5. Mock exams at the end of each level.
