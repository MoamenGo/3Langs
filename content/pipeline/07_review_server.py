"""Stage 7: a small local web page to fix machine-drafted translations.

    python 07_review_server.py --level A1
    then open http://localhost:8765

Lists every word and sentence marked needsReview in work/<level>.draft.json.
Edit the translations, press Approve, and the draft file is updated in place.
Uses only the Python standard library.
"""
from __future__ import annotations

import argparse
import html
import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs

from common import EXPLAIN_LANGS, WORK_DIR

PAGE = """<!doctype html><meta charset=utf-8><title>3Lang review</title>
<style>body{{font:15px system-ui;max-width:900px;margin:2em auto}}form{{border:1px solid #ccc;padding:1em;margin:1em 0;border-radius:8px}}
input{{width:100%;padding:4px;margin:2px 0}}b{{font-size:1.1em}}</style>
<h1>Needs review: {count}</h1>{forms}"""

FORM = """<form method=post><input type=hidden name=id value="{id}"><b>{de}</b> <small>{id}</small>{fields}
<button>Approve</button></form>"""


def load(level: str) -> tuple[dict, str]:
    path = WORK_DIR / f"{level.lower()}.draft.json"
    return json.loads(path.read_text(encoding="utf-8")), str(path)


def make_handler(level: str):
    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            data, _ = load(level)
            items = [r for r in data["vocab"] + data["sentences"] if r.get("needsReview")]
            forms = "".join(FORM.format(
                id=html.escape(r["id"]), de=html.escape(r.get("de") or r.get("lemma")),
                fields="".join(f'<label>{l}<input name={l} value="{html.escape(r["translations"].get(l, ""))}"></label>'
                               for l in EXPLAIN_LANGS)) for r in items[:200])
            self._send(PAGE.format(count=len(items), forms=forms))

        def do_POST(self):
            form = parse_qs(self.rfile.read(int(self.headers["Content-Length"])).decode())
            data, path = load(level)
            for r in data["vocab"] + data["sentences"]:
                if r["id"] == form["id"][0]:
                    r["translations"] = {l: form.get(l, [""])[0].strip() for l in EXPLAIN_LANGS}
                    r["needsReview"] = not all(r["translations"].values())
            with open(path, "w", encoding="utf-8") as f:
                json.dump(data, f, ensure_ascii=False, indent=1)
            self.send_response(303)
            self.send_header("Location", "/")
            self.end_headers()

        def _send(self, body: str):
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(body.encode())

    return Handler


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--level", default="A1")
    ap.add_argument("--port", type=int, default=8765)
    args = ap.parse_args()
    print(f"open http://localhost:{args.port}")
    HTTPServer(("127.0.0.1", args.port), make_handler(args.level)).serve_forever()


if __name__ == "__main__":
    main()
