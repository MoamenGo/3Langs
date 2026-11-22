"""Hand-written A1 units 2 to 4, used by starter_a1.py.

Each unit spec lists its vocab lessons, example sentences, one grammar point,
a listening set, a reading text and writing prompts, in German with English,
Dutch and Spanish. starter_a1.py turns a spec into lessons with stable ids.
"""
from __future__ import annotations


def t(en: str, nl: str, es: str) -> dict:
    return {"en": en, "nl": nl, "es": es}


# Vocab tuple: (lemma, article, plural, pos, en, nl, es, freq_rank)
# Sentence tuple: (key, German, en, nl, es, [lemmas it illustrates])

# ---------------------------------------------------------------------------
# Unit 2: family and numbers
# ---------------------------------------------------------------------------
U02_FAMILY = [
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

U02_NUMBERS = [
    ("vier", None, None, "numeral", "four", "vier", "cuatro", 400),
    ("fünf", None, None, "numeral", "five", "vijf", "cinco", 450),
    ("sechs", None, None, "numeral", "six", "zes", "seis", 700),
    ("sieben", None, None, "numeral", "seven", "zeven", "siete", 800),
    ("acht", None, None, "numeral", "eight", "acht", "ocho", 750),
    ("neun", None, None, "numeral", "nine", "negen", "nueve", 1000),
    ("zehn", None, None, "numeral", "ten", "tien", "diez", 600),
    ("zwanzig", None, None, "numeral", "twenty", "twintig", "veinte", 1100),
    ("alt", None, None, "adjective", "old", "oud", "viejo", 200),
    ("Jahr", "das", "Jahre", "noun", "year", "het jaar", "el año", 150),
    ("Sohn", "der", "Söhne", "noun", "son", "de zoon", "el hijo", 900),
    ("Tochter", "die", "Töchter", "noun", "daughter", "de dochter", "la hija", 1000),
    ("verheiratet", None, None, "adjective", "married", "getrouwd", "casado, casada", 2600),
    ("wie viele", None, None, "phrase", "how many", "hoeveel", "cuántos, cuántas", None),
]

U02_SENTENCES = [
    ("s021", "Das ist meine Familie.", "This is my family.", "Dit is mijn familie.", "Esta es mi familia.", ["Familie"]),
    ("s022", "Ich habe zwei Brüder.", "I have two brothers.", "Ik heb twee broers.", "Tengo dos hermanos.", ["haben", "zwei", "Bruder"]),
    ("s023", "Meine Mutter heißt Maria.", "My mother's name is Maria.", "Mijn moeder heet Maria.", "Mi madre se llama María.", ["Mutter", "heißen"]),
    ("s024", "Hast du Kinder?", "Do you have children?", "Heb jij kinderen?", "¿Tienes hijos?", ["haben", "Kind", "du"]),
    ("s025", "Mein Vater kommt aus Spanien.", "My father comes from Spain.", "Mijn vader komt uit Spanje.", "Mi padre es de España.", ["Vater", "kommen", "aus"]),
    ("s026", "Ich habe eine Schwester.", "I have one sister.", "Ik heb één zus.", "Tengo una hermana.", ["haben", "Schwester"]),
    ("s027", "Eins, zwei, drei – los!", "One, two, three – go!", "Een, twee, drie – start!", "Uno, dos, tres, ¡ya!", ["eins", "zwei", "drei"]),
    ("s028", "Wie alt bist du?", "How old are you?", "Hoe oud ben jij?", "¿Cuántos años tienes?", ["wie", "alt", "sein", "du"]),
    ("s029", "Ich bin zwanzig Jahre alt.", "I'm twenty years old.", "Ik ben twintig jaar oud.", "Tengo veinte años.", ["sein", "zwanzig", "Jahr", "alt"]),
    ("s030", "Mein Sohn ist acht.", "My son is eight.", "Mijn zoon is acht.", "Mi hijo tiene ocho años.", ["Sohn", "acht"]),
    ("s031", "Wie viele Kinder hast du?", "How many children do you have?", "Hoeveel kinderen heb jij?", "¿Cuántos hijos tienes?", ["wie viele", "haben", "Kind"]),
    ("s032", "Meine Tochter ist fünf Jahre alt.", "My daughter is five years old.", "Mijn dochter is vijf jaar oud.", "Mi hija tiene cinco años.", ["Tochter", "fünf", "Jahr", "alt"]),
    ("s033", "Bist du verheiratet?", "Are you married?", "Ben jij getrouwd?", "¿Estás casado?", ["verheiratet", "du"]),
    ("s034", "Ja, und wir haben zwei Kinder.", "Yes, and we have two children.", "Ja, en we hebben twee kinderen.", "Sí, y tenemos dos hijos.", ["ja", "haben", "zwei", "Kind"]),
    ("s035", "Sie hat drei Kinder.", "She has three children.", "Zij heeft drie kinderen.", "Ella tiene tres hijos.", ["haben", "drei", "Kind"]),
    ("s036", "Das ist dein Bruder, oder?", "That's your brother, isn't it?", "Dat is jouw broer, toch?", "Ese es tu hermano, ¿no?", ["Bruder"]),
    ("s037", "Meine Eltern wohnen in Kairo.", "My parents live in Cairo.", "Mijn ouders wonen in Caïro.", "Mis padres viven en El Cairo.", ["wohnen", "in"]),
    ("s038", "Sieben, acht, neun, zehn!", "Seven, eight, nine, ten!", "Zeven, acht, negen, tien!", "¡Siete, ocho, nueve, diez!", ["sieben", "acht", "neun", "zehn"]),
    ("s039", "Unsere Katze ist vier Jahre alt.", "Our cat is four years old.", "Onze kat is vier jaar oud.", "Nuestro gato tiene cuatro años.", ["vier", "Jahr", "alt"]),
    ("s040", "Mein Bruder hat sechs Kinder!", "My brother has six children!", "Mijn broer heeft zes kinderen!", "¡Mi hermano tiene seis hijos!", ["Bruder", "haben", "sechs", "Kind"]),
]

U02_GRAMMAR = {
    "id": "a1.gram.haben_possessive",
    "title": t("haben and my/your: mein, dein",
               "haben en mijn/jouw: mein, dein",
               "haben y mi/tu: mein, dein"),
    "explanation": t(
        "haben (to have) is slightly irregular: du hast, er/sie/es hat. The other forms are regular.\n\n"
        "Possessive words take the gender of the noun that follows. Use mein, dein, sein... before masculine "
        "and neuter nouns (mein Bruder, mein Kind) and add -e before feminine and plural nouns "
        "(meine Mutter, meine Kinder).\n\n"
        "sein means his, ihr means her, unser means our.\n\n"
        "Age uses sein, not haben: Ich bin zwanzig Jahre alt.",
        "haben (hebben) is een beetje onregelmatig: du hast, er/sie/es hat. De andere vormen zijn regelmatig.\n\n"
        "Bezittelijke woorden passen zich aan het geslacht van het zelfstandig naamwoord aan. Gebruik mein, dein, "
        "sein... voor mannelijke en onzijdige woorden (mein Bruder, mein Kind) en zet er -e achter voor "
        "vrouwelijke woorden en meervoud (meine Mutter, meine Kinder).\n\n"
        "sein betekent zijn, ihr betekent haar, unser betekent ons/onze.\n\n"
        "Leeftijd gaat met sein, net als in het Nederlands: Ich bin zwanzig Jahre alt.",
        "haben (tener) es un poco irregular: du hast, er/sie/es hat. Las demás formas son regulares.\n\n"
        "Los posesivos concuerdan con el género del sustantivo que sigue. Usa mein, dein, sein... con sustantivos "
        "masculinos y neutros (mein Bruder, mein Kind) y añade -e con femeninos y plurales "
        "(meine Mutter, meine Kinder).\n\n"
        "sein significa su (de él), ihr significa su (de ella), unser significa nuestro.\n\n"
        "Ojo: la edad se dice con sein (ser), no con haben (tener): Ich bin zwanzig Jahre alt = Tengo veinte años.",
    ),
    "table": {
        "headers": ["", "haben", "masc./neut.", "fem./plural"],
        "rows": [
            ["ich", "habe", "mein", "meine"],
            ["du", "hast", "dein", "deine"],
            ["er / es", "hat", "sein", "seine"],
            ["sie (she)", "hat", "ihr", "ihre"],
            ["wir", "haben", "unser", "unsere"],
            ["ihr", "habt", "euer", "eure"],
            ["sie / Sie", "haben", "ihr / Ihr", "ihre / Ihre"],
        ],
    },
    "examples": ["s022", "s024", "s023", "s029"],
    "exercises": [
        {"type": "fill_blank", "prompt": "Ich ___ zwei Brüder.", "answer": "habe", "base": "haben"},
        {"type": "fill_blank", "prompt": "___ du Kinder?", "answer": "Hast", "base": "haben"},
        {"type": "fill_blank", "prompt": "Er ___ eine Schwester.", "answer": "hat", "base": "haben"},
        {"type": "fill_blank", "prompt": "Wir ___ drei Kinder.", "answer": "haben", "base": "haben"},
        {"type": "fill_blank", "prompt": "Das ist ___ Mutter.", "answer": "meine", "base": "mein-"},
        {"type": "fill_blank", "prompt": "Das ist ___ Vater.", "answer": "mein", "base": "mein-"},
        {"type": "fill_blank", "prompt": "Ist das ___ Bruder?", "answer": "dein", "base": "dein-"},
        {"type": "fill_blank", "prompt": "Das sind ___ Kinder.", "answer": "meine", "base": "mein-"},
    ],
}

U02_TEXT = {
    "id": "a1.text.mia_familie",
    "title": "Meine Familie",
    "body": (
        "Hallo! Ich bin Mia und ich bin zehn Jahre alt. Das ist meine Familie. "
        "Meine Mutter heißt Anna, mein Vater heißt Jonas. Ich habe einen Bruder, er heißt Ben. "
        "Ben ist sieben. Wir wohnen in Hamburg. Meine Oma wohnt auch in Hamburg."
    ),
    "translation": t(
        "Hi! I'm Mia and I'm ten years old. This is my family. My mother's name is Anna, my father's name is "
        "Jonas. I have a brother, his name is Ben. Ben is seven. We live in Hamburg. My grandma lives in Hamburg too.",
        "Hallo! Ik ben Mia en ik ben tien jaar oud. Dit is mijn familie. Mijn moeder heet Anna, mijn vader heet "
        "Jonas. Ik heb een broer, hij heet Ben. Ben is zeven. We wonen in Hamburg. Mijn oma woont ook in Hamburg.",
        "¡Hola! Soy Mia y tengo diez años. Esta es mi familia. Mi madre se llama Anna, mi padre se llama Jonas. "
        "Tengo un hermano, se llama Ben. Ben tiene siete años. Vivimos en Hamburgo. Mi abuela también vive en Hamburgo.",
    ),
    "glossary": ["Familie", "Mutter", "Vater", "Bruder", "zehn", "sieben", "alt"],
    "questions": [
        {"question": "Wie alt ist Mia?", "options": ["Sieben", "Zehn", "Zwanzig"], "answer": 1},
        {"question": "Wie heißt Mias Vater?", "options": ["Jonas", "Ben", "Lukas"], "answer": 0},
        {"question": "Wo wohnt die Familie?", "options": ["In Berlin", "In Hamburg", "In Kairo"], "answer": 1},
    ],
}

# ---------------------------------------------------------------------------
# Unit 3: home and living
# ---------------------------------------------------------------------------
U03_ROOMS = [
    ("Haus", "das", "Häuser", "noun", "house", "het huis", "la casa", 160),
    ("Wohnung", "die", "Wohnungen", "noun", "flat, apartment", "het appartement, de woning", "el piso, el apartamento", 900),
    ("Zimmer", "das", "Zimmer", "noun", "room", "de kamer", "la habitación", 500),
    ("Küche", "die", "Küchen", "noun", "kitchen", "de keuken", "la cocina", 1300),
    ("Bad", "das", "Bäder", "noun", "bathroom", "de badkamer", "el baño", 1800),
    ("Schlafzimmer", "das", "Schlafzimmer", "noun", "bedroom", "de slaapkamer", "el dormitorio", 4000),
    ("Wohnzimmer", "das", "Wohnzimmer", "noun", "living room", "de woonkamer", "el salón", 5000),
    ("Balkon", "der", "Balkone", "noun", "balcony", "het balkon", "el balcón", 6000),
    ("Garten", "der", "Gärten", "noun", "garden", "de tuin", "el jardín", 2200),
    ("groß", None, None, "adjective", "big, tall", "groot", "grande", 180),
    ("klein", None, None, "adjective", "small, little", "klein", "pequeño", 300),
    ("schön", None, None, "adjective", "beautiful, nice", "mooi", "bonito", 140),
]

U03_FURNITURE = [
    ("Tisch", "der", "Tische", "noun", "table", "de tafel", "la mesa", 1400),
    ("Stuhl", "der", "Stühle", "noun", "chair", "de stoel", "la silla", 3000),
    ("Bett", "das", "Betten", "noun", "bed", "het bed", "la cama", 700),
    ("Sofa", "das", "Sofas", "noun", "sofa", "de bank, de sofa", "el sofá", 6500),
    ("Schrank", "der", "Schränke", "noun", "cupboard, wardrobe", "de kast", "el armario", 5500),
    ("Lampe", "die", "Lampen", "noun", "lamp", "de lamp", "la lámpara", 7000),
    ("Fenster", "das", "Fenster", "noun", "window", "het raam", "la ventana", 1600),
    ("Tür", "die", "Türen", "noun", "door", "de deur", "la puerta", 600),
    ("neu", None, None, "adjective", "new", "nieuw", "nuevo", 400),
    ("teuer", None, None, "adjective", "expensive", "duur", "caro", 2500),
    ("billig", None, None, "adjective", "cheap", "goedkoop", "barato", 4500),
    ("hell", None, None, "adjective", "bright, light", "licht", "luminoso, claro", 3500),
]

U03_SENTENCES = [
    ("s041", "Meine Wohnung ist klein, aber schön.", "My flat is small but nice.", "Mijn appartement is klein, maar mooi.", "Mi piso es pequeño, pero bonito.", ["Wohnung", "klein", "schön"]),
    ("s042", "Das Haus hat einen Garten.", "The house has a garden.", "Het huis heeft een tuin.", "La casa tiene jardín.", ["Haus", "Garten", "haben"]),
    ("s043", "Die Küche ist groß und hell.", "The kitchen is big and bright.", "De keuken is groot en licht.", "La cocina es grande y luminosa.", ["Küche", "groß", "hell"]),
    ("s044", "Wie viele Zimmer hat die Wohnung?", "How many rooms does the flat have?", "Hoeveel kamers heeft het appartement?", "¿Cuántas habitaciones tiene el piso?", ["wie viele", "Zimmer", "Wohnung"]),
    ("s045", "Die Wohnung hat drei Zimmer, ein Bad und einen Balkon.", "The flat has three rooms, a bathroom and a balcony.", "Het appartement heeft drie kamers, een badkamer en een balkon.", "El piso tiene tres habitaciones, un baño y un balcón.", ["Wohnung", "Zimmer", "Bad", "Balkon"]),
    ("s046", "Das Sofa ist neu. Es ist sehr bequem.", "The sofa is new. It's very comfortable.", "De bank is nieuw. Hij zit heel lekker.", "El sofá es nuevo. Es muy cómodo.", ["Sofa", "neu"]),
    ("s047", "Der Tisch ist alt, aber schön.", "The table is old but beautiful.", "De tafel is oud, maar mooi.", "La mesa es vieja, pero bonita.", ["Tisch", "alt", "schön"]),
    ("s048", "Im Schlafzimmer stehen ein Bett und ein Schrank.", "In the bedroom there's a bed and a wardrobe.", "In de slaapkamer staan een bed en een kast.", "En el dormitorio hay una cama y un armario.", ["Schlafzimmer", "Bett", "Schrank"]),
    ("s049", "Die Lampe ist teuer.", "The lamp is expensive.", "De lamp is duur.", "La lámpara es cara.", ["Lampe", "teuer"]),
    ("s050", "Der Stuhl ist billig.", "The chair is cheap.", "De stoel is goedkoop.", "La silla es barata.", ["Stuhl", "billig"]),
    ("s051", "Mach bitte das Fenster auf!", "Please open the window!", "Doe alsjeblieft het raam open!", "¡Abre la ventana, por favor!", ["Fenster", "bitte"]),
    ("s052", "Die Tür ist zu.", "The door is closed.", "De deur is dicht.", "La puerta está cerrada.", ["Tür"]),
    ("s053", "Wir sitzen im Wohnzimmer.", "We're sitting in the living room.", "We zitten in de woonkamer.", "Estamos sentados en el salón.", ["Wohnzimmer"]),
    ("s054", "Das Bad ist sehr klein.", "The bathroom is very small.", "De badkamer is heel klein.", "El baño es muy pequeño.", ["Bad", "klein"]),
    ("s055", "Ist der Garten groß?", "Is the garden big?", "Is de tuin groot?", "¿Es grande el jardín?", ["Garten", "groß"]),
    ("s056", "Der Schrank ist neu. Er ist sehr groß.", "The wardrobe is new. It's very big.", "De kast is nieuw. Hij is heel groot.", "El armario es nuevo. Es muy grande.", ["Schrank", "neu", "groß"]),
]

U03_GRAMMAR = {
    "id": "a1.gram.articles_gender",
    "title": t("der, die, das: articles and gender",
               "der, die, das: lidwoorden en geslacht",
               "der, die, das: artículos y género"),
    "explanation": t(
        "Every German noun is masculine (der), feminine (die) or neuter (das). The gender often doesn't follow "
        "logic, so always learn a noun together with its article: der Tisch, die Lampe, das Bett.\n\n"
        "The indefinite article is ein for masculine and neuter, eine for feminine. In the plural the definite "
        "article is always die, and there is no indefinite article: die Betten, Betten.\n\n"
        "When you replace a thing with a pronoun, use its grammatical gender: der Tisch → er, die Lampe → sie, "
        "das Bett → es. So: Der Schrank ist neu. Er ist groß. (\"It is big\" in English.)",
        "Elk Duits zelfstandig naamwoord is mannelijk (der), vrouwelijk (die) of onzijdig (das). Waar het "
        "Nederlands de en het heeft, heeft het Duits drie lidwoorden. Leer een woord daarom altijd met zijn "
        "lidwoord: der Tisch, die Lampe, das Bett. Een het-woord is vaak (niet altijd) das: das Haus, das Bett.\n\n"
        "Het onbepaalde lidwoord is ein bij mannelijk en onzijdig, eine bij vrouwelijk. In het meervoud is het "
        "bepaalde lidwoord altijd die: die Betten.\n\n"
        "Voor dingen gebruik je het voornaamwoord van het grammaticale geslacht: der Tisch → er, die Lampe → sie, "
        "das Bett → es. Dus: Der Schrank ist neu. Er ist groß. (net als: De kast is nieuw. Hij is groot.)",
        "Todo sustantivo alemán es masculino (der), femenino (die) o neutro (das). El género no siempre coincide "
        "con el español (la mesa → der Tisch), así que aprende cada palabra con su artículo: der Tisch, "
        "die Lampe, das Bett.\n\n"
        "El artículo indeterminado es ein para masculino y neutro, eine para femenino. En plural el artículo "
        "determinado siempre es die y no hay artículo indeterminado: die Betten, Betten.\n\n"
        "Para referirte a una cosa con un pronombre, usa su género gramatical: der Tisch → er, die Lampe → sie, "
        "das Bett → es. Así: Der Schrank ist neu. Er ist groß. (El armario es nuevo. Es grande.)",
    ),
    "table": {
        "headers": ["", "masculine", "feminine", "neuter", "plural"],
        "rows": [
            ["the", "der Tisch", "die Lampe", "das Bett", "die Betten"],
            ["a", "ein Tisch", "eine Lampe", "ein Bett", "– Betten"],
            ["it / they", "er", "sie", "es", "sie"],
        ],
    },
    "examples": ["s047", "s049", "s056"],
    "exercises": [
        {"type": "fill_blank", "prompt": "___ Küche ist groß.", "answer": "Die", "base": "der / die / das"},
        {"type": "fill_blank", "prompt": "___ Tisch ist neu.", "answer": "Der", "base": "der / die / das"},
        {"type": "fill_blank", "prompt": "___ Bett ist klein.", "answer": "Das", "base": "der / die / das"},
        {"type": "fill_blank", "prompt": "Das ist ___ Lampe.", "answer": "eine", "base": "ein / eine"},
        {"type": "fill_blank", "prompt": "Das ist ___ Stuhl.", "answer": "ein", "base": "ein / eine"},
        {"type": "fill_blank", "prompt": "Der Schrank ist teuer. ___ ist neu.", "answer": "Er", "base": "er / sie / es"},
        {"type": "fill_blank", "prompt": "Die Wohnung ist hell. ___ ist schön.", "answer": "Sie", "base": "er / sie / es"},
        {"type": "fill_blank", "prompt": "Das Haus ist alt. ___ hat einen Garten.", "answer": "Es", "base": "er / sie / es"},
    ],
}

U03_TEXT = {
    "id": "a1.text.neue_wohnung",
    "title": "Meine neue Wohnung",
    "body": (
        "Hallo Tom, ich habe eine neue Wohnung! Sie ist nicht groß, aber sehr schön. "
        "Die Wohnung hat zwei Zimmer, eine Küche und ein Bad. Das Wohnzimmer ist hell und hat einen Balkon. "
        "Die Küche ist klein. Im Schlafzimmer stehen ein Bett und ein Schrank. Das Sofa ist neu, das Bett ist alt. "
        "Die Wohnung ist nicht teuer. Komm doch am Samstag! Liebe Grüße, Sara"
    ),
    "translation": t(
        "Hi Tom, I have a new flat! It isn't big, but it's very nice. The flat has two rooms, a kitchen and a "
        "bathroom. The living room is bright and has a balcony. The kitchen is small. In the bedroom there's a bed "
        "and a wardrobe. The sofa is new, the bed is old. The flat isn't expensive. Come over on Saturday! Love, Sara",
        "Hoi Tom, ik heb een nieuw appartement! Het is niet groot, maar wel heel mooi. Het appartement heeft twee "
        "kamers, een keuken en een badkamer. De woonkamer is licht en heeft een balkon. De keuken is klein. In de "
        "slaapkamer staan een bed en een kast. De bank is nieuw, het bed is oud. Het appartement is niet duur. "
        "Kom zaterdag langs! Groetjes, Sara",
        "¡Hola, Tom! ¡Tengo un piso nuevo! No es grande, pero es muy bonito. El piso tiene dos habitaciones, una "
        "cocina y un baño. El salón es luminoso y tiene balcón. La cocina es pequeña. En el dormitorio hay una cama "
        "y un armario. El sofá es nuevo, la cama es vieja. El piso no es caro. ¡Ven el sábado! Un abrazo, Sara",
    ),
    "glossary": ["Wohnung", "Zimmer", "Küche", "Bad", "Wohnzimmer", "Balkon", "hell", "teuer"],
    "questions": [
        {"question": "Wie viele Zimmer hat die Wohnung?", "options": ["Ein Zimmer", "Zwei Zimmer", "Drei Zimmer"], "answer": 1},
        {"question": "Wie ist die Küche?", "options": ["Groß", "Klein", "Teuer"], "answer": 1},
        {"question": "Was ist neu?", "options": ["Das Bett", "Der Schrank", "Das Sofa"], "answer": 2},
    ],
}

# ---------------------------------------------------------------------------
# Unit 4: food and drink
# ---------------------------------------------------------------------------
U04_FOOD = [
    ("Brot", "das", "Brote", "noun", "bread", "het brood", "el pan", 1700),
    ("Brötchen", "das", "Brötchen", "noun", "bread roll", "het broodje", "el panecillo", 6000),
    ("Käse", "der", None, "noun", "cheese", "de kaas", "el queso", 4000),
    ("Wurst", "die", "Würste", "noun", "sausage; cold cuts", "de worst; de vleeswaren", "la salchicha; el embutido", 5000),
    ("Ei", "das", "Eier", "noun", "egg", "het ei", "el huevo", 3500),
    ("Apfel", "der", "Äpfel", "noun", "apple", "de appel", "la manzana", 4500),
    ("Fleisch", "das", None, "noun", "meat", "het vlees", "la carne", 2000),
    ("Fisch", "der", "Fische", "noun", "fish", "de vis", "el pescado; el pez", 1900),
    ("Gemüse", "das", None, "noun", "vegetables", "de groente", "la verdura", 6500),
    ("Obst", "das", None, "noun", "fruit", "het fruit", "la fruta", 8000),
    ("Reis", "der", None, "noun", "rice", "de rijst", "el arroz", 9000),
    ("Kartoffel", "die", "Kartoffeln", "noun", "potato", "de aardappel", "la patata", 8500),
]

U04_DRINKS = [
    ("Wasser", "das", None, "noun", "water", "het water", "el agua", 800),
    ("Kaffee", "der", None, "noun", "coffee", "de koffie", "el café", 1100),
    ("Tee", "der", None, "noun", "tea", "de thee", "el té", 3000),
    ("Milch", "die", None, "noun", "milk", "de melk", "la leche", 4000),
    ("Saft", "der", "Säfte", "noun", "juice", "het sap", "el zumo", 9500),
    ("essen", None, None, "verb", "to eat", "eten", "comer", 450),
    ("trinken", None, None, "verb", "to drink", "drinken", "beber", 600),
    ("möchten", None, None, "verb", "would like", "graag willen", "querer, querría", 250),
    ("Frühstück", "das", None, "noun", "breakfast", "het ontbijt", "el desayuno", 3500),
    ("Mittagessen", "das", None, "noun", "lunch", "de lunch, het middageten", "la comida, el almuerzo", 7000),
    ("Abendessen", "das", None, "noun", "dinner, supper", "het avondeten", "la cena", 4500),
    ("lecker", None, None, "adjective", "tasty, delicious", "lekker", "rico, delicioso", 3000),
    ("Hunger", "der", None, "noun", "hunger", "de honger", "el hambre", 2800),
    ("Durst", "der", None, "noun", "thirst", "de dorst", "la sed", 9000),
]

U04_SENTENCES = [
    ("s057", "Ich möchte einen Kaffee, bitte.", "I'd like a coffee, please.", "Ik wil graag een koffie, alstublieft.", "Querría un café, por favor.", ["möchten", "Kaffee", "bitte"]),
    ("s058", "Zum Frühstück esse ich Brot mit Käse.", "For breakfast I eat bread with cheese.", "Als ontbijt eet ik brood met kaas.", "Para desayunar como pan con queso.", ["Frühstück", "essen", "Brot", "Käse"]),
    ("s059", "Trinkst du Tee oder Kaffee?", "Do you drink tea or coffee?", "Drink jij thee of koffie?", "¿Bebes té o café?", ["trinken", "Tee", "Kaffee"]),
    ("s060", "Ich habe Hunger!", "I'm hungry!", "Ik heb honger!", "¡Tengo hambre!", ["haben", "Hunger"]),
    ("s061", "Hast du Durst?", "Are you thirsty?", "Heb jij dorst?", "¿Tienes sed?", ["haben", "Durst"]),
    ("s062", "Ich esse kein Fleisch.", "I don't eat meat.", "Ik eet geen vlees.", "No como carne.", ["essen", "Fleisch"]),
    ("s063", "Der Fisch ist sehr lecker.", "The fish is very tasty.", "De vis is heel lekker.", "El pescado está muy rico.", ["Fisch", "lecker"]),
    ("s064", "Möchtest du einen Apfel?", "Would you like an apple?", "Wil je een appel?", "¿Quieres una manzana?", ["möchten", "Apfel"]),
    ("s065", "Zum Mittagessen gibt es Reis mit Gemüse.", "For lunch there's rice with vegetables.", "Als lunch is er rijst met groente.", "Para comer hay arroz con verdura.", ["Mittagessen", "Reis", "Gemüse"]),
    ("s066", "Kinder trinken viel Milch.", "Children drink a lot of milk.", "Kinderen drinken veel melk.", "Los niños beben mucha leche.", ["Kind", "trinken", "Milch"]),
    ("s067", "Ein Wasser und einen Saft, bitte.", "A water and a juice, please.", "Een water en een sap, alstublieft.", "Un agua y un zumo, por favor.", ["Wasser", "Saft", "bitte"]),
    ("s068", "Wir essen Kartoffeln mit Wurst.", "We eat potatoes with sausage.", "We eten aardappelen met worst.", "Comemos patatas con salchicha.", ["essen", "Kartoffel", "Wurst"]),
    ("s069", "Was gibt es zum Abendessen?", "What's for dinner?", "Wat eten we vanavond?", "¿Qué hay de cena?", ["Abendessen"]),
    ("s070", "Ich esse jeden Tag Obst.", "I eat fruit every day.", "Ik eet elke dag fruit.", "Como fruta todos los días.", ["essen", "Obst"]),
    ("s071", "Möchten Sie ein Ei?", "Would you like an egg?", "Wilt u een ei?", "¿Quiere un huevo?", ["möchten", "Ei", "Sie"]),
    ("s072", "Zwei Brötchen, bitte.", "Two bread rolls, please.", "Twee broodjes, alstublieft.", "Dos panecillos, por favor.", ["Brötchen", "zwei", "bitte"]),
]

U04_GRAMMAR = {
    "id": "a1.gram.accusative_moechten",
    "title": t("Accusative: einen Kaffee, keinen Hunger. And möchten",
               "Accusatief: einen Kaffee, keinen Hunger. En möchten",
               "Acusativo: einen Kaffee, keinen Hunger. Y möchten"),
    "explanation": t(
        "The thing you eat, drink, have or want is the object of the sentence, and German marks it with the "
        "accusative case. Good news: only masculine words change. der → den, ein → einen, kein → keinen: "
        "Ich möchte einen Kaffee. Ich habe keinen Hunger. Feminine, neuter and plural stay the same.\n\n"
        "kein means \"no / not a\": Ich esse kein Fleisch (I don't eat meat).\n\n"
        "möchten (would like) is the polite way to order: ich möchte, du möchtest, er/sie möchte, "
        "wir möchten, ihr möchtet, sie/Sie möchten. Note: no -t in the er/sie form.",
        "Het ding dat je eet, drinkt, hebt of wilt is het lijdend voorwerp. Het Duits geeft dat aan met de "
        "accusatief (vierde naamval). Goed nieuws: alleen mannelijke woorden veranderen. der → den, ein → einen, "
        "kein → keinen: Ich möchte einen Kaffee. Ich habe keinen Hunger. Vrouwelijk, onzijdig en meervoud "
        "blijven gelijk.\n\n"
        "kein betekent geen: Ich esse kein Fleisch (ik eet geen vlees).\n\n"
        "möchten (graag willen) gebruik je om beleefd te bestellen: ich möchte, du möchtest, er/sie möchte, "
        "wir möchten, ihr möchtet, sie/Sie möchten. Let op: geen -t bij er/sie.",
        "Lo que comes, bebes, tienes o quieres es el complemento directo, y en alemán va en acusativo. "
        "La buena noticia: solo cambian las palabras masculinas. der → den, ein → einen, kein → keinen: "
        "Ich möchte einen Kaffee. Ich habe keinen Hunger. Femenino, neutro y plural no cambian.\n\n"
        "kein significa \"ningún / no\": Ich esse kein Fleisch (no como carne).\n\n"
        "möchten (querría, me gustaría) es la forma educada de pedir: ich möchte, du möchtest, er/sie möchte, "
        "wir möchten, ihr möchtet, sie/Sie möchten. Ojo: sin -t en la forma de er/sie.",
    ),
    "table": {
        "headers": ["", "subject (nominative)", "object (accusative)"],
        "rows": [
            ["masculine", "der / ein / kein Apfel", "den / einen / keinen Apfel"],
            ["feminine", "die / eine / keine Wurst", "die / eine / keine Wurst"],
            ["neuter", "das / ein / kein Ei", "das / ein / kein Ei"],
            ["plural", "die / – / keine Eier", "die / – / keine Eier"],
        ],
    },
    "examples": ["s057", "s064", "s062", "s060"],
    "exercises": [
        {"type": "fill_blank", "prompt": "Ich möchte ___ Kaffee, bitte.", "answer": "einen", "base": "ein"},
        {"type": "fill_blank", "prompt": "Ich esse ___ Apfel.", "answer": "einen", "base": "ein"},
        {"type": "fill_blank", "prompt": "Möchtest du ___ Tee?", "answer": "einen", "base": "ein"},
        {"type": "fill_blank", "prompt": "Ich kaufe ___ Brot.", "answer": "ein", "base": "ein"},
        {"type": "fill_blank", "prompt": "Wir trinken ___ Milch.", "answer": "keine", "base": "kein"},
        {"type": "fill_blank", "prompt": "Ich habe ___ Hunger.", "answer": "keinen", "base": "kein"},
        {"type": "fill_blank", "prompt": "Er ___ ein Brötchen.", "answer": "möchte", "base": "möchten"},
        {"type": "fill_blank", "prompt": "___ du Wasser?", "answer": "Möchtest", "base": "möchten"},
    ],
}

U04_TEXT = {
    "id": "a1.text.im_cafe",
    "title": "Im Café",
    "body": (
        "Kellner: Guten Tag! Was möchten Sie?\n"
        "Anna: Ich möchte einen Kaffee mit Milch, bitte.\n"
        "Kellner: Und Sie?\n"
        "Peter: Ich habe Durst. Ein Wasser, bitte. Und ich habe auch Hunger. Haben Sie Brötchen?\n"
        "Kellner: Ja, mit Käse oder mit Wurst.\n"
        "Peter: Ich esse kein Fleisch. Ein Brötchen mit Käse, bitte.\n"
        "Kellner: Gern. Also: ein Kaffee, ein Wasser und ein Brötchen mit Käse."
    ),
    "translation": t(
        "Waiter: Hello! What would you like? / Anna: I'd like a coffee with milk, please. / Waiter: And you? / "
        "Peter: I'm thirsty. A water, please. And I'm hungry too. Do you have bread rolls? / Waiter: Yes, with "
        "cheese or with sausage. / Peter: I don't eat meat. A roll with cheese, please. / Waiter: Sure. So: a "
        "coffee, a water and a roll with cheese.",
        "Ober: Goedendag! Wat wilt u? / Anna: Ik wil graag een koffie met melk. / Ober: En u? / Peter: Ik heb "
        "dorst. Een water, alstublieft. En ik heb ook honger. Hebt u broodjes? / Ober: Ja, met kaas of met worst. "
        "/ Peter: Ik eet geen vlees. Een broodje kaas, alstublieft. / Ober: Graag. Dus: een koffie, een water en "
        "een broodje kaas.",
        "Camarero: ¡Buenos días! ¿Qué desean? / Anna: Querría un café con leche, por favor. / Camarero: ¿Y usted? "
        "/ Peter: Tengo sed. Un agua, por favor. Y también tengo hambre. ¿Tienen panecillos? / Camarero: Sí, de "
        "queso o de embutido. / Peter: No como carne. Un panecillo de queso, por favor. / Camarero: Muy bien. "
        "Entonces: un café, un agua y un panecillo de queso.",
    ),
    "glossary": ["möchten", "Kaffee", "Milch", "Durst", "Hunger", "Brötchen", "Käse", "Wurst", "Fleisch"],
    "questions": [
        {"question": "Was trinkt Anna?", "options": ["Tee", "Kaffee mit Milch", "Wasser"], "answer": 1},
        {"question": "Was isst Peter?", "options": ["Ein Brötchen mit Wurst", "Ein Brötchen mit Käse", "Einen Apfel"], "answer": 1},
        {"question": "Warum isst Peter keine Wurst?", "options": ["Er isst kein Fleisch.", "Er hat keinen Hunger.", "Er trinkt nur Wasser."], "answer": 0},
    ],
}

UNITS = [
    {
        "key": "u02",
        "theme": t("Family and numbers", "Familie en getallen", "Familia y números"),
        "goals": [t("Talk about your family", "Over je familie praten", "Hablar de tu familia"),
                  t("Count to 20 and say how old someone is", "Tot 20 tellen en zeggen hoe oud iemand is",
                    "Contar hasta 20 y decir la edad de alguien")],
        "vocabLessons": [
            (t("My family", "Mijn familie", "Mi familia"), U02_FAMILY),
            (t("Numbers and age", "Getallen en leeftijd", "Números y edad"), U02_NUMBERS),
        ],
        "sentences": U02_SENTENCES,
        "grammar": U02_GRAMMAR,
        "grammarTitle": t("I have, my and your", "Ik heb, mijn en jouw", "Tengo, mi y tu"),
        "listening": ["s022", "s024", "s028", "s029", "s031", "s033", "s035", "s038"],
        "listeningTitle": t("Listen: family talk", "Luisteren: over familie", "Escuchar: hablar de la familia"),
        "text": U02_TEXT,
        "readingTitle": t("Read: Mia's family", "Lezen: de familie van Mia", "Leer: la familia de Mia"),
        "reviewTitle": t("Unit 2 review", "Herhaling unit 2", "Repaso de la unidad 2"),
    },
    {
        "key": "u03",
        "theme": t("Home and living", "Wonen", "La casa"),
        "goals": [t("Describe your flat or house", "Je appartement of huis beschrijven", "Describir tu piso o casa"),
                  t("Name rooms and furniture with the right article", "Kamers en meubels noemen met het juiste lidwoord",
                    "Nombrar habitaciones y muebles con el artículo correcto")],
        "vocabLessons": [
            (t("Rooms", "Kamers", "Habitaciones"), U03_ROOMS),
            (t("Furniture", "Meubels", "Muebles"), U03_FURNITURE),
        ],
        "sentences": U03_SENTENCES,
        "grammar": U03_GRAMMAR,
        "grammarTitle": t("der, die or das?", "der, die of das?", "¿der, die o das?"),
        "listening": ["s041", "s042", "s043", "s046", "s049", "s050", "s052", "s054"],
        "listeningTitle": t("Listen: at home", "Luisteren: thuis", "Escuchar: en casa"),
        "text": U03_TEXT,
        "readingTitle": t("Read: Sara's new flat", "Lezen: Sara's nieuwe appartement", "Leer: el piso nuevo de Sara"),
        "reviewTitle": t("Unit 3 review", "Herhaling unit 3", "Repaso de la unidad 3"),
    },
    {
        "key": "u04",
        "theme": t("Food and drink", "Eten en drinken", "Comida y bebida"),
        "goals": [t("Say what you eat and drink", "Zeggen wat je eet en drinkt", "Decir qué comes y bebes"),
                  t("Order in a café", "Bestellen in een café", "Pedir en una cafetería")],
        "vocabLessons": [
            (t("Food", "Eten", "Comida"), U04_FOOD),
            (t("Drinks and meals", "Drinken en maaltijden", "Bebidas y comidas"), U04_DRINKS),
        ],
        "sentences": U04_SENTENCES,
        "grammar": U04_GRAMMAR,
        "grammarTitle": t("I'd like a coffee", "Ik wil graag een koffie", "Querría un café"),
        "listening": ["s057", "s059", "s060", "s061", "s062", "s064", "s067", "s072"],
        "listeningTitle": t("Listen: ordering food", "Luisteren: eten bestellen", "Escuchar: pedir comida"),
        "text": U04_TEXT,
        "readingTitle": t("Read: in the café", "Lezen: in het café", "Leer: en la cafetería"),
        "reviewTitle": t("Unit 4 review", "Herhaling unit 4", "Repaso de la unidad 4"),
    },
]

WRITING_PROMPTS = [
    {
        "id": "a1.write.home",
        "level": "A1",
        "prompt": t(
            "Describe your home: how many rooms, what is in them, what is big, small, new or old?",
            "Beschrijf je huis: hoeveel kamers, wat staat erin, wat is groot, klein, nieuw of oud?",
            "Describe tu casa: ¿cuántas habitaciones tiene, qué hay en ellas, qué es grande, pequeño, nuevo o viejo?",
        ),
        "minWords": 20,
    },
    {
        "id": "a1.write.breakfast",
        "level": "A1",
        "prompt": t(
            "What do you eat and drink for breakfast, lunch and dinner?",
            "Wat eet en drink je bij het ontbijt, de lunch en het avondeten?",
            "¿Qué comes y bebes en el desayuno, la comida y la cena?",
        ),
        "minWords": 20,
    },
]
