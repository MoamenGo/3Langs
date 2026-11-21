"""Validate level files: JSON schema plus cross-reference checks.

    python validate.py ../../app/assets/content/a1.json
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from common import EXPLAIN_LANGS, SCHEMA_PATH


def validate_level(data: dict) -> list[str]:
    errors: list[str] = []
    try:
        import jsonschema
        schema = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))
        v = jsonschema.Draft202012Validator(schema)
        errors += [f"{'/'.join(map(str, e.path))}: {e.message}" for e in v.iter_errors(data)]
    except ImportError:
        print("  note: jsonschema not installed, running reference checks only")

    ids: dict[str, set[str]] = {k: {r["id"] for r in data.get(k, [])}
                                for k in ("units", "lessons", "vocab", "sentences", "grammar", "texts")}
    all_ids = [r["id"] for k in ids for r in data.get(k, [])]
    dupes = {i for i in all_ids if all_ids.count(i) > 1}
    errors += [f"duplicate id {d}" for d in sorted(dupes)]

    for u in data.get("units", []):
        errors += [f"{u['id']}: unknown lesson {l}" for l in u["lessonIds"] if l not in ids["lessons"]]
    for l in data.get("lessons", []):
        if l["unitId"] not in ids["units"]:
            errors.append(f"{l['id']}: unknown unit {l['unitId']}")
        pool = ids["sentences"] if l["type"] == "listening" else ids["vocab"]
        errors += [f"{l['id']}: unknown item {i}" for i in l.get("items", []) if i not in pool]
        if l["type"] == "grammar" and l.get("grammarId") not in ids["grammar"]:
            errors.append(f"{l['id']}: unknown grammar {l.get('grammarId')}")
        if l["type"] == "reading" and l.get("textId") not in ids["texts"]:
            errors.append(f"{l['id']}: unknown text {l.get('textId')}")
    for w in data.get("vocab", []):
        errors += [f"{w['id']}: unknown sentence {s}" for s in w.get("sentenceIds", []) if s not in ids["sentences"]]
        missing = [lang for lang in EXPLAIN_LANGS if not w["translations"].get(lang)]
        if missing and not w.get("needsReview"):
            errors.append(f"{w['id']}: missing translations {missing}")
    for t in data.get("texts", []):
        errors += [f"{t['id']}: unknown glossary word {g}" for g in t.get("glossary", []) if g not in ids["vocab"]]
    return errors


def main() -> None:
    bad = 0
    for arg in sys.argv[1:]:
        data = json.loads(Path(arg).read_text(encoding="utf-8"))
        errors = validate_level(data)
        print(f"{arg}: {'OK' if not errors else f'{len(errors)} errors'}")
        for e in errors[:50]:
            print("  -", e)
        bad += bool(errors)
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
