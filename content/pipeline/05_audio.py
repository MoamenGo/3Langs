"""Stage 5: attach audio to sentences and words.

1. Tatoeba recordings (CC licences per speaker, listed in sentences_with_audio).
2. Common Voice clips (CC0) whose text matches a sentence exactly.
3. Otherwise generate a file with Piper TTS, if the `piper` binary and a German
   voice (for example de_DE-thorsten-medium.onnx) are installed.

The app also falls back to on-device text-to-speech, so missing audio never
blocks a lesson. Generated files go to content/build/audio/<id>.mp3 (or .wav)
and are served from Supabase Storage or bundled per level.

Outputs: work/words_audio.jsonl, work/sentences_audio.jsonl
"""
from __future__ import annotations

import argparse
import csv
import io
import shutil
import subprocess
import tarfile

from common import BUILD_DIR, RAW_DIR, WORK_DIR, read_jsonl, write_jsonl

AUDIO_DIR = BUILD_DIR / "audio"


def tatoeba_audio_ids() -> dict[int, str]:
    path = RAW_DIR / "tatoeba" / "sentences_with_audio.tar.bz2"
    if not path.exists():
        return {}
    out = {}
    with tarfile.open(path, "r:bz2") as tar:
        member = next(m for m in tar.getmembers() if m.name.endswith(".csv"))
        for row in csv.reader(io.TextIOWrapper(tar.extractfile(member), encoding="utf-8"), delimiter="\t"):
            # sentence_id, audio_id, username, license, attribution_url
            out.setdefault(int(row[0]), row[3] or "see Tatoeba")
    return out


def common_voice_index() -> dict[str, str]:
    tsv = RAW_DIR / "commonvoice" / "validated.tsv"
    if not tsv.exists():
        return {}
    with tsv.open(encoding="utf-8") as f:
        return {row["sentence"].strip(): row["path"] for row in csv.DictReader(f, delimiter="\t")}


def piper(text: str, out_name: str, voice: str) -> str | None:
    if shutil.which("piper") is None:
        return None
    AUDIO_DIR.mkdir(parents=True, exist_ok=True)
    out = AUDIO_DIR / f"{out_name}.wav"
    subprocess.run(["piper", "--model", voice, "--output_file", str(out)],
                   input=text.encode(), check=True, capture_output=True)
    return out.name


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--voice", default="de_DE-thorsten-medium.onnx")
    ap.add_argument("--generate", action="store_true", help="run Piper for items without audio")
    args = ap.parse_args()

    tatoeba, cv = tatoeba_audio_ids(), common_voice_index()
    sentences = []
    for s in read_jsonl(WORK_DIR / "sentences_translated.jsonl"):
        audio = None
        if s.get("tatoebaId") in tatoeba:
            audio = {"kind": "tatoeba", "ref": f"https://tatoeba.org/audio/download/{s['tatoebaId']}",
                     "license": tatoeba[s["tatoebaId"]]}
        elif s["de"] in cv:
            audio = {"kind": "commonvoice", "ref": cv[s["de"]], "license": "CC0"}
        elif args.generate:
            name = piper(s["de"], f"tatoeba_{s['tatoebaId']}", args.voice)
            audio = name and {"kind": "piper", "ref": name, "license": "generated"}
        sentences.append({**s, "audio": audio})
    write_jsonl(WORK_DIR / "sentences_audio.jsonl", sentences)

    words = []
    for w in read_jsonl(WORK_DIR / "words_translated.jsonl"):
        audio = None
        if args.generate:
            text = f"{w['article']} {w['lemma']}" if w.get("article") else w["lemma"]
            name = piper(text, f"word_{w['lemma']}", args.voice)
            audio = name and {"kind": "piper", "ref": name, "license": "generated"}
        words.append({**w, "audio": audio})
    write_jsonl(WORK_DIR / "words_audio.jsonl", words)
    with_audio = sum(1 for s in sentences if s["audio"])
    print(f"sentences with audio: {with_audio}/{len(sentences)}")


if __name__ == "__main__":
    main()
