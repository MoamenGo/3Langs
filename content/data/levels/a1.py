"""A1 units 5-11 (units 1-4 are in content/data/starter/). Unit 12 is the
review and mock exam, built automatically.

words:     concept | pos | English | Arabic | German | Dutch | Spanish
           (nouns with article; ", plural" after the noun when useful)
sentences: English | Arabic | German | Dutch | Spanish
"""

UNITS = [
    {
        "key": "u05",
        "write_en": "what you buy every week and how much it costs",
        "write_ar": "إيه اللي بتشتريه كل أسبوع وبكام",
        "words": """
shop | n | shop | محل | das Geschäft, Geschäfte | de winkel, winkels | la tienda, tiendas
supermarket | n | supermarket | سوبر ماركت | der Supermarkt, Supermärkte | de supermarkt, supermarkten | el supermercado, supermercados
money | n | money | فلوس | das Geld | het geld | el dinero
price | n | price | سعر | der Preis, Preise | de prijs, prijzen | el precio, precios
euro | n | euro | يورو | der Euro, Euro | de euro, euro's | el euro, euros
cheap_a1 | adj | cheap | رخيص | billig | goedkoop | barato
buy | v | to buy | يشتري | kaufen | kopen | comprar
pay | v | to pay | يدفع | bezahlen | betalen | pagar
cost | v | to cost | يكلّف، تمنه | kosten | kosten | costar
how_much | phr | how much | بكام، قد إيه | wie viel | hoeveel | cuánto
shirt | n | shirt | قميص | das Hemd, Hemden | het overhemd, overhemden | la camisa, camisas
bag | n | bag | شنطة | die Tasche, Taschen | de tas, tassen | la bolsa, bolsas
""",
        "sentences": """
How much does the bread cost? | العيش بكام؟ | Wie viel kostet das Brot? | Hoeveel kost het brood? | ¿Cuánto cuesta el pan?
The shirt costs twenty euros. | القميص بعشرين يورو. | Das Hemd kostet zwanzig Euro. | Het overhemd kost twintig euro. | La camisa cuesta veinte euros.
I don't have any money. | معييش فلوس. | Ich habe kein Geld. | Ik heb geen geld. | No tengo dinero.
Can I pay by card? | ينفع أدفع بالكارت؟ | Kann ich mit Karte bezahlen? | Kan ik met de kaart betalen? | ¿Puedo pagar con tarjeta?
""",
        "grammar": {
            "de": {
                "title": ("kein or nicht?", "kein ولا nicht؟"),
                "text": (
                    "kein negates a noun that would have ein or no article: Ich habe kein Geld. Das ist keine Tasche. It takes the same endings as ein (kein, keine, keinen).\n\nnicht negates everything else: verbs, adjectives, nouns with der/die/das, names: Das Hemd ist nicht billig. Ich kaufe das Brot nicht.\n\nnicht usually goes at the end of the sentence, or before the word it negates.",
                    "kein بتنفي اسم كان هيبقى معاه ein أو من غير أداة: Ich habe kein Geld (معييش فلوس). Das ist keine Tasche. وبتاخد نفس نهايات ein (kein, keine, keinen).\n\nnicht بتنفي أي حاجة تانية: الأفعال، الصفات، الأسماء اللي معاها der/die/das، والأسماء: Das Hemd ist nicht billig. Ich kaufe das Brot nicht.\n\nnicht غالبًا بتيجي في آخر الجملة أو قبل الكلمة اللي بتنفيها.",
                ),
                "table": [["", "masc.", "fem.", "neut.", "plural"], ["nominative", "kein", "keine", "kein", "keine"], ["accusative", "keinen", "keine", "kein", "keine"]],
                "exercises": [
                    ("Ich habe ___ Geld.", "kein", "kein / nicht"),
                    ("Das Hemd ist ___ teuer.", "nicht", "kein / nicht"),
                    ("Er kauft ___ Tasche.", "keine", "kein"),
                    ("Wir haben ___ Supermarkt hier.", "keinen", "kein"),
                ],
            },
            "nl": {
                "title": ("geen or niet with prices and shopping", "geen ولا niet في الشرا"),
                "text": (
                    "Remember: geen replaces een or comes before a noun without an article: Ik heb geen geld. Dat is geen tas.\n\nniet negates the rest: Het overhemd is niet goedkoop. Ik koop het brood niet.\n\nPrices: twintig euro (no plural -s after a number), 2,50 = twee euro vijftig. Ask: Hoeveel kost ...? or Wat kost ...?",
                    "افتكر: geen بتيجي مكان een أو قبل اسم من غير أداة: Ik heb geen geld. Dat is geen tas.\n\nniet بتنفي الباقي: Het overhemd is niet goedkoop. Ik koop het brood niet.\n\nالأسعار: twintig euro (من غير ‎-s بعد الرقم)، و2,50 = twee euro vijftig. تسأل: Hoeveel kost ...? أو Wat kost ...?",
                ),
                "exercises": [
                    ("Ik heb ___ geld.", "geen", "geen / niet"),
                    ("Het overhemd is ___ duur.", "niet", "geen / niet"),
                    ("___ kost de tas?", "Hoeveel", "hoeveel"),
                    ("Dat is ___ supermarkt.", "geen", "geen / niet"),
                ],
            },
            "es": {
                "title": ("costar and numbers with prices", "costar والأرقام مع الأسعار"),
                "text": (
                    "costar changes o to ue when stressed: cuesta (one thing), cuestan (several): La camisa cuesta veinte euros. Las bolsas cuestan dos euros.\n\nAsk: ¿Cuánto cuesta? / ¿Cuánto cuestan? cuánto agrees with the noun: ¿Cuánto dinero? ¿Cuántas bolsas?\n\nNegation is simple: put no before the verb: No tengo dinero. No es barato.",
                    "costar الـ o بتبقى ue: cuesta (لحاجة واحدة) وcuestan (لكذا حاجة): La camisa cuesta veinte euros. Las bolsas cuestan dos euros.\n\nتسأل: ¿Cuánto cuesta? / ¿Cuánto cuestan? وcuánto بتتغير مع الاسم: ¿Cuánto dinero? ¿Cuántas bolsas?\n\nالنفي سهل: حط no قبل الفعل: No tengo dinero. No es barato.",
                ),
                "exercises": [
                    ("La camisa ___ veinte euros.", "cuesta", "costar"),
                    ("Las bolsas ___ dos euros.", "cuestan", "costar"),
                    ("¿___ bolsas quieres?", "Cuántas", "cuánto"),
                    ("Yo ___ tengo dinero.", "no", "no"),
                ],
            },
        },
    },
    {
        "key": "u06",
        "write_en": "your typical day from morning to evening",
        "write_ar": "يومك العادي من الصبح لبالليل",
        "words": """
get_up | v | to get up | يصحى، يقوم | aufstehen | opstaan | levantarse
sleep | v | to sleep | ينام | schlafen | slapen | dormir
work | v | to work | يشتغل | arbeiten | werken | trabajar
morning | n | morning | الصبح | der Morgen, Morgen | de ochtend, ochtenden | la mañana, mañanas
evening | n | evening | المسا، بالليل | der Abend, Abende | de avond, avonden | la noche, noches
hour | n | hour | ساعة | die Stunde, Stunden | het uur, uren | la hora, horas
clock_time | n | clock; o'clock | ساعة (الوقت) | die Uhr, Uhren | de klok, klokken | el reloj, relojes
always | adv | always | دايمًا | immer | altijd | siempre
often | adv | often | كتير، غالبًا | oft | vaak | a menudo
today | adv | today | النهاردة | heute | vandaag | hoy
tomorrow | adv | tomorrow | بكرة | morgen | morgen | mañana
late | adj | late | متأخر | spät | laat | tarde
""",
        "sentences": """
I get up at seven o'clock. | بصحى الساعة سبعة. | Ich stehe um sieben Uhr auf. | Ik sta om zeven uur op. | Me levanto a las siete.
What time is it? | الساعة كام؟ | Wie spät ist es? | Hoe laat is het? | ¿Qué hora es?
Today I work until five. | النهاردة هشتغل لحد خمسة. | Heute arbeite ich bis fünf. | Vandaag werk ik tot vijf uur. | Hoy trabajo hasta las cinco.
In the evening I often sleep late. | بالليل غالبًا بنام متأخر. | Am Abend schlafe ich oft spät. | 's Avonds slaap ik vaak laat. | Por la noche a menudo duermo tarde.
""",
        "grammar": {
            "de": {
                "title": ("Separable verbs and verb second", "الأفعال اللي بتنفصل والفعل في المكان التاني"),
                "text": (
                    "Some verbs have a prefix that splits off: aufstehen → Ich stehe um sieben Uhr auf. The verb goes in position 2, the prefix goes to the very end.\n\nThe verb is always the second element in a statement, even when the sentence starts with a time: Heute arbeite ich bis fünf. (not: Heute ich arbeite).\n\nTime: um sieben Uhr = at seven o'clock; Wie spät ist es? = What time is it?",
                    "فيه أفعال ليها بادئة بتنفصل: aufstehen ← Ich stehe um sieben Uhr auf. الفعل في المكان التاني والبادئة في آخر الجملة خالص.\n\nالفعل دايمًا العنصر التاني في الجملة الخبرية، حتى لو الجملة بدأت بوقت: Heute arbeite ich bis fünf (مش Heute ich arbeite).\n\nالوقت: um sieben Uhr = الساعة سبعة؛ Wie spät ist es? = الساعة كام؟",
                ),
                "exercises": [
                    ("Ich ___ um sieben Uhr auf.", "stehe", "aufstehen"),
                    ("Er steht um sechs Uhr ___.", "auf", "aufstehen"),
                    ("Heute ___ ich bis fünf.", "arbeite", "arbeiten"),
                    ("Am Abend ___ er oft spät.", "schläft", "schlafen"),
                ],
            },
            "nl": {
                "title": ("Separable verbs and inversion", "الأفعال اللي بتنفصل وتقديم الفعل"),
                "text": (
                    "Like German, Dutch has separable verbs: opstaan → Ik sta om zeven uur op. The prefix goes to the end.\n\nThe verb comes second; if you start with a time, the subject moves after the verb: Vandaag werk ik tot vijf uur.\n\nTime: om zeven uur = at seven; Hoe laat is het? = What time is it? Watch out: half acht means 7:30 (half to eight), as in German halb acht.",
                    "زي الألماني، الهولندي فيه أفعال بتنفصل: opstaan ← Ik sta om zeven uur op. البادئة بتروح للآخر.\n\nالفعل في المكان التاني؛ لو بدأت بوقت، الفاعل ييجي بعد الفعل: Vandaag werk ik tot vijf uur.\n\nالوقت: om zeven uur = الساعة سبعة؛ Hoe laat is het? = الساعة كام؟ خلي بالك: half acht يعني سبعة ونص (نص قبل تمانية)، زي halb acht في الألماني.",
                ),
                "exercises": [
                    ("Ik ___ om zeven uur op.", "sta", "opstaan"),
                    ("Hij staat om zes uur ___.", "op", "opstaan"),
                    ("Vandaag ___ ik tot vijf uur.", "werk", "werken"),
                    ("'s Avonds ___ zij vaak laat.", "slaapt", "slapen"),
                ],
            },
            "es": {
                "title": ("Reflexive verbs and telling the time", "الأفعال الانعكاسية ومعرفة الوقت"),
                "text": (
                    "levantarse (to get up) is reflexive: me levanto, te levantas, se levanta, nos levantamos, os levantáis, se levantan.\n\ndormir changes o to ue: duermo, duermes, duerme, dormimos, dormís, duermen.\n\nTime: ¿Qué hora es? – Es la una. Son las siete. At seven = a las siete. Note: mañana means both morning (la mañana) and tomorrow (mañana).",
                    "levantarse (يصحى) فعل انعكاسي: me levanto, te levantas, se levanta, nos levantamos, os levantáis, se levantan.\n\ndormir الـ o بتبقى ue: duermo, duermes, duerme, dormimos, dormís, duermen.\n\nالوقت: ¿Qué hora es? – Es la una. Son las siete. الساعة سبعة (في) = a las siete. خلي بالك: mañana معناها الصبح (la mañana) وبكرة (mañana).",
                ),
                "exercises": [
                    ("Yo ___ levanto a las siete.", "me", "levantarse"),
                    ("Ella ___ hasta las nueve.", "duerme", "dormir"),
                    ("Nosotros ___ levantamos tarde.", "nos", "levantarse"),
                    ("___ las cinco.", "Son", "ser"),
                ],
            },
        },
    },
    {
        "key": "u07",
        "write_en": "what you like to do in your free time",
        "write_ar": "بتحب تعمل إيه في وقت فراغك",
        "words": """
play | v | to play | يلعب | spielen | spelen | jugar
read | v | to read | يقرا | lesen | lezen | leer
swim | v | to swim | يعوم | schwimmen | zwemmen | nadar
cook | v | to cook | يطبخ | kochen | koken | cocinar
music | n | music | مزيكا | die Musik | de muziek | la música
football | n | football | كورة | der Fußball | het voetbal | el fútbol
book | n | book | كتاب | das Buch, Bücher | het boek, boeken | el libro, libros
film | n | film | فيلم | der Film, Filme | de film, films | la película, películas
friend | n | friend | صاحب | der Freund, Freunde | de vriend, vrienden | el amigo, amigos
weekend | n | weekend | الويك إند | das Wochenende, Wochenenden | het weekend, weekenden | el fin de semana, fines de semana
can | v | can, to be able to | يقدر | können | kunnen | poder
gladly | adv | gladly (like to) | بحب، بكل سرور | gern | graag | con gusto
""",
        "sentences": """
I like to read books. | بحب أقرا كتب. | Ich lese gern Bücher. | Ik lees graag boeken. | Me gusta leer libros.
Can you swim? | تعرف تعوم؟ | Kannst du schwimmen? | Kun jij zwemmen? | ¿Sabes nadar?
At the weekend I play football with friends. | في الويك إند بلعب كورة مع أصحابي. | Am Wochenende spiele ich mit Freunden Fußball. | In het weekend speel ik voetbal met vrienden. | El fin de semana juego al fútbol con amigos.
We want to see a film. | عايزين نشوف فيلم. | Wir wollen einen Film sehen. | We willen een film zien. | Queremos ver una película.
""",
        "grammar": {
            "de": {
                "title": ("gern and the modal verbs können, wollen", "gern والأفعال können وwollen"),
                "text": (
                    "To say you like doing something, add gern after the verb: Ich lese gern. Ich spiele gern Fußball. Not liking it: nicht gern.\n\nModal verbs push the main verb to the end in the infinitive: Ich kann schwimmen. Wir wollen einen Film sehen.\n\nkönnen: ich kann, du kannst, er kann, wir können, ihr könnt, sie können. wollen: ich will, du willst, er will, wir wollen, ihr wollt, sie wollen.",
                    "عشان تقول بتحب تعمل حاجة، زوّد gern بعد الفعل: Ich lese gern (بحب أقرا). Ich spiele gern Fußball. ومش بتحب: nicht gern.\n\nأفعال الوجه بتزق الفعل الأساسي لآخر الجملة في المصدر: Ich kann schwimmen. Wir wollen einen Film sehen.\n\nkönnen: ich kann, du kannst, er kann, wir können, ihr könnt, sie können. وwollen: ich will, du willst, er will, wir wollen, ihr wollt, sie wollen.",
                ),
                "table": [["", "können", "wollen"], ["ich", "kann", "will"], ["du", "kannst", "willst"], ["er/sie/es", "kann", "will"], ["wir", "können", "wollen"], ["ihr", "könnt", "wollt"], ["sie/Sie", "können", "wollen"]],
                "exercises": [
                    ("Ich lese ___ Bücher.", "gern", "gern"),
                    ("___ du schwimmen?", "Kannst", "können"),
                    ("Wir ___ einen Film sehen.", "wollen", "wollen"),
                    ("Er ___ gut kochen.", "kann", "können"),
                ],
            },
            "nl": {
                "title": ("graag and the modal verbs kunnen, willen", "graag والأفعال kunnen وwillen"),
                "text": (
                    "graag after the verb means you like doing it: Ik lees graag. Ik speel graag voetbal. Not: niet graag.\n\nModal verbs send the main verb to the end: Ik kan zwemmen. We willen een film zien.\n\nkunnen: ik kan, jij kunt (kun jij?), hij kan, wij kunnen. willen: ik wil, jij wilt (wil jij?), hij wil, wij willen.",
                    "graag بعد الفعل معناها إنك بتحب تعمله: Ik lees graag. Ik speel graag voetbal. ومش بتحب: niet graag.\n\nأفعال الوجه بتبعت الفعل الأساسي للآخر: Ik kan zwemmen. We willen een film zien.\n\nkunnen: ik kan, jij kunt (kun jij?), hij kan, wij kunnen. وwillen: ik wil, jij wilt (wil jij?), hij wil, wij willen.",
                ),
                "exercises": [
                    ("Ik lees ___ boeken.", "graag", "graag"),
                    ("___ jij zwemmen?", "Kun", "kunnen"),
                    ("Wij ___ een film zien.", "willen", "willen"),
                    ("Hij ___ goed koken.", "kan", "kunnen"),
                ],
            },
            "es": {
                "title": ("gustar, poder and saber", "gustar وpoder وsaber"),
                "text": (
                    "gustar works backwards: the thing you like is the subject. Me gusta leer. Me gusta la música. Me gustan los libros (plural → gustan).\n\npoder (o → ue) = can, be allowed: puedo, puedes, puede, podemos, podéis, pueden. For a learned skill Spanish uses saber: ¿Sabes nadar? = Can you swim?\n\njugar (u → ue) takes a: juego al fútbol.",
                    "gustar بتشتغل بالعكس: الحاجة اللي بتحبها هي الفاعل. Me gusta leer. Me gusta la música. Me gustan los libros (جمع ← gustan).\n\npoder (o ← ue) = يقدر أو مسموح له: puedo, puedes, puede, podemos, podéis, pueden. وللمهارة اللي اتعلمتها الإسباني بيستخدم saber: ¿Sabes nadar? = تعرف تعوم؟\n\njugar (u ← ue) بتاخد a: juego al fútbol.",
                ),
                "exercises": [
                    ("Me ___ la música.", "gusta", "gustar"),
                    ("Me ___ los libros.", "gustan", "gustar"),
                    ("¿___ nadar? (tú)", "Sabes", "saber"),
                    ("Yo ___ al fútbol.", "juego", "jugar"),
                ],
            },
        },
    },
    {
        "key": "u08",
        "write_en": "the way from your home to a place you like in your city",
        "write_ar": "الطريق من بيتك لمكان بتحبه في مدينتك",
        "words": """
street | n | street | شارع | die Straße, Straßen | de straat, straten | la calle, calles
station | n | station | محطة | der Bahnhof, Bahnhöfe | het station, stations | la estación, estaciones
bank | n | bank | بنك | die Bank, Banken | de bank, banken | el banco, bancos
pharmacy | n | pharmacy | صيدلية | die Apotheke, Apotheken | de apotheek, apotheken | la farmacia, farmacias
museum | n | museum | متحف | das Museum, Museen | het museum, musea | el museo, museos
park | n | park | جنينة، حديقة | der Park, Parks | het park, parken | el parque, parques
left | adv | left | شمال | links | links | a la izquierda
right_dir | adv | right | يمين | rechts | rechts | a la derecha
straight_on | adv | straight on | على طول | geradeaus | rechtdoor | todo recto
near | adj | near | قريب | nah | dichtbij | cerca
far | adj | far | بعيد | weit | ver | lejos
where | adv | where | فين | wo | waar | dónde
""",
        "sentences": """
Excuse me, where is the station? | لو سمحت، المحطة فين؟ | Entschuldigung, wo ist der Bahnhof? | Pardon, waar is het station? | Perdone, ¿dónde está la estación?
Go straight on and then left. | امشي على طول وبعدين شمال. | Gehen Sie geradeaus und dann links. | Ga rechtdoor en dan links. | Siga todo recto y luego a la izquierda.
The pharmacy is next to the bank. | الصيدلية جنب البنك. | Die Apotheke ist neben der Bank. | De apotheek is naast de bank. | La farmacia está al lado del banco.
Is the museum far? No, it is near. | المتحف بعيد؟ لأ، قريب. | Ist das Museum weit? Nein, es ist nah. | Is het museum ver? Nee, het is dichtbij. | ¿Está lejos el museo? No, está cerca.
""",
        "grammar": {
            "de": {
                "title": ("The imperative and in, an, bei + dative", "الأمر وin وan وbei مع الداتيف"),
                "text": (
                    "Imperative: polite form = verb + Sie: Gehen Sie geradeaus! Informal (du) = verb stem: Geh! Nimm den Bus!\n\nAfter in, an, bei, neben (answering wo?) the noun is in the dative: der/das → dem, die → der. Ich bin im Park (in + dem). Die Apotheke ist neben der Bank. Ich wohne bei meinem Bruder.",
                    "الأمر: الصيغة الرسمية = الفعل + Sie: Gehen Sie geradeaus! والعادية (du) = جذر الفعل: Geh! Nimm den Bus!\n\nبعد in وan وbei وneben (لما بتجاوب على wo؟ فين) الاسم بيبقى داتيف: der/das ← dem، وdie ← der. Ich bin im Park (in + dem). Die Apotheke ist neben der Bank. Ich wohne bei meinem Bruder.",
                ),
                "table": [["", "masc.", "fem.", "neut.", "plural"], ["dative", "dem", "der", "dem", "den (+n)"]],
                "exercises": [
                    ("___ Sie geradeaus! (gehen)", "Gehen", "gehen"),
                    ("Die Apotheke ist neben ___ Bank.", "der", "die"),
                    ("Ich bin ___ Park.", "im", "in + dem"),
                    ("Wo ___ der Bahnhof?", "ist", "sein"),
                ],
            },
            "nl": {
                "title": ("The imperative and asking the way", "الأمر والسؤال عن الطريق"),
                "text": (
                    "The Dutch imperative is just the stem: Ga rechtdoor! Neem de bus! Kom hier! For politeness add u after it (Gaat u rechtdoor) or add maar / even: Kijk even.\n\nDutch has no cases: prepositions don't change the article: naast de bank, in het park, bij het station.\n\nTo ask: Waar is ...? Hoe kom ik bij ...? (How do I get to ...?)",
                    "الأمر في الهولندي هو الجذر بس: Ga rechtdoor! Neem de bus! Kom hier! ولو عايز تبقى مؤدب زوّد u بعده (Gaat u rechtdoor) أو maar / even: Kijk even.\n\nالهولندي مفيهوش حالات إعرابية: حروف الجر مش بتغير الأداة: naast de bank، in het park، bij het station.\n\nتسأل: Waar is ...? وHoe kom ik bij ...? (أروح ... إزاي؟)",
                ),
                "exercises": [
                    ("___ rechtdoor! (gaan)", "Ga", "gaan"),
                    ("De apotheek is ___ de bank. (next to)", "naast", "naast"),
                    ("___ is het station?", "Waar", "waar"),
                    ("___ de bus! (nemen)", "Neem", "nemen"),
                ],
            },
            "es": {
                "title": ("estar for location and the polite imperative", "estar للمكان والأمر المؤدب"),
                "text": (
                    "For where something is, Spanish uses estar, not ser: ¿Dónde está la estación? El museo está cerca.\n\nPolite (usted) imperative: -ar verbs take -e, -er/-ir verbs take -a: tomar → tome, seguir → siga, girar → gire. Informal (tú): toma, sigue, gira.\n\nde + el = del, a + el = al: al lado del banco.",
                    "عشان تقول الحاجة فين، الإسباني بيستخدم estar مش ser: ¿Dónde está la estación? El museo está cerca.\n\nالأمر المؤدب (usted): أفعال ‎-ar بتاخد ‎-e، وأفعال ‎-er/-ir بتاخد ‎-a: tomar ← tome، seguir ← siga، girar ← gire. والعادي (tú): toma، sigue، gira.\n\nde + el = del، وa + el = al: al lado del banco.",
                ),
                "exercises": [
                    ("¿Dónde ___ la farmacia?", "está", "estar"),
                    ("___ todo recto. (usted, seguir)", "Siga", "seguir"),
                    ("La farmacia está al lado ___ banco.", "del", "de + el"),
                    ("El museo ___ lejos.", "está", "estar"),
                ],
            },
        },
    },
    {
        "key": "u09",
        "write_en": "a trip you took: where, how and with whom",
        "write_ar": "رحلة عملتها: فين وإزاي ومع مين",
        "words": """
train | n | train | قطر | der Zug, Züge | de trein, treinen | el tren, trenes
bus | n | bus | أتوبيس | der Bus, Busse | de bus, bussen | el autobús, autobuses
car | n | car | عربية | das Auto, Autos | de auto, auto's | el coche, coches
plane | n | plane | طيارة | das Flugzeug, Flugzeuge | het vliegtuig, vliegtuigen | el avión, aviones
ticket | n | ticket | تذكرة | die Fahrkarte, Fahrkarten | het kaartje, kaartjes | el billete, billetes
suitcase | n | suitcase | شنطة سفر | der Koffer, Koffer | de koffer, koffers | la maleta, maletas
travel | v | to travel | يسافر | reisen | reizen | viajar
drive | v | to drive; to go (by vehicle) | يسوق؛ يروح بمواصلة | fahren | rijden | conducir
fly | v | to fly | يطير، يسافر بالطيارة | fliegen | vliegen | volar
must | v | must, to have to | لازم | müssen | moeten | tener que
departure | n | departure | قيام، مغادرة | die Abfahrt, Abfahrten | het vertrek | la salida, salidas
holiday | n | holiday, vacation | إجازة | der Urlaub, Urlaube | de vakantie, vakanties | las vacaciones
""",
        "sentences": """
I go to work by train. | بروح الشغل بالقطر. | Ich fahre mit dem Zug zur Arbeit. | Ik ga met de trein naar mijn werk. | Voy al trabajo en tren.
We have to buy a ticket. | لازم نشتري تذكرة. | Wir müssen eine Fahrkarte kaufen. | We moeten een kaartje kopen. | Tenemos que comprar un billete.
When does the bus leave? | الأتوبيس بيقوم إمتى؟ | Wann fährt der Bus ab? | Wanneer vertrekt de bus? | ¿Cuándo sale el autobús?
In the holidays we fly to Spain. | في الإجازة هنسافر إسبانيا بالطيارة. | Im Urlaub fliegen wir nach Spanien. | In de vakantie vliegen we naar Spanje. | En vacaciones volamos a España.
""",
        "grammar": {
            "de": {
                "title": ("müssen, dürfen and mit + dative", "müssen وdürfen وmit مع الداتيف"),
                "text": (
                    "müssen (must): ich muss, du musst, er muss, wir müssen, ihr müsst, sie müssen. dürfen (may): ich darf, du darfst, er darf, wir dürfen. Hier darf man nicht rauchen = smoking is not allowed here.\n\nmit always takes the dative: mit dem Zug, mit der Bahn, mit dem Auto. Going by vehicle is fahren (ich fahre, du fährst, er fährt).",
                    "müssen (لازم): ich muss, du musst, er muss, wir müssen, ihr müsst, sie müssen. وdürfen (مسموح): ich darf, du darfst, er darf, wir dürfen. Hier darf man nicht rauchen = ممنوع التدخين هنا.\n\nmit دايمًا بتاخد داتيف: mit dem Zug، mit der Bahn، mit dem Auto. والسفر بمواصلة اسمه fahren (ich fahre, du fährst, er fährt).",
                ),
                "exercises": [
                    ("Wir ___ eine Fahrkarte kaufen.", "müssen", "müssen"),
                    ("Ich fahre mit ___ Zug.", "dem", "der"),
                    ("Hier ___ man nicht rauchen.", "darf", "dürfen"),
                    ("Er ___ mit dem Auto. (fahren)", "fährt", "fahren"),
                ],
            },
            "nl": {
                "title": ("moeten, mogen and travelling met", "moeten وmogen والسفر بـ met"),
                "text": (
                    "moeten (must): ik moet, jij moet, hij moet, wij moeten. mogen (may): ik mag, jij mag, hij mag, wij mogen. Hier mag je niet roken.\n\nBy train/bus = met de trein / met de bus. Dutch splits German fahren: rijden for driving (Ik rijd naar Utrecht), gaan for going in general (Ik ga met de trein).\n\nFalse friend: Dutch rijden is not reiten (to ride a horse) only; it is any driving.",
                    "moeten (لازم): ik moet, jij moet, hij moet, wij moeten. وmogen (مسموح): ik mag, jij mag, hij mag, wij mogen. Hier mag je niet roken.\n\nبالقطر/بالأتوبيس = met de trein / met de bus. الهولندي بيقسم fahren الألماني: rijden للسواقة (Ik rijd naar Utrecht)، وgaan للروحان عمومًا (Ik ga met de trein).\n\nخلي بالك: rijden في الهولندي مش ركوب الخيل بس زي reiten؛ دي أي سواقة.",
                ),
                "exercises": [
                    ("We ___ een kaartje kopen.", "moeten", "moeten"),
                    ("Ik ga ___ de trein.", "met", "met"),
                    ("Hier ___ je niet roken.", "mag", "mogen"),
                    ("Hij ___ naar Utrecht. (drive)", "rijdt", "rijden"),
                ],
            },
            "es": {
                "title": ("tener que, salir and transport with en", "tener que وsalir والمواصلات بـ en"),
                "text": (
                    "Must = tener que + infinitive: Tengo que trabajar. Tenemos que comprar un billete.\n\nTransport uses en: en tren, en autobús, en coche, en avión (but a pie = on foot).\n\nsalir (to leave) has yo salgo; ¿Cuándo sale el tren? volar changes o → ue: vuelo, vuelas, vuela, volamos.",
                    "لازم = tener que + مصدر: Tengo que trabajar. Tenemos que comprar un billete.\n\nالمواصلات بـ en: en tren، en autobús، en coche، en avión (بس a pie = ماشي على رجلك).\n\nsalir (يقوم/يخرج) ليها yo salgo؛ ¿Cuándo sale el tren? وvolar الـ o بتبقى ue: vuelo, vuelas, vuela, volamos.",
                ),
                "exercises": [
                    ("Tenemos ___ comprar un billete.", "que", "tener que"),
                    ("Voy al trabajo ___ tren.", "en", "en"),
                    ("¿Cuándo ___ el autobús?", "sale", "salir"),
                    ("Yo ___ a Madrid. (volar)", "vuelo", "volar"),
                ],
            },
        },
    },
    {
        "key": "u10",
        "write_en": "a time you were ill and what you did",
        "write_ar": "مرة كنت عيان وعملت إيه",
        "words": """
head | n | head | راس | der Kopf, Köpfe | het hoofd, hoofden | la cabeza, cabezas
belly | n | belly, stomach | بطن | der Bauch, Bäuche | de buik, buiken | la barriga, barrigas
arm | n | arm | دراع | der Arm, Arme | de arm, armen | el brazo, brazos
leg | n | leg | رجل | das Bein, Beine | het been, benen | la pierna, piernas
doctor | n | doctor | دكتور | der Arzt, Ärzte | de dokter, dokters | el médico, médicos
medicine | n | medicine | دوا | das Medikament, Medikamente | het medicijn, medicijnen | el medicamento, medicamentos
ill | adj | ill, sick | عيان | krank | ziek | enfermo
healthy | adj | healthy | صحي، بصحة كويسة | gesund | gezond | sano
hurt | v | to hurt | يوجع | wehtun | pijn doen | doler
pain | n | pain | وجع | der Schmerz, Schmerzen | de pijn | el dolor, dolores
fever | n | fever | سخونية، حرارة | das Fieber | de koorts | la fiebre
should | v | should, to be supposed to | المفروض | sollen | moeten | deber
""",
        "sentences": """
My head hurts. | راسي بتوجعني. | Mein Kopf tut weh. | Mijn hoofd doet pijn. | Me duele la cabeza.
I am ill and have a fever. | أنا عيان وعندي سخونية. | Ich bin krank und habe Fieber. | Ik ben ziek en heb koorts. | Estoy enfermo y tengo fiebre.
You should go to the doctor. | المفروض تروح للدكتور. | Du sollst zum Arzt gehen. | Je moet naar de dokter gaan. | Debes ir al médico.
Take this medicine three times a day. | خد الدوا ده تلات مرات في اليوم. | Nehmen Sie das Medikament dreimal am Tag. | Neem dit medicijn drie keer per dag. | Tome este medicamento tres veces al día.
""",
        "grammar": {
            "de": {
                "title": ("sollen and pronouns in the accusative", "sollen والضمائر في الأكوزاتيف"),
                "text": (
                    "sollen passes on advice or an instruction from someone else: Du sollst zum Arzt gehen (the doctor says so). ich soll, du sollst, er soll, wir sollen.\n\nPersonal pronouns in the accusative: mich, dich, ihn, sie, es, uns, euch, sie/Sie. Der Arzt untersucht mich.\n\nPain: Mein Kopf tut weh. Ich habe Kopfschmerzen / Bauchschmerzen.",
                    "sollen بتنقل نصيحة أو تعليمات من حد تاني: Du sollst zum Arzt gehen (الدكتور قال كده). ich soll, du sollst, er soll, wir sollen.\n\nالضمائر في الأكوزاتيف: mich, dich, ihn, sie, es, uns, euch, sie/Sie. Der Arzt untersucht mich (الدكتور بيكشف عليّا).\n\nالوجع: Mein Kopf tut weh. Ich habe Kopfschmerzen / Bauchschmerzen.",
                ),
                "table": [["nominative", "ich", "du", "er", "sie", "es", "wir", "ihr", "sie/Sie"], ["accusative", "mich", "dich", "ihn", "sie", "es", "uns", "euch", "sie/Sie"]],
                "exercises": [
                    ("Du ___ zum Arzt gehen.", "sollst", "sollen"),
                    ("Der Arzt untersucht ___. (ich)", "mich", "ich"),
                    ("Mein Kopf tut ___.", "weh", "wehtun"),
                    ("Ich sehe ___ morgen. (er)", "ihn", "er"),
                ],
            },
            "nl": {
                "title": ("Pain, moeten for advice, object pronouns", "الوجع وmoeten للنصيحة وضماير المفعول"),
                "text": (
                    "Pain: Mijn hoofd doet pijn. Ik heb hoofdpijn / buikpijn.\n\nDutch has no sollen: use moeten for advice (Je moet naar de dokter gaan) or zou moeten for softer advice (Je zou moeten rusten).\n\nObject pronouns: mij (me), jou (je), hem, haar, ons, jullie, hen/hun (them). De dokter onderzoekt mij.",
                    "الوجع: Mijn hoofd doet pijn. Ik heb hoofdpijn / buikpijn.\n\nالهولندي مفيهوش sollen: استخدم moeten للنصيحة (Je moet naar de dokter gaan) أو zou moeten لنصيحة أخف (Je zou moeten rusten).\n\nضماير المفعول: mij (me)، jou (je)، hem، haar، ons، jullie، hen/hun. De dokter onderzoekt mij.",
                ),
                "exercises": [
                    ("Mijn hoofd doet ___.", "pijn", "pijn doen"),
                    ("Je ___ naar de dokter gaan.", "moet", "moeten"),
                    ("De dokter onderzoekt ___. (ik)", "mij", "ik"),
                    ("Ik zie ___ morgen. (hij)", "hem", "hij"),
                ],
            },
            "es": {
                "title": ("doler, estar enfermo and deber", "doler وestar enfermo وdeber"),
                "text": (
                    "doler works like gustar: Me duele la cabeza (one thing), Me duelen las piernas (plural). Use the article, not a possessive: la cabeza, not mi cabeza.\n\nIllness is a state, so estar: Estoy enfermo/enferma. But tener for fever: Tengo fiebre.\n\ndeber + infinitive = should: Debes ir al médico.",
                    "doler بتشتغل زي gustar: Me duele la cabeza (حاجة واحدة)، Me duelen las piernas (جمع). استخدم الأداة مش الملكية: la cabeza مش mi cabeza.\n\nالعيا حالة، فبنستخدم estar: Estoy enfermo/enferma. بس الحرارة بـ tener: Tengo fiebre.\n\ndeber + مصدر = المفروض: Debes ir al médico.",
                ),
                "exercises": [
                    ("Me ___ la cabeza.", "duele", "doler"),
                    ("Me ___ las piernas.", "duelen", "doler"),
                    ("___ enfermo. (yo)", "Estoy", "estar"),
                    ("___ ir al médico. (tú)", "Debes", "deber"),
                ],
            },
        },
    },
    {
        "key": "u11",
        "write_en": "what you did last week at work or school",
        "write_ar": "عملت إيه الأسبوع اللي فات في الشغل أو المدرسة",
        "words": """
job | n | job, work | شغل | die Arbeit | het werk | el trabajo
office | n | office | مكتب | das Büro, Büros | het kantoor, kantoren | la oficina, oficinas
colleague | n | colleague | زميل | der Kollege, Kollegen | de collega, collega's | el compañero, compañeros
boss | n | boss | مدير | der Chef, Chefs | de baas, bazen | el jefe, jefes
school | n | school | مدرسة | die Schule, Schulen | de school, scholen | la escuela, escuelas
teacher | n | teacher | مدرس | der Lehrer, Lehrer | de leraar, leraren | el profesor, profesores
student | n | student | طالب | der Student, Studenten | de student, studenten | el estudiante, estudiantes
learn | v | to learn | يتعلّم | lernen | leren | aprender
write | v | to write | يكتب | schreiben | schrijven | escribir
make_do | v | to make, to do | يعمل | machen | maken | hacer
yesterday | adv | yesterday | امبارح | gestern | gisteren | ayer
why | adv | why | ليه | warum | waarom | por qué
""",
        "sentences": """
Yesterday I worked a lot. | امبارح اشتغلت كتير. | Gestern habe ich viel gearbeitet. | Gisteren heb ik veel gewerkt. | Ayer trabajé mucho.
My colleague has written an email. | زميلي كتب إيميل. | Mein Kollege hat eine E-Mail geschrieben. | Mijn collega heeft een e-mail geschreven. | Mi compañero ha escrito un correo.
Why are you learning Spanish? | بتتعلم إسباني ليه؟ | Warum lernst du Spanisch? | Waarom leer je Spaans? | ¿Por qué aprendes español?
What did you do at school? | عملت إيه في المدرسة؟ | Was hast du in der Schule gemacht? | Wat heb je op school gedaan? | ¿Qué has hecho en la escuela?
""",
        "grammar": {
            "de": {
                "title": ("Perfect tense with haben", "الماضي التام (Perfekt) مع haben"),
                "text": (
                    "Spoken German talks about the past with haben + past participle at the end: Ich habe viel gearbeitet.\n\nRegular verbs: ge- + stem + -t: machen → gemacht, lernen → gelernt, arbeiten → gearbeitet. Irregular verbs: ge- + stem + -en, often with a vowel change: schreiben → geschrieben, lesen → gelesen.\n\nQuestion words: wer, was, wo, wann, warum, wie.",
                    "الألماني في الكلام بيحكي عن الماضي بـ haben + اسم المفعول في آخر الجملة: Ich habe viel gearbeitet.\n\nالأفعال المنتظمة: ge- + الجذر + ‎-t: machen ← gemacht، lernen ← gelernt، arbeiten ← gearbeitet. والشاذة: ge- + الجذر + ‎-en وغالبًا الحرف المتحرك بيتغير: schreiben ← geschrieben، lesen ← gelesen.\n\nأدوات السؤال: wer (مين)، was (إيه)، wo (فين)، wann (إمتى)، warum (ليه)، wie (إزاي).",
                ),
                "exercises": [
                    ("Ich ___ viel gearbeitet.", "habe", "haben"),
                    ("Was hast du ___? (machen)", "gemacht", "machen"),
                    ("Er hat eine E-Mail ___. (schreiben)", "geschrieben", "schreiben"),
                    ("___ lernst du Spanisch? (why)", "Warum", "warum"),
                ],
            },
            "nl": {
                "title": ("Perfect tense with hebben", "الماضي التام مع hebben"),
                "text": (
                    "The Dutch perfect: hebben + past participle at the end: Ik heb veel gewerkt.\n\nRegular verbs: ge- + stem + -t or -d. Use -t if the stem ends in a sound from 't kofschip (t, k, f, s, ch, p): werken → gewerkt, maken → gemaakt; otherwise -d: leren → geleerd, wonen → gewoond. Irregular: schrijven → geschreven, doen → gedaan.\n\nCompare German: gearbeitet / gewerkt, gemacht / gemaakt.",
                    "الماضي التام في الهولندي: hebben + اسم المفعول في الآخر: Ik heb veel gewerkt.\n\nالأفعال المنتظمة: ge- + الجذر + ‎-t أو ‎-d. استخدم ‎-t لو الجذر بيخلص بحرف من 't kofschip (t, k, f, s, ch, p): werken ← gewerkt، maken ← gemaakt؛ وإلا ‎-d: leren ← geleerd، wonen ← gewoond. والشاذة: schrijven ← geschreven، doen ← gedaan.\n\nقارن بالألماني: gearbeitet / gewerkt، gemacht / gemaakt.",
                ),
                "exercises": [
                    ("Ik ___ veel gewerkt.", "heb", "hebben"),
                    ("Wat heb je ___? (doen)", "gedaan", "doen"),
                    ("Hij heeft een e-mail ___. (schrijven)", "geschreven", "schrijven"),
                    ("Wij hebben Nederlands ___. (leren)", "geleerd", "leren"),
                ],
            },
            "es": {
                "title": ("Two pasts: pretérito perfecto and indefinido", "ماضيين: pretérito perfecto وindefinido"),
                "text": (
                    "pretérito perfecto = haber + participle, for today, this week, life so far: He trabajado. Ha escrito un correo. (he, has, ha, hemos, habéis, han). Participles: -ar → -ado, -er/-ir → -ido; irregular: hecho (hacer), escrito (escribir).\n\nindefinido for finished times like ayer: trabajé, trabajaste, trabajó, trabajamos, trabajaron.\n\npor qué (why, two words) vs porque (because).",
                    "pretérito perfecto = haber + اسم المفعول، للنهاردة والأسبوع ده والحياة لحد دلوقتي: He trabajado. Ha escrito un correo. (he, has, ha, hemos, habéis, han). اسم المفعول: ‎-ar ← ‎-ado، و‎-er/-ir ← ‎-ido؛ والشاذ: hecho (hacer)، escrito (escribir).\n\nindefinido للوقت اللي خلص زي ayer (امبارح): trabajé, trabajaste, trabajó, trabajamos, trabajaron.\n\npor qué (ليه، كلمتين) غير porque (عشان).",
                ),
                "exercises": [
                    ("Mi compañero ___ escrito un correo.", "ha", "haber"),
                    ("¿Qué has ___? (hacer)", "hecho", "hacer"),
                    ("Ayer ___ mucho. (yo, trabajar)", "trabajé", "trabajar"),
                    ("¿___ aprendes español?", "Por qué", "por qué"),
                ],
            },
        },
    },
]
