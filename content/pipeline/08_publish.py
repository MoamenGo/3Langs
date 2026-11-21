"""Stage 8: publish a level file the apps can download and store offline.

Merges work/<level>.draft.json with hand-written extras (grammar points,
reading texts, writing prompts) from content/data/manual/<level>_extras.json,
validates the result against content/schema/level.schema.json, then writes:

  content/build/<level>.json          the level file
  content/build/manifest.json         level -> contentVersion, for app updates
  app/assets/content/<level>.json     bundled copy (with --bundle)
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import shutil

from common import APP_CONTENT_DIR, BUILD_DIR, MANUAL_DIR, WORK_DIR
from validate import validate_level


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--level", default="A1")
    ap.add_argument("--bundle", action="store_true", help="also copy into the Flutter app assets")
    ap.add_argument("--allow-unreviewed", action="store_true")
    args = ap.parse_args()
    lvl = args.level.lower()

    data = json.loads((WORK_DIR / f"{lvl}.draft.json").read_text(encoding="utf-8"))
    extras_path = MANUAL_DIR / f"{lvl}_extras.json"
    if extras_path.exists():
        extras = json.loads(extras_path.read_text(encoding="utf-8"))
        for key in ("grammar", "texts", "writingPrompts", "credits"):
            data[key] = data.get(key, []) + extras.get(key, [])

    unreviewed = [r["id"] for r in data["vocab"] + data["sentences"] if r.get("needsReview")]
    if unreviewed and not args.allow_unreviewed:
        raise SystemExit(f"{len(unreviewed)} items still need review (run 07_review_server.py), "
                         "or pass --allow-unreviewed")

    data["contentVersion"] = dt.datetime.now(dt.timezone.utc).strftime("%Y.%m.%d.%H%M")
    errors = validate_level(data)
    if errors:
        raise SystemExit("schema errors:\n" + "\n".join(errors[:30]))

    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    out = BUILD_DIR / f"{lvl}.json"
    out.write_text(json.dumps(data, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")

    manifest_path = BUILD_DIR / "manifest.json"
    manifest = json.loads(manifest_path.read_text()) if manifest_path.exists() else {"levels": {}}
    manifest["levels"][args.level.upper()] = {"file": out.name, "contentVersion": data["contentVersion"]}
    manifest_path.write_text(json.dumps(manifest, indent=2))

    if args.bundle:
        shutil.copy(out, APP_CONTENT_DIR / out.name)
    print(f"published {out} ({data['contentVersion']})")


if __name__ == "__main__":
    main()
