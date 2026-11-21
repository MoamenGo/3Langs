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

- `starter_a1.py` writes the hand-checked A1 starter file the app ships with
  today (unit 1 complete, unit 2 started). Re-run it after editing it.
- `validate.py <file>` checks a level file against `content/schema/level.schema.json`
  plus cross-references (every lesson item exists, all three translations present).

Licences: every record keeps `source` and `license`. The app's About screen
lists them. Goethe lists and DW are copyrighted: use Goethe only as a level
checklist and only link to DW.
