"""Shared A1 data for units 1-4: Arabic for the 72 sentences, concept ids,
and Arabic for the German grammar, texts and writing prompts.

Sentence keys (s001...) are the same in every language, so one Arabic
translation serves the German, Dutch and Spanish version of a sentence.
"""

SENT_AR = {
    "s001": "أهلًا، اسمي آنا.",
    "s002": "اسمك إيه؟",
    "s003": "اسم حضرتك إيه؟",
    "s004": "أنا من مصر.",
    "s005": "إنت منين؟",
    "s006": "أنا ساكن في برلين.",
    "s007": "إزي حضرتك؟",
    "s008": "كويس، شكرًا. وإنت؟",
    "s009": "صباح الخير يا أستاذ فيبر!",
    "s010": "مع السلامة يا مدام كلاين!",
    "s011": "لو سمحت، حضرتك الأستاذ فيبر؟",
    "s012": "أيوه، أنا.",
    "s013": "لأ، أنا بيتر.",
    "s014": "اسمي لوكاس.",
    "s015": "برلين مدينة في ألمانيا.",
    "s016": "باي، أشوفك بكرة!",
    "s017": "شكرًا جزيلًا! – العفو!",
    "s018": "نهارك سعيد! أنا مدام شميت.",
    "s019": "مساء الخير! إزيك؟",
    "s020": "إسبانيا بلد في أوروبا.",
    "s021": "دي عيلتي.",
    "s022": "عندي أخين.",
    "s023": "مامتي اسمها ماريا.",
    "s024": "عندك أطفال؟",
    "s025": "بابا من إسبانيا.",
    "s026": "عندي أخت واحدة.",
    "s027": "واحد، اتنين، تلاتة – يلا!",
    "s028": "عندك كام سنة؟",
    "s029": "عندي عشرين سنة.",
    "s030": "ابني عنده تمن سنين.",
    "s031": "عندك كام طفل؟",
    "s032": "بنتي عندها خمس سنين.",
    "s033": "إنت متجوز؟",
    "s034": "أيوه، وعندنا طفلين.",
    "s035": "هي عندها تلات أطفال.",
    "s036": "ده أخوك، صح؟",
    "s037": "أهلي ساكنين في القاهرة.",
    "s038": "سبعة، تمانية، تسعة، عشرة!",
    "s039": "قطتنا عندها أربع سنين.",
    "s040": "أخويا عنده ست أطفال!",
    "s041": "شقتي صغيرة بس حلوة.",
    "s042": "البيت فيه جنينة.",
    "s043": "المطبخ كبير ومنوّر.",
    "s044": "الشقة فيها كام أوضة؟",
    "s045": "الشقة فيها تلات أوض وحمّام وبلكونة.",
    "s046": "الكنبة جديدة. ومريحة جدًا.",
    "s047": "الترابيزة قديمة بس حلوة.",
    "s048": "في أوضة النوم فيه سرير ودولاب.",
    "s049": "اللمبة غالية.",
    "s050": "الكرسي رخيص.",
    "s051": "افتح الشباك لو سمحت!",
    "s052": "الباب مقفول.",
    "s053": "إحنا قاعدين في الصالة.",
    "s054": "الحمّام صغير جدًا.",
    "s055": "الجنينة كبيرة؟",
    "s056": "الدولاب جديد. وكبير جدًا.",
    "s057": "عايز قهوة، لو سمحت.",
    "s058": "على الفطار باكل عيش بجبنة.",
    "s059": "بتشرب شاي ولا قهوة؟",
    "s060": "أنا جعان!",
    "s061": "إنت عطشان؟",
    "s062": "أنا مش باكل لحمة.",
    "s063": "السمك طعمه حلو جدًا.",
    "s064": "تحب تاكل تفاحة؟",
    "s065": "على الغدا فيه رز بالخضار.",
    "s066": "الأطفال بيشربوا لبن كتير.",
    "s067": "مية وعصير، لو سمحت.",
    "s068": "بناكل بطاطس بالسجق.",
    "s069": "العشا إيه؟",
    "s070": "باكل فاكهة كل يوم.",
    "s071": "حضرتك تحب بيضة؟",
    "s072": "اتنين عيش صغير، لو سمحت.",
}

# German vocab slug -> shared concept id. Every language's word for the same
# meaning carries the same conceptId, which links the three packs together.
CONCEPTS = {
    "hallo": "hello", "tschuess": "bye", "guten_morgen": "good_morning",
    "guten_tag": "good_day", "guten_abend": "good_evening",
    "auf_wiedersehen": "goodbye", "danke": "thank_you", "bitte": "please",
    "ja": "yes", "nein": "no", "entschuldigung": "excuse_me", "gut": "good",
    "name": "name", "heissen": "be_called", "sein": "be", "kommen": "come",
    "aus": "from", "wohnen": "live", "in": "in", "ich": "i",
    "du": "you_informal", "sie": "you_formal", "wie": "how",
    "woher": "where_from", "land": "country", "stadt": "city",
    "familie": "family", "mutter": "mother", "vater": "father",
    "bruder": "brother", "schwester": "sister", "kind": "child",
    "haben": "have", "eins": "one", "zwei": "two", "drei": "three",
    "vier": "four", "fuenf": "five", "sechs": "six", "sieben": "seven",
    "acht": "eight", "neun": "nine", "zehn": "ten", "zwanzig": "twenty",
    "alt": "old", "jahr": "year", "sohn": "son", "tochter": "daughter",
    "verheiratet": "married", "wie_viele": "how_many", "haus": "house",
    "wohnung": "flat", "zimmer": "room", "kueche": "kitchen",
    "bad": "bathroom", "schlafzimmer": "bedroom", "wohnzimmer": "living_room",
    "balkon": "balcony", "garten": "garden", "gross": "big",
    "klein": "small", "schoen": "beautiful", "tisch": "table",
    "stuhl": "chair", "bett": "bed", "sofa": "sofa", "schrank": "wardrobe",
    "lampe": "lamp", "fenster": "window", "tuer": "door", "neu": "new",
    "teuer": "expensive", "billig": "cheap", "hell": "bright",
    "brot": "bread", "broetchen": "bread_roll", "kaese": "cheese",
    "wurst": "sausage", "ei": "egg", "apfel": "apple", "fleisch": "meat",
    "fisch": "fish", "gemuese": "vegetables", "obst": "fruit",
    "reis": "rice", "kartoffel": "potato", "wasser": "water",
    "kaffee": "coffee", "tee": "tea", "milch": "milk", "saft": "juice",
    "essen": "eat", "trinken": "drink", "moechten": "want",
    "fruehstueck": "breakfast", "mittagessen": "lunch",
    "abendessen": "dinner", "lecker": "tasty", "hunger": "hunger",
    "durst": "thirst",
}

# Same order as the German lessons; the units are shared.
UNIT_KEYS = ["u01", "u02", "u03", "u04"]

# Arabic for the German texts' translations and questions stay in German.
DE_TEXT_AR = {
    "de.a1.text.sara": "أهلًا! اسمي سارة. أنا من إسبانيا، من مدريد. دلوقتي ساكنة في برلين. برلين مدينة كبيرة. بتعلّم ألماني. ده صاحبي توم. هو من إنجلترا وساكن في برلين برضه.",
    "de.a1.text.dw_nicos_weg": "مسلسل مجاني من دويتشه فيله لمستوى A1: فيديوهات قصيرة مع تمارين.",
    "de.a1.text.mia_familie": "أهلًا! أنا ميا وعندي عشر سنين. دي عيلتي. مامتي اسمها آنا، وبابا اسمه يوناس. عندي أخ اسمه بن. بن عنده سبع سنين. إحنا ساكنين في هامبورج. تيتة ساكنة في هامبورج برضه.",
    "de.a1.text.neue_wohnung": "أهلًا يا توم، عندي شقة جديدة! مش كبيرة، بس حلوة جدًا. الشقة فيها أوضتين ومطبخ وحمّام. الصالة منوّرة وفيها بلكونة. المطبخ صغير. في أوضة النوم فيه سرير ودولاب. الكنبة جديدة والسرير قديم. الشقة مش غالية. تعالى يوم السبت! سلامات، سارة",
    "de.a1.text.im_cafe": "الجرسون: نهارك سعيد! تحبوا تطلبوا إيه؟ / آنا: عايزة قهوة بلبن، لو سمحت. / الجرسون: وحضرتك؟ / بيتر: أنا عطشان. مية، لو سمحت. وجعان كمان. عندكم عيش صغير؟ / الجرسون: أيوه، بجبنة أو بسجق. / بيتر: أنا مش باكل لحمة. واحد بالجبنة، لو سمحت. / الجرسون: حاضر. يبقى: قهوة ومية وعيش بالجبنة.",
}

# Writing prompts: same task in every language. {L} is the language name.
WRITING = [
    ("introduce", 15,
     "Introduce yourself in {Len}: your name, where you come from and where you live. Write 3 to 5 sentences.",
     "عرّف نفسك بال{Lar}: اسمك، إنت منين، وساكن فين. اكتب من 3 لـ 5 جمل."),
    ("family", 15,
     "Describe your family in {Len}: who is in it and what are their names?",
     "اوصف عيلتك بال{Lar}: مين فيها وأساميهم إيه؟"),
    ("home", 20,
     "Describe your home in {Len}: how many rooms, what is in them, what is big, small, new or old?",
     "اوصف بيتك بال{Lar}: فيه كام أوضة، وفيها إيه، وإيه الكبير والصغير والجديد والقديم؟"),
    ("breakfast", 20,
     "What do you eat and drink for breakfast, lunch and dinner? Write in {Len}.",
     "بتاكل وتشرب إيه على الفطار والغدا والعشا؟ اكتب بال{Lar}."),
]

LANG_NAME = {
    "de": ("German", "ألماني"),
    "nl": ("Dutch", "هولندي"),
    "es": ("Spanish", "إسباني"),
}

# Arabic for the German grammar points (titles and explanations).
DE_GRAMMAR_AR = {
    "de.a1.gram.present_sein_heissen": (
        "المضارع: sein و heißen و kommen و wohnen",
        "الأفعال الألماني المنتظمة بتاخد نهاية حسب الشخص: ich ‎-e، du ‎-st، er/sie/es ‎-t، wir ‎-en، ihr ‎-t، sie/Sie ‎-en. يعني: ich komme، du kommst، er kommt، wir kommen.\n\nheißen بتخلص بـ ß، فتصريف du بيبقى du heißt بس (مش heißst).\n\nsein (يكون) شاذ ولازم يتحفظ: ich bin، du bist، er/sie/es ist، wir sind، ihr seid، sie/Sie sind.\n\ndu للأصحاب والعيلة والأطفال. Sie (دايمًا بـ S كابيتال) للكبار اللي متعرفهمش.",
    ),
    "de.a1.gram.haben_possessive": (
        "haben (عنده) و mein و dein",
        "haben (عنده) شاذ شوية: du hast، er/sie/es hat. باقي التصريفات منتظمة.\n\nكلمات الملكية بتاخد جنس الاسم اللي بعدها. mein وdein وsein قبل المذكر والمحايد (mein Bruder، mein Kind)، وبنزود ‎-e قبل المؤنث والجمع (meine Mutter، meine Kinder).\n\nsein = بتاعه، ihr = بتاعها، unser = بتاعنا.\n\nالعمر بـ sein مش haben: Ich bin zwanzig Jahre alt (حرفيًا: أنا عشرين سنة كبير).",
    ),
    "de.a1.gram.articles_gender": (
        "der و die و das: الأدوات والجنس",
        "كل اسم ألماني يا مذكر (der) يا مؤنث (die) يا محايد (das). الجنس غالبًا مالوش منطق، فاحفظ الاسم دايمًا مع أداته: der Tisch، die Lampe، das Bett.\n\nأداة النكرة ein للمذكر والمحايد، وeine للمؤنث. في الجمع أداة التعريف دايمًا die، ومفيش أداة نكرة: die Betten، Betten.\n\nلما تشاور على حاجة بضمير، استخدم جنسها في القواعد: der Tisch ← er، die Lampe ← sie، das Bett ← es. يعني: Der Schrank ist neu. Er ist groß (هو كبير).",
    ),
    "de.a1.gram.accusative_moechten": (
        "حالة المفعول: einen Kaffee و keinen Hunger، و möchten",
        "الحاجة اللي بتاكلها أو تشربها أو عندك أو عايزها هي المفعول، والألماني بيعلّمها بحالة المفعول (Akkusativ). الخبر الحلو: المذكر بس هو اللي بيتغير. der ← den، ein ← einen، kein ← keinen: Ich möchte einen Kaffee. Ich habe keinen Hunger. المؤنث والمحايد والجمع زي ما هم.\n\nkein معناها «مفيش/ولا»: Ich esse kein Fleisch (مش باكل لحمة).\n\nmöchten (أحب/عايز) هي الطريقة المؤدبة للطلب: ich möchte، du möchtest، er/sie möchte، wir möchten، ihr möchtet، sie/Sie möchten. خد بالك: مفيش ‎-t مع er/sie.",
    ),
}
