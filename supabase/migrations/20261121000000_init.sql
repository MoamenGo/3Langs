-- 3Lang initial schema: learner data only.
-- Course content (words, sentences, lessons) ships inside the app as JSON
-- level files, so the database only stores what is personal to each learner.
--
-- Sync model: every row has updated_at and a soft-delete flag. The app keeps
-- a local copy, pushes rows it changed while offline, and pulls rows changed
-- since its last sync. Last write (by updated_at) wins.

create extension if not exists "pgcrypto";

-- Keep updated_at honest on every write coming from the server side.
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  if new.updated_at is null or new.updated_at < old.updated_at then
    new.updated_at := now();
  end if;
  return new;
end $$;

-- ---------------------------------------------------------------------------
-- Profile and settings
-- ---------------------------------------------------------------------------
create table public.user_settings (
  user_id              uuid primary key references auth.users on delete cascade,
  ui_language          text not null default 'en' check (ui_language in ('en','nl','es')),
  explanation_language text not null default 'en' check (explanation_language in ('en','nl','es')),
  daily_goal_minutes   int  not null default 120 check (daily_goal_minutes between 5 and 600),
  new_cards_per_day    int  not null default 20  check (new_cards_per_day between 0 and 200),
  desired_retention    real not null default 0.9 check (desired_retention between 0.7 and 0.99),
  current_level        text not null default 'A1' check (current_level in ('A1','A2','B1','B2','C1')),
  updated_at           timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Spaced repetition (FSRS) state, one row per learner per card
-- card_id is a content id, for example "a1.vocab.haus" or "a1.sent.0001".
-- ---------------------------------------------------------------------------
create table public.card_states (
  user_id        uuid not null references auth.users on delete cascade,
  card_id        text not null,
  stability      real not null default 0,
  difficulty     real not null default 0,
  reps           int  not null default 0,
  lapses         int  not null default 0,
  state          smallint not null default 0, -- 0 new, 1 learning, 2 review, 3 relearning
  due            timestamptz not null default now(),
  last_review    timestamptz,
  deleted        boolean not null default false,
  updated_at     timestamptz not null default now(),
  primary key (user_id, card_id)
);
create index card_states_due_idx on public.card_states (user_id, due) where not deleted;
create index card_states_updated_idx on public.card_states (user_id, updated_at);

-- Append-only log of every review, used for statistics and to re-fit FSRS weights.
create table public.review_logs (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references auth.users on delete cascade,
  card_id        text not null,
  rating         smallint not null check (rating between 1 and 4), -- again, hard, good, easy
  state_before   smallint not null,
  elapsed_days   real not null,
  scheduled_days real not null,
  reviewed_at    timestamptz not null,
  duration_ms    int,
  updated_at     timestamptz not null default now()
);
create index review_logs_user_idx on public.review_logs (user_id, reviewed_at);
create index review_logs_updated_idx on public.review_logs (user_id, updated_at);

-- ---------------------------------------------------------------------------
-- Course progress
-- ---------------------------------------------------------------------------
create table public.lesson_progress (
  user_id      uuid not null references auth.users on delete cascade,
  lesson_id    text not null,           -- for example "a1.u01.l03"
  status       text not null default 'not_started'
               check (status in ('not_started','in_progress','completed')),
  best_score   real,                    -- 0..1
  attempts     int not null default 0,
  completed_at timestamptz,
  deleted      boolean not null default false,
  updated_at   timestamptz not null default now(),
  primary key (user_id, lesson_id)
);
create index lesson_progress_updated_idx on public.lesson_progress (user_id, updated_at);

-- One row per study session, the source for streaks and hours studied.
create table public.study_sessions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users on delete cascade,
  activity     text not null check (activity in
               ('lesson','review','listening','reading','writing','speaking','exam')),
  started_at   timestamptz not null,
  duration_s   int not null check (duration_s >= 0),
  items_done   int not null default 0,
  local_day    date not null,           -- learner's own calendar day, for streaks
  updated_at   timestamptz not null default now()
);
create index study_sessions_user_day_idx on public.study_sessions (user_id, local_day);
create index study_sessions_updated_idx on public.study_sessions (user_id, updated_at);

-- Writing practice: the learner's texts and the LanguageTool result.
create table public.writing_submissions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users on delete cascade,
  prompt_id    text,
  body         text not null,
  issues       jsonb not null default '[]'::jsonb,
  created_at   timestamptz not null default now(),
  deleted      boolean not null default false,
  updated_at   timestamptz not null default now()
);
create index writing_submissions_updated_idx on public.writing_submissions (user_id, updated_at);

-- ---------------------------------------------------------------------------
-- Triggers and row level security: every learner sees only their own rows.
-- ---------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array['user_settings','card_states','review_logs',
                           'lesson_progress','study_sessions','writing_submissions']
  loop
    execute format(
      'create trigger %I_touch before update on public.%I
         for each row execute function public.touch_updated_at()', t, t);
    execute format('alter table public.%I enable row level security', t);
    execute format(
      'create policy "own rows" on public.%I for all
         using (auth.uid() = user_id) with check (auth.uid() = user_id)', t);
  end loop;
end $$;

-- Create default settings when someone signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.user_settings (user_id) values (new.id) on conflict do nothing;
  return new;
end $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Streak helper used by the progress screen when online.
-- ---------------------------------------------------------------------------
create or replace function public.current_streak(p_user uuid default auth.uid())
returns int language sql stable as $$
  with days as (
    select distinct local_day from public.study_sessions where user_id = p_user
  ), numbered as (
    select local_day, local_day + (row_number() over (order by local_day desc))::int as grp
    from days
  )
  select coalesce(count(*), 0)::int
  from numbered
  where grp = (select grp from numbered order by local_day desc limit 1)
    and (select max(local_day) from days) >= current_date - 1;
$$;
