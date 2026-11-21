"""Stage 1: download the free source dumps into content/data/raw/<source>/.

Each folder gets a SOURCE.json noting the URL, date and licence, so every
record can later be credited. Licences must be re-checked on the source's own
page before the first import.

Large files: the Wiktextract German dump is about 1 GB. Use --only to pick.
    python 01_download.py --only tatoeba frequency
"""
from __future__ import annotations

import argparse
import datetime as dt
import json

import requests

from common import RAW_DIR

SOURCES = {
    "tatoeba": {
        "licence": "CC BY 2.0 FR",
        "files": {
            "deu_sentences_detailed.tsv.bz2": "https://downloads.tatoeba.org/exports/per_language/deu/deu_sentences_detailed.tsv.bz2",
            "eng_sentences.tsv.bz2": "https://downloads.tatoeba.org/exports/per_language/eng/eng_sentences.tsv.bz2",
            "nld_sentences.tsv.bz2": "https://downloads.tatoeba.org/exports/per_language/nld/nld_sentences.tsv.bz2",
            "spa_sentences.tsv.bz2": "https://downloads.tatoeba.org/exports/per_language/spa/spa_sentences.tsv.bz2",
            "links.tar.bz2": "https://downloads.tatoeba.org/exports/links.tar.bz2",
            "sentences_with_audio.tar.bz2": "https://downloads.tatoeba.org/exports/sentences_with_audio.tar.bz2",
        },
    },
    "wiktextract": {
        "licence": "CC BY-SA 4.0 / GFDL (Wiktionary)",
        "files": {
            "kaikki-german.jsonl": "https://kaikki.org/dictionary/German/kaikki.org-dictionary-German.jsonl",
        },
    },
    "frequency": {
        "licence": "CC BY-SA 4.0 (hermitdave/FrequencyWords, OpenSubtitles 2018)",
        "files": {
            "de_50k.txt": "https://raw.githubusercontent.com/hermitdave/FrequencyWords/master/content/2018/de/de_50k.txt",
        },
    },
    # Common Voice needs a free account and a manual download from
    # https://commonvoice.mozilla.org/de/datasets . Put the extracted folder in
    # content/data/raw/commonvoice/ ; stage 5 reads validated.tsv from there.
}


def download(name: str, spec: dict) -> None:
    folder = RAW_DIR / name
    folder.mkdir(parents=True, exist_ok=True)
    for filename, url in spec["files"].items():
        target = folder / filename
        if target.exists():
            print(f"  skip {filename} (already downloaded)")
            continue
        print(f"  get  {url}")
        with requests.get(url, stream=True, timeout=60) as r:
            r.raise_for_status()
            tmp = target.with_suffix(target.suffix + ".part")
            with tmp.open("wb") as f:
                for chunk in r.iter_content(1 << 20):
                    f.write(chunk)
            tmp.rename(target)
    (folder / "SOURCE.json").write_text(json.dumps({
        "source": name,
        "licence": spec["licence"],
        "downloaded": dt.date.today().isoformat(),
        "files": spec["files"],
    }, indent=2))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*", choices=list(SOURCES), help="sources to fetch")
    args = ap.parse_args()
    for name in args.only or SOURCES:
        print(f"[{name}]")
        download(name, SOURCES[name])


if __name__ == "__main__":
    main()
