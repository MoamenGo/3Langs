"""A0 grammar (sounds, questions), reading text and writing prompt, per language."""

GRAMMAR = {
    "de": {
        "sounds": {
            "title": {"ar": "أصوات الألماني", "en": "German sounds"},
            "explanation": {
                "en": "German is mostly read as it is written. A few letters and pairs work differently from English:\n\nei sounds like English 'eye' (drei), ie like 'ee' (vier). eu and äu sound like 'oy' (neu).\n\nch after a, o, u is a throat sound like Arabic خ (acht, Buch); after e and i it is softer, between ش and خ (ich, nicht).\n\nsch = ش (Schule). At the start of a word, sp and st sound like شب and شت (Sport, Stadt).\n\nw sounds like English v (Wasser), v usually like f (Vater), z like تس (zehn), j like y (ja). ß is a sharp s (groß).\n\nä is like e, ö and ü are rounded vowels with no English or Arabic match: say e or i with rounded lips. Nouns always start with a capital letter.",
                "ar": "الألماني غالبًا بيتقري زي ما بيتكتب. شوية حروف بتتنطق غير الإنجليزي:\n\nei بتتنطق «اي» (drei = دراي)، وie بتتنطق «ii» طويلة (vier = فير). eu وäu بتتنطق «وي» (neu = نوي).\n\nch بعد a وo وu بتتنطق زي الخاء (acht = أخت، Buch)، وبعد e وi بتبقى أخف، بين الشين والخاء (ich، nicht).\n\nsch = ش (Schule = شوله). وفي أول الكلمة sp وst بيتنطقوا «شب» و«شت» (Sport، Stadt = شتات).\n\nw بتتنطق ف/v (Wasser = فاسر)، وv غالبًا ف (Vater = فاتر)، وz بتتنطق «تس» (zehn = تسين)، وj بتتنطق ي (ja = يا). وß سين قوية (groß).\n\nä زي e، أما ö وü فحروف متحركة بشفايف مدوّرة مالهاش مقابل في العربي: قول e أو i وإنت مدوّر شفايفك. والأسماء دايمًا أول حرف فيها كابيتال.",
            },
            "table": {"headers": ["letters", "sounds like", "example"], "rows": [
                ["ei", "ai (eye) / اي", "drei, mein"], ["ie", "ee / ii", "vier, Liebe"],
                ["eu, äu", "oy / وي", "neu, Häuser"], ["ch (a, o, u)", "خ", "acht, Buch"],
                ["ch (e, i)", "soft ش/خ", "ich, nicht"], ["sch", "ش", "Schule"],
                ["sp-, st-", "شب، شت", "Sport, Stadt"], ["w", "v", "Wasser"], ["v", "f", "Vater"],
                ["z", "ts / تس", "zehn"], ["j", "y / ي", "ja"], ["ß", "s", "groß"],
                ["ä / ö / ü", "e / rounded e / rounded i", "Käse, schön, fünf"],
            ]},
            "examples": ["a02", "a07", "a09"],
            "exercises": [
                ("___ule (school, sounds 'shoo-leh')", "Sch", "sch"), ("dr___ (three, sounds 'dry')", "ei", "ei / ie"),
                ("v___r (four, sounds 'feer')", "ie", "ei / ie"), ("n___ (new, sounds 'noy')", "eu", "eu"),
                ("___asser (water, sounds 'vasser')", "W", "w / v"), ("___ehn (ten, sounds 'tsayn')", "z", "z"),
                ("gro___ (big, a sharp s)", "ß", "ß"), ("K___se (cheese, sounds 'kayzeh')", "ä", "ä"),
            ],
        },
        "questions": {
            "title": {"ar": "الأسئلة: الفعل في الأول أو التاني", "en": "Questions: the verb comes first or second"},
            "explanation": {
                "en": "In a German statement the verb is always the second element: Du lernst Deutsch.\n\nFor a yes/no question, put the verb first: Lernst du Deutsch?\n\nFor a question with a question word (W-Fragen), the question word comes first and the verb second: Was lernst du? Wo ist das Hotel? Wann kommt der Bus?\n\nQuestion words: was (what), wer (who), wo (where), wann (when), warum (why), wie (how), woher (where from).\n\nCareful: wer means who, not where. wo means where.",
                "ar": "في الجملة الخبرية الألماني الفعل دايمًا العنصر التاني: Du lernst Deutsch (إنت بتتعلم ألماني).\n\nفي سؤال إجابته أيوه أو لأ، الفعل بييجي الأول: Lernst du Deutsch? (بتتعلم ألماني؟)\n\nفي سؤال بكلمة سؤال، كلمة السؤال الأول والفعل التاني: Was lernst du? Wo ist das Hotel? Wann kommt der Bus?\n\nكلمات السؤال: was (إيه)، wer (مين)، wo (فين)، wann (إمتى)، warum (ليه)، wie (إزاي)، woher (منين).\n\nخد بالك: wer معناها مين، مش فين. وwo معناها فين.",
            },
            "table": {"headers": ["", "1", "2", "3"], "rows": [
                ["statement", "Du", "lernst", "Deutsch."], ["yes/no question", "Lernst", "du", "Deutsch?"],
                ["W-question", "Was", "lernst", "du?"], ["W-question", "Wo", "ist", "das Hotel?"],
            ]},
            "examples": ["a31", "a34", "a39"],
            "exercises": [
                ("___ ist das? (who)", "Wer", "wer / wo"), ("___ ist die Toilette? (where)", "Wo", "wer / wo"),
                ("___ kommt der Bus? (when)", "Wann", "wann"), ("___ lernst du Deutsch? (why)", "Warum", "warum"),
                ("___ ist das? (what)", "Was", "was"), ("___ du Deutsch? (lernen)", "Lernst", "lernen"),
                ("Ich lerne Deutsch ___ Spanisch. (and)", "und", "und"), ("Ich spreche Englisch, ___ langsam. (but)", "aber", "aber"),
            ],
        },
    },
    "nl": {
        "sounds": {
            "title": {"ar": "أصوات الهولندي", "en": "Dutch sounds"},
            "explanation": {
                "en": "Dutch spelling is regular once you know a few rules:\n\ng and ch are throat sounds like Arabic خ (goed, acht). This is the most typical Dutch sound.\n\nij and ei sound the same, close to English 'eye' (mijn, klein). ui has no English match: start with 'a' and round your lips (huis, uit). ou and au sound like 'ow' (oud).\n\noe sounds like 'oo' (goed, moeder). eu is a rounded e (neus).\n\nA double vowel is a long vowel: aa, ee, oo, uu (jaar, twee). In an open syllable one letter is enough: ja-ren, ko-men.\n\nw is softer than English w, v is close to f (vader), j is y (ja). sch = s + خ (school). The -n at the end of -en is often not pronounced (eten sounds like 'ay-tuh').",
                "ar": "الكتابة الهولندي منتظمة لما تعرف شوية قواعد:\n\ng وch بيتنطقوا من الزور زي الخاء (goed = خوت، acht = أخت). ده أشهر صوت في الهولندي.\n\nij وei نفس الصوت، قريب من «اي» (mijn = ماين، klein). ui مالهاش مقابل: ابدأ بـ «أ» ودوّر شفايفك (huis، uit). ou وau بيتنطقوا «او» (oud = اوت).\n\noe بتتنطق «uu» (goed، moeder = مودر). eu حرف e بشفايف مدوّرة (neus).\n\nالحرف المتحرك المتكرر صوته طويل: aa وee وoo وuu (jaar = يااار، twee = تفيي). وفي المقطع المفتوح حرف واحد كفاية: ja-ren، ko-men.\n\nw أخف من الإنجليزي، وv قريبة من ف (vader = فادر)، وj بتتنطق ي (ja = يا). sch = س + خ (school = سخول). والـ n في آخر ‎-en غالبًا مش بتتنطق (eten = ايتة).",
            },
            "table": {"headers": ["letters", "sounds like", "example"], "rows": [
                ["g, ch", "خ", "goed, acht"], ["ij, ei", "ai (eye) / اي", "mijn, klein"],
                ["ui", "rounded 'a-u'", "huis, uit"], ["ou, au", "ow / او", "oud"],
                ["oe", "oo / uu", "goed, moeder"], ["eu", "rounded e", "neus"],
                ["aa, ee, oo, uu", "long vowel", "jaar, twee"], ["sch", "s + خ", "school"],
                ["v", "close to f", "vader"], ["w", "soft v/w", "water"], ["j", "y / ي", "ja"],
                ["-en", "-uh", "eten, komen"],
            ]},
            "examples": ["a02", "a07", "a09"],
            "exercises": [
                ("h___s (house, rounded 'a-u')", "ui", "ui / ij"), ("m___n (my, sounds 'mine')", "ij", "ui / ij"),
                ("g___d (good, sounds 'khoot')", "oe", "oe"), ("j___r (year, a long a)", "aa", "a / aa"),
                ("___ool (school, s + kh)", "sch", "sch"), ("tw___ (two, a long e)", "ee", "e / ee"),
                ("___d (old, sounds 'owt')", "ou", "ou"), ("kl___n (small, sounds 'kline')", "ei", "ei"),
            ],
        },
        "questions": {
            "title": {"ar": "الأسئلة: الفعل في الأول أو التاني", "en": "Questions: the verb comes first or second"},
            "explanation": {
                "en": "Dutch word order works like German. In a statement the verb is second: Jij leert Nederlands.\n\nFor a yes/no question, put the verb first: Leer jij Nederlands? Note that the -t disappears when jij or je follows the verb.\n\nWith a question word, the question word comes first and the verb second: Wat leer je? Waar is het hotel? Wanneer komt de bus?\n\nQuestion words: wat (what), wie (who), waar (where), wanneer (when), waarom (why), hoe (how).\n\nCareful if you also learn German: Dutch wie means who, but German wie means how.",
                "ar": "ترتيب الكلام في الهولندي زي الألماني. في الجملة الخبرية الفعل التاني: Jij leert Nederlands.\n\nفي سؤال إجابته أيوه أو لأ الفعل بييجي الأول: Leer jij Nederlands? خد بالك إن الـ ‎-t بتختفي لما jij أو je ييجوا بعد الفعل.\n\nمع كلمة سؤال، كلمة السؤال الأول والفعل التاني: Wat leer je? Waar is het hotel? Wanneer komt de bus?\n\nكلمات السؤال: wat (إيه)، wie (مين)، waar (فين)، wanneer (إمتى)، waarom (ليه)، hoe (إزاي).\n\nخلي بالك لو بتتعلم ألماني كمان: wie في الهولندي معناها مين، لكن في الألماني معناها إزاي.",
            },
            "table": {"headers": ["", "1", "2", "3"], "rows": [
                ["statement", "Jij", "leert", "Nederlands."], ["yes/no question", "Leer", "jij", "Nederlands?"],
                ["question word", "Wat", "leer", "je?"], ["question word", "Waar", "is", "het hotel?"],
            ]},
            "examples": ["a31", "a34", "a39"],
            "exercises": [
                ("___ is dat? (who)", "Wie", "wie / waar"), ("___ is het toilet? (where)", "Waar", "wie / waar"),
                ("___ komt de bus? (when)", "Wanneer", "wanneer"), ("___ leer je Nederlands? (why)", "Waarom", "waarom"),
                ("___ is dat? (what)", "Wat", "wat"), ("___ jij Engels? (spreken)", "Spreek", "spreken"),
                ("Ik leer Nederlands ___ Spaans. (and)", "en", "en"), ("Ik leer Nederlands, ___ langzaam. (but)", "maar", "maar"),
            ],
        },
    },
    "es": {
        "sounds": {
            "title": {"ar": "أصوات الإسباني", "en": "Spanish sounds"},
            "explanation": {
                "en": "Spanish is read exactly as it is written, and the five vowels a, e, i, o, u are always short and clear.\n\nh is silent (hola, hijo). j, and g before e or i, are throat sounds like Arabic خ (jardín, gente).\n\nñ sounds like 'ny' (España, mañana). ll and y sound like English y (llamar, yo).\n\nIn Spain, z and c before e or i sound like English th, Arabic ث (zumo, cinco). In Latin America they sound like s.\n\nqu = k (queso). r between vowels is a quick tap (pero); rr and r at the start of a word are rolled (perro, rico). b and v sound the same.\n\nAn accent mark shows the stressed syllable: café, teléfono. Questions and exclamations open with ¿ and ¡.",
                "ar": "الإسباني بيتقري بالظبط زي ما بيتكتب، والخمس حروف المتحركة a وe وi وo وu دايمًا قصيرة وواضحة.\n\nh مش بتتنطق (hola = أولا، hijo = إيخو). j، وg قبل e أو i، بيتنطقوا زي الخاء (jardín = خاردين، gente = خينتي).\n\nñ بتتنطق «ني» (España = إسبانيا، mañana = مانيانا). ll وy بيتنطقوا ي (llamar = يامار، yo = يو).\n\nفي إسبانيا z وc قبل e أو i بيتنطقوا ث (zumo = ثومو، cinco = ثينكو). في أمريكا اللاتينية بيتنطقوا س.\n\nqu = ك (queso = كيسو). r بين حرفين متحركين رنة خفيفة (pero)، وrr وr في أول الكلمة راء مكررة قوية (perro، rico). b وv نفس الصوت.\n\nالشرطة فوق الحرف بتوضح مكان الضغط: café، teléfono. والسؤال والتعجب بيبتدوا بـ ¿ و¡.",
            },
            "table": {"headers": ["letters", "sounds like", "example"], "rows": [
                ["h", "silent", "hola, hijo"], ["j, ge, gi", "خ", "jardín, gente"],
                ["ñ", "ny / ني", "España, mañana"], ["ll, y", "y / ي", "llamar, yo"],
                ["z, ce, ci", "th / ث (Spain)", "zumo, cinco"], ["qu", "k", "queso"],
                ["r / rr", "tap / rolled", "pero / perro"], ["b, v", "same sound", "vivir, bien"],
                ["á é í ó ú", "stressed syllable", "café, teléfono"], ["¿ ¡", "open a question", "¿Qué?"],
            ]},
            "examples": ["a02", "a07", "a09"],
            "exercises": [
                ("___ola (hello, the h is silent)", "h", "h"), ("Espa___a (Spain, sounds 'españa')", "ñ", "n / ñ"),
                ("___ardín (garden, sounds 'khardeen')", "j", "j"), ("___eso (cheese, sounds 'keso')", "qu", "qu"),
                ("Me ___amo Ana. (sounds 'yamo')", "ll", "ll"), ("pe___o (dog, rolled r)", "rr", "r / rr"),
                ("___inco (five, sounds 'thinko')", "c", "c / z"), ("caf___ (coffee, stress at the end)", "é", "e / é"),
            ],
        },
        "questions": {
            "title": {"ar": "الأسئلة: ¿ وكلمات السؤال", "en": "Questions: ¿ and question words"},
            "explanation": {
                "en": "Spanish questions often keep the same word order as a statement; the voice rises at the end: ¿Hablas inglés? (Do you speak English?)\n\nWritten questions open with ¿ and close with ?.\n\nWith a question word, the question word comes first and usually the verb next: ¿Qué aprendes? ¿Dónde está el hotel? ¿Cuándo viene el autobús?\n\nQuestion words always have an accent: qué (what), quién (who), dónde (where), cuándo (when), por qué (why), cómo (how). Without the accent porque means because.\n\nSmall changes: y (and) becomes e before an i sound (árabe e inglés), and o (or) becomes u before an o sound.",
                "ar": "السؤال الإسباني غالبًا بنفس ترتيب الجملة الخبرية، والصوت بيعلى في الآخر: ¿Hablas inglés? (بتتكلم إنجليزي؟)\n\nالسؤال المكتوب بيبتدي بـ ¿ ويخلص بـ ?.\n\nمع كلمة سؤال، كلمة السؤال الأول وبعدها الفعل غالبًا: ¿Qué aprendes? ¿Dónde está el hotel? ¿Cuándo viene el autobús?\n\nكلمات السؤال دايمًا عليها شرطة: qué (إيه)، quién (مين)، dónde (فين)، cuándo (إمتى)، por qué (ليه)، cómo (إزاي). ومن غير الشرطة porque معناها «عشان».\n\nتغييرات صغيرة: y (و) بتبقى e قبل صوت i (árabe e inglés)، وo (أو) بتبقى u قبل صوت o.",
            },
            "table": {"headers": ["", "question", "meaning"], "rows": [
                ["yes/no", "¿Hablas inglés?", "Do you speak English?"], ["qué", "¿Qué es eso?", "What is that?"],
                ["dónde", "¿Dónde está el hotel?", "Where is the hotel?"], ["cuándo", "¿Cuándo viene el autobús?", "When is the bus coming?"],
                ["por qué", "¿Por qué aprendes español?", "Why are you learning Spanish?"],
            ]},
            "examples": ["a31", "a34", "a39"],
            "exercises": [
                ("¿___ es? (who)", "Quién", "quién"), ("¿___ está el aseo? (where)", "Dónde", "dónde"),
                ("¿___ viene el autobús? (when)", "Cuándo", "cuándo"), ("¿___ aprendes español? (why)", "Por qué", "por qué"),
                ("¿___ es eso? (what)", "Qué", "qué"), ("¿___ usted inglés? (hablar)", "Habla", "hablar"),
                ("Hablo árabe ___ inglés. (and)", "e", "y / e"), ("Aprendo español, ___ despacio. (but)", "pero", "pero"),
            ],
        },
    },
}

TEXT_EN = "Omar: Hello! Do you speak English? / Receptionist: A little. And {Len}? / Omar: I'm learning {Len}, but slowly. Where is the toilet? / Receptionist: There. / Omar: Thanks! And when is the taxi coming? / Receptionist: Today, at twelve o'clock."
TEXT_AR = "عمر: أهلًا! حضرتك بتتكلم إنجليزي؟ / موظفة الاستقبال: شوية. و{Lar}؟ / عمر: بتعلّم {Lar}، بس بالراحة. الحمّام فين؟ / الموظفة: هناك. / عمر: شكرًا! والتاكسي جاي إمتى؟ / الموظفة: النهارده، الساعة اتناشر."

TEXTS = {
    "de": {
        "title": "Im Hotel",
        "body": "Omar: Hallo! Sprechen Sie Englisch?\nRezeption: Ein bisschen. Und Deutsch?\nOmar: Ich lerne Deutsch, aber langsam. Wo ist die Toilette?\nRezeption: Dort.\nOmar: Danke! Und wann kommt das Taxi?\nRezeption: Heute, um zwölf Uhr.",
        "glossary": ["speak_english", "a_little", "learn", "slowly", "toilet", "there", "when", "taxi", "today", "oclock"],
        "questions": [
            ("Wer lernt Deutsch?", ["Omar", "Die Rezeption", "Das Taxi"], 0),
            ("Wo ist die Toilette?", ["Hier", "Dort", "Im Taxi"], 1),
            ("Wann kommt das Taxi?", ["Morgen", "Heute um zwölf Uhr", "Am Montag"], 1),
        ],
    },
    "nl": {
        "title": "In het hotel",
        "body": "Omar: Hallo! Spreekt u Engels?\nReceptie: Een beetje. En Nederlands?\nOmar: Ik leer Nederlands, maar langzaam. Waar is het toilet?\nReceptie: Daar.\nOmar: Dank u! En wanneer komt de taxi?\nReceptie: Vandaag, om twaalf uur.",
        "glossary": ["speak_english", "a_little", "learn", "slowly", "toilet", "there", "when", "taxi", "today", "oclock"],
        "questions": [
            ("Wie leert Nederlands?", ["Omar", "De receptie", "De taxi"], 0),
            ("Waar is het toilet?", ["Hier", "Daar", "In de taxi"], 1),
            ("Wanneer komt de taxi?", ["Morgen", "Vandaag om twaalf uur", "Op maandag"], 1),
        ],
    },
    "es": {
        "title": "En el hotel",
        "body": "Omar: ¡Hola! ¿Habla inglés?\nRecepción: Un poco. ¿Y español?\nOmar: Aprendo español, pero despacio. ¿Dónde está el aseo?\nRecepción: Allí.\nOmar: ¡Gracias! ¿Y cuándo viene el taxi?\nRecepción: Hoy, a las doce.",
        "glossary": ["speak_english", "a_little", "learn", "slowly", "toilet", "there", "when", "taxi", "today"],
        "questions": [
            ("¿Quién aprende español?", ["Omar", "La recepción", "El taxi"], 0),
            ("¿Dónde está el aseo?", ["Aquí", "Allí", "En el taxi"], 1),
            ("¿Cuándo viene el taxi?", ["Mañana", "Hoy a las doce", "El lunes"], 1),
        ],
    },
}

WRITING = (
    "languages", 8,
    "Write 2 or 3 short sentences in {Len}: which languages do you speak, and which are you learning?",
    "اكتب جملتين أو تلاتة قصيرين بال{Lar}: بتتكلم لغات إيه، وبتتعلم إيه؟",
)
