"""Stage 6: group words and sentences into units and lessons following the
course outline (content/outline/course_outline.json).

Each unit in the outline lists topic keywords and grammar ids. Words are
assigned to the first unit of their level whose keywords match their English
gloss, then the rest are spread by frequency. About 8 to 12 new words per
vocab lesson; each unit ends with a review lesson.

Output: work/<level>.draft.json  (same shape as the published level file)
"""
from __future__ import annotations

import argparse
import json

from common import CONTENT_DIR, EXPLAIN_LANGS, WORK_DIR, read_jsonl, slug

WORDS_PER_LESSON = 10
SENTENCES_PER_WORD = 3


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--level", default="A1")
    args = ap.parse_args()
    lvl = args.level
    outline = json.loads((CONTENT_DIR / "outline" / "course_outline.json").read_text(encoding="utf-8"))
    level_outline = next(l for l in outline["levels"] if l["id"] == lvl)

    words = sorted((w for w in read_jsonl(WORK_DIR / "words_audio.jsonl") if w["level"] == lvl),
                   key=lambda w: w.get("freqRank") or 10**9)
    sentences = [s for s in read_jsonl(WORK_DIR / "sentences_audio.jsonl") if s["level"] <= lvl]
    by_token: dict[str, list[dict]] = {}
    for s in sentences:
        for tok in set(s["tokens"]):
            by_token.setdefault(tok, []).append(s)

    units_out, lessons_out, vocab_out, sent_out = [], [], [], {}
    pool = list(words)
    for u_index, unit in enumerate(level_outline["units"], start=1):
        uid = f"{lvl.lower()}.u{u_index:02d}"
        keys = [k.lower() for k in unit.get("keywords", [])]
        chosen = [w for w in pool if any(k in " ".join(w.get("glossEn", [])).lower() for k in keys)]
        chosen += [w for w in pool if w not in chosen][: max(0, unit.get("newWords", 30) - len(chosen))]
        chosen = chosen[: unit.get("newWords", 30)]
        pool = [w for w in pool if w not in chosen]

        lesson_ids = []
        for i in range(0, len(chosen), WORDS_PER_LESSON):
            chunk = chosen[i:i + WORDS_PER_LESSON]
            lid = f"{uid}.l{len(lesson_ids) + 1:02d}"
            item_ids = []
            for w in chunk:
                vid = f"{lvl.lower()}.vocab.{slug(w['lemma'])}"
                examples = by_token.get(w["lemma"].lower(), [])[:SENTENCES_PER_WORD]
                for s in examples:
                    sent_out.setdefault(s["tatoebaId"], s)
                vocab_out.append({
                    "id": vid, "lemma": w["lemma"], "article": w.get("article"), "plural": w.get("plural"),
                    "pos": w["pos"], "level": lvl, "freqRank": w.get("freqRank"), "ipa": w.get("ipa"),
                    "audio": w.get("audio"), "translations": w["translations"],
                    "sentenceIds": [f"{lvl.lower()}.sent.t{s['tatoebaId']}" for s in examples],
                    "source": w["source"], "license": w["license"], "needsReview": w.get("needsReview", False),
                })
                item_ids.append(vid)
            lessons_out.append({"id": lid, "unitId": uid, "order": len(lesson_ids) + 1, "type": "vocab",
                                "title": unit["theme"], "items": item_ids})
            lesson_ids.append(lid)
        review_id = f"{uid}.l{len(lesson_ids) + 1:02d}"
        lessons_out.append({"id": review_id, "unitId": uid, "order": len(lesson_ids) + 1, "type": "review",
                            "title": {lang: "Review" for lang in EXPLAIN_LANGS},
                            "items": [i for l in lessons_out if l["unitId"] == uid for i in l["items"]]})
        lesson_ids.append(review_id)
        units_out.append({"id": uid, "level": lvl, "order": u_index, "theme": unit["theme"],
                          "goals": unit.get("goals", []), "grammarIds": unit.get("grammar", []),
                          "lessonIds": lesson_ids})

    draft = {
        "schemaVersion": 1, "contentVersion": "draft",
        "level": {"id": lvl, "title": level_outline["title"], "targetHours": level_outline["targetHours"],
                  "canDo": level_outline.get("canDo", [])},
        "units": units_out, "lessons": lessons_out, "vocab": vocab_out,
        "sentences": [{"id": f"{lvl.lower()}.sent.t{s['tatoebaId']}", "de": s["de"],
                       "translations": s["translations"], "audio": s.get("audio"),
                       "source": s["source"], "license": s["license"],
                       "needsReview": s.get("needsReview", False)} for s in sent_out.values()],
        "grammar": [], "texts": [], "writingPrompts": [], "credits": [],
    }
    out = WORK_DIR / f"{lvl.lower()}.draft.json"
    out.write_text(json.dumps(draft, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"wrote {out}: {len(units_out)} units, {len(lessons_out)} lessons, {len(vocab_out)} words")


if __name__ == "__main__":
    main()
