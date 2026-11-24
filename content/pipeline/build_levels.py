"""Build the course packs after the starter: A1 units 5-12, then A2, B1, B2
and C1, for German, Dutch and Spanish (phases 4 and 5).

    python content/pipeline/starter_v2.py          # A0 + A1 units 1-4 first
    python content/pipeline/build_levels.py        # all languages, all levels
    python content/pipeline/build_levels.py --lang nl --level B1

The hand-written data is in content/data/levels/{a1,a2,b1,b2,c1}.py: one
shared table per unit (a concept per row, with the word in all three
languages and its Arabic and English meaning), example sentences in all three
languages, and a grammar point per language. Each unit becomes five lessons:
two vocabulary lessons, grammar, listening (dictation of the unit's
sentences) and a unit review. The last unit of each level is its review and
mock exam; passing the exam moves the learner to the next level.
"""
from __future__ import annotations

import argparse
import importlib
import json
import sys
from pathlib import Path

from common import APP_CONTENT_DIR, slug

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "content" / "data"))
sys.path.insert(0, str(Path(__file__).resolve().parent))

import starter_v2  # noqa: E402

LANGS = ("de", "nl", "es")
LEVELS = ("A1", "A2", "B1", "B2", "C1")
VERSION = "2026.11.24-phase5"
SRC, LIC = "3lang-original", "CC BY-SA 4.0"
OUTLINE = json.loads((ROOT / "content" / "outline" / "course_outline.json").read_text(encoding="utf-8"))
ARTICLES = {"der", "die", "das", "de", "het", "el", "la", "los", "las"}
POS = {"n": "noun", "v": "verb", "adj": "adjective", "adv": "adverb", "phr": "phrase",
       "prep": "preposition", "conj": "conjunction", "pron": "pronoun", "num": "numeral",
       "int": "interjection"}
LANG_COL = {"de": 0, "nl": 1, "es": 2}
NAMES = {"de": ("German", "الألماني"), "nl": ("Dutch", "الهولندي"), "es": ("Spanish", "الإسباني")}


def parse_word(cell: str):
    """'der Bahnhof, Bahnhöfe' -> ('Bahnhof', 'der', 'Bahnhöfe')."""
    cell = cell.strip()
    plural = None
    if "," in cell:
        cell, plural = (x.strip() for x in cell.split(",", 1))
        plural = plural or None
    parts = cell.split(" ", 1)
    if len(parts) == 2 and parts[0] in ARTICLES:
        return parts[1], parts[0], plural
    return cell, None, plural


def rows(block: str, n: int) -> list[list[str]]:
    out = []
    for line in block.strip().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        cells = [c.strip() for c in line.split("|")]
        if len(cells) != n:
            raise ValueError(f"expected {n} cells, got {len(cells)}: {line}")
        out.append(cells)
    return out


def outline_level(level: str) -> dict:
    return next(l for l in OUTLINE["levels"] if l["id"] == level)


def parse_display(cell: str) -> str:
    lemma, article, _ = parse_word(cell)
    return f"{article} {lemma}" if article else lemma


def skipped_concepts(level: str, data) -> set[str]:
    """Rows whose word, in any of the three languages, is already taught in a
    lower level (or A1 units 1-4) or earlier in this level. Skipping the whole
    row keeps the three courses teaching the same concepts."""
    order = ["A0", "A1", "A2", "B1", "B2", "C1"]
    seen = {l: set() for l in LANGS}
    for lang in LANGS:
        for lv in order[: order.index(level) + 1]:
            f = APP_CONTENT_DIR / lang / f"{lv.lower()}.json"
            if not f.exists() or (lv == level and level != "A1"):
                continue
            for v in json.loads(f.read_text(encoding="utf-8"))["vocab"]:
                seen[lang].add(f"{v['article']} {v['lemma']}" if v.get("article") else v["lemma"])
    skip = set()
    for u in data.UNITS:
        for r in rows(u["words"], 7):
            disp = {l: parse_display(r[4 + LANG_COL[l]]) for l in LANGS}
            dup = [l for l in LANGS if disp[l] in seen[l]]
            if dup:
                print(f"  skip {level} {u['key']} {r[0]}: already taught in {', '.join(dup)}")
                skip.add(r[0])
                continue
            for l in LANGS:
                seen[l].add(disp[l])
    return skip


def build_units(lang: str, level: str, data, taken: set, start_order: int, skip: set):
    """Units, lessons, vocab, sentences, grammar and writing for one level."""
    lv = level.lower()
    p = f"{lang}.{lv}."
    col = LANG_COL[lang]
    out = {k: [] for k in ("units", "lessons", "vocab", "sentences", "grammar", "writingPrompts")}
    oul = outline_level(level)
    en_name, ar_name = NAMES[lang]
    for u in data.UNITS:
        key = u["key"]
        order = int(key[1:])
        if order < start_order:
            continue
        shared = next(x for x in oul["units"] if x["order"] == order)
        theme = shared["theme"]
        uid = f"{p}{key}"
        # Sentences.
        sent_ids = []
        for i, (en, ar, *forms) in enumerate(rows(u["sentences"], 5), start=1):
            sid = f"{p}sent.{key}_{i:02d}"
            out["sentences"].append({
                "id": sid, "text": forms[col], "translations": {"ar": ar, "en": en},
                "source": SRC, "license": LIC, "needsReview": False,
            })
            sent_ids.append(sid)
        # Words.
        word_ids = []
        unit_vocab = []
        for concept, pos, en, ar, *forms in [r for r in rows(u["words"], 7) if r[0] not in skip]:
            lemma, article, plural = parse_word(forms[col])
            e = starter_v2.vocab_entry(lang, level, lemma, article, plural, POS.get(pos, pos),
                                       en, ar, concept, taken)
            unit_vocab.append(e)
            word_ids.append(e["id"])
        starter_v2.link_sentences(lang, unit_vocab, out["sentences"][-len(sent_ids):])
        out["vocab"].extend(unit_vocab)
        # Grammar.
        g = u["grammar"][lang]
        gid = f"{p}gram.{key}"
        out["grammar"].append({
            "id": gid, "level": level,
            "title": {"en": g["title"][0], "ar": g["title"][1]},
            "explanation": {"en": g["text"][0], "ar": g["text"][1]},
            "table": {"headers": g["table"][0], "rows": g["table"][1:]} if g.get("table") else None,
            "exampleSentenceIds": sent_ids[:2],
            "exercises": [{"type": "fill_blank", "prompt": pr, "answer": a, "base": b}
                          for pr, a, b in g["exercises"]],
            "source": SRC, "license": LIC,
        })
        if out["grammar"][-1]["table"] is None:
            del out["grammar"][-1]["table"]
        half = (len(word_ids) + 1) // 2
        lessons = [
            ("vocab", {"en": f"{theme['en']}: words 1", "ar": f"{theme['ar']}: كلمات 1"}, word_ids[:half]),
            ("vocab", {"en": f"{theme['en']}: words 2", "ar": f"{theme['ar']}: كلمات 2"}, word_ids[half:]),
            ("grammar", {"en": g["title"][0], "ar": g["title"][1]}, []),
            ("listening", {"en": f"Listen: {theme['en'].lower()}", "ar": f"استماع: {theme['ar']}"}, sent_ids),
            ("review", {"en": f"Unit {order} review", "ar": f"مراجعة الوحدة {order}"}, word_ids),
        ]
        lesson_ids = []
        for n, (ltype, title, items) in enumerate(lessons, start=1):
            lid = f"{uid}.l{n:02d}"
            lesson = {"id": lid, "unitId": uid, "order": n, "type": ltype, "title": title, "items": items}
            if ltype == "grammar":
                lesson["grammarId"] = gid
            out["lessons"].append(lesson)
            lesson_ids.append(lid)
        out["units"].append({
            "id": uid, "level": level, "order": order, "theme": theme,
            "goals": [{"en": f"Talk about {theme['en'].lower()} in {en_name}",
                       "ar": f"تتكلم عن {theme['ar']} بال{ar_name[2:]}"},
                      {"en": g["title"][0], "ar": g["title"][1]}],
            "grammarIds": [gid], "lessonIds": lesson_ids, "sharedUnitId": shared["id"],
        })
        out["writingPrompts"].append({
            "id": f"{p}write.{key}", "level": level,
            "prompt": {"en": f"Write about {theme['en'].lower()} in {en_name}: {u.get('write_en', 'describe your own experience')}.",
                       "ar": f"اكتب بال{ar_name[2:]} عن {theme['ar']}: {u.get('write_ar', 'احكي عن تجربتك')}."},
            "minWords": {"A1": 20, "A2": 40, "B1": 80, "B2": 120, "C1": 180}[level],
        })
    # The review and mock exam unit.
    last = oul["units"][-1]
    order = last["order"]
    uid = f"{p}u{order:02d}"
    all_words = [v["id"] for v in out["vocab"]]
    out["units"].append({
        "id": uid, "level": level, "order": order, "theme": last["theme"],
        "goals": [{"en": f"Show you have reached {level}", "ar": f"توري إنك وصلت لمستوى {level}"}],
        "grammarIds": [], "lessonIds": [f"{uid}.l01", f"{uid}.l02"], "sharedUnitId": last["id"],
    })
    out["lessons"].append({"id": f"{uid}.l01", "unitId": uid, "order": 1, "type": "review",
                           "title": {"en": f"{level} words review", "ar": f"مراجعة كلمات {level}"},
                           "items": all_words[::max(1, len(all_words) // 30)][:30]})
    out["lessons"].append({"id": f"{uid}.l02", "unitId": uid, "order": 2, "type": "exam",
                           "title": {"en": f"{level} exam", "ar": f"امتحان {level}"}, "items": []})
    return out


def build_pack(lang: str, level: str, skip: set) -> dict:
    data = importlib.import_module(f"levels.{level.lower()}")
    path = APP_CONTENT_DIR / lang / f"{level.lower()}.json"
    if level == "A1":
        # Extend the starter pack (units 1-4, written by starter_v2.py).
        pack = json.loads(path.read_text(encoding="utf-8"))
        if any(u["order"] >= 5 for u in pack["units"]):
            raise SystemExit("A1 already extended: run starter_v2.py first")
        start = 5
        taken = {v["id"] for v in pack["vocab"]}
    else:
        lv = outline_level(level)
        pack = {
            "schemaVersion": 2, "lang": lang, "contentVersion": VERSION,
            "level": {"id": level, "title": lv["title"], "targetHours": lv["targetHours"],
                      "canDo": data.CAN_DO},
            "units": [], "lessons": [], "vocab": [], "sentences": [], "grammar": [],
            "texts": [], "writingPrompts": [],
            "credits": [{"name": "3Lang original content", "license": LIC}],
        }
        start = 1
        taken = set()
    built = build_units(lang, level, data, taken, start, skip)
    for k, v in built.items():
        pack[k].extend(v)
    pack["contentVersion"] = VERSION
    pack["units"].sort(key=lambda u: u["order"])
    return pack


def check(pack: dict) -> None:
    ids = {k: {x["id"] for x in pack[k]} for k in ("vocab", "sentences", "grammar", "texts", "lessons")}
    for l in pack["lessons"]:
        for i in l["items"]:
            assert i in ids["vocab"] or i in ids["sentences"], (l["id"], i)
        if l.get("grammarId"):
            assert l["grammarId"] in ids["grammar"], l["id"]
    for v in pack["vocab"]:
        assert v["translations"].get("ar") and v["translations"].get("en"), v["id"]
    assert len(ids["vocab"]) == len(pack["vocab"]), "duplicate vocab id"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lang", choices=LANGS, action="append")
    ap.add_argument("--level", choices=LEVELS, action="append")
    args = ap.parse_args()
    langs = args.lang or list(LANGS)
    if args.level is None or "A1" in args.level:
        starter_v2.main()  # fresh A0 and A1 units 1-4
    levels = args.level or [l for l in LEVELS if (ROOT / "content/data/levels" / f"{l.lower()}.py").exists()]
    for level in levels:
        skip = skipped_concepts(level, importlib.import_module(f"levels.{level.lower()}"))
        for lang in (LANGS if level == "A1" else langs):  # A1 is rebuilt whole
            pack = build_pack(lang, level, skip)
            check(pack)
            out = APP_CONTENT_DIR / lang / f"{level.lower()}.json"
            out.write_text(json.dumps(pack, ensure_ascii=False, indent=1), encoding="utf-8")
            print(f"wrote {out.relative_to(ROOT)}: {len(pack['units'])} units, {len(pack['vocab'])} words, "
                  f"{len(pack['sentences'])} sentences, {len(pack['lessons'])} lessons")
    # Rebuild the contrast dictionary over every pack in the app.
    packs = {}
    for lang in LANGS:
        for f in sorted((APP_CONTENT_DIR / lang).glob("*.json")):
            p = json.loads(f.read_text(encoding="utf-8"))
            packs[(lang, p["level"]["id"])] = p
    c = starter_v2.build_contrast(packs)
    (APP_CONTENT_DIR / "contrast.json").write_text(json.dumps(c, ensure_ascii=False, indent=1), encoding="utf-8")
    kinds = {}
    for e in c["entries"]:
        kinds[e["kind"]] = kinds.get(e["kind"], 0) + 1
    print(f"wrote app/assets/content/contrast.json: {kinds}")


if __name__ == "__main__":
    main()
