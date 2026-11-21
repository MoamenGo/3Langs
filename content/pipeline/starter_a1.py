"""Hand-written A1 starter content.

The full pipeline (stages 01 to 08) builds level files from Tatoeba, Wiktionary
and the other free sources. Until those dumps are downloaded and reviewed, this
script writes a small, hand-checked A1 file (unit 1 complete, unit 2 started)
so the app has real content to run on.

Run:  python content/pipeline/starter_a1.py
Out:  app/assets/content/a1.json
"""
from __future__ import annotations

import json
from pathlib import Path

from common import APP_CONTENT_DIR, SCHEMA_VERSION, slug

SRC = "3lang-original"
LIC = "CC BY-SA 4.0"


def t(en: str, nl: str, es: str) -> dict:
    return {"en": en, "nl": nl, "es": es}


# (lemma, article, plural, pos, en, nl, es, freq_rank)
VOCAB_U01_GREETINGS = [
    ("hallo", None, None, "interjection", "hello", "hallo", "hola", 210),
    ("tschüss", None, None, "interjection", "bye", "doei", "adiós, chao", 1900),
    ("guten Morgen", None, None, "phrase", "good morning", "goedemorgen", "buenos días", None),
    ("guten Tag", None, None, "phrase", "hello, good day", "goedendag", "buenos días, buenas tardes", None),
    ("guten Abend", None, None, "phrase", "good evening", "goedenavond", "buenas noches", None),
    ("auf Wiedersehen", None, None, "phrase", "goodbye", "tot ziens", "adiós, hasta la vista", None),
    ("danke", None, None, "interjection", "thank you", "dank je, bedankt", "gracias", 180),
    ("bitte", None, None, "adverb", "please; you're welcome", "alsjeblieft; graag gedaan", "por favor; de nada", 150),
    ("ja", None, None, "adverb", "yes", "ja", "sí", 20),
    ("nein", None, None, "adverb", "no", "nee", "no", 60),
    ("Entschuldigung", "die", "Entschuldigungen", "noun", "excuse me; sorry", "pardon; sorry", "perdón, disculpe", 1500),
    ("gut", None, None, "adjective", "good, well", "goed", "bueno, bien", 45),
]

VOCAB_U01_INTRO = [
    ("Name", "der", "Namen", "noun", "name", "de naam", "el nombre", 400),
    ("heißen", None, None, "verb", "to be called", "heten", "llamarse", 300),
    ("sein", None, None, "verb", "to be", "zijn", "ser, estar", 5),
    ("kommen", None, None, "verb", "to come", "komen", "venir", 90),
    ("aus", None, None, "preposition", "from, out of", "uit", "de, desde", 40),
    ("wohnen", None, None, "verb", "to live (reside)", "wonen", "vivir", 1200),
    ("in", None, None, "preposition", "in", "in", "en", 8),
    ("ich", None, None, "pronoun", "I", "ik", "yo", 2),
    ("du", None, None, "pronoun", "you (informal)", "jij, je", "tú", 4),
    ("Sie", None, None, "pronoun", "you (formal)", "u", "usted", 12),
    ("wie", None, None, "adverb", "how", "hoe", "cómo", 50),
    ("woher", None, None, "adverb", "where from", "waar vandaan", "de dónde", 2500),
    ("Land", "das", "Länder", "noun", "country", "het land", "el país", 700),
    ("Stadt", "die", "Städte", "noun", "city, town", "de stad", "la ciudad", 500),
]

VOCAB_U02_FAMILY = [
    ("Familie", "die", "Familien", "noun", "family", "de familie, het gezin", "la familia", 450),
    ("Mutter", "die", "Mütter", "noun", "mother", "de moeder", "la madre", 380),
    ("Vater", "der", "Väter", "noun", "father", "de vader", "el padre", 350),
    ("Bruder", "der", "Brüder", "noun", "brother", "de broer", "el hermano", 600),
    ("Schwester", "die", "Schwestern", "noun", "sister", "de zus", "la hermana", 800),
    ("Kind", "das", "Kinder", "noun", "child", "het kind", "el niño, la niña; el hijo, la hija", 300),
    ("haben", None, None, "verb", "to have", "hebben", "tener", 10),
    ("eins", None, None, "numeral", "one", "een", "uno", 900),
    ("zwei", None, None, "numeral", "two", "twee", "dos", 120),
    ("drei", None, None, "numeral", "three", "drie", "tres", 250),
]

# (key, German, en, nl, es, vocab lemmas it illustrates)
SENTENCES = [
    ("s001", "Hallo, ich heiße Anna.", "Hello, my name is Anna.", "Hallo, ik heet Anna.", "Hola, me llamo Anna.", ["hallo", "ich", "heißen"]),
    ("s002", "Wie heißt du?", "What's your name?", "Hoe heet jij?", "¿Cómo te llamas?", ["wie", "heißen", "du"]),
    ("s003", "Wie heißen Sie?", "What is your name? (formal)", "Hoe heet u?", "¿Cómo se llama usted?", ["wie", "heißen", "Sie"]),
    ("s004", "Ich komme aus Ägypten.", "I come from Egypt.", "Ik kom uit Egypte.", "Soy de Egipto.", ["kommen", "aus"]),
    ("s005", "Woher kommst du?", "Where are you from?", "Waar kom jij vandaan?", "¿De dónde eres?", ["woher", "kommen", "du"]),
    ("s006", "Ich wohne in Berlin.", "I live in Berlin.", "Ik woon in Berlijn.", "Vivo en Berlín.", ["wohnen", "in"]),
    ("s007", "Wie geht es Ihnen?", "How are you? (formal)", "Hoe gaat het met u?", "¿Cómo está usted?", ["wie"]),
    ("s008", "Danke, gut. Und dir?", "Fine, thanks. And you?", "Goed, dank je. En met jou?", "Bien, gracias. ¿Y tú?", ["danke", "gut"]),
    ("s009", "Guten Morgen, Herr Weber!", "Good morning, Mr Weber!", "Goedemorgen, meneer Weber!", "¡Buenos días, señor Weber!", ["guten Morgen"]),
    ("s010", "Auf Wiedersehen, Frau Klein!", "Goodbye, Ms Klein!", "Tot ziens, mevrouw Klein!", "¡Adiós, señora Klein!", ["auf Wiedersehen"]),
    ("s011", "Entschuldigung, sind Sie Herr Weber?", "Excuse me, are you Mr Weber?", "Pardon, bent u meneer Weber?", "Disculpe, ¿es usted el señor Weber?", ["Entschuldigung", "sein", "Sie"]),
    ("s012", "Ja, das bin ich.", "Yes, that's me.", "Ja, dat ben ik.", "Sí, soy yo.", ["ja", "sein"]),
    ("s013", "Nein, ich bin Peter.", "No, I'm Peter.", "Nee, ik ben Peter.", "No, soy Peter.", ["nein", "sein", "ich"]),
    ("s014", "Mein Name ist Lukas.", "My name is Lukas.", "Mijn naam is Lukas.", "Mi nombre es Lukas.", ["Name", "sein"]),
    ("s015", "Berlin ist eine Stadt in Deutschland.", "Berlin is a city in Germany.", "Berlijn is een stad in Duitsland.", "Berlín es una ciudad de Alemania.", ["Stadt", "in", "sein"]),
    ("s016", "Tschüss, bis morgen!", "Bye, see you tomorrow!", "Doei, tot morgen!", "¡Adiós, hasta mañana!", ["tschüss"]),
    ("s017", "Danke schön! – Bitte schön!", "Thank you very much! – You're welcome!", "Dank je wel! – Graag gedaan!", "¡Muchas gracias! – ¡De nada!", ["danke", "bitte"]),
    ("s018", "Guten Tag! Ich bin Frau Schmidt.", "Hello! I'm Ms Schmidt.", "Goedendag! Ik ben mevrouw Schmidt.", "¡Buenos días! Soy la señora Schmidt.", ["guten Tag", "sein"]),
    ("s019", "Guten Abend! Wie geht's?", "Good evening! How are you?", "Goedenavond! Hoe gaat het?", "¡Buenas noches! ¿Qué tal?", ["guten Abend", "wie"]),
    ("s020", "Spanien ist ein Land in Europa.", "Spain is a country in Europe.", "Spanje is een land in Europa.", "España es un país de Europa.", ["Land", "in"]),
    ("s021", "Das ist meine Familie.", "This is my family.", "Dit is mijn familie.", "Esta es mi familia.", ["Familie"]),
    ("s022", "Ich habe zwei Brüder.", "I have two brothers.", "Ik heb twee broers.", "Tengo dos hermanos.", ["haben", "zwei", "Bruder"]),
    ("s023", "Meine Mutter heißt Maria.", "My mother's name is Maria.", "Mijn moeder heet Maria.", "Mi madre se llama María.", ["Mutter", "heißen"]),
    ("s024", "Hast du Kinder?", "Do you have children?", "Heb jij kinderen?", "¿Tienes hijos?", ["haben", "Kind", "du"]),
    ("s025", "Mein Vater kommt aus Spanien.", "My father comes from Spain.", "Mijn vader komt uit Spanje.", "Mi padre es de España.", ["Vater", "kommen", "aus"]),
    ("s026", "Ich habe eine Schwester.", "I have one sister.", "Ik heb één zus.", "Tengo una hermana.", ["haben", "Schwester"]),
    ("s027", "Eins, zwei, drei – los!", "One, two, three – go!", "Een, twee, drie – start!", "Uno, dos, tres, ¡ya!", ["eins", "zwei", "drei"]),
]

GRAMMAR_PRESENT = {
    "id": "a1.gram.present_sein_heissen",
    "level": "A1",
    "title": t("Present tense: sein, heißen, kommen, wohnen",
               "Tegenwoordige tijd: sein, heißen, kommen, wohnen",
               "Presente: sein, heißen, kommen, wohnen"),
    "explanation": t(
        "Regular German verbs take an ending that matches the person: ich -e, du -st, er/sie/es -t, "
        "wir -en, ihr -t, sie/Sie -en. So: ich komme, du kommst, er kommt, wir kommen.\n\n"
        "heißen ends in ß, so the du-form is just du heißt (not heißst).\n\n"
        "sein (to be) is irregular and must be learned by heart: ich bin, du bist, er/sie/es ist, "
        "wir sind, ihr seid, sie/Sie sind.\n\n"
        "Use du with friends, family and children. Use Sie (always with a capital S) with adults you don't know.",
        "Regelmatige Duitse werkwoorden krijgen een uitgang die bij de persoon past: ich -e, du -st, er/sie/es -t, "
        "wir -en, ihr -t, sie/Sie -en. Dus: ich komme, du kommst, er kommt, wir kommen.\n\n"
        "heißen eindigt op ß, daarom is de du-vorm gewoon du heißt (niet heißst).\n\n"
        "sein (zijn) is onregelmatig en moet je uit je hoofd leren: ich bin, du bist, er/sie/es ist, "
        "wir sind, ihr seid, sie/Sie sind.\n\n"
        "Gebruik du bij vrienden, familie en kinderen, net als jij. Gebruik Sie (altijd met hoofdletter) bij "
        "volwassenen die je niet kent, net als u.",
        "Los verbos regulares alemanes llevan una terminación según la persona: ich -e, du -st, er/sie/es -t, "
        "wir -en, ihr -t, sie/Sie -en. Así: ich komme, du kommst, er kommt, wir kommen.\n\n"
        "heißen termina en ß, por eso la forma de du es simplemente du heißt (no heißst).\n\n"
        "sein (ser/estar) es irregular y hay que aprenderlo de memoria: ich bin, du bist, er/sie/es ist, "
        "wir sind, ihr seid, sie/Sie sind.\n\n"
        "Usa du (tú) con amigos, familia y niños. Usa Sie (usted, siempre con mayúscula) con adultos que no conoces.",
    ),
    "table": {
        "headers": ["", "sein", "heißen", "kommen", "wohnen"],
        "rows": [
            ["ich", "bin", "heiße", "komme", "wohne"],
            ["du", "bist", "heißt", "kommst", "wohnst"],
            ["er/sie/es", "ist", "heißt", "kommt", "wohnt"],
            ["wir", "sind", "heißen", "kommen", "wohnen"],
            ["ihr", "seid", "heißt", "kommt", "wohnt"],
            ["sie/Sie", "sind", "heißen", "kommen", "wohnen"],
        ],
    },
    "exampleSentenceIds": ["a1.sent.s001", "a1.sent.s005", "a1.sent.s013"],
    "exercises": [
        {"type": "fill_blank", "prompt": "Ich ___ Anna.", "answer": "heiße", "base": "heißen"},
        {"type": "fill_blank", "prompt": "Wie ___ du?", "answer": "heißt", "base": "heißen"},
        {"type": "fill_blank", "prompt": "Woher ___ Sie?", "answer": "kommen", "base": "kommen"},
        {"type": "fill_blank", "prompt": "Ich ___ aus Spanien.", "answer": "komme", "base": "kommen"},
        {"type": "fill_blank", "prompt": "Du ___ Peter.", "answer": "bist", "base": "sein"},
        {"type": "fill_blank", "prompt": "Er ___ in Berlin.", "answer": "wohnt", "base": "wohnen"},
        {"type": "fill_blank", "prompt": "Wir ___ aus Ägypten.", "answer": "sind", "base": "sein"},
        {"type": "fill_blank", "prompt": "Ich ___ Lukas.", "answer": "bin", "base": "sein"},
    ],
    "source": SRC,
    "license": LIC,
}

TEXT_SARA = {
    "id": "a1.text.sara",
    "level": "A1",
    "kind": "reading",
    "title": "Hallo, ich bin Sara!",
    "body": (
        "Hallo! Ich heiße Sara. Ich komme aus Spanien, aus Madrid. "
        "Jetzt wohne ich in Berlin. Berlin ist eine große Stadt. Ich lerne Deutsch. "
        "Das ist mein Freund Tom. Er kommt aus England und wohnt auch in Berlin."
    ),
    "translation": t(
        "Hello! My name is Sara. I come from Spain, from Madrid. Now I live in Berlin. Berlin is a big city. "
        "I'm learning German. This is my friend Tom. He comes from England and also lives in Berlin.",
        "Hallo! Ik heet Sara. Ik kom uit Spanje, uit Madrid. Nu woon ik in Berlijn. Berlijn is een grote stad. "
        "Ik leer Duits. Dit is mijn vriend Tom. Hij komt uit Engeland en woont ook in Berlijn.",
        "¡Hola! Me llamo Sara. Soy de España, de Madrid. Ahora vivo en Berlín. Berlín es una ciudad grande. "
        "Estoy aprendiendo alemán. Este es mi amigo Tom. Es de Inglaterra y también vive en Berlín.",
    ),
    "glossary": ["heißen", "kommen", "aus", "wohnen", "Stadt"],
    "questions": [
        {"question": "Woher kommt Sara?", "options": ["Aus England", "Aus Spanien", "Aus Berlin"], "answer": 1},
        {"question": "Wo wohnt Sara jetzt?", "options": ["In Madrid", "In London", "In Berlin"], "answer": 2},
        {"question": "Woher kommt Tom?", "options": ["Aus England", "Aus Spanien", "Aus Deutschland"], "answer": 0},
    ],
    "source": SRC,
    "license": LIC,
}

TEXT_DW = {
    "id": "a1.text.dw_nicos_weg",
    "level": "A1",
    "kind": "external",
    "title": "DW: Nicos Weg (A1)",
    "url": "https://learngerman.dw.com/",
    "translation": t(
        "Free video course from Deutsche Welle. Watch the A1 episodes that match this unit.",
        "Gratis videocursus van Deutsche Welle. Bekijk de A1-afleveringen die bij deze unit passen.",
        "Curso de vídeo gratuito de Deutsche Welle. Mira los episodios A1 de esta unidad.",
    ),
    "glossary": [],
    "questions": [],
    "source": "Deutsche Welle (linked, not copied)",
    "license": "© DW, link only",
}

WRITING_PROMPTS = [
    {
        "id": "a1.write.introduce",
        "level": "A1",
        "prompt": t(
            "Introduce yourself in German: your name, where you come from and where you live. Write 3 to 5 sentences.",
            "Stel jezelf voor in het Duits: je naam, waar je vandaan komt en waar je woont. Schrijf 3 tot 5 zinnen.",
            "Preséntate en alemán: tu nombre, de dónde eres y dónde vives. Escribe de 3 a 5 frases.",
        ),
        "minWords": 15,
    },
    {
        "id": "a1.write.family",
        "level": "A1",
        "prompt": t(
            "Describe your family: who is in it and what are their names?",
            "Beschrijf je familie: wie hoort erbij en hoe heten ze?",
            "Describe a tu familia: ¿quiénes son y cómo se llaman?",
        ),
        "minWords": 15,
    },
]


def vocab_id(lemma: str) -> str:
    return f"a1.vocab.{slug(lemma)}"


def build() -> dict:
    vocab, by_lemma = [], {}
    for group in (VOCAB_U01_GREETINGS, VOCAB_U01_INTRO, VOCAB_U02_FAMILY):
        for lemma, art, plural, pos, en, nl, es, rank in group:
            item = {
                "id": vocab_id(lemma),
                "lemma": lemma,
                "article": art,
                "plural": plural,
                "pos": pos,
                "level": "A1",
                "freqRank": rank,
                "translations": t(en, nl, es),
                "sentenceIds": [],
                "source": SRC,
                "license": LIC,
            }
            vocab.append(item)
            by_lemma[lemma] = item

    sentences = []
    for key, de, en, nl, es, lemmas in SENTENCES:
        sid = f"a1.sent.{key}"
        sentences.append({
            "id": sid, "de": de, "translations": t(en, nl, es),
            "source": SRC, "license": LIC, "needsReview": False,
        })
        for lemma in lemmas:
            by_lemma[lemma]["sentenceIds"].append(sid)

    ids = lambda group: [vocab_id(v[0]) for v in group]  # noqa: E731
    text = dict(TEXT_SARA, glossary=[vocab_id(x) for x in TEXT_SARA["glossary"]])

    lessons = [
        {"id": "a1.u01.l01", "unitId": "a1.u01", "order": 1, "type": "vocab",
         "title": t("Hello and goodbye", "Hallo en tot ziens", "Hola y adiós"),
         "items": ids(VOCAB_U01_GREETINGS)},
        {"id": "a1.u01.l02", "unitId": "a1.u01", "order": 2, "type": "vocab",
         "title": t("Who are you?", "Wie ben jij?", "¿Quién eres?"),
         "items": ids(VOCAB_U01_INTRO)},
        {"id": "a1.u01.l03", "unitId": "a1.u01", "order": 3, "type": "grammar",
         "title": t("I am, you are", "Ik ben, jij bent", "Yo soy, tú eres"),
         "grammarId": GRAMMAR_PRESENT["id"], "items": []},
        {"id": "a1.u01.l04", "unitId": "a1.u01", "order": 4, "type": "listening",
         "title": t("Listen: first conversations", "Luisteren: eerste gesprekken", "Escuchar: primeras conversaciones"),
         "items": [f"a1.sent.s{n:03d}" for n in (1, 2, 4, 5, 6, 8, 12, 14)]},
        {"id": "a1.u01.l05", "unitId": "a1.u01", "order": 5, "type": "reading",
         "title": t("Read: Sara in Berlin", "Lezen: Sara in Berlijn", "Leer: Sara en Berlín"),
         "textId": text["id"], "items": []},
        {"id": "a1.u01.l06", "unitId": "a1.u01", "order": 6, "type": "review",
         "title": t("Unit 1 review", "Herhaling unit 1", "Repaso de la unidad 1"),
         "items": ids(VOCAB_U01_GREETINGS) + ids(VOCAB_U01_INTRO)},
        {"id": "a1.u02.l01", "unitId": "a1.u02", "order": 1, "type": "vocab",
         "title": t("My family", "Mijn familie", "Mi familia"),
         "items": ids(VOCAB_U02_FAMILY)},
    ]

    units = [
        {"id": "a1.u01", "level": "A1", "order": 1,
         "theme": t("Hello! Greetings and introductions", "Hallo! Begroeten en voorstellen", "¡Hola! Saludos y presentaciones"),
         "goals": [t("Greet people and say goodbye", "Mensen begroeten en afscheid nemen", "Saludar y despedirse"),
                   t("Say your name, where you're from and where you live",
                     "Je naam zeggen, waar je vandaan komt en waar je woont",
                     "Decir tu nombre, de dónde eres y dónde vives")],
         "grammarIds": [GRAMMAR_PRESENT["id"]],
         "lessonIds": [l["id"] for l in lessons if l["unitId"] == "a1.u01"]},
        {"id": "a1.u02", "level": "A1", "order": 2,
         "theme": t("Family and numbers", "Familie en getallen", "Familia y números"),
         "goals": [t("Talk about your family", "Over je familie praten", "Hablar de tu familia"),
                   t("Count from 1 to 20", "Tellen van 1 tot 20", "Contar del 1 al 20")],
         "grammarIds": [],
         "lessonIds": [l["id"] for l in lessons if l["unitId"] == "a1.u02"]},
    ]

    return {
        "schemaVersion": SCHEMA_VERSION,
        "contentVersion": "2026.11.21-starter",
        "level": {
            "id": "A1",
            "title": t("A1 Beginner", "A1 Beginner", "A1 Principiante"),
            "targetHours": 150,
            "canDo": [
                t("Introduce yourself and others", "Jezelf en anderen voorstellen", "Presentarte a ti y a otros"),
                t("Ask and answer simple personal questions", "Eenvoudige persoonlijke vragen stellen en beantwoorden",
                  "Hacer y responder preguntas personales sencillas"),
            ],
        },
        "units": units,
        "lessons": lessons,
        "vocab": vocab,
        "sentences": sentences,
        "grammar": [GRAMMAR_PRESENT],
        "texts": [text, TEXT_DW],
        "writingPrompts": WRITING_PROMPTS,
        "credits": [
            {"name": "3Lang original content", "license": LIC},
        ],
    }


def main() -> None:
    out = APP_CONTENT_DIR / "a1.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(build(), ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
