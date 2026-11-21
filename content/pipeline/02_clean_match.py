"""Stage 2: keep German entries, join words to Wiktionary details and
sentences to their translations and to the words they contain.

Inputs  (from stage 1): raw/tatoeba/*, raw/wiktextract/kaikki-german.jsonl
Outputs: work/words.jsonl, work/sentences.jsonl
"""
from __future__ import annotations

import bz2
import csv
import io
import tarfile
from collections import defaultdict

from common import RAW_DIR, TATOEBA_LANGS, WORK_DIR, read_jsonl, tokenize_de, write_jsonl

MAX_SENTENCE_WORDS = 14          # longer sentences are poor flashcard material
POS_KEEP = {"noun", "verb", "adj", "adv", "pron", "prep", "conj", "num", "intj", "phrase", "det", "particle"}
GENDER = {"masculine": "der", "feminine": "die", "neuter": "das"}

csv.field_size_limit(10_000_000)


def read_tatoeba(code: str) -> dict[int, str]:
    name = "deu_sentences_detailed.tsv.bz2" if code == "deu" else f"{code}_sentences.tsv.bz2"
    out = {}
    with bz2.open(RAW_DIR / "tatoeba" / name, "rt", encoding="utf-8") as f:
        for row in csv.reader(f, delimiter="\t", quoting=csv.QUOTE_NONE):
            out[int(row[0])] = row[2]
    return out


def read_links(wanted_src: set[int]) -> dict[int, list[int]]:
    links = defaultdict(list)
    with tarfile.open(RAW_DIR / "tatoeba" / "links.tar.bz2", "r:bz2") as tar:
        member = next(m for m in tar.getmembers() if m.name.endswith(".csv"))
        for line in io.TextIOWrapper(tar.extractfile(member), encoding="utf-8"):
            a, b = line.rstrip("\n").split("\t")
            a = int(a)
            if a in wanted_src:
                links[a].append(int(b))
    return links


def build_sentences() -> list[dict]:
    de = {k: v for k, v in read_tatoeba("deu").items() if len(tokenize_de(v)) <= MAX_SENTENCE_WORDS}
    other = {lang: read_tatoeba(code) for lang, code in TATOEBA_LANGS.items() if lang != "de"}
    links = read_links(set(de))
    rows = []
    for sid, text in de.items():
        tr = {}
        for target in links.get(sid, []):
            for lang, table in other.items():
                if lang not in tr and target in table:
                    tr[lang] = table[target]
        rows.append({
            "tatoebaId": sid, "de": text, "translations": tr,
            "tokens": [t.lower() for t in tokenize_de(text)],
            "source": f"Tatoeba #{sid}", "license": "CC BY 2.0 FR",
        })
    return rows


def build_words() -> list[dict]:
    words = {}
    for e in read_jsonl(RAW_DIR / "wiktextract" / "kaikki-german.jsonl"):
        if e.get("lang_code") != "de" or e.get("pos") not in POS_KEEP:
            continue
        lemma = e["word"]
        key = (lemma, e["pos"])
        if key in words:
            continue
        glosses = [g for s in e.get("senses", []) for g in s.get("glosses", [])
                   if "form-of" not in s.get("tags", [])]
        if not glosses:
            continue
        article = plural = None
        for form in e.get("forms", []):
            tags = set(form.get("tags", []))
            if "plural" in tags and "nominative" in tags and plural is None:
                plural = form["form"]
        for tmpl in e.get("head_templates", []):
            g = tmpl.get("args", {}).get("1", "")
            article = {"m": "der", "f": "die", "n": "das"}.get(g[:1], article)
        ipa = next((s["ipa"] for s in e.get("sounds", []) if "ipa" in s), None)
        words[key] = {
            "lemma": lemma, "pos": e["pos"], "article": article if e["pos"] == "noun" else None,
            "plural": plural, "ipa": ipa, "glossEn": glosses[:3],
            "source": "Wiktionary via kaikki.org", "license": "CC BY-SA 4.0",
        }
    return list(words.values())


def main() -> None:
    n = write_jsonl(WORK_DIR / "sentences.jsonl", build_sentences())
    print(f"sentences: {n}")
    n = write_jsonl(WORK_DIR / "words.jsonl", build_words())
    print(f"words: {n}")


if __name__ == "__main__":
    main()
