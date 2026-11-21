"""Stage 3: give every word and sentence a CEFR level.

Words on the Goethe-Institut A1/A2/B1 lists get that level. The lists are
copyrighted PDFs, so we only use them as a checklist: put one lemma per line
in content/data/manual/goethe_a1.txt, goethe_a2.txt, goethe_b1.txt (typed or
extracted by you; never copy their example sentences).

Words on no list get B2 or C1 by frequency rank. A sentence gets the level of
its hardest known word.

Outputs: work/words_leveled.jsonl, work/sentences_leveled.jsonl
"""
from __future__ import annotations

from common import LEVELS, MANUAL_DIR, RAW_DIR, WORK_DIR, read_jsonl, write_jsonl

B2_MAX_RANK = 12_000   # frequency rank cut-offs for words on no Goethe list
C1_MAX_RANK = 25_000


def goethe_lists() -> dict[str, str]:
    level_of = {}
    for lvl in ("A1", "A2", "B1"):
        path = MANUAL_DIR / f"goethe_{lvl.lower()}.txt"
        if not path.exists():
            print(f"  warning: {path.name} missing, skipping")
            continue
        for line in path.read_text(encoding="utf-8").splitlines():
            lemma = line.strip()
            if lemma and not lemma.startswith("#"):
                level_of.setdefault(lemma.lower(), lvl)
    return level_of


def frequency_ranks() -> dict[str, int]:
    ranks = {}
    path = RAW_DIR / "frequency" / "de_50k.txt"
    for i, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        word = line.split(" ")[0].lower()
        ranks.setdefault(word, i)
    return ranks


def main() -> None:
    goethe, ranks = goethe_lists(), frequency_ranks()
    words = []
    for w in read_jsonl(WORK_DIR / "words.jsonl"):
        key = w["lemma"].lower()
        rank = ranks.get(key)
        level = goethe.get(key)
        if level is None and rank is not None:
            level = "B2" if rank <= B2_MAX_RANK else "C1" if rank <= C1_MAX_RANK else None
        if level is None:
            continue                        # too rare for the course
        words.append({**w, "level": level, "freqRank": rank})
    write_jsonl(WORK_DIR / "words_leveled.jsonl", words)

    word_level = {w["lemma"].lower(): w["level"] for w in words}
    sentences = []
    for s in read_jsonl(WORK_DIR / "sentences.jsonl"):
        known = [word_level[t] for t in s["tokens"] if t in word_level]
        if not known:
            continue
        hardest = max(known, key=LEVELS.index)
        sentences.append({**s, "level": hardest})
    write_jsonl(WORK_DIR / "sentences_leveled.jsonl", sentences)
    print(f"words: {len(words)}  sentences: {len(sentences)}")


if __name__ == "__main__":
    main()
