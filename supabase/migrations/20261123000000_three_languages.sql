-- 3Lang phase 1: learn German, Dutch and Spanish at the same time.
--
-- * Explanations and the interface are now Arabic or English (Dutch and
--   Spanish became languages you learn).
-- * Content ids carry their language: 'a1.vocab.haus' -> 'de.a1.vocab.haus'.
-- * One language_tracks row per learner per language (level, unit, plan).
-- The app does the same upgrade on its local data, and also renames old ids
-- it pulls, so the order of app update and migration does not matter.

-- ---------------------------------------------------------------------------
-- Settings
-- ---------------------------------------------------------------------------
alter table public.user_settings
  drop constraint if exists user_settings_ui_language_check,
  drop constraint if exists user_settings_explanation_language_check;

update public.user_settings set ui_language = 'ar' where ui_language not in ('ar','en');
update public.user_settings set explanation_language = 'ar' where explanation_language not in ('ar','en');

alter table public.user_settings
  alter column ui_language set default 'ar',
  alter column explanation_language set default 'ar',
  add constraint user_settings_ui_language_check check (ui_language in ('ar','en')),
  add constraint user_settings_explanation_language_check check (explanation_language in ('ar','en')),
  add column if not exists active_language text not null default 'de'
    check (active_language in ('de','nl','es'));
-- current_level now lives in language_tracks; the column stays for old app
-- builds and is no longer written by new ones.

-- ---------------------------------------------------------------------------
-- One track per language
-- ---------------------------------------------------------------------------
create table public.language_tracks (
  user_id           uuid not null references auth.users on delete cascade,
  lang              text not null check (lang in ('de','nl','es')),
  status            text not null default 'scheduled'
                    check (status in ('scheduled','active','paused')),
  start_date        date,
  current_level     text not null default 'A0'
                    check (current_level in ('A0','A1','A2','B1','B2','C1')),
  current_unit_id   text,
  time_share        real not null default 0.3333 check (time_share between 0 and 1),
  new_cards_per_day int  not null default 10 check (new_cards_per_day between 0 and 100),
  deleted           boolean not null default false,
  updated_at        timestamptz not null default now(),
  primary key (user_id, lang)
);
create index language_tracks_updated_idx on public.language_tracks (user_id, updated_at);

create trigger language_tracks_touch before update on public.language_tracks
  for each row execute function public.touch_updated_at();
alter table public.language_tracks enable row level security;
create policy "own rows" on public.language_tracks for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Existing learners: German keeps their level and starts now; Spanish and
-- Dutch follow the default plan (weeks 3 and 9).
insert into public.language_tracks (user_id, lang, status, start_date, current_level)
select s.user_id, l.lang,
       case when l.lang = 'de' then 'active' else 'scheduled' end,
       current_date + l.offset_days,
       case when l.lang = 'de' then s.current_level else 'A0' end
from public.user_settings s
cross join (values ('de', 0), ('es', 14), ('nl', 56)) as l(lang, offset_days)
on conflict do nothing;

-- ---------------------------------------------------------------------------
-- Language prefix on content ids
-- ---------------------------------------------------------------------------
-- Keyed tables: drop an old row when the app already uploaded the new one.
delete from public.card_states o
where o.card_id ~ '^(a0|a1|a2|b1|b2|c1)\.'
  and exists (select 1 from public.card_states n
              where n.user_id = o.user_id and n.card_id = 'de.' || o.card_id);
update public.card_states set card_id = 'de.' || card_id
where card_id ~ '^(a0|a1|a2|b1|b2|c1)\.';

delete from public.lesson_progress o
where o.lesson_id ~ '^(a0|a1|a2|b1|b2|c1)\.'
  and exists (select 1 from public.lesson_progress n
              where n.user_id = o.user_id and n.lesson_id = 'de.' || o.lesson_id);
update public.lesson_progress set lesson_id = 'de.' || lesson_id
where lesson_id ~ '^(a0|a1|a2|b1|b2|c1)\.';

update public.review_logs set card_id = 'de.' || card_id
where card_id ~ '^(a0|a1|a2|b1|b2|c1)\.';
update public.writing_submissions set prompt_id = 'de.' || prompt_id
where prompt_id ~ '^(a0|a1|a2|b1|b2|c1)\.';

-- Per-language queries (due cards, lessons done) filter on the id prefix.
create index if not exists card_states_lang_due_idx
  on public.card_states (user_id, (split_part(card_id, '.', 1)), due) where not deleted;

-- New sign-ups also get their three tracks.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.user_settings (user_id) values (new.id) on conflict do nothing;
  insert into public.language_tracks (user_id, lang, status, start_date)
  values (new.id, 'de', 'active',    current_date),
         (new.id, 'es', 'scheduled', current_date + 14),
         (new.id, 'nl', 'scheduled', current_date + 56)
  on conflict do nothing;
  return new;
end $$;
