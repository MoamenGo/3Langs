"""Stage 4: make sure every word and sentence has en, nl and es.

Order of preference: Tatoeba translation (from stage 2), Wiktionary English
gloss for words, then an offline draft from Argos Translate marked
needsReview=True. Drafts are fixed by hand in the review page (stage 7).

Outputs: work/words_translated.jsonl, work/sentences_translated.jsonl
"""
from __future__ import annotations

from common import EXPLAIN_LANGS, WORK_DIR, read_jsonl, write_jsonl

try:
    import argostranslate.translate as argos  # optional dependency
except ImportError:  # pragma: no cover
    argos = None


def draft(text: str, target: str) -> str | None:
    if argos is None:
        return None
    try:
        return argos.translate(text, "de", target)
    except Exception:  # model for this pair not installed
        return None


def fill(record: dict, german: str) -> dict:
    tr = dict(record.get("translations") or {})
    if "en" not in tr and record.get("glossEn"):
        tr["en"] = "; ".join(record["glossEn"][:2])
    needs_review = record.get("needsReview", False)
    for lang in EXPLAIN_LANGS:
        if lang not in tr:
            guess = draft(german, lang)
            if guess:
                tr[lang] = guess
            needs_review = True
    return {**record, "translations": tr, "needsReview": needs_review}


def main() -> None:
    if argos is None:
        print("  note: argostranslate not installed; missing translations stay empty and flagged")
    words = [fill(w, w["lemma"]) for w in read_jsonl(WORK_DIR / "words_leveled.jsonl")]
    sents = [fill(s, s["de"]) for s in read_jsonl(WORK_DIR / "sentences_leveled.jsonl")]
    write_jsonl(WORK_DIR / "words_translated.jsonl", words)
    write_jsonl(WORK_DIR / "sentences_translated.jsonl", sents)
    flagged = sum(r["needsReview"] for r in words + sents)
    print(f"words: {len(words)}  sentences: {len(sents)}  needs review: {flagged}")


if __name__ == "__main__":
    main()
