"""A0 (first steps), units 1-4, for German, Dutch and Spanish.

A0 is built concept-first: each row is one meaning with its word in all
three languages, so the three packs stay in step. Words here never repeat an
A1 lemma, so a word is only ever scheduled once.
"""

LEVEL = {
    "title": {"ar": "A0 البداية", "en": "A0 First steps"},
    "targetHours": 30,
    "canDo": [
        {"ar": "تقرا وتنطق حروف اللغة وأصواتها", "en": "Read and pronounce the letters and sounds"},
        {"ar": "تستخدم عبارات النجاة لما متفهمش", "en": "Use survival phrases when you don't understand"},
        {"ar": "تقول الأيام والأرقام والساعة", "en": "Say days, numbers and the time"},
        {"ar": "تسأل أسئلة بسيطة: مين، فين، إمتى، ليه", "en": "Ask simple questions: who, where, when, why"},
    ],
}

UNITS = {
    "u01": {
        "theme": {"ar": "الأصوات والحروف", "en": "Sounds and letters"},
        "goals": [
            {"ar": "تعرف الأصوات اللي مش موجودة في العربي", "en": "Know the sounds that differ from Arabic and English"},
            {"ar": "تقرا كلمات دولية بالنطق الصح", "en": "Read international words with the right sounds"},
        ],
    },
    "u02": {
        "theme": {"ar": "عبارات النجاة", "en": "Survival phrases"},
        "goals": [
            {"ar": "تقول إنك مش فاهم وتطلب حد يعيد", "en": "Say you don't understand and ask for a repeat"},
            {"ar": "تسأل عن الحمّام والسعر", "en": "Ask for the toilet and the price"},
        ],
    },
    "u03": {
        "theme": {"ar": "الأرقام والأيام والوقت", "en": "Numbers, days and time"},
        "goals": [
            {"ar": "تقول أيام الأسبوع", "en": "Say the days of the week"},
            {"ar": "تقول النهارده وبكرة وامبارح والساعة", "en": "Say today, tomorrow, yesterday and the time"},
        ],
    },
    "u04": {
        "theme": {"ar": "أول أسئلة", "en": "First questions"},
        "goals": [
            {"ar": "تسأل بكلمات السؤال", "en": "Ask with question words"},
            {"ar": "تقول بتتكلم وبتتعلم لغات إيه", "en": "Say which languages you speak and learn"},
        ],
    },
}

# (concept, en, ar, {lang: (lemma, article, plural, pos)}), grouped by lesson.
W = lambda l, a=None, p=None, pos="noun": (l, a, p, pos)  # noqa: E731

VOCAB = {
    "u01.words": [
        ("taxi", "taxi", "تاكسي", {"de": W("Taxi", "das", "Taxis"), "nl": W("taxi", "de", "taxi's"), "es": W("taxi", "el", "taxis")}),
        ("hotel", "hotel", "فندق", {"de": W("Hotel", "das", "Hotels"), "nl": W("hotel", "het", "hotels"), "es": W("hotel", "el", "hoteles")}),
        ("bus", "bus", "أتوبيس", {"de": W("Bus", "der", "Busse"), "nl": W("bus", "de", "bussen"), "es": W("autobús", "el", "autobuses")}),
        ("telephone", "telephone", "تليفون", {"de": W("Telefon", "das", "Telefone"), "nl": W("telefoon", "de", "telefoons"), "es": W("teléfono", "el", "teléfonos")}),
        ("music", "music", "موسيقى", {"de": W("Musik", "die"), "nl": W("muziek", "de"), "es": W("música", "la")}),
        ("problem", "problem", "مشكلة", {"de": W("Problem", "das", "Probleme"), "nl": W("probleem", "het", "problemen"), "es": W("problema", "el", "problemas")}),
        ("banana", "banana", "موزة", {"de": W("Banane", "die", "Bananen"), "nl": W("banaan", "de", "bananen"), "es": W("plátano", "el", "plátanos")}),
        ("tomato", "tomato", "طماطم", {"de": W("Tomate", "die", "Tomaten"), "nl": W("tomaat", "de", "tomaten"), "es": W("tomate", "el", "tomates")}),
        ("school", "school", "مدرسة", {"de": W("Schule", "die", "Schulen"), "nl": W("school", "de", "scholen"), "es": W("escuela", "la", "escuelas")}),
        ("car", "car", "عربية", {"de": W("Auto", "das", "Autos"), "nl": W("auto", "de", "auto's"), "es": W("coche", "el", "coches")}),
        ("chocolate", "chocolate", "شوكولاتة", {"de": W("Schokolade", "die"), "nl": W("chocola", "de"), "es": W("chocolate", "el")}),
        ("pizza", "pizza", "بيتزا", {"de": W("Pizza", "die", "Pizzas"), "nl": W("pizza", "de", "pizza's"), "es": W("pizza", "la", "pizzas")}),
    ],
    "u02.phrases": [
        ("dont_understand", "I don't understand", "مش فاهم", {"de": W("ich verstehe nicht", pos="phrase"), "nl": W("ik begrijp het niet", pos="phrase"), "es": W("no entiendo", pos="phrase")}),
        ("speak_english", "do you speak English?", "بتتكلم إنجليزي؟", {"de": W("sprechen Sie Englisch?", pos="phrase"), "nl": W("spreekt u Engels?", pos="phrase"), "es": W("¿habla inglés?", pos="phrase")}),
        ("a_little", "a little", "شوية", {"de": W("ein bisschen", pos="phrase"), "nl": W("een beetje", pos="phrase"), "es": W("un poco", pos="phrase")}),
        ("slowly", "slowly", "بالراحة، ببطء", {"de": W("langsam", pos="adverb"), "nl": W("langzaam", pos="adverb"), "es": W("despacio", pos="adverb")}),
        ("once_more", "once more, again", "مرة كمان", {"de": W("noch einmal", pos="phrase"), "nl": W("nog een keer", pos="phrase"), "es": W("otra vez", pos="phrase")}),
        ("pardon", "pardon? (what did you say?)", "نعم؟ (قلت إيه؟)", {"de": W("wie bitte?", pos="phrase"), "nl": W("wat zegt u?", pos="phrase"), "es": W("¿cómo?", pos="phrase")}),
        ("toilet", "toilet", "حمّام، تواليت", {"de": W("Toilette", "die", "Toiletten"), "nl": W("toilet", "het", "toiletten"), "es": W("aseo", "el", "aseos")}),
        ("help", "help", "مساعدة", {"de": W("Hilfe", "die"), "nl": W("hulp", "de"), "es": W("ayuda", "la")}),
        ("how_much_cost", "how much is it?", "بكام؟", {"de": W("was kostet das?", pos="phrase"), "nl": W("hoeveel kost het?", pos="phrase"), "es": W("¿cuánto cuesta?", pos="phrase")}),
        ("dont_know", "I don't know", "مش عارف", {"de": W("ich weiß nicht", pos="phrase"), "nl": W("ik weet het niet", pos="phrase"), "es": W("no sé", pos="phrase")}),
        ("here", "here", "هنا", {"de": W("hier", pos="adverb"), "nl": W("hier", pos="adverb"), "es": W("aquí", pos="adverb")}),
        ("there", "there", "هناك", {"de": W("dort", pos="adverb"), "nl": W("daar", pos="adverb"), "es": W("allí", pos="adverb")}),
    ],
    "u03.time": [
        ("zero", "zero", "صفر", {"de": W("null", pos="numeral"), "nl": W("nul", pos="numeral"), "es": W("cero", pos="numeral")}),
        ("eleven", "eleven", "حداشر", {"de": W("elf", pos="numeral"), "nl": W("elf", pos="numeral"), "es": W("once", pos="numeral")}),
        ("twelve", "twelve", "اتناشر", {"de": W("zwölf", pos="numeral"), "nl": W("twaalf", pos="numeral"), "es": W("doce", pos="numeral")}),
        ("hundred", "a hundred", "مية", {"de": W("hundert", pos="numeral"), "nl": W("honderd", pos="numeral"), "es": W("cien", pos="numeral")}),
        ("today", "today", "النهارده", {"de": W("heute", pos="adverb"), "nl": W("vandaag", pos="adverb"), "es": W("hoy", pos="adverb")}),
        ("tomorrow", "tomorrow", "بكرة", {"de": W("morgen", pos="adverb"), "nl": W("morgen", pos="adverb"), "es": W("mañana", pos="adverb")}),
        ("yesterday", "yesterday", "امبارح", {"de": W("gestern", pos="adverb"), "nl": W("gisteren", pos="adverb"), "es": W("ayer", pos="adverb")}),
        ("day", "day", "يوم", {"de": W("Tag", "der", "Tage"), "nl": W("dag", "de", "dagen"), "es": W("día", "el", "días")}),
        ("week", "week", "أسبوع", {"de": W("Woche", "die", "Wochen"), "nl": W("week", "de", "weken"), "es": W("semana", "la", "semanas")}),
        ("oclock", "o'clock; hour", "الساعة (في الوقت)", {"de": W("Uhr", "die", "Uhren"), "nl": W("uur", "het", "uren"), "es": W("hora", "la", "horas")}),
    ],
    "u03.days": [
        ("monday", "Monday", "الاتنين", {"de": W("Montag", "der", "Montage"), "nl": W("maandag", "de", "maandagen"), "es": W("lunes", "el", "lunes")}),
        ("tuesday", "Tuesday", "التلات", {"de": W("Dienstag", "der", "Dienstage"), "nl": W("dinsdag", "de", "dinsdagen"), "es": W("martes", "el", "martes")}),
        ("wednesday", "Wednesday", "الأربع", {"de": W("Mittwoch", "der", "Mittwoche"), "nl": W("woensdag", "de", "woensdagen"), "es": W("miércoles", "el", "miércoles")}),
        ("thursday", "Thursday", "الخميس", {"de": W("Donnerstag", "der", "Donnerstage"), "nl": W("donderdag", "de", "donderdagen"), "es": W("jueves", "el", "jueves")}),
        ("friday", "Friday", "الجمعة", {"de": W("Freitag", "der", "Freitage"), "nl": W("vrijdag", "de", "vrijdagen"), "es": W("viernes", "el", "viernes")}),
        ("saturday", "Saturday", "السبت", {"de": W("Samstag", "der", "Samstage"), "nl": W("zaterdag", "de", "zaterdagen"), "es": W("sábado", "el", "sábados")}),
        ("sunday", "Sunday", "الحد", {"de": W("Sonntag", "der", "Sonntage"), "nl": W("zondag", "de", "zondagen"), "es": W("domingo", "el", "domingos")}),
    ],
    "u04.questions": [
        ("what", "what", "إيه", {"de": W("was", pos="pronoun"), "nl": W("wat", pos="pronoun"), "es": W("qué", pos="pronoun")}),
        ("who", "who", "مين", {"de": W("wer", pos="pronoun"), "nl": W("wie", pos="pronoun"), "es": W("quién", pos="pronoun")}),
        ("where", "where", "فين", {"de": W("wo", pos="adverb"), "nl": W("waar", pos="adverb"), "es": W("dónde", pos="adverb")}),
        ("when", "when", "إمتى", {"de": W("wann", pos="adverb"), "nl": W("wanneer", pos="adverb"), "es": W("cuándo", pos="adverb")}),
        ("why", "why", "ليه", {"de": W("warum", pos="adverb"), "nl": W("waarom", pos="adverb"), "es": W("por qué", pos="adverb")}),
        ("and", "and", "و", {"de": W("und", pos="conjunction"), "nl": W("en", pos="conjunction"), "es": W("y", pos="conjunction")}),
        ("or", "or", "أو، ولا", {"de": W("oder", pos="conjunction"), "nl": W("of", pos="conjunction"), "es": W("o", pos="conjunction")}),
        ("but", "but", "بس، لكن", {"de": W("aber", pos="conjunction"), "nl": W("maar", pos="conjunction"), "es": W("pero", pos="conjunction")}),
        ("also", "also, too", "كمان، برضه", {"de": W("auch", pos="adverb"), "nl": W("ook", pos="adverb"), "es": W("también", pos="adverb")}),
        ("speak", "to speak", "يتكلم", {"de": W("sprechen", pos="verb"), "nl": W("spreken", pos="verb"), "es": W("hablar", pos="verb")}),
        ("learn", "to learn", "يتعلم", {"de": W("lernen", pos="verb"), "nl": W("leren", pos="verb"), "es": W("aprender", pos="verb")}),
        ("language", "language", "لغة", {"de": W("Sprache", "die", "Sprachen"), "nl": W("taal", "de", "talen"), "es": W("idioma", "el", "idiomas")}),
    ],
}

# (key, unit, en, ar, de, nl, es). {Len}/{Lar} = the language's name.
SENTENCES = [
    ("a01", "u01", "The taxi is here.", "التاكسي هنا.", "Das Taxi ist hier.", "De taxi is hier.", "El taxi está aquí."),
    ("a02", "u01", "The hotel is big.", "الفندق كبير.", "Das Hotel ist groß.", "Het hotel is groot.", "El hotel es grande."),
    ("a03", "u01", "I like music.", "أنا بحب الموسيقى.", "Ich mag Musik.", "Ik hou van muziek.", "Me gusta la música."),
    ("a04", "u01", "The bus is coming.", "الأتوبيس جاي.", "Der Bus kommt.", "De bus komt.", "Viene el autobús."),
    ("a05", "u01", "No problem!", "مفيش مشكلة!", "Kein Problem!", "Geen probleem!", "¡No hay problema!"),
    ("a06", "u01", "A pizza and a banana, please.", "بيتزا وموزة، من فضلك.", "Eine Pizza und eine Banane, bitte.", "Een pizza en een banaan, alstublieft.", "Una pizza y un plátano, por favor."),
    ("a07", "u01", "The school is new.", "المدرسة جديدة.", "Die Schule ist neu.", "De school is nieuw.", "La escuela es nueva."),
    ("a08", "u01", "Where is the car?", "العربية فين؟", "Wo ist das Auto?", "Waar is de auto?", "¿Dónde está el coche?"),
    ("a09", "u01", "I like chocolate.", "أنا بحب الشوكولاتة.", "Ich mag Schokolade.", "Ik hou van chocola.", "Me gusta el chocolate."),
    ("a41", "u01", "Where is the telephone?", "التليفون فين؟", "Wo ist das Telefon?", "Waar is de telefoon?", "¿Dónde está el teléfono?"),
    ("a42", "u01", "A pizza with tomato.", "بيتزا بالطماطم.", "Eine Pizza mit Tomate.", "Een pizza met tomaat.", "Una pizza con tomate."),
    ("a10", "u02", "Sorry, I don't understand.", "آسف، مش فاهم.", "Entschuldigung, ich verstehe nicht.", "Sorry, ik begrijp het niet.", "Perdón, no entiendo."),
    ("a11", "u02", "Do you speak English?", "حضرتك بتتكلم إنجليزي؟", "Sprechen Sie Englisch?", "Spreekt u Engels?", "¿Habla inglés?"),
    ("a12", "u02", "A little.", "شوية.", "Ein bisschen.", "Een beetje.", "Un poco."),
    ("a13", "u02", "Slowly, please!", "بالراحة، من فضلك!", "Langsam, bitte!", "Langzaam, alstublieft!", "¡Despacio, por favor!"),
    ("a14", "u02", "Once more, please.", "مرة كمان، من فضلك.", "Noch einmal, bitte.", "Nog een keer, alstublieft.", "Otra vez, por favor."),
    ("a15", "u02", "Where is the toilet?", "الحمّام فين؟", "Wo ist die Toilette?", "Waar is het toilet?", "¿Dónde está el aseo?"),
    ("a16", "u02", "The toilet is there.", "الحمّام هناك.", "Die Toilette ist dort.", "Het toilet is daar.", "El aseo está allí."),
    ("a17", "u02", "How much is it? – Five euros.", "بكام ده؟ – خمسة يورو.", "Was kostet das? – Fünf Euro.", "Hoeveel kost het? – Vijf euro.", "¿Cuánto cuesta? – Cinco euros."),
    ("a18", "u02", "I don't know.", "مش عارف.", "Ich weiß nicht.", "Ik weet het niet.", "No sé."),
    ("a19", "u02", "I need help.", "محتاج مساعدة.", "Ich brauche Hilfe.", "Ik heb hulp nodig.", "Necesito ayuda."),
    ("a20", "u02", "Pardon? I don't understand.", "نعم؟ مش فاهم.", "Wie bitte? Ich verstehe nicht.", "Wat zegt u? Ik begrijp het niet.", "¿Cómo? No entiendo."),
    ("a21", "u03", "Today is Monday.", "النهارده الاتنين.", "Heute ist Montag.", "Vandaag is het maandag.", "Hoy es lunes."),
    ("a22", "u03", "Tomorrow is Tuesday.", "بكرة التلات.", "Morgen ist Dienstag.", "Morgen is het dinsdag.", "Mañana es martes."),
    ("a23", "u03", "Yesterday was Sunday.", "امبارح كان الحد.", "Gestern war Sonntag.", "Gisteren was het zondag.", "Ayer fue domingo."),
    ("a24", "u03", "The week has seven days.", "الأسبوع فيه سبع أيام.", "Die Woche hat sieben Tage.", "De week heeft zeven dagen.", "La semana tiene siete días."),
    ("a25", "u03", "It's twelve o'clock.", "الساعة اتناشر.", "Es ist zwölf Uhr.", "Het is twaalf uur.", "Son las doce."),
    ("a26", "u03", "I don't work on Saturday and Sunday.", "مش بشتغل يوم السبت والحد.", "Am Samstag und am Sonntag arbeite ich nicht.", "Op zaterdag en zondag werk ik niet.", "El sábado y el domingo no trabajo."),
    ("a27", "u03", "See you on Friday!", "أشوفك يوم الجمعة!", "Bis Freitag!", "Tot vrijdag!", "¡Hasta el viernes!"),
    ("a28", "u03", "The class is on Wednesday and Thursday.", "الدرس يوم الأربع والخميس.", "Der Kurs ist am Mittwoch und am Donnerstag.", "De les is op woensdag en donderdag.", "La clase es el miércoles y el jueves."),
    ("a29", "u03", "Eleven, twelve … a hundred!", "حداشر، اتناشر … مية!", "Elf, zwölf … hundert!", "Elf, twaalf … honderd!", "Once, doce… ¡cien!"),
    ("a30", "u03", "Zero problems today!", "مفيش ولا مشكلة النهارده!", "Heute null Probleme!", "Vandaag nul problemen!", "¡Hoy cero problemas!"),
    ("a43", "u03", "What time is it? – Twelve o'clock.", "الساعة كام؟ – اتناشر.", "Wie viel Uhr ist es? – Zwölf Uhr.", "Hoe laat is het? – Twaalf uur.", "¿Qué hora es? – Las doce."),
    ("a31", "u04", "What is that?", "إيه ده؟", "Was ist das?", "Wat is dat?", "¿Qué es eso?"),
    ("a32", "u04", "Who is that?", "مين ده؟", "Wer ist das?", "Wie is dat?", "¿Quién es?"),
    ("a33", "u04", "Where is the hotel?", "الفندق فين؟", "Wo ist das Hotel?", "Waar is het hotel?", "¿Dónde está el hotel?"),
    ("a34", "u04", "When is the bus coming?", "الأتوبيس جاي إمتى؟", "Wann kommt der Bus?", "Wanneer komt de bus?", "¿Cuándo viene el autobús?"),
    ("a35", "u04", "Why are you learning {Len}?", "ليه بتتعلم {Lar}؟", "Warum lernst du Deutsch?", "Waarom leer je Nederlands?", "¿Por qué aprendes español?"),
    ("a36", "u04", "I speak Arabic and English.", "أنا بتكلم عربي وإنجليزي.", "Ich spreche Arabisch und Englisch.", "Ik spreek Arabisch en Engels.", "Hablo árabe e inglés."),
    ("a37", "u04", "I'm learning {Len}, but slowly.", "أنا بتعلم {Lar}، بس بالراحة.", "Ich lerne Deutsch, aber langsam.", "Ik leer Nederlands, maar langzaam.", "Aprendo español, pero despacio."),
    ("a38", "u04", "{Len} is a beautiful language.", "ال{Lar} لغة جميلة.", "Deutsch ist eine schöne Sprache.", "Nederlands is een mooie taal.", "El español es un idioma bonito."),
    ("a39", "u04", "Do you speak {Len} too?", "إنت كمان بتتكلم {Lar}؟", "Sprichst du auch Deutsch?", "Spreek jij ook Nederlands?", "¿Tú también hablas español?"),
    ("a40", "u04", "Tea or coffee? – Coffee, but slowly!", "شاي ولا قهوة؟ – قهوة، بس بالراحة!", "Tee oder Kaffee? – Kaffee, aber langsam!", "Thee of koffie? – Koffie, maar langzaam!", "¿Té o café? – Café, ¡pero despacio!"),
]

LISTENING = {
    "u01": ["a01", "a02", "a03", "a04", "a05", "a06", "a07", "a08"],
    "u02": ["a10", "a11", "a12", "a13", "a14", "a15", "a17", "a18"],
    "u03": ["a21", "a22", "a23", "a24", "a25", "a27", "a28", "a29"],
    "u04": ["a31", "a32", "a33", "a34", "a35", "a36", "a37", "a39"],
}

# Lesson layout per unit: (type, key, title).
LESSONS = {
    "u01": [
        ("grammar", "sounds", {"ar": "أصوات اللغة", "en": "The sounds"}),
        ("vocab", "u01.words", {"ar": "كلمات دولية", "en": "International words"}),
        ("listening", "u01", {"ar": "استماع: كلمات وأصوات", "en": "Listen: words and sounds"}),
        ("review", "u01", {"ar": "مراجعة الوحدة 1", "en": "Unit 1 review"}),
    ],
    "u02": [
        ("vocab", "u02.phrases", {"ar": "مش فاهم! عبارات النجاة", "en": "I don't understand! Survival phrases"}),
        ("listening", "u02", {"ar": "استماع: لما تتوه", "en": "Listen: when you're lost"}),
        ("review", "u02", {"ar": "مراجعة الوحدة 2", "en": "Unit 2 review"}),
    ],
    "u03": [
        ("vocab", "u03.time", {"ar": "أرقام ووقت", "en": "Numbers and time"}),
        ("vocab", "u03.days", {"ar": "أيام الأسبوع", "en": "Days of the week"}),
        ("listening", "u03", {"ar": "استماع: النهارده إيه؟", "en": "Listen: what day is it?"}),
        ("review", "u03", {"ar": "مراجعة الوحدة 3", "en": "Unit 3 review"}),
    ],
    "u04": [
        ("vocab", "u04.questions", {"ar": "مين؟ فين؟ إمتى؟", "en": "Who? Where? When?"}),
        ("grammar", "questions", {"ar": "إزاي تسأل سؤال", "en": "How to ask a question"}),
        ("listening", "u04", {"ar": "استماع: أول أسئلة", "en": "Listen: first questions"}),
        ("reading", "hotel", {"ar": "قراءة: في الفندق", "en": "Read: at the hotel"}),
        ("review", "u04", {"ar": "مراجعة الوحدة 4", "en": "Unit 4 review"}),
    ],
}
