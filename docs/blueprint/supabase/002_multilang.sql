-- DRAFT (blueprint, not applied): learner data for three target languages at once.
-- Builds on 20261121000000_init.sql. Same sync rules: updated_at + soft delete, last write wins.

-- 1. Settings: explanation language becomes ar/en; chosen targets stored as an array.
alter table public.user_settings drop constraint if exists user_settings_ui_language_check;
alter table public.user_settings drop constraint if exists user_settings_explanation_language_check;
alter table public.user_settings
  add column if not exists target_languages text[] not null default array['de','es','nl'],
  add constraint user_settings_ui_language_check check (ui_language in ('ar','en')),
  add constraint user_settings_explanation_language_check check (explanation_language in ('ar','en'));
-- current_level moves to language_tracks; keep the column until the app no longer reads it.

-- 2. One row per learner per language.
create table public.language_tracks (
  user_id         uuid not null references auth.users on delete cascade,
  lang            text not null check (lang in ('de','nl','es')),
  status          text not null default 'active' check (status in ('scheduled','active','paused')),
  start_date      date,
  current_level   text not null default 'A0' check (current_level in ('A0','A1','A2','B1','B2','C1')),
  current_unit_id text,                         -- e.g. 'u.a1.03'
  time_share      real not null default 0.33 check (time_share between 0 and 1),
  new_cards_per_day int not null default 10 check (new_cards_per_day between 0 and 100),
  fsrs_weights    real[],                       -- personal weights once enough reviews exist
  deleted         boolean not null default false,
  updated_at      timestamptz not null default now(),
  primary key (user_id, lang)
);

-- 3. Language column on existing learner tables (derived from the id prefix for old rows).
alter table public.card_states     add column if not exists lang text;
alter table public.review_logs     add column if not exists lang text,
                                   add column if not exists interference_lang text;
alter table public.lesson_progress add column if not exists lang text;
update public.card_states     set lang = 'de' where lang is null;
update public.review_logs     set lang = 'de' where lang is null;
update public.lesson_progress set lang = 'de' where lang is null;
-- Old ids 'a1.vocab.haus' are renamed to 'de.a1.vocab.haus' by the app on first launch
-- (local DB first, then pushed), so the server only ever sees the new ids.
create index if not exists card_states_lang_due_idx on public.card_states (user_id, lang, due) where not deleted;

-- 4. Interference: you answered with a word from another language.
create table public.interference_events (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references auth.users on delete cascade,
  expected_lang text not null check (expected_lang in ('de','nl','es')),
  intruder_lang text not null check (intruder_lang in ('de','nl','es')),
  item_id       text not null,                  -- the card or exercise item
  answer        text not null,
  contrast_id   text,                           -- matching pair in contrast.json, if any
  occurred_at   timestamptz not null,
  updated_at    timestamptz not null default now()
);
create index interference_user_idx on public.interference_events (user_id, occurred_at);

-- 5. Placement tests and end-of-level exams, per language and skill.
create table public.level_assessments (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users on delete cascade,
  lang        text not null check (lang in ('de','nl','es')),
  kind        text not null check (kind in ('placement','unit','level')),
  level       text not null,
  scores      jsonb not null,                   -- {"listening":0.8,"reading":0.75,"writing":0.6,"speaking":0.7}
  passed      boolean not null,
  taken_at    timestamptz not null,
  updated_at  timestamptz not null default now()
);

-- 6. Study sessions record minutes per language.
alter table public.study_sessions add column if not exists minutes_by_lang jsonb;

-- 7. Row level security, same pattern as init.
alter table public.language_tracks     enable row level security;
alter table public.interference_events enable row level security;
alter table public.level_assessments   enable row level security;
create policy own_rows on public.language_tracks     for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own_rows on public.interference_events for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy own_rows on public.level_assessments   for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
