# Content pipeline

Small Python scripts that turn free sources into the JSON level files the app
reads. Run them from this folder, in order. Everything is free and runs on a
laptop. Downloaded data goes to `content/data/raw/` and is not committed.

```bash
cd content/pipeline
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

| Stage | Script | What it does |
|---|---|---|
| 1 | `01_download.py` | Downloads Tatoeba, Wiktextract (kaikki.org) and FrequencyWords dumps. Common Voice is a manual download. |
| 2 | `02_clean_match.py` | Keeps German entries, joins sentences to nl/en/es translations, and words to Wiktionary details. |
| 3 | `03_tag_levels.py` | Tags words A1–B1 from your Goethe word-list checklists (`content/data/manual/goethe_*.txt`), B2/C1 by frequency. |
| 4 | `04_translate.py` | Fills missing translations with Argos Translate drafts, flagged `needsReview`. |
| 5 | `05_audio.py` | Attaches Tatoeba / Common Voice audio, optionally generates Piper TTS (`--generate`). |
| 6 | `06_build_lessons.py --level A1` | Groups words into units and lessons following `content/outline/course_outline.json`. |
| 7 | `07_review_server.py --level A1` | Local web page at http://localhost:8765 to fix drafted translations. |
| 8 | `08_publish.py --level A1 --bundle` | Merges hand-written grammar/texts, validates, writes `content/build/a1.json` and copies it into the app. |

Other scripts:

- `starter_v2.py` builds every pack the app ships with today: A0 and A1
  (units 1 to 4) for German, Dutch and Spanish, plus `contrast.json`. The
  hand-written data is in `content/data/starter/` (A0 concepts and sentences
  in `a0.py`, A0 sounds and questions grammar in `a0_lang.py`, Dutch and
  Spanish A1 in `a1_nl.py` / `a1_es.py`, Arabic for the shared sentences in
  `a1_shared.py`, false friends in `contrast.py`). German A1 still comes from
  `starter_a1.py` (+ `starter_a1_units.py`), which `starter_v2.py` runs first.
  Re-run `python starter_v2.py` after editing any of them.
- `validate.py <file>` checks a level file against `content/schema/level.schema.json`
  plus cross-references (every lesson item exists, Arabic and English translations present).

Licences: every record keeps `source` and `license`. The app's About screen
lists them. Goethe lists and DW are copyrighted: use Goethe only as a level
checklist and only link to DW.

## Three-language layout (v2)

The app now reads `app/assets/content/{lang}/{level}.json` with ids like
`de.a1.vocab.haus` and explanations in `ar`/`en`. `to_v2.py` converts a v1
file (what `starter_a1.py` and `08_publish.py` still write) into that layout,
adding Arabic from `content/data/manual/ar_de_a1.json`. A `--lang` option for
the download pipeline (stages 01 to 08) comes in phase 4; until then the
starter packs above are written by hand.

Every vocab record has a `conceptId` (`c.a1.house`). The German, Dutch and
Spanish words for one meaning share it, which is how the app links them and
how `starter_v2.py` finds gender mismatches and look-alikes for
`app/assets/content/contrast.json` (schema: `content/schema/contrast.schema.json`).
