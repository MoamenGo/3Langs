"""Convert German-only (schema v1) content to the three-language layout (v2).

v1: app/assets/content/a1.json, ids like `a1.vocab.haus`, explanations en/nl/es.
v2: app/assets/content/{lang}/{level}.json, ids like `de.a1.vocab.haus`,
    explanations ar/en, every unit tied to a unit of the shared syllabus.

Also turns content/outline/course_outline.json into the shared A0-C1 syllabus
used by all three languages.

Run:  python content/pipeline/to_v2.py
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
APP_CONTENT = ROOT / "app" / "assets" / "content"
MANUAL = ROOT / "content" / "data" / "manual"
OUTLINE = ROOT / "content" / "outline" / "course_outline.json"

LEGACY_ID = re.compile(r"^(a0|a1|a2|b1|b2|c1)\.[a-z0-9_]")
OLD_L10N_KEYS = {"en", "nl", "es"}


def prefix_ids(node, lang: str):
    """Adds the language prefix to every content id anywhere in the tree."""
    if isinstance(node, str):
        return f"{lang}.{node}" if LEGACY_ID.match(node) else node
    if isinstance(node, list):
        return [prefix_ids(x, lang) for x in node]
    if isinstance(node, dict):
        if node and set(node) <= OLD_L10N_KEYS and all(isinstance(v, str) for v in node.values()):
            # An explanation text: keep English; nl/es are target languages now.
            return {"en": node["en"]} if "en" in node else {}
        return {k: prefix_ids(v, lang) for k, v in node.items()}
    return node


def with_ar(text: dict, ar: str | None) -> dict:
    return {"ar": ar, **text} if ar else text


def convert_pack(legacy: dict, lang: str, ar: dict) -> dict:
    level = legacy["level"]["id"].lower()
    pack = prefix_ids({k: v for k, v in legacy.items() if k != "schemaVersion"}, lang)
    for s in pack.get("sentences", []):
        if "de" in s:
            s["text"] = s.pop("de")
    if "level" in ar:
        pack["level"]["title"] = with_ar(pack["level"]["title"], ar["level"]["title"])
        pack["level"]["canDo"] = [
            with_ar(t, a) for t, a in zip(pack["level"]["canDo"], ar["level"]["canDo"])
        ]
    for u in pack["units"]:
        extra = ar.get("units", {}).get(u["id"].split(".", 1)[1], {})
        u["theme"] = with_ar(u["theme"], extra.get("theme"))
        u["goals"] = [with_ar(g, a) for g, a in zip(u["goals"], extra.get("goals", []))] or u["goals"]
        if "sharedUnitId" in extra:
            u["sharedUnitId"] = extra["sharedUnitId"]
    for l in pack["lessons"]:
        l["title"] = with_ar(l["title"], ar.get("lessons", {}).get(l["id"].split(".", 1)[1]))
    for v in pack["vocab"]:
        v["translations"] = with_ar(v["translations"], ar.get("vocab", {}).get(v["id"].rsplit(".", 1)[1]))
    return {"schemaVersion": 2, "lang": lang, **pack, "contentVersion": f"{legacy['contentVersion']}-v2"}


OUTLINE_AR = {
    "A0": ("A0 البداية", [
        ("Sounds and letters", "الأصوات والحروف"),
        ("Survival phrases", "عبارات النجاة"),
        ("Numbers, days and time", "الأرقام والأيام والوقت"),
        ("First questions", "أول أسئلة"),
    ]),
    "A1": ("A1 مبتدئ", "التحية والتعارف|العائلة والأرقام|البيت والسكن|الأكل والشرب|التسوق والأسعار|الروتين اليومي والوقت|وقت الفراغ والهوايات|في المدينة|السفر والمواصلات|الصحة والجسم|الشغل والمدرسة|مراجعة A1 واختبار تجريبي"),
    "A2": ("A2 أساسي", "قصة حياتي|الأصدقاء والعلاقات|اللبس والمظهر|السكن والنقل لبيت جديد|حياة الشغل|الإعلام والتكنولوجيا|الصحة واللياقة|السفر والإجازات|ثقافة الأكل|الخدمات والجهات الرسمية|الاحتفالات والعادات|مراجعة A2 واختبار تجريبي"),
    "B1": ("B1 متوسط", "التعليم والتعلم|البحث عن شغل والتقديم|العيش مع الآخرين|الاستهلاك والفلوس|البيئة والطبيعة|الإعلام والأخبار|النظام الصحي|الثقافة والفن|السفر والتنقل|السياسة والمجتمع|العلاقات والمشاعر|العلوم والتكنولوجيا|الرياضة والترفيه|العيش في الخارج|الرسائل والإيميلات الرسمية|مراجعة B1 واختبار تجريبي"),
    "B2": ("B2 فوق المتوسط", "الشغل والمسار المهني|الاقتصاد والعولمة|العلوم والبحث|التعامل مع الإعلام|المجتمع والقيم|البيئة والمستقبل|الصحة وعلم النفس|التاريخ|الفن والأدب|القانون والحياة اليومية|العالم الرقمي|اللغة والتواصل|الجدال والنقاش|مراجعة B2 واختبار تجريبي"),
    "C1": ("C1 متقدم", "اللغة الأكاديمية|الفلسفة والأخلاق|لغة البيزنس|السياسة والاتحاد الأوروبي|تبسيط العلوم|الأدب والسينما|الهجرة والهوية|الفكاهة والتعبيرات|التكنولوجيا والأخلاق|اللهجات المحلية|العرض والمناظرة|مراجعة C1 واختبار تجريبي"),
}
EN_RENAME = {"Business German": "Business language", "Regional German": "Regional varieties"}


def convert_outline(legacy: dict) -> dict:
    levels = [{
        "id": "A0",
        "title": {"ar": OUTLINE_AR["A0"][0], "en": "A0 First steps"},
        "targetHours": 30,
        "units": [
            {"id": f"u.a0.{i:02d}", "order": i, "theme": {"ar": ar, "en": en},
             "grammarTopics": {}, "newWords": 40 if i < 4 else 30}
            for i, (en, ar) in enumerate(OUTLINE_AR["A0"][1], 1)
        ],
    }]
    for lvl in legacy["levels"]:
        title_ar, themes_ar = OUTLINE_AR[lvl["id"]]
        themes_ar = themes_ar.split("|")
        assert len(themes_ar) == len(lvl["units"]), lvl["id"]
        levels.append({
            "id": lvl["id"],
            "title": {"ar": title_ar, "en": lvl["title"]["en"]},
            "targetHours": lvl["targetHours"],
            "units": [{
                "id": f"u.{lvl['id'].lower()}.{u['order']:02d}",
                "order": u["order"],
                "theme": {"ar": ar, "en": EN_RENAME.get(u["theme"]["en"], u["theme"]["en"])},
                "keywords": u.get("keywords", []),
                # Grammar differs per language: German topics come from the old
                # outline; Dutch and Spanish are added with their content.
                "grammarTopics": {"de": u.get("grammarTopics", [])},
                "newWords": u["newWords"],
            } for u, ar in zip(lvl["units"], themes_ar)],
        })
    return {
        "schemaVersion": 2,
        "description": "Shared A0-C1 syllabus for German, Dutch and Spanish. Each unit is "
                       "realised once per language; targetHours are per language.",
        "languages": ["de", "es", "nl"],
        "hoursPerLanguage": sum(l["targetHours"] for l in levels),
        "levels": levels,
    }


def main() -> None:
    legacy_path = APP_CONTENT / "a1.json"
    if legacy_path.exists():
        ar = json.loads((MANUAL / "ar_de_a1.json").read_text(encoding="utf-8"))
        pack = convert_pack(json.loads(legacy_path.read_text(encoding="utf-8")), "de", ar)
        out = APP_CONTENT / "de" / "a1.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(pack, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
        legacy_path.unlink()
        print(f"wrote {out.relative_to(ROOT)}")
    outline = json.loads(OUTLINE.read_text(encoding="utf-8"))
    if outline.get("schemaVersion") != 2:
        shared = convert_outline(outline)
        text = json.dumps(shared, ensure_ascii=False, indent=1) + "\n"
        OUTLINE.write_text(text, encoding="utf-8")
        (APP_CONTENT / "course_outline.json").write_text(text, encoding="utf-8")
        print("wrote shared outline")


if __name__ == "__main__":
    sys.exit(main())
