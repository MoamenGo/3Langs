"""A2: units 1-11 (unit 12 is the review and mock exam).

words:     concept | pos | English | Arabic | German | Dutch | Spanish
sentences: English | Arabic | German | Dutch | Spanish
"""

CAN_DO = [
    {"en": "Talk about your past, your plans and your daily life", "ar": "تحكي عن ماضيك وخططك وحياتك اليومية"},
    {"en": "Handle shops, travel, doctors and offices", "ar": "تتعامل في المحلات والسفر والدكتور والمصالح"},
    {"en": "Write short messages and personal emails", "ar": "تكتب رسايل قصيرة وإيميلات شخصية"},
]


def G(title, text, exercises, table=None):
    g = {"title": title, "text": text, "exercises": exercises}
    if table:
        g["table"] = table
    return g


UNITS = [
    {
        "key": "u01",
        "write_en": "where you were born, where you grew up and what you did",
        "write_ar": "اتولدت فين واتربيت فين وعملت إيه",
        "words": """
be_born | v | to be born | يتولد | geboren werden | geboren worden | nacer
childhood | n | childhood | الطفولة | die Kindheit | de jeugd | la infancia
grow_up | v | to grow up | يكبر، يتربى | aufwachsen | opgroeien | crecer
year | n | year | سنة | das Jahr, Jahre | het jaar, jaren | el año, años
past | n | past | الماضي | die Vergangenheit | het verleden | el pasado
move_house | v | to move (house) | يعزّل | umziehen | verhuizen | mudarse
marry | v | to get married | يتجوز | heiraten | trouwen | casarse
study | v | to study (at university) | يدرس في الجامعة | studieren | studeren | estudiar
go | v | to go | يروح | gehen | gaan | ir
come_back | v | to come back | يرجع | zurückkommen | terugkomen | volver
ago | adv | ago | من (زمان) | vor | geleden | hace
when_past | conj | when (once, in the past) | لما (في الماضي) | als | toen | cuando
""",
        "sentences": """
I was born in Cairo in 1998. | اتولدت في القاهرة سنة 1998. | Ich bin 1998 in Kairo geboren. | Ik ben in 1998 in Caïro geboren. | Nací en El Cairo en 1998.
When I was a child, we moved to Alexandria. | لما كنت صغير، عزّلنا إسكندرية. | Als ich ein Kind war, sind wir nach Alexandria umgezogen. | Toen ik een kind was, zijn we naar Alexandrië verhuisd. | Cuando era niño, nos mudamos a Alejandría.
Two years ago I went to Germany. | من سنتين رحت ألمانيا. | Vor zwei Jahren bin ich nach Deutschland gegangen. | Twee jaar geleden ben ik naar Duitsland gegaan. | Hace dos años fui a Alemania.
My parents got married in 1990. | أهلي اتجوزوا سنة 1990. | Meine Eltern haben 1990 geheiratet. | Mijn ouders zijn in 1990 getrouwd. | Mis padres se casaron en 1990.
""",
        "grammar": {
            "de": G(("Perfect with sein; war and hatte", "الـ Perfekt مع sein؛ war وhatte"),
                    ("Verbs of movement or change of state form the perfect with sein: gehen → ich bin gegangen, umziehen → wir sind umgezogen, kommen → er ist gekommen, werden → ich bin geworden.\n\nFor sein and haben, Germans prefer the simple past: ich war, du warst, er war, wir waren; ich hatte, du hattest, er hatte, wir hatten.\n\nvor + dative = ago: vor zwei Jahren.",
                     "الأفعال اللي فيها حركة أو تغيّر حالة بتعمل الـ Perfekt بـ sein: gehen ← ich bin gegangen، umziehen ← wir sind umgezogen، kommen ← er ist gekommen، werden ← ich bin geworden.\n\nمع sein وhaben الألمان بيفضلوا الماضي البسيط: ich war, du warst, er war, wir waren؛ ich hatte, du hattest, er hatte, wir hatten.\n\nvor + داتيف = من (مدة): vor zwei Jahren = من سنتين."),
                    [("Wir ___ nach Alexandria umgezogen.", "sind", "sein"), ("Ich ___ ein Kind. (past)", "war", "sein"),
                     ("Er ___ viel Arbeit. (past)", "hatte", "haben"), ("___ zwei Jahren bin ich gekommen.", "Vor", "vor")]),
            "nl": G(("Perfect with zijn; was and had", "الماضي التام مع zijn؛ was وhad"),
                    ("Like German, verbs of movement and change use zijn: gaan → ik ben gegaan, verhuizen → we zijn verhuisd, komen → hij is gekomen, trouwen → ze zijn getrouwd.\n\nSimple past of zijn and hebben: ik was, wij waren; ik had, wij hadden.\n\nAgo = ... geleden after the time: twee jaar geleden. When (once, in the past) = toen: Toen ik een kind was ...",
                     "زي الألماني، أفعال الحركة والتغيّر بتاخد zijn: gaan ← ik ben gegaan، verhuizen ← we zijn verhuisd، komen ← hij is gekomen، trouwen ← ze zijn getrouwd.\n\nالماضي البسيط لـ zijn وhebben: ik was, wij waren؛ ik had, wij hadden.\n\nمن (مدة) = ... geleden بعد المدة: twee jaar geleden. ولما (في الماضي) = toen: Toen ik een kind was ..."),
                    [("We ___ naar Alexandrië verhuisd.", "zijn", "zijn"), ("Ik ___ een kind. (past)", "was", "zijn"),
                     ("Twee jaar ___ ben ik gekomen.", "geleden", "geleden"), ("___ ik klein was, woonde ik in Caïro.", "Toen", "toen")]),
            "es": G(("Indefinido and imperfecto", "الـ indefinido والـ imperfecto"),
                    ("Spanish has two simple pasts. indefinido = finished events: nací, fui, nos mudamos. ir and ser share it: fui, fuiste, fue, fuimos, fueron.\n\nimperfecto = background, how things used to be: era niño, vivíamos en El Cairo. -ar: -aba; -er/-ir: -ía. ser: era, eras, era, éramos, eran.\n\nhace + time = ago: hace dos años.",
                     "الإسباني فيه ماضيين بسيطين. indefinido = أحداث خلصت: nací، fui، nos mudamos. وir وser ليهم نفس الصيغة: fui, fuiste, fue, fuimos, fueron.\n\nimperfecto = الخلفية أو اللي كان بيحصل عادةً: era niño، vivíamos en El Cairo. ‎-ar: ‎-aba؛ ‎-er/-ir: ‎-ía. وser: era, eras, era, éramos, eran.\n\nhace + مدة = من (مدة): hace dos años."),
                    [("___ en El Cairo en 1998. (yo, nacer)", "Nací", "nacer"), ("Cuando ___ niño, vivía en Alejandría.", "era", "ser"),
                     ("Hace dos años ___ a Alemania. (yo, ir)", "fui", "ir"), ("Mis padres se ___ en 1990.", "casaron", "casarse")]),
        },
    },
    {
        "key": "u02",
        "write_en": "your best friend and how you met",
        "write_ar": "أقرب صاحب ليك وإزاي اتعرفتوا",
        "words": """
meet | v | to meet | يقابل | treffen | ontmoeten | encontrarse con
love_v | v | to love | يحب | lieben | houden van | querer
help | v | to help | يساعد | helfen | helpen | ayudar
like_person | v | to like (someone) | يستلطف، يحب | mögen | aardig vinden | caer bien
party | n | party | حفلة | die Party, Partys | het feest, feesten | la fiesta, fiestas
relationship | n | relationship | علاقة | die Beziehung, Beziehungen | de relatie, relaties | la relación, relaciones
neighbour | n | neighbour | جار | der Nachbar, Nachbarn | de buurman, buren | el vecino, vecinos
girlfriend | n | girlfriend; female friend | صاحبة، حبيبة | die Freundin, Freundinnen | de vriendin, vriendinnen | la amiga, amigas
together | adv | together | مع بعض | zusammen | samen | juntos
argue | v | to argue | يتخانق | sich streiten | ruzie maken | discutir
remember | v | to remember | يفتكر | sich erinnern | zich herinneren | acordarse
invite | v | to invite | يعزم | einladen | uitnodigen | invitar
""",
        "sentences": """
I met my friend at a party. | قابلت صاحبي في حفلة. | Ich habe meinen Freund auf einer Party getroffen. | Ik heb mijn vriend op een feest ontmoet. | Conocí a mi amigo en una fiesta.
Can you help me? | ممكن تساعدني؟ | Kannst du mir helfen? | Kun je me helpen? | ¿Puedes ayudarme?
I remember our first holiday together. | فاكر أول إجازة لينا مع بعض. | Ich erinnere mich an unseren ersten Urlaub zusammen. | Ik herinner me onze eerste vakantie samen. | Me acuerdo de nuestras primeras vacaciones juntos.
We are inviting the neighbours. | هنعزم الجيران. | Wir laden die Nachbarn ein. | We nodigen de buren uit. | Invitamos a los vecinos.
""",
        "grammar": {
            "de": G(("Dative verbs and reflexive verbs", "أفعال الداتيف والأفعال الانعكاسية"),
                    ("Some verbs take a dative object: helfen, danken, gefallen, gehören, antworten. Kannst du mir helfen? Das Buch gehört ihm.\n\nDative pronouns: mir, dir, ihm, ihr, uns, euch, ihnen/Ihnen.\n\nReflexive verbs use a pronoun for the same person: ich erinnere mich, du erinnerst dich, er erinnert sich, wir erinnern uns. sich streiten = to argue.",
                     "فيه أفعال مفعولها بيبقى داتيف: helfen, danken, gefallen, gehören, antworten. Kannst du mir helfen? Das Buch gehört ihm.\n\nضماير الداتيف: mir, dir, ihm, ihr, uns, euch, ihnen/Ihnen.\n\nالأفعال الانعكاسية بتستخدم ضمير لنفس الشخص: ich erinnere mich, du erinnerst dich, er erinnert sich, wir erinnern uns. وsich streiten = يتخانق."),
                    [("Kannst du ___ helfen? (ich)", "mir", "ich"), ("Ich erinnere ___ an den Urlaub.", "mich", "sich"),
                     ("Das Buch gehört ___. (er)", "ihm", "er"), ("Wir streiten ___ nie.", "uns", "sich")],
                    [["", "ich", "du", "er", "sie", "wir", "ihr", "sie/Sie"], ["dative", "mir", "dir", "ihm", "ihr", "uns", "euch", "ihnen/Ihnen"], ["reflexive (acc.)", "mich", "dich", "sich", "sich", "uns", "euch", "sich"]]),
            "nl": G(("Reflexive verbs and separable invite", "الأفعال الانعكاسية والفعل المنفصل uitnodigen"),
                    ("Reflexive pronouns: me, je, zich, ons, je, zich: Ik herinner me, jij herinnert je, hij herinnert zich, wij herinneren ons.\n\nDutch has no dative case: Kun je me helpen? Ik geef hem het boek.\n\nuitnodigen splits: We nodigen de buren uit. houden van = to love: Ik hou van jou.",
                     "ضماير الانعكاس: me, je, zich, ons, je, zich: Ik herinner me, jij herinnert je, hij herinnert zich, wij herinneren ons.\n\nالهولندي مفيهوش داتيف: Kun je me helpen? Ik geef hem het boek.\n\nuitnodigen بينفصل: We nodigen de buren uit. وhouden van = يحب: Ik hou van jou."),
                    [("Ik herinner ___ de vakantie.", "me", "zich"), ("We nodigen de buren ___.", "uit", "uitnodigen"),
                     ("Ik hou ___ jou.", "van", "houden van"), ("Hij herinnert ___ niets.", "zich", "zich")]),
            "es": G(("Object pronouns and personal a", "ضماير المفعول وa للأشخاص"),
                    ("A person as direct object gets a: Conocí a mi amigo. Invitamos a los vecinos.\n\nIndirect object pronouns: me, te, le, nos, os, les. ¿Puedes ayudarme? (pronoun attached to the infinitive) Me cae bien = I like him/her.\n\nReflexive: me acuerdo, te acuerdas, se acuerda, nos acordamos (o → ue).",
                     "الشخص لما يبقى مفعول بيه بياخد a: Conocí a mi amigo. Invitamos a los vecinos.\n\nضماير المفعول غير المباشر: me, te, le, nos, os, les. ¿Puedes ayudarme? (الضمير بيتلزق في المصدر) وMe cae bien = بستلطفه.\n\nالانعكاسي: me acuerdo, te acuerdas, se acuerda, nos acordamos (o ← ue)."),
                    [("Invitamos ___ los vecinos.", "a", "a"), ("¿Puedes ayudar___? (yo)", "me", "me"),
                     ("Me ___ de nuestras vacaciones. (acordarse)", "acuerdo", "acordarse"), ("Mi vecino me ___ bien. (caer)", "cae", "caer")]),
        },
    },
    {
        "key": "u03",
        "write_en": "what you are wearing today and your favourite clothes",
        "write_ar": "لابس إيه النهاردة وإيه هدومك المفضلة",
        "words": """
clothes | n | clothes | هدوم | die Kleidung | de kleding | la ropa
trousers | n | trousers | بنطلون | die Hose, Hosen | de broek, broeken | el pantalón, pantalones
dress | n | dress | فستان | das Kleid, Kleider | de jurk, jurken | el vestido, vestidos
shoe | n | shoe | جزمة | der Schuh, Schuhe | de schoen, schoenen | el zapato, zapatos
jacket | n | jacket | جاكيت | die Jacke, Jacken | de jas, jassen | la chaqueta, chaquetas
wear | v | to wear | يلبس | tragen | dragen | llevar
try_on | v | to try on | يقيس | anprobieren | passen | probarse
colour | n | colour | لون | die Farbe, Farben | de kleur, kleuren | el color, colores
red | adj | red | أحمر | rot | rood | rojo
blue | adj | blue | أزرق | blau | blauw | azul
black | adj | black | أسود | schwarz | zwart | negro
size | n | size | مقاس | die Größe, Größen | de maat, maten | la talla, tallas
""",
        "sentences": """
I am wearing a blue jacket. | لابس جاكيت أزرق. | Ich trage eine blaue Jacke. | Ik draag een blauwe jas. | Llevo una chaqueta azul.
Can I try on the black trousers? | ممكن أقيس البنطلون الأسود؟ | Kann ich die schwarze Hose anprobieren? | Mag ik de zwarte broek passen? | ¿Puedo probarme el pantalón negro?
Which size do you need? | محتاج مقاس كام؟ | Welche Größe brauchen Sie? | Welke maat heeft u nodig? | ¿Qué talla necesita?
This red dress is very nice. | الفستان الأحمر ده حلو جدًا. | Dieses rote Kleid ist sehr schön. | Deze rode jurk is heel mooi. | Este vestido rojo es muy bonito.
""",
        "grammar": {
            "de": G(("Adjective endings and welch-, dies-", "نهايات الصفات وwelch- وdies-"),
                    ("Before a noun, an adjective takes an ending. After der/die/das (and dies-, welch-): -e in the nominative singular, -en almost everywhere else: der rote Schuh, die blaue Jacke, das rote Kleid, den roten Schuh.\n\nAfter ein/kein/mein the adjective shows the gender itself: ein roter Schuh, eine blaue Jacke, ein rotes Kleid, einen roten Schuh.\n\ndieser/diese/dieses = this; welcher/welche/welches = which.",
                     "الصفة قبل الاسم بتاخد نهاية. بعد der/die/das (وdies- وwelch-): ‎-e في الفاعل المفرد، و‎-en تقريبًا في أي حتة تانية: der rote Schuh، die blaue Jacke، das rote Kleid، den roten Schuh.\n\nبعد ein/kein/mein الصفة هي اللي بتوضح الجنس: ein roter Schuh، eine blaue Jacke، ein rotes Kleid، einen roten Schuh.\n\ndieser/diese/dieses = ده/دي؛ welcher/welche/welches = أنهي."),
                    [("Ich trage eine ___ Jacke. (blau)", "blaue", "blau"), ("Das ist ein ___ Kleid. (rot)", "rotes", "rot"),
                     ("Ich kaufe den ___ Schuh. (schwarz)", "schwarzen", "schwarz"), ("___ Größe brauchen Sie?", "Welche", "welch-")],
                    [["", "masc.", "fem.", "neut."], ["der + adj (nom.)", "der rote", "die rote", "das rote"], ["ein + adj (nom.)", "ein roter", "eine rote", "ein rotes"], ["accusative", "den/einen roten", "die/eine rote", "das rote / ein rotes"]]),
            "nl": G(("Adjective -e and deze, die, welke", "الـ ‎-e في الصفات وdeze وdie وwelke"),
                    ("Dutch adjective rule is short: add -e before a noun, except with a singular het-word after een, geen or no article: een blauwe jas, de zwarte broek, but een rood kostuum, een mooi huis.\n\nSpelling: rood → rode, blauw → blauwe, zwart → zwarte.\n\nthis/these: deze (de-words and plurals), dit (het-words). that: die / dat. which: welke (welk with a het-word).",
                     "قاعدة الصفة في الهولندي قصيرة: زوّد ‎-e قبل الاسم، إلا مع كلمة het مفرد بعد een أو geen أو من غير أداة: een blauwe jas، de zwarte broek، بس een rood kostuum، een mooi huis.\n\nالإملا: rood ← rode، blauw ← blauwe، zwart ← zwarte.\n\nده/دول: deze (لكلمات de والجمع)، dit (لكلمات het). داك: die / dat. أنهي: welke (welk مع كلمة het)."),
                    [("Ik draag een ___ jas. (blauw)", "blauwe", "blauw"), ("___ jurk is heel mooi. (this)", "Deze", "deze / dit"),
                     ("Een ___ huis. (mooi)", "mooi", "mooi"), ("___ maat heeft u nodig?", "Welke", "welk / welke")]),
            "es": G(("Adjective agreement and este, ese", "مطابقة الصفة وeste وese"),
                    ("Adjectives come after the noun and agree in gender and number: el vestido rojo, la chaqueta roja, los zapatos negros. Adjectives in -e or a consonant change only for number: azul → azules.\n\nthis: este, esta, estos, estas. that: ese, esa, esos, esas.\n\nllevar = to wear: Llevo una chaqueta azul. probarse (o → ue) = to try on.",
                     "الصفة بتيجي بعد الاسم وبتطابقه في الجنس والعدد: el vestido rojo، la chaqueta roja، los zapatos negros. والصفات اللي بتخلص بـ ‎-e أو حرف ساكن بتتغير في العدد بس: azul ← azules.\n\nده: este, esta, estos, estas. داك: ese, esa, esos, esas.\n\nllevar = يلبس: Llevo una chaqueta azul. وprobarse (o ← ue) = يقيس."),
                    [("Llevo una chaqueta ___. (rojo)", "roja", "rojo"), ("___ vestido es bonito. (this)", "Este", "este"),
                     ("Los zapatos ___. (azul)", "azules", "azul"), ("¿Puedo ___ el pantalón?", "probarme", "probarse")]),
        },
    },
    {
        "key": "u04",
        "write_en": "your dream flat and where you would put the furniture",
        "write_ar": "شقة أحلامك وهتحط العفش فين",
        "words": """
rent | n | rent | إيجار | die Miete, Mieten | de huur | el alquiler, alquileres
rent_v | v | to rent | يأجّر | mieten | huren | alquilar
furniture | n | furniture | عفش، أثاث | die Möbel | de meubels | los muebles
wall | n | wall | حيطة | die Wand, Wände | de muur, muren | la pared, paredes
floor | n | floor | أرضية | der Boden, Böden | de vloer, vloeren | el suelo, suelos
shelf | n | shelf | رف | das Regal, Regale | de plank, planken | la estantería, estanterías
picture | n | picture | صورة، لوحة | das Bild, Bilder | het schilderij, schilderijen | el cuadro, cuadros
put_stand | v | to put (upright) | يحط (واقف) | stellen | zetten | poner
put_lay | v | to put (lying) | يحط (نايم) | legen | leggen | poner
hang | v | to hang | يعلّق | hängen | hangen | colgar
landlord | n | landlord | صاحب البيت | der Vermieter, Vermieter | de verhuurder, verhuurders | el casero, caseros
neighbourhood | n | neighbourhood | حي، منطقة | die Gegend, Gegenden | de buurt, buurten | el barrio, barrios
""",
        "sentences": """
The rent is too expensive. | الإيجار غالي أوي. | Die Miete ist zu teuer. | De huur is te duur. | El alquiler es demasiado caro.
I put the shelf against the wall. | حطيت الرف على الحيطة. | Ich stelle das Regal an die Wand. | Ik zet de plank tegen de muur. | Pongo la estantería contra la pared.
The picture is hanging on the wall. | الصورة متعلقة على الحيطة. | Das Bild hängt an der Wand. | Het schilderij hangt aan de muur. | El cuadro está colgado en la pared.
We live in a quiet neighbourhood. | ساكنين في منطقة هادية. | Wir wohnen in einer ruhigen Gegend. | We wonen in een rustige buurt. | Vivimos en un barrio tranquilo.
""",
        "grammar": {
            "de": G(("Two-way prepositions: wohin? and wo?", "حروف الجر ذات الوجهين: wohin؟ وwo؟"),
                    ("in, an, auf, über, unter, vor, hinter, neben, zwischen take the accusative for movement (wohin?) and the dative for position (wo?).\n\nIch stelle das Regal an die Wand (wohin? → acc.). Das Regal steht an der Wand (wo? → dat.).\n\nVerb pairs: stellen → stehen, legen → liegen, hängen → hängen. The first of each pair is an action, the second a position.",
                     "in وan وauf وüber وunter وvor وhinter وneben وzwischen بتاخد أكوزاتيف مع الحركة (wohin؟ على فين) وداتيف مع المكان (wo؟ فين).\n\nIch stelle das Regal an die Wand (على فين ← أكوزاتيف). Das Regal steht an der Wand (فين ← داتيف).\n\nأزواج الأفعال: stellen ← stehen، legen ← liegen، hängen ← hängen. الأول فعل حركة والتاني مكان."),
                    [("Ich stelle das Regal an ___ Wand.", "die", "die Wand"), ("Das Bild hängt an ___ Wand.", "der", "die Wand"),
                     ("Das Buch ___ auf dem Tisch. (position)", "liegt", "liegen / legen"), ("Ich ___ das Buch auf den Tisch. (action)", "lege", "liegen / legen")]),
            "nl": G(("zetten, leggen, hangen and staan, liggen", "zetten وleggen وhangen وstaan وliggen"),
                    ("Dutch also pairs action and position: zetten (put upright) → staan, leggen (lay) → liggen, hangen → hangen.\n\nIk zet de plank tegen de muur. De plank staat tegen de muur. Ik leg het boek op de tafel. Het boek ligt op de tafel.\n\nNo case changes: op de tafel stays op de tafel. Dutch even uses staan for things in print: Het staat in de krant.",
                     "الهولندي برضه بيقابل الحركة بالمكان: zetten (يحط واقف) ← staan، leggen (يحط نايم) ← liggen، hangen ← hangen.\n\nIk zet de plank tegen de muur. De plank staat tegen de muur. Ik leg het boek op de tafel. Het boek ligt op de tafel.\n\nمفيش تغيير في الأداة: op de tafel زي ما هي. والهولندي بيستخدم staan للمكتوب كمان: Het staat in de krant (مكتوب في الجرنال)."),
                    [("Ik ___ de plank tegen de muur. (action)", "zet", "zetten / staan"), ("Het boek ___ op de tafel. (position)", "ligt", "liggen / leggen"),
                     ("Het schilderij ___ aan de muur.", "hangt", "hangen"), ("De huur is ___ duur. (too)", "te", "te")]),
            "es": G(("poner, estar and place prepositions", "poner وestar وحروف المكان"),
                    ("Spanish uses one verb for putting: poner (pongo, pones, pone): Pongo la estantería contra la pared.\n\nPosition uses estar: El cuadro está en la pared. El libro está encima de la mesa.\n\nPlace words: encima de (on top of), debajo de (under), delante de (in front of), detrás de (behind), entre (between), al lado de (next to).",
                     "الإسباني بيستخدم فعل واحد للحط: poner (pongo, pones, pone): Pongo la estantería contra la pared.\n\nالمكان بـ estar: El cuadro está en la pared. El libro está encima de la mesa.\n\nكلمات المكان: encima de (فوق)، debajo de (تحت)، delante de (قدام)، detrás de (ورا)، entre (بين)، al lado de (جنب)."),
                    [("___ la estantería contra la pared. (yo)", "Pongo", "poner"), ("El libro ___ encima de la mesa.", "está", "estar"),
                     ("El gato está ___ de la mesa. (under)", "debajo", "debajo de"), ("El alquiler es ___ caro. (too)", "demasiado", "demasiado")]),
        },
    },
    {
        "key": "u05",
        "write_en": "your job or the job you would like, and why",
        "write_ar": "شغلك أو الشغل اللي نفسك فيه وليه",
        "words": """
meeting | n | meeting | اجتماع | die Besprechung, Besprechungen | de vergadering, vergaderingen | la reunión, reuniones
company | n | company | شركة | die Firma, Firmen | het bedrijf, bedrijven | la empresa, empresas
salary | n | salary | مرتب | das Gehalt, Gehälter | het salaris, salarissen | el sueldo, sueldos
appointment | n | appointment | ميعاد | der Termin, Termine | de afspraak, afspraken | la cita, citas
task | n | task | مهمة | die Aufgabe, Aufgaben | de taak, taken | la tarea, tareas
computer | n | computer | كمبيوتر | der Computer, Computer | de computer, computers | el ordenador, ordenadores
email | n | email | إيميل | die E-Mail, E-Mails | de e-mail, e-mails | el correo electrónico
earn | v | to earn | يكسب | verdienen | verdienen | ganar
because | conj | because | عشان | weil | omdat | porque
that_conj | conj | that | إن | dass | dat | que
busy | adj | busy | مشغول | beschäftigt | druk | ocupado
interesting | adj | interesting | ممتع، مثير للاهتمام | interessant | interessant | interesante
""",
        "sentences": """
I like my job because it is interesting. | بحب شغلي عشان ممتع. | Ich mag meine Arbeit, weil sie interessant ist. | Ik vind mijn werk leuk, omdat het interessant is. | Me gusta mi trabajo porque es interesante.
I think that the meeting is at ten. | أعتقد إن الاجتماع الساعة عشرة. | Ich glaube, dass die Besprechung um zehn ist. | Ik denk dat de vergadering om tien uur is. | Creo que la reunión es a las diez.
I would like to earn more. | نفسي أكسب أكتر. | Ich würde gern mehr verdienen. | Ik zou graag meer verdienen. | Me gustaría ganar más.
Today I am very busy. | النهاردة أنا مشغول جدًا. | Heute bin ich sehr beschäftigt. | Vandaag heb ik het heel druk. | Hoy estoy muy ocupado.
""",
        "grammar": {
            "de": G(("weil, dass and Konjunktiv II (würde, hätte, wäre)", "weil وdass والـ Konjunktiv II"),
                    ("weil (because) and dass (that) start a subordinate clause: the verb goes to the end. Ich mag meine Arbeit, weil sie interessant ist. Ich glaube, dass die Besprechung um zehn ist.\n\nPolite wishes: würde + infinitive (Ich würde gern mehr verdienen), hätte (Ich hätte gern einen Kaffee), wäre (Das wäre toll).",
                     "weil (عشان) وdass (إن) بيبدأوا جملة فرعية: الفعل بيروح للآخر. Ich mag meine Arbeit, weil sie interessant ist. Ich glaube, dass die Besprechung um zehn ist.\n\nالأمنيات المؤدبة: würde + مصدر (Ich würde gern mehr verdienen)، hätte (Ich hätte gern einen Kaffee)، wäre (Das wäre toll)."),
                    [("Ich bleibe zu Hause, weil ich krank ___.", "bin", "sein"), ("Ich glaube, ___ er kommt.", "dass", "dass"),
                     ("Ich ___ gern mehr verdienen.", "würde", "werden"), ("Ich ___ gern einen Kaffee.", "hätte", "haben")]),
            "nl": G(("omdat, dat and zou graag", "omdat وdat وzou graag"),
                    ("omdat (because) and dat (that) send the verb to the end, like German: ..., omdat het interessant is. Ik denk dat de vergadering om tien uur is.\n\nBut want (also because) keeps normal word order: ..., want het is interessant.\n\nPolite wish: zou + graag + infinitive: Ik zou graag meer verdienen. Busy: Ik heb het druk.",
                     "omdat (عشان) وdat (إن) بيبعتوا الفعل للآخر زي الألماني: ..., omdat het interessant is. Ik denk dat de vergadering om tien uur is.\n\nبس want (برضه عشان) بتسيب ترتيب الكلام عادي: ..., want het is interessant.\n\nالأمنية المؤدبة: zou + graag + مصدر: Ik zou graag meer verdienen. ومشغول: Ik heb het druk."),
                    [("..., omdat het interessant ___.", "is", "zijn"), ("Ik denk ___ hij komt.", "dat", "dat"),
                     ("Ik ___ graag meer verdienen.", "zou", "zullen"), ("..., want het ___ interessant.", "is", "zijn")]),
            "es": G(("porque, que and the conditional", "porque وque والشرطي"),
                    ("porque (because) and que (that) don't change word order: Me gusta porque es interesante. Creo que la reunión es a las diez.\n\nPolite wish: me gustaría + infinitive, or the conditional: querría, podría. Conditional = infinitive + -ía: ganaría, sería.\n\nBusy is a state: estoy ocupado/ocupada.",
                     "porque (عشان) وque (إن) مش بيغيروا ترتيب الكلام: Me gusta porque es interesante. Creo que la reunión es a las diez.\n\nالأمنية المؤدبة: me gustaría + مصدر، أو الشرطي: querría، podría. الشرطي = المصدر + ‎-ía: ganaría، sería.\n\nمشغول حالة: estoy ocupado/ocupada."),
                    [("Me ___ ganar más.", "gustaría", "gustar"), ("Creo ___ la reunión es a las diez.", "que", "que"),
                     ("Hoy ___ muy ocupado.", "estoy", "estar"), ("Eso ___ fantástico. (conditional, ser)", "sería", "ser")]),
        },
    },
    {
        "key": "u06",
        "write_en": "how you use your phone and the internet",
        "write_ar": "بتستخدم الموبايل والإنترنت إزاي",
        "words": """
phone | n | mobile phone | موبايل | das Handy, Handys | de mobiel, mobielen | el móvil, móviles
internet | n | internet | إنترنت | das Internet | het internet | internet
message | n | message | رسالة | die Nachricht, Nachrichten | het bericht, berichten | el mensaje, mensajes
send | v | to send | يبعت | schicken | sturen | enviar
download | v | to download | ينزّل، يحمّل | herunterladen | downloaden | descargar
screen | n | screen | شاشة | der Bildschirm, Bildschirme | het scherm, schermen | la pantalla, pantallas
password | n | password | باسورد | das Passwort, Passwörter | het wachtwoord, wachtwoorden | la contraseña, contraseñas
newspaper | n | newspaper | جرنال | die Zeitung, Zeitungen | de krant, kranten | el periódico, periódicos
fast | adj | fast | سريع | schnell | snel | rápido
better | adj | better | أحسن | besser | beter | mejor
if_cond | conj | if, whenever | لو، لما | wenn | als | si
than | conj | than | من (للمقارنة) | als | dan | que
""",
        "sentences": """
My new phone is faster than the old one. | موبايلي الجديد أسرع من القديم. | Mein neues Handy ist schneller als das alte. | Mijn nieuwe mobiel is sneller dan de oude. | Mi móvil nuevo es más rápido que el viejo.
If I have time, I'll send you a message. | لو عندي وقت هبعتلك رسالة. | Wenn ich Zeit habe, schicke ich dir eine Nachricht. | Als ik tijd heb, stuur ik je een bericht. | Si tengo tiempo, te envío un mensaje.
I read the newspaper on the internet. | بقرا الجرنال على النت. | Ich lese die Zeitung im Internet. | Ik lees de krant op internet. | Leo el periódico en internet.
This is the best computer. | ده أحسن كمبيوتر. | Das ist der beste Computer. | Dit is de beste computer. | Este es el mejor ordenador.
""",
        "grammar": {
            "de": G(("Comparative, superlative and wenn", "المقارنة والتفضيل وwenn"),
                    ("Comparative: adjective + -er + als: schneller als. Superlative: am + -sten (am schnellsten) or der/die/das + -ste (der schnellste). Short words often add an umlaut: alt → älter, groß → größer. Irregular: gut → besser → am besten, viel → mehr → am meisten.\n\nwenn (if, whenever) sends the verb to the end; the main clause then starts with its verb: Wenn ich Zeit habe, schicke ich dir eine Nachricht.",
                     "المقارنة: الصفة + ‎-er + als: schneller als. والتفضيل: am + ‎-sten (am schnellsten) أو der/die/das + ‎-ste (der schnellste). الكلمات القصيرة غالبًا بتاخد أوملاوت: alt ← älter، groß ← größer. والشاذ: gut ← besser ← am besten، viel ← mehr ← am meisten.\n\nwenn (لو/لما) بتبعت الفعل للآخر، والجملة الأساسية تبدأ بفعلها: Wenn ich Zeit habe, schicke ich dir eine Nachricht."),
                    [("Mein Handy ist ___ als das alte. (schnell)", "schneller", "schnell"), ("Das ist der ___ Computer. (gut)", "beste", "gut"),
                     ("Wenn ich Zeit ___, schreibe ich dir.", "habe", "haben"), ("Er ist ___ als ich. (alt)", "älter", "alt")]),
            "nl": G(("Comparative with dan, and als (if)", "المقارنة بـ dan، وals (لو)"),
                    ("Comparative: adjective + -er + dan: sneller dan. Superlative: -st: het snelst, de snelste. After r add -der: duur → duurder. Irregular: goed → beter → best, veel → meer → meest.\n\nCareful: German als (than) = Dutch dan; Dutch als = if/when: Als ik tijd heb, stuur ik je een bericht. The main clause after it starts with the verb.",
                     "المقارنة: الصفة + ‎-er + dan: sneller dan. والتفضيل: ‎-st: het snelst، de snelste. بعد r زوّد ‎-der: duur ← duurder. والشاذ: goed ← beter ← best، veel ← meer ← meest.\n\nخلي بالك: als الألمانية (من، للمقارنة) = dan بالهولندي؛ وals الهولندية = لو/لما: Als ik tijd heb, stuur ik je een bericht. والجملة الأساسية بعدها تبدأ بالفعل."),
                    [("Mijn mobiel is sneller ___ de oude.", "dan", "dan"), ("Dit is de ___ computer. (goed)", "beste", "goed"),
                     ("___ ik tijd heb, stuur ik je een bericht.", "Als", "als"), ("Hij is ___ dan ik. (oud)", "ouder", "oud")]),
            "es": G(("más ... que, the superlative and si", "más ... que والتفضيل وsi"),
                    ("Comparative: más/menos + adjective + que: más rápido que. Irregular: mejor (better), peor (worse), mayor (older), menor (younger).\n\nSuperlative: el/la/los/las + más + adjective: el más rápido; with irregulars: el mejor ordenador.\n\nsi (if) + present, then present or future: Si tengo tiempo, te envío un mensaje.",
                     "المقارنة: más/menos + الصفة + que: más rápido que. والشاذ: mejor (أحسن)، peor (أوحش)، mayor (أكبر في السن)، menor (أصغر).\n\nالتفضيل: el/la/los/las + más + الصفة: el más rápido؛ ومع الشاذ: el mejor ordenador.\n\nsi (لو) + مضارع، وبعدها مضارع أو مستقبل: Si tengo tiempo, te envío un mensaje."),
                    [("Mi móvil es más rápido ___ el viejo.", "que", "que"), ("Este es el ___ ordenador. (bueno)", "mejor", "bueno"),
                     ("___ tengo tiempo, te envío un mensaje.", "Si", "si"), ("Mi hermano es ___ que yo. (older)", "mayor", "mayor")]),
        },
    },
    {
        "key": "u07",
        "write_en": "what you do to stay healthy",
        "write_ar": "بتعمل إيه عشان تفضل صحتك كويسة",
        "words": """
sport | n | sport | رياضة | der Sport | de sport | el deporte, deportes
run | v | to run | يجري | laufen | lopen | correr
gym | n | gym | جيم | das Fitnessstudio, Fitnessstudios | de sportschool, sportscholen | el gimnasio, gimnasios
tired | adj | tired | تعبان | müde | moe | cansado
feel | v | to feel | يحس | sich fühlen | zich voelen | sentirse
rest | v | to rest | يرتاح | sich ausruhen | uitrusten | descansar
wash | v | to wash | يغسل | waschen | wassen | lavar
teeth | n | tooth | سنة (ضرس) | der Zahn, Zähne | de tand, tanden | el diente, dientes
diet | n | diet (food habits) | نظام أكل | die Ernährung | de voeding | la alimentación
weight | n | weight | وزن | das Gewicht | het gewicht | el peso
stress | n | stress | ضغط، توتر | der Stress | de stress | el estrés
enough | adv | enough | كفاية | genug | genoeg | suficiente
""",
        "sentences": """
I run three times a week. | بجري تلات مرات في الأسبوع. | Ich laufe dreimal pro Woche. | Ik loop drie keer per week hard. | Corro tres veces a la semana.
I feel tired today. | حاسس إني تعبان النهاردة. | Ich fühle mich heute müde. | Ik voel me vandaag moe. | Hoy me siento cansado.
You should sleep enough. | المفروض تنام كفاية. | Du solltest genug schlafen. | Je zou genoeg moeten slapen. | Deberías dormir lo suficiente.
I brush my teeth every morning. | بغسل سناني كل يوم الصبح. | Ich putze mir jeden Morgen die Zähne. | Ik poets elke ochtend mijn tanden. | Me lavo los dientes cada mañana.
""",
        "grammar": {
            "de": G(("Reflexive verbs with dative and sollte", "أفعال انعكاسية مع الداتيف وsollte"),
                    ("When a reflexive verb also has a direct object, the reflexive pronoun is dative: Ich wasche mich (acc.), but Ich wasche mir die Hände (dat.). Only ich and du change: mir, dir.\n\nGerman uses the article for body parts: Ich putze mir die Zähne (not meine Zähne).\n\nAdvice: sollte (Konjunktiv II of sollen): Du solltest genug schlafen.",
                     "لو الفعل الانعكاسي ليه مفعول تاني، ضمير الانعكاس بيبقى داتيف: Ich wasche mich (أكوزاتيف)، بس Ich wasche mir die Hände (داتيف). ich وdu بس اللي بيتغيروا: mir، dir.\n\nالألماني بيستخدم الأداة مع أعضاء الجسم: Ich putze mir die Zähne (مش meine Zähne).\n\nالنصيحة: sollte: Du solltest genug schlafen."),
                    [("Ich wasche ___ die Hände.", "mir", "ich"), ("Ich fühle ___ müde.", "mich", "ich"),
                     ("Du ___ genug schlafen.", "solltest", "sollen"), ("Ich putze mir ___ Zähne.", "die", "die")]),
            "nl": G(("Reflexive verbs and zou moeten", "الأفعال الانعكاسية وzou moeten"),
                    ("Ik voel me, jij voelt je, hij voelt zich, wij voelen ons. Dutch has no dative: Ik was mijn handen.\n\nDutch uses the possessive with body parts: Ik poets mijn tanden.\n\nAdvice: zou ... moeten: Je zou genoeg moeten slapen. Running for sport = hardlopen: Ik loop hard; lopen alone usually means walking.",
                     "Ik voel me, jij voelt je, hij voelt zich, wij voelen ons. الهولندي مفيهوش داتيف: Ik was mijn handen.\n\nالهولندي بيستخدم الملكية مع أعضاء الجسم: Ik poets mijn tanden.\n\nالنصيحة: zou ... moeten: Je zou genoeg moeten slapen. والجري كرياضة = hardlopen: Ik loop hard؛ وlopen لوحدها غالبًا يعني المشي."),
                    [("Ik voel ___ moe.", "me", "zich"), ("Ik poets ___ tanden.", "mijn", "mijn"),
                     ("Je ___ genoeg moeten slapen.", "zou", "zullen"), ("Hij voelt ___ goed.", "zich", "zich")]),
            "es": G(("Reflexives with body parts and deberías", "الانعكاسي مع أعضاء الجسم وdeberías"),
                    ("With body parts Spanish uses a reflexive verb and the article: Me lavo los dientes. Me duele la espalda.\n\nsentirse (e → ie): me siento, te sientes, se siente.\n\nAdvice in the conditional is softer: deberías + infinitive: Deberías dormir lo suficiente.",
                     "مع أعضاء الجسم الإسباني بيستخدم فعل انعكاسي والأداة: Me lavo los dientes. Me duele la espalda.\n\nsentirse (e ← ie): me siento, te sientes, se siente.\n\nالنصيحة بالشرطي أخف: deberías + مصدر: Deberías dormir lo suficiente."),
                    [("Me lavo ___ dientes.", "los", "los"), ("Hoy me ___ cansado.", "siento", "sentirse"),
                     ("___ dormir más. (tú, advice)", "Deberías", "deber"), ("Ella ___ siente bien.", "se", "se")]),
        },
    },
    {
        "key": "u08",
        "write_en": "your last holiday: where you stayed and what you saw",
        "write_ar": "آخر إجازة: نزلت فين وشفت إيه",
        "words": """
hotel | n | hotel | فندق | das Hotel, Hotels | het hotel, hotels | el hotel, hoteles
room_book | v | to book | يحجز | buchen | boeken | reservar
beach | n | beach | شط | der Strand, Strände | het strand, stranden | la playa, playas
sea | n | sea | بحر | das Meer, Meere | de zee, zeeën | el mar, mares
mountain | n | mountain | جبل | der Berg, Berge | de berg, bergen | la montaña, montañas
weather | n | weather | الجو | das Wetter | het weer | el tiempo
sun | n | sun | شمس | die Sonne | de zon | el sol
rain | n | rain | مطر | der Regen | de regen | la lluvia
passport | n | passport | باسبور | der Reisepass, Reisepässe | het paspoort, paspoorten | el pasaporte, pasaportes
abroad | adv | abroad | برة البلد | im Ausland | in het buitenland | en el extranjero
during | prep | during | خلال | während | tijdens | durante
sightseeing | n | sight, place of interest | معلم سياحي | die Sehenswürdigkeit, Sehenswürdigkeiten | de bezienswaardigheid, bezienswaardigheden | el monumento, monumentos
""",
        "sentences": """
We booked a hotel by the sea. | حجزنا فندق على البحر. | Wir haben ein Hotel am Meer gebucht. | We hebben een hotel aan zee geboekt. | Reservamos un hotel junto al mar.
During the holiday the weather was good. | خلال الإجازة الجو كان حلو. | Während des Urlaubs war das Wetter gut. | Tijdens de vakantie was het weer goed. | Durante las vacaciones hizo buen tiempo.
My sister's passport is in the bag. | باسبور أختي في الشنطة. | Der Reisepass meiner Schwester ist in der Tasche. | Het paspoort van mijn zus zit in de tas. | El pasaporte de mi hermana está en la bolsa.
In the mountains it rained a lot. | في الجبال مطرت كتير. | In den Bergen hat es viel geregnet. | In de bergen heeft het veel geregend. | En las montañas llovió mucho.
""",
        "grammar": {
            "de": G(("Genitive basics and während", "أساسيات الجينيتيف وwährend"),
                    ("The genitive shows belonging: der Pass meiner Schwester, das Auto des Vaters. Articles: des (masc./neut., + -s on the noun), der (fem./plural).\n\nIn speech von + dative is common: der Pass von meiner Schwester. With names: Annas Pass.\n\nwährend (during) takes the genitive: während des Urlaubs.",
                     "الجينيتيف بيوضح الملكية: der Pass meiner Schwester، das Auto des Vaters. الأدوات: des (مذكر/محايد + ‎-s في الاسم)، der (مؤنث/جمع).\n\nفي الكلام von + داتيف منتشرة: der Pass von meiner Schwester. ومع الأسماء: Annas Pass.\n\nwährend (خلال) بتاخد جينيتيف: während des Urlaubs."),
                    [("Der Pass ___ Schwester. (my)", "meiner", "meine"), ("Das Auto ___ Vaters.", "des", "der"),
                     ("Während ___ Urlaubs war es warm.", "des", "der Urlaub"), ("Es hat viel ___. (regnen, perfect)", "geregnet", "regnen")]),
            "nl": G(("van for belonging and tijdens", "van للملكية وtijdens"),
                    ("Dutch has no genitive in everyday speech: use van: het paspoort van mijn zus, de auto van mijn vader. With names: Anna's paspoort, Peters auto.\n\nDuring = tijdens: tijdens de vakantie.\n\nWeather uses het: het regent, het heeft geregend; Het weer is goed. Note zee: aan zee = by the sea.",
                     "الهولندي مفيهوش جينيتيف في الكلام العادي: استخدم van: het paspoort van mijn zus، de auto van mijn vader. ومع الأسماء: Anna's paspoort، Peters auto.\n\nخلال = tijdens: tijdens de vakantie.\n\nالجو بـ het: het regent، het heeft geregend؛ Het weer is goed. وaan zee = على البحر."),
                    [("Het paspoort ___ mijn zus.", "van", "van"), ("___ de vakantie was het weer goed.", "Tijdens", "tijdens"),
                     ("Het heeft veel ___. (regenen)", "geregend", "regenen"), ("We hebben een hotel aan ___ geboekt.", "zee", "de zee")]),
            "es": G(("de for belonging, weather with hacer", "de للملكية والجو بـ hacer"),
                    ("Belonging uses de: el pasaporte de mi hermana, la casa de Ana.\n\nWeather: hace buen/mal tiempo, hace sol, hace calor/frío; llueve (it rains), nieva (it snows). In the past: hizo buen tiempo, llovió.\n\ndurante = during: durante las vacaciones.",
                     "الملكية بـ de: el pasaporte de mi hermana، la casa de Ana.\n\nالجو: hace buen/mal tiempo، hace sol، hace calor/frío؛ llueve (بتمطر)، nieva (بتتلج). في الماضي: hizo buen tiempo، llovió.\n\ndurante = خلال: durante las vacaciones."),
                    [("El pasaporte ___ mi hermana.", "de", "de"), ("Hoy ___ sol.", "hace", "hacer"),
                     ("Ayer ___ mucho. (llover)", "llovió", "llover"), ("___ las vacaciones hizo calor.", "Durante", "durante")]),
        },
    },
    {
        "key": "u09",
        "write_en": "a dish from your country and how to make it",
        "write_ar": "أكلة من بلدك وإزاي تتعمل",
        "words": """
recipe | n | recipe | وصفة | das Rezept, Rezepte | het recept, recepten | la receta, recetas
vegetables | n | vegetables | خضار | das Gemüse | de groente, groenten | la verdura, verduras
rice | n | rice | رز | der Reis | de rijst | el arroz
chicken | n | chicken | فراخ | das Hähnchen, Hähnchen | de kip, kippen | el pollo, pollos
salt | n | salt | ملح | das Salz | het zout | la sal
spicy | adj | spicy, hot | حراق | scharf | pittig | picante
sweet | adj | sweet | مسكّر، حلو | süß | zoet | dulce
taste | v | to taste | طعمه | schmecken | smaken | saber
cut | v | to cut | يقطّع | schneiden | snijden | cortar
restaurant | n | restaurant | مطعم | das Restaurant, Restaurants | het restaurant, restaurants | el restaurante, restaurantes
bill | n | bill | الحساب | die Rechnung, Rechnungen | de rekening, rekeningen | la cuenta, cuentas
something | pron | something | حاجة | etwas | iets | algo
""",
        "sentences": """
The soup tastes very good. | الشوربة طعمها حلو أوي. | Die Suppe schmeckt sehr gut. | De soep smaakt heel lekker. | La sopa sabe muy bien.
I cut the fresh vegetables. | بقطّع الخضار الطازة. | Ich schneide das frische Gemüse. | Ik snijd de verse groenten. | Corto las verduras frescas.
Would you like something sweet? | تحب حاجة حلوة؟ | Möchtest du etwas Süßes? | Wil je iets zoets? | ¿Quieres algo dulce?
The bill, please! | الحساب لو سمحت! | Die Rechnung, bitte! | De rekening, alstublieft! | ¡La cuenta, por favor!
""",
        "grammar": {
            "de": G(("Adjective endings in the dative; etwas, nichts", "نهايات الصفة في الداتيف؛ etwas وnichts"),
                    ("In the dative, adjectives after der/ein end in -en: mit dem frischen Gemüse, in einem kleinen Restaurant, mit der scharfen Soße.\n\nWithout an article, the adjective takes the article ending: mit frischem Gemüse, mit scharfer Soße.\n\nIndefinite pronouns: etwas (something), nichts (nothing), alles (everything), jemand (someone), niemand (no one). etwas Süßes = something sweet (capital, -es).",
                     "في الداتيف، الصفة بعد der/ein بتخلص بـ ‎-en: mit dem frischen Gemüse، in einem kleinen Restaurant، mit der scharfen Soße.\n\nمن غير أداة، الصفة بتاخد نهاية الأداة: mit frischem Gemüse، mit scharfer Soße.\n\nضماير غير محددة: etwas (حاجة)، nichts (ولا حاجة)، alles (كل حاجة)، jemand (حد)، niemand (ولا حد). وetwas Süßes = حاجة حلوة (حرف كبير و‎-es)."),
                    [("mit dem ___ Gemüse (frisch)", "frischen", "frisch"), ("in einem ___ Restaurant (klein)", "kleinen", "klein"),
                     ("Möchtest du etwas ___? (süß)", "Süßes", "süß"), ("Ich habe ___ gegessen. (nothing)", "nichts", "nichts")]),
            "nl": G(("iets + -s, niets, smaken", "iets + ‎-s، وniets، وsmaken"),
                    ("After iets (something), niets (nothing), veel, weinig an adjective gets -s: iets zoets, niets bijzonders.\n\nsmaken = to taste: Het smaakt lekker. Hoe smaakt het?\n\nDutch lekker is everywhere: tasty food, a nice bed, lovely weather. Remember the de-/het-rule with adjectives: de verse groenten, het verse brood, vers brood.",
                     "بعد iets (حاجة) وniets (ولا حاجة) وveel وweinig الصفة بتاخد ‎-s: iets zoets، niets bijzonders.\n\nsmaken = طعمه: Het smaakt lekker. Hoe smaakt het?\n\nlekker الهولندية في كل حتة: الأكل اللذيذ، السرير المريح، الجو الحلو. وافتكر قاعدة de/het مع الصفة: de verse groenten، het verse brood، vers brood."),
                    [("Wil je iets ___? (zoet)", "zoets", "zoet"), ("De soep ___ lekker.", "smaakt", "smaken"),
                     ("Ik snijd de ___ groenten. (vers)", "verse", "vers"), ("Er is ___ bijzonders. (nothing)", "niets", "niets")]),
            "es": G(("saber (to taste), algo, nada", "saber (طعمه)، algo، nada"),
                    ("saber also means to taste: La sopa sabe bien. ¿A qué sabe? (What does it taste like?)\n\nalgo = something, nada = nothing, alguien = someone, nadie = no one. Spanish uses a double negative: No quiero nada. No hay nadie.\n\nalgo + adjective (masculine): algo dulce, algo picante.",
                     "saber معناها برضه طعمه: La sopa sabe bien. ¿A qué sabe? (طعمه عامل إزاي؟)\n\nalgo = حاجة، nada = ولا حاجة، alguien = حد، nadie = ولا حد. الإسباني بيستخدم نفي مزدوج: No quiero nada. No hay nadie.\n\nalgo + صفة (مذكر): algo dulce، algo picante."),
                    [("La sopa ___ muy bien.", "sabe", "saber"), ("No quiero ___. (nothing)", "nada", "nada"),
                     ("¿Quieres ___ dulce?", "algo", "algo"), ("No hay ___. (no one)", "nadie", "nadie")]),
        },
    },
    {
        "key": "u10",
        "write_en": "a visit to an office: what you needed and what happened",
        "write_ar": "زيارة لمصلحة: كنت محتاج إيه وإيه اللي حصل",
        "words": """
form | n | form | استمارة | das Formular, Formulare | het formulier, formulieren | el formulario, formularios
fill_in | v | to fill in | يملا | ausfüllen | invullen | rellenar
sign | v | to sign | يمضي | unterschreiben | ondertekenen | firmar
office_authority | n | public office, authority | مصلحة حكومية | das Amt, Ämter | het gemeentehuis, gemeentehuizen | la oficina pública
residence_permit | n | residence permit | إقامة | die Aufenthaltserlaubnis | de verblijfsvergunning | el permiso de residencia
address | n | address | عنوان | die Adresse, Adressen | het adres, adressen | la dirección, direcciones
documents | n | document | ورقة رسمية، مستند | das Dokument, Dokumente | het document, documenten | el documento, documentos
wait | v | to wait | يستنى | warten | wachten | esperar
question_ask | v | to ask | يسأل | fragen | vragen | preguntar
whether | conj | whether, if | إذا كان | ob | of | si
open_adj | adj | open | مفتوح | geöffnet | open | abierto
closed | adj | closed | مقفول | geschlossen | gesloten | cerrado
""",
        "sentences": """
Please fill in the form. | من فضلك املا الاستمارة. | Bitte füllen Sie das Formular aus. | Vult u alstublieft het formulier in. | Por favor, rellene el formulario.
Can you tell me whether the office is open? | ممكن تقولي إذا كانت المصلحة فاتحة؟ | Können Sie mir sagen, ob das Amt geöffnet ist? | Kunt u me zeggen of het gemeentehuis open is? | ¿Puede decirme si la oficina está abierta?
The form is signed here. | الاستمارة بتتمضي هنا. | Das Formular wird hier unterschrieben. | Het formulier wordt hier ondertekend. | El formulario se firma aquí.
I don't know where I have to wait. | مش عارف لازم أستنى فين. | Ich weiß nicht, wo ich warten muss. | Ik weet niet waar ik moet wachten. | No sé dónde tengo que esperar.
""",
        "grammar": {
            "de": G(("Indirect questions with ob, wo; passive (intro)", "الأسئلة غير المباشرة بـ ob وwo؛ المبني للمجهول"),
                    ("A yes/no question inside a sentence starts with ob, and the verb goes to the end: Können Sie mir sagen, ob das Amt geöffnet ist? With a question word: Ich weiß nicht, wo ich warten muss.\n\nPresent passive = werden + participle: Das Formular wird hier unterschrieben. Die Formulare werden geprüft.",
                     "سؤال الإجابة عليه أيوه/لأ لما يبقى جوه جملة بيبدأ بـ ob والفعل بيروح للآخر: Können Sie mir sagen, ob das Amt geöffnet ist? ومع أداة سؤال: Ich weiß nicht, wo ich warten muss.\n\nالمبني للمجهول في المضارع = werden + اسم المفعول: Das Formular wird hier unterschrieben. Die Formulare werden geprüft."),
                    [("Wissen Sie, ___ das Amt offen ist?", "ob", "ob"), ("Ich weiß nicht, wo ich warten ___.", "muss", "müssen"),
                     ("Das Formular ___ hier unterschrieben.", "wird", "werden"), ("Bitte füllen Sie das Formular ___.", "aus", "ausfüllen")]),
            "nl": G(("of in indirect questions; passive with worden", "of في الأسئلة غير المباشرة؛ المجهول بـ worden"),
                    ("Indirect yes/no questions use of (not als!): Kunt u me zeggen of het gemeentehuis open is? The verb goes to the end: Ik weet niet waar ik moet wachten.\n\nPresent passive: worden + participle: Het formulier wordt hier ondertekend. De documenten worden gecontroleerd.\n\ninvullen splits: Vult u het formulier in.",
                     "الأسئلة غير المباشرة أيوه/لأ بـ of (مش als!): Kunt u me zeggen of het gemeentehuis open is? والفعل بيروح للآخر: Ik weet niet waar ik moet wachten.\n\nالمجهول في المضارع: worden + اسم المفعول: Het formulier wordt hier ondertekend. De documenten worden gecontroleerd.\n\ninvullen بينفصل: Vult u het formulier in."),
                    [("Weet u ___ het open is?", "of", "of"), ("Het formulier ___ hier ondertekend.", "wordt", "worden"),
                     ("Vult u het formulier ___.", "in", "invullen"), ("Ik weet niet waar ik ___ wachten.", "moet", "moeten")]),
            "es": G(("si in indirect questions; passive with se", "si في الأسئلة غير المباشرة؛ المجهول بـ se"),
                    ("Indirect yes/no question: si: ¿Puede decirme si la oficina está abierta? With question words keep the accent: No sé dónde tengo que esperar.\n\nSpanish often forms the passive with se: El formulario se firma aquí. Se habla español. Plural: Los documentos se revisan.\n\nPolite request: Por favor, rellene el formulario (usted imperative).",
                     "السؤال غير المباشر أيوه/لأ: si: ¿Puede decirme si la oficina está abierta? ومع أدوات السؤال خلي العلامة: No sé dónde tengo que esperar.\n\nالإسباني غالبًا بيعمل المجهول بـ se: El formulario se firma aquí. Se habla español. والجمع: Los documentos se revisan.\n\nالطلب المؤدب: Por favor, rellene el formulario (أمر usted)."),
                    [("¿Sabe ___ la oficina está abierta?", "si", "si"), ("El formulario ___ firma aquí.", "se", "se"),
                     ("No sé ___ tengo que esperar. (where)", "dónde", "dónde"), ("Los documentos se ___. (revisar)", "revisan", "revisar")]),
        },
    },
    {
        "key": "u11",
        "write_en": "your favourite celebration and how you celebrate it",
        "write_ar": "أحب مناسبة ليك وبتحتفل بيها إزاي",
        "words": """
birthday | n | birthday | عيد ميلاد | der Geburtstag, Geburtstage | de verjaardag, verjaardagen | el cumpleaños, cumpleaños
celebrate | v | to celebrate | يحتفل | feiern | vieren | celebrar
present | n | present, gift | هدية | das Geschenk, Geschenke | het cadeau, cadeaus | el regalo, regalos
congratulate | v | to congratulate | يهنّي | gratulieren | feliciteren | felicitar
wedding | n | wedding | فرح | die Hochzeit, Hochzeiten | de bruiloft, bruiloften | la boda, bodas
holiday_feast | n | festival, (religious) holiday | عيد | das Fest, Feste | het feest, feesten | la fiesta, fiestas
tradition | n | tradition | عادة، تقليد | die Tradition, Traditionen | de traditie, tradities | la tradición, tradiciones
guest | n | guest | ضيف | der Gast, Gäste | de gast, gasten | el invitado, invitados
cake | n | cake | تورتة، كيكة | der Kuchen, Kuchen | de taart, taarten | la tarta, tartas
date_day | n | date | تاريخ | das Datum, Daten | de datum, data | la fecha, fechas
first | adj | first | أول | erste | eerste | primero
when_once | conj | when (one time, past) | لما (مرة في الماضي) | als | toen | cuando
""",
        "sentences": """
My birthday is on the third of May. | عيد ميلادي يوم تلاتة مايو. | Mein Geburtstag ist am dritten Mai. | Mijn verjaardag is op drie mei. | Mi cumpleaños es el tres de mayo.
When I was twenty, we celebrated a big party. | لما كان عندي عشرين سنة، عملنا حفلة كبيرة. | Als ich zwanzig war, haben wir eine große Party gefeiert. | Toen ik twintig was, hebben we een groot feest gevierd. | Cuando tenía veinte años, celebramos una gran fiesta.
Congratulations on your wedding! | مبروك على الفرح! | Ich gratuliere dir zur Hochzeit! | Gefeliciteerd met je bruiloft! | ¡Felicidades por tu boda!
The guests bring presents. | الضيوف بيجيبوا هدايا. | Die Gäste bringen Geschenke mit. | De gasten nemen cadeaus mee. | Los invitados traen regalos.
""",
        "grammar": {
            "de": G(("Dates, ordinal numbers, als vs. wenn", "التواريخ والأعداد الترتيبية، als ولا wenn"),
                    ("Ordinals: 1-19 add -te (der zweite, der vierte; irregular: erste, dritte, siebte), from 20 add -ste (der zwanzigste). Dates: am dritten Mai, Heute ist der dritte Mai.\n\nals = one event or period in the past: Als ich zwanzig war, ... wenn = whenever (repeated) or any present/future condition: Wenn ich Geburtstag habe, backe ich einen Kuchen.",
                     "الأعداد الترتيبية: من 1 لـ 19 زوّد ‎-te (der zweite، der vierte؛ والشاذ: erste، dritte، siebte)، ومن 20 زوّد ‎-ste (der zwanzigste). التواريخ: am dritten Mai، Heute ist der dritte Mai.\n\nals = حدث واحد أو فترة في الماضي: Als ich zwanzig war, ... وwenn = كل ما (متكرر) أو أي شرط في الحاضر/المستقبل: Wenn ich Geburtstag habe, backe ich einen Kuchen."),
                    [("Mein Geburtstag ist am ___ Mai. (3.)", "dritten", "drei"), ("___ ich zwanzig war, ...", "Als", "als / wenn"),
                     ("___ ich Geburtstag habe, feiere ich.", "Wenn", "als / wenn"), ("Heute ist der ___ Juni. (1.)", "erste", "eins")]),
            "nl": G(("Dates, ordinals, toen vs. als", "التواريخ والأعداد الترتيبية، toen ولا als"),
                    ("Dates use plain numbers: op drie mei, het is vandaag drie mei. Ordinals: eerste, tweede, derde, vierde, ... twintigste.\n\ntoen = when for one event in the past (German als): Toen ik twintig was, ... als = when/whenever/if in the present or future (German wenn): Als ik jarig ben, bak ik een taart.\n\nIk ben jarig = it's my birthday.",
                     "التواريخ بالأرقام العادية: op drie mei، het is vandaag drie mei. والترتيبية: eerste، tweede، derde، vierde، ... twintigste.\n\ntoen = لما لحدث واحد في الماضي (als الألمانية): Toen ik twintig was, ... وals = لما/كل ما/لو في الحاضر أو المستقبل (wenn الألمانية): Als ik jarig ben, bak ik een taart.\n\nIk ben jarig = النهاردة عيد ميلادي."),
                    [("___ ik twintig was, ...", "Toen", "toen / als"), ("___ ik jarig ben, bak ik een taart.", "Als", "toen / als"),
                     ("Dit is mijn ___ bruiloft. (1st)", "eerste", "een"), ("We hebben een groot feest ___. (vieren)", "gevierd", "vieren")]),
            "es": G(("Dates, ordinals and cuando with two pasts", "التواريخ والترتيبي وcuando مع الماضيين"),
                    ("Dates use cardinal numbers: el tres de mayo (only el primero de ... is sometimes ordinal). Ordinals: primero, segundo, tercero, cuarto, quinto (primer, tercer before a masculine noun).\n\ncuando + imperfecto for the background, indefinido for the event: Cuando tenía veinte años, celebramos una fiesta.\n\nFelicidades / ¡Enhorabuena! = congratulations.",
                     "التواريخ بالأرقام العادية: el tres de mayo (بس el primero de ... أحيانًا ترتيبي). الترتيبي: primero، segundo، tercero، cuarto، quinto (primer وtercer قبل اسم مذكر).\n\ncuando + imperfecto للخلفية، وindefinido للحدث: Cuando tenía veinte años, celebramos una fiesta.\n\nFelicidades / ¡Enhorabuena! = مبروك."),
                    [("Mi cumpleaños es el ___ de mayo. (3)", "tres", "tres"), ("Cuando ___ veinte años, ... (tener, background)", "tenía", "tener"),
                     ("Es mi ___ boda. (1st, fem.)", "primera", "primero"), ("Los invitados ___ regalos. (traer)", "traen", "traer")]),
        },
    },
]
