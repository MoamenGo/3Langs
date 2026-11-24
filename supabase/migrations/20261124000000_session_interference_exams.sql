-- 3Lang phases 3-5: mix-ups between languages and level results.
--
-- * interference_events: an answer that came from the wrong language
--   (append only, like review_logs). Feeds the daily contrast drill.
-- * level_assessments: placement tests and end-of-level exams.

create table public.interference_events (
  user_id     uuid not null references auth.users on delete cascade,
  id          uuid not null,
  lang        text not null check (lang in ('de','nl','es')),
  other_lang  text not null check (other_lang in ('de','nl','es')),
  concept_id  text,
  kind        text not null default 'same_concept'
              check (kind in ('same_concept','confusable')),
  expected    text not null,
  given       text not null,
  occurred_at timestamptz not null,
  updated_at  timestamptz not null default now(),
  primary key (id)
);
create index interference_events_user_idx on public.interference_events (user_id, updated_at);
alter table public.interference_events enable row level security;
create policy "own rows" on public.interference_events for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table public.level_assessments (
  user_id    uuid not null references auth.users on delete cascade,
  id         uuid not null,
  lang       text not null check (lang in ('de','nl','es')),
  level      text not null check (level in ('A0','A1','A2','B1','B2','C1')),
  kind       text not null check (kind in ('placement','exam')),
  score      real not null check (score between 0 and 1),
  passed     boolean not null,
  taken_at   timestamptz not null,
  updated_at timestamptz not null default now(),
  primary key (id)
);
create index level_assessments_user_idx on public.level_assessments (user_id, updated_at);
alter table public.level_assessments enable row level security;
create policy "own rows" on public.level_assessments for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
