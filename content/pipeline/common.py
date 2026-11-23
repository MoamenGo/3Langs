"""Shared paths and helpers for the 3Lang content pipeline."""
from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]          # repository root
CONTENT_DIR = ROOT / "content"
RAW_DIR = CONTENT_DIR / "data" / "raw"               # downloaded dumps (git-ignored)
WORK_DIR = CONTENT_DIR / "data" / "work"             # intermediate files (git-ignored)
MANUAL_DIR = CONTENT_DIR / "data" / "manual"         # hand-made inputs, committed
BUILD_DIR = CONTENT_DIR / "build"                    # published level files
APP_CONTENT_DIR = ROOT / "app" / "assets" / "content"
SCHEMA_PATH = CONTENT_DIR / "schema" / "level.schema.json"

SCHEMA_VERSION = 1
LEVELS = ["A1", "A2", "B1", "B2", "C1"]
EXPLAIN_LANGS = ["ar", "en"]  # explanation languages (schema v2)
# Tatoeba uses ISO 639-3 codes.
TATOEBA_LANGS = {"de": "deu", "en": "eng", "nl": "nld", "es": "spa"}


def slug(text: str) -> str:
    """Stable ASCII id fragment: 'heißen' -> 'heissen', 'guten Morgen' -> 'guten_morgen'."""
    text = text.replace("ß", "ss").replace("ä", "ae").replace("ö", "oe").replace("ü", "ue")
    text = text.replace("Ä", "Ae").replace("Ö", "Oe").replace("Ü", "Ue")
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    return re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")


def read_jsonl(path: Path):
    with path.open(encoding="utf-8") as f:
        for line in f:
            if line.strip():
                yield json.loads(line)


def write_jsonl(path: Path, rows) -> int:
    path.parent.mkdir(parents=True, exist_ok=True)
    n = 0
    with path.open("w", encoding="utf-8") as f:
        for row in rows:
            f.write(json.dumps(row, ensure_ascii=False) + "\n")
            n += 1
    return n


def tokenize_de(sentence: str) -> list[str]:
    """Very small German tokenizer, good enough to join sentences to words."""
    return re.findall(r"[A-Za-zÄÖÜäöüß]+", sentence)
