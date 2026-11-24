"""C1: units 1-11 (unit 12 is the review and mock exam).

words:     concept | pos | English | Arabic | German | Dutch | Spanish
sentences: English | Arabic | German | Dutch | Spanish
"""

CAN_DO = [
    {"en": "Understand long, demanding texts and recognise implicit meaning", "ar": "تفهم نصوص طويلة وصعبة وتلقط المعنى اللي بين السطور"},
    {"en": "Express yourself fluently without obviously searching for words", "ar": "تعبّر عن نفسك بطلاقة من غير ما تبان بتدوّر على الكلام"},
    {"en": "Use language flexibly for social, academic and professional purposes", "ar": "تستخدم اللغة بمرونة في الحياة الاجتماعية والدراسة والشغل"},
]


def G(title, text, exercises, table=None):
    g = {"title": title, "text": text, "exercises": exercises}
    if table:
        g["table"] = table
    return g


UNITS = [
    {
        "key": "u01", "write_en": "a short abstract of a study you find interesting", "write_ar": "ملخص قصير لدراسة شايفها مهمة",
        "words": """
thesis | n | thesis | رسالة علمية | die Abschlussarbeit, Abschlussarbeiten | de scriptie, scripties | la tesis, tesis
analysis | n | analysis | تحليل | die Analyse, Analysen | de analyse, analyses | el análisis, análisis
lecture | n | lecture | محاضرة | die Vorlesung, Vorlesungen | het college, colleges | la clase magistral, clases magistrales
hypothesis | n | hypothesis | فرضية | die Hypothese, Hypothesen | de hypothese, hypothesen | la hipótesis, hipótesis
investigate | v | to investigate | يبحث في | untersuchen | onderzoeken | investigar
quote_v | v | to quote | يقتبس | zitieren | citeren | citar
summary | n | summary | ملخص | die Zusammenfassung, Zusammenfassungen | de samenvatting, samenvattingen | el resumen, resúmenes
footnote | n | footnote | هامش | die Fußnote, Fußnoten | de voetnoot, voetnoten | la nota al pie, notas al pie
relevant | adj | relevant | مرتبط بالموضوع | relevant | relevant | pertinente
empirical | adj | empirical | تجريبي | empirisch | empirisch | empírico
findings | n | findings | نتايج البحث | der Befund, Befunde | de bevinding, bevindingen | el hallazgo, hallazgos
""",
        "sentences": """
The analysis of the data confirms the hypothesis. | تحليل البيانات بيأكد الفرضية. | Die Analyse der Daten bestätigt die Hypothese. | De analyse van de gegevens bevestigt de hypothese. | El análisis de los datos confirma la hipótesis.
In my thesis I investigate the use of dialects. | في رسالتي ببحث في استخدام اللهجات. | In meiner Abschlussarbeit untersuche ich den Gebrauch von Dialekten. | In mijn scriptie onderzoek ik het gebruik van dialecten. | En mi tesis investigo el uso de los dialectos.
The summary presents the main findings. | الملخص بيعرض أهم نتايج البحث. | Die Zusammenfassung stellt die wichtigsten Befunde dar. | De samenvatting presenteert de belangrijkste bevindingen. | El resumen presenta los principales hallazgos.
""",
        "grammar": {
            "de": G(("Academic nominal style", "الأسلوب الاسمي الأكاديمي"),
                    ("Academic German packs meaning into noun phrases. A verb clause becomes a noun with genitive and prepositional attributes:\n- Man analysiert die Daten. → die Analyse der Daten\n- Nachdem die Studie veröffentlicht wurde, ... → Nach der Veröffentlichung der Studie ...\n- Weil die Preise steigen, ... → Aufgrund der steigenden Preise ...\n\nTo read such texts, unpack the noun back into a clause.",
                     "الألماني الأكاديمي بيحط المعنى في عبارات اسمية. جملة فعلية بتبقى اسم مع إضافة وحروف جر:\n- Man analysiert die Daten. ← die Analyse der Daten\n- Nachdem die Studie veröffentlicht wurde, ... ← Nach der Veröffentlichung der Studie ...\n- Weil die Preise steigen, ... ← Aufgrund der steigenden Preise ...\n\nعشان تقرا النصوص دي، فكّ الاسم وارجعه جملة."),
                    [("Nach der ___ der Studie (veröffentlichen)", "Veröffentlichung", "veröffentlichen"), ("die Analyse ___ Daten", "der", "die"),
                     ("Weil die Preise steigen → Aufgrund der ___ Preise", "steigenden", "steigen"), ("untersuchen → die ___", "Untersuchung", "untersuchen")]),
            "nl": G(("Academic nominal style", "الأسلوب الاسمي الأكاديمي"),
                    ("Academic Dutch also prefers nouns, linked with van and other prepositions:\n- Men analyseert de gegevens. → de analyse van de gegevens\n- Nadat de studie was gepubliceerd → Na de publicatie van de studie\n- Omdat de prijzen stijgen → Door de stijging van de prijzen\n\nDutch style guides warn against too many nouns: in plain writing, prefer a verb.",
                     "الهولندي الأكاديمي برضه بيفضّل الأسماء، مربوطة بـ van وحروف جر تانية:\n- Men analyseert de gegevens. ← de analyse van de gegevens\n- Nadat de studie was gepubliceerd ← Na de publicatie van de studie\n- Omdat de prijzen stijgen ← Door de stijging van de prijzen\n\nوأدلة الكتابة الهولندية بتحذّر من الأسماء الكتير: في الكتابة البسيطة، الفعل أحسن."),
                    [("Na de ___ van de studie (publiceren)", "publicatie", "publiceren"), ("de analyse ___ de gegevens", "van", "van"),
                     ("Door de ___ van de prijzen (stijgen)", "stijging", "stijgen"), ("onderzoeken → het ___", "onderzoek", "onderzoeken")]),
            "es": G(("Academic nominal style", "الأسلوب الاسمي الأكاديمي"),
                    ("Academic Spanish turns clauses into noun phrases with de:\n- Se analizan los datos. → el análisis de los datos\n- Después de que se publicara el estudio → Tras la publicación del estudio\n- Porque suben los precios → Debido a la subida de los precios\n\nAlso typical: impersonal se (se observa que ...), the passive with ser, and long noun chains with de.",
                     "الإسباني الأكاديمي بيحوّل الجمل لعبارات اسمية بـ de:\n- Se analizan los datos. ← el análisis de los datos\n- Después de que se publicara el estudio ← Tras la publicación del estudio\n- Porque suben los precios ← Debido a la subida de los precios\n\nومن المعتاد كمان: se غير الشخصية (se observa que ...)، والمبني للمجهول بـ ser، وسلاسل أسماء طويلة بـ de."),
                    [("Tras la ___ del estudio (publicar)", "publicación", "publicar"), ("el análisis ___ los datos", "de", "de"),
                     ("Debido a la ___ de los precios (subir)", "subida", "subir"), ("Se ___ que los resultados varían. (observar)", "observa", "observar")]),
        },
    },
    {
        "key": "u02", "write_en": "whether freedom or security matters more", "write_ar": "الحرية ولا الأمان أهم",
        "words": """
moral | adj | moral | أخلاقي | moralisch | moreel | moral
freedom | n | freedom | حرية | die Freiheit, Freiheiten | de vrijheid, vrijheden | la libertad, libertades
conscience | n | conscience | ضمير | das Gewissen | het geweten | la conciencia
dignity | n | dignity | كرامة | die Würde | de waardigheid | la dignidad
dilemma | n | dilemma | معضلة | das Dilemma, Dilemmas | het dilemma, dilemma's | el dilema, dilemas
justify | v | to justify | يبرر | rechtfertigen | rechtvaardigen | justificar
virtue | n | virtue | فضيلة | die Tugend, Tugenden | de deugd, deugden | la virtud, virtudes
consequence | n | consequence | عاقبة | die Folge, Folgen | het gevolg, gevolgen | la consecuencia, consecuencias
philosopher | n | philosopher | فيلسوف | der Philosoph, Philosophen | de filosoof, filosofen | el filósofo, filósofos
ought_to | v | to ought to | المفروض | sollte | zou moeten | debería
selfish | adj | selfish | أناني | egoistisch | egoïstisch | egoísta
""",
        "sentences": """
Whoever has a conscience cannot justify that. | اللي عنده ضمير ما يقدرش يبرر ده. | Wer ein Gewissen hat, kann das nicht rechtfertigen. | Wie een geweten heeft, kan dat niet rechtvaardigen. | Quien tiene conciencia no puede justificar eso.
Freedom without responsibility has consequences. | الحرية من غير مسؤولية ليها عواقب. | Freiheit ohne Verantwortung hat Folgen. | Vrijheid zonder verantwoordelijkheid heeft gevolgen. | La libertad sin responsabilidad tiene consecuencias.
The philosopher describes a moral dilemma. | الفيلسوف بيوصف معضلة أخلاقية. | Der Philosoph beschreibt ein moralisches Dilemma. | De filosoof beschrijft een moreel dilemma. | El filósofo describe un dilema moral.
""",
        "grammar": {
            "de": G(("Complex subordinate clauses", "الجمل الفرعية المركبة"),
                    ("C1 texts nest clauses inside clauses. Useful patterns:\n- wer ..., (der) ...: Wer ein Gewissen hat, (der) kann das nicht rechtfertigen.\n- was after alles, nichts, etwas, das: Alles, was er sagt, ...\n- je ... desto/umso: Je länger ich nachdenke, desto unsicherer werde ich.\n- ohne dass / anstatt dass / als ob + subjunctive: Er tut, als ob er nichts wüsste.\n\nIn every subordinate clause the verb goes to the end; with two infinitives the finite verb comes first: ..., dass er es hätte wissen müssen.",
                     "نصوص C1 بتحط جمل جوه جمل. تراكيب مفيدة:\n- wer ..., (der) ...: Wer ein Gewissen hat, (der) kann das nicht rechtfertigen.\n- was بعد alles وnichts وetwas وdas: Alles, was er sagt, ...\n- je ... desto/umso: Je länger ich nachdenke, desto unsicherer werde ich.\n- ohne dass / anstatt dass / als ob + Konjunktiv: Er tut, als ob er nichts wüsste.\n\nفي كل جملة فرعية الفعل بيروح الآخر؛ ومع مصدرين الفعل المصرّف بييجي الأول: ..., dass er es hätte wissen müssen."),
                    [("___ ein Gewissen hat, kann das nicht rechtfertigen.", "Wer", "wer"), ("Alles, ___ er sagt, stimmt.", "was", "was"),
                     ("Je länger ich nachdenke, ___ unsicherer werde ich.", "desto", "desto"), ("Er tut, als ob er nichts ___. (wissen, KII)", "wüsste", "wissen")]),
            "nl": G(("Complex subordinate clauses", "الجمل الفرعية المركبة"),
                    ("Useful patterns for complex Dutch sentences:\n- wie ..., (die) ...: Wie een geweten heeft, kan dat niet rechtvaardigen.\n- wat after alles, niets, iets: Alles wat hij zegt, ...\n- hoe ... hoe/des te: Hoe langer ik nadenk, hoe onzekerder ik word.\n- zonder dat / in plaats van te / alsof: Hij doet alsof hij niets weet.\n\nThe verb cluster at the end may be in either order: ..., dat hij het had moeten weten.",
                     "تراكيب مفيدة للجمل الهولندية المركبة:\n- wie ..., (die) ...: Wie een geweten heeft, kan dat niet rechtvaardigen.\n- wat بعد alles وniets وiets: Alles wat hij zegt, ...\n- hoe ... hoe/des te: Hoe langer ik nadenk, hoe onzekerder ik word.\n- zonder dat / in plaats van te / alsof: Hij doet alsof hij niets weet.\n\nمجموعة الأفعال في الآخر ممكن تيجي بأي ترتيب: ..., dat hij het had moeten weten."),
                    [("___ een geweten heeft, kan dat niet rechtvaardigen.", "Wie", "wie"), ("Alles ___ hij zegt, klopt.", "wat", "wat"),
                     ("Hoe langer ik nadenk, ___ onzekerder ik word.", "hoe", "hoe"), ("Hij doet ___ hij niets weet. (as if)", "alsof", "alsof")]),
            "es": G(("Complex subordinate clauses", "الجمل الفرعية المركبة"),
                    ("Patterns for complex Spanish sentences:\n- quien / el que: Quien tiene conciencia no puede justificarlo.\n- lo que: Todo lo que dice es verdad.\n- cuanto más ..., más ...: Cuanto más lo pienso, más dudas tengo.\n- sin que / como si + subjunctive: Lo hizo sin que nadie lo supiera. Actúa como si no supiera nada.\n\nSubjunctive after verbs of wishing, doubt and emotion is essential at C1.",
                     "تراكيب للجمل الإسبانية المركبة:\n- quien / el que: Quien tiene conciencia no puede justificarlo.\n- lo que: Todo lo que dice es verdad.\n- cuanto más ...، más ...: Cuanto más lo pienso, más dudas tengo.\n- sin que / como si + subjuntivo: Lo hizo sin que nadie lo supiera. Actúa como si no supiera nada.\n\nوالـ subjuntivo بعد أفعال الأمنية والشك والمشاعر أساسي في C1."),
                    [("___ tiene conciencia no puede justificarlo.", "Quien", "quien"), ("Todo lo ___ dice es verdad.", "que", "que"),
                     ("Cuanto ___ lo pienso, más dudas tengo.", "más", "más"), ("Actúa como si no ___ nada. (saber)", "supiera", "saber")]),
        },
    },
    {
        "key": "u03", "write_en": "a reply to a client who complains about a late delivery", "write_ar": "رد على عميل بيشتكي من تأخير الطلب",
        "words": """
negotiation | n | negotiation | مفاوضة | die Verhandlung, Verhandlungen | de onderhandeling, onderhandelingen | la negociación, negociaciones
client | n | client | عميل | der Kunde, Kunden | de klant, klanten | el cliente, clientes
offer_n | n | offer, quote | عرض سعر | das Angebot, Angebote | de offerte, offertes | la oferta, ofertas
deadline | n | deadline | ميعاد التسليم | die Frist, Fristen | de deadline, deadlines | el plazo, plazos
delivery | n | delivery | توصيل | die Lieferung, Lieferungen | de levering, leveringen | la entrega, entregas
invoice | n | invoice | فاتورة | die Rechnung, Rechnungen | de factuur, facturen | la factura, facturas
compromise | n | compromise | حل وسط | der Kompromiss, Kompromisse | het compromis, compromissen | el compromiso, compromisos
condition | n | condition (of contract) | شرط | die Bedingung, Bedingungen | de voorwaarde, voorwaarden | la condición, condiciones
take_into_account | phr | to take into account | ياخد في الاعتبار | berücksichtigen | rekening houden met | tener en cuenta
make_decision | phr | to make a decision | ياخد قرار | eine Entscheidung treffen | een beslissing nemen | tomar una decisión
take_measures | phr | to take measures | ياخد إجراءات | Maßnahmen ergreifen | maatregelen nemen | tomar medidas
""",
        "sentences": """
We have to make a decision before the deadline. | لازم ناخد قرار قبل ميعاد التسليم. | Wir müssen vor Ablauf der Frist eine Entscheidung treffen. | We moeten voor de deadline een beslissing nemen. | Tenemos que tomar una decisión antes del plazo.
We will take your wishes into account. | هناخد طلباتك في الاعتبار. | Wir werden Ihre Wünsche berücksichtigen. | We zullen rekening houden met uw wensen. | Tendremos en cuenta sus deseos.
After long negotiations we found a compromise. | بعد مفاوضات طويلة لقينا حل وسط. | Nach langen Verhandlungen haben wir einen Kompromiss gefunden. | Na lange onderhandelingen hebben we een compromis gevonden. | Tras largas negociaciones encontramos un compromiso.
""",
        "grammar": {
            "de": G(("Functional verb structures (Funktionsverbgefüge)", "التراكيب الفعلية الاسمية"),
                    ("Formal German often replaces a simple verb with noun + 'light' verb. The noun carries the meaning:\n- entscheiden → eine Entscheidung treffen\n- berücksichtigen → in Betracht ziehen\n- anwenden → zur Anwendung kommen\n- fragen → eine Frage stellen\n- handeln → Maßnahmen ergreifen\n- beeinflussen → Einfluss nehmen auf\n\nLearn them as fixed pairs: you cannot swap the verb.",
                     "الألماني الرسمي كتير بيبدّل فعل بسيط بـ اسم + فعل 'خفيف'. الاسم هو اللي شايل المعنى:\n- entscheiden ← eine Entscheidung treffen\n- berücksichtigen ← in Betracht ziehen\n- anwenden ← zur Anwendung kommen\n- fragen ← eine Frage stellen\n- handeln ← Maßnahmen ergreifen\n- beeinflussen ← Einfluss nehmen auf\n\nاحفظهم كأزواج ثابتة: ما ينفعش تغيّر الفعل."),
                    [("eine Entscheidung ___", "treffen", "treffen"), ("eine Frage ___", "stellen", "stellen"),
                     ("Maßnahmen ___", "ergreifen", "ergreifen"), ("in Betracht ___", "ziehen", "ziehen")]),
            "nl": G(("Fixed verb-noun combinations", "تراكيب فعل واسم ثابتة"),
                    ("Formal Dutch has many fixed noun + verb combinations:\n- beslissen → een beslissing nemen\n- vragen → een vraag stellen\n- rekening houden met (take into account)\n- maatregelen nemen / treffen\n- invloed uitoefenen op\n- in aanmerking komen voor (be eligible for)\n\nNote that Dutch uses nemen where German uses treffen: een beslissing nemen.",
                     "الهولندي الرسمي فيه تراكيب كتير ثابتة من اسم + فعل:\n- beslissen ← een beslissing nemen\n- vragen ← een vraag stellen\n- rekening houden met (ياخد في الاعتبار)\n- maatregelen nemen / treffen\n- invloed uitoefenen op\n- in aanmerking komen voor (يستحق / مؤهل لـ)\n\nلاحظ إن الهولندي بيستخدم nemen والألماني treffen: een beslissing nemen."),
                    [("een beslissing ___", "nemen", "nemen"), ("een vraag ___", "stellen", "stellen"),
                     ("rekening ___ met", "houden", "houden"), ("invloed ___ op", "uitoefenen", "uitoefenen")]),
            "es": G(("Verb + noun collocations", "تراكيب فعل واسم"),
                    ("Formal Spanish likes verb + noun collocations:\n- decidir → tomar una decisión\n- preguntar → hacer una pregunta\n- considerar → tener en cuenta\n- actuar → tomar medidas\n- influir → ejercer influencia sobre\n- aplicar → poner en práctica\n\nSpanish uses tomar where German uses treffen and Dutch nemen.",
                     "الإسباني الرسمي بيحب تراكيب الفعل + الاسم:\n- decidir ← tomar una decisión\n- preguntar ← hacer una pregunta\n- considerar ← tener en cuenta\n- actuar ← tomar medidas\n- influir ← ejercer influencia sobre\n- aplicar ← poner en práctica\n\nالإسباني بيستخدم tomar مكان treffen في الألماني وnemen في الهولندي."),
                    [("___ una decisión", "tomar", "tomar"), ("___ una pregunta", "hacer", "hacer"),
                     ("tener en ___", "cuenta", "cuenta"), ("poner en ___", "práctica", "práctica")]),
        },
    },
    {
        "key": "u04", "write_en": "a news report about a decision of the European Parliament", "write_ar": "خبر عن قرار للبرلمان الأوروبي",
        "words": """
parliament | n | parliament | برلمان | das Parlament, Parlamente | het parlement, parlementen | el parlamento, parlamentos
policy | n | policy | سياسة | die Politik | het beleid | la política, políticas
union | n | union | اتحاد | die Union, Unionen | de unie, unies | la unión, uniones
member_state | n | member state | دولة عضو | der Mitgliedstaat, Mitgliedstaaten | de lidstaat, lidstaten | el Estado miembro, Estados miembros
legislation | n | legislation | تشريع | die Gesetzgebung | de wetgeving | la legislación
spokesperson | n | spokesperson | متحدث رسمي | der Sprecher, Sprecher | de woordvoerder, woordvoerders | el portavoz, portavoces
opposition | n | opposition | معارضة | die Opposition, Oppositionen | de oppositie, opposities | la oposición, oposiciones
majority | n | majority | أغلبية | die Mehrheit, Mehrheiten | de meerderheid, meerderheden | la mayoría, mayorías
coalition | n | coalition | ائتلاف | die Koalition, Koalitionen | de coalitie, coalities | la coalición, coaliciones
reject | v | to reject | يرفض | ablehnen | verwerpen | rechazar
treaty | n | treaty | معاهدة | der Vertrag, Verträge | het verdrag, verdragen | el tratado, tratados
""",
        "sentences": """
The spokesperson said the majority had rejected the law. | المتحدث الرسمي قال إن الأغلبية رفضت القانون. | Der Sprecher sagte, die Mehrheit habe das Gesetz abgelehnt. | De woordvoerder zei dat de meerderheid de wet had verworpen. | El portavoz dijo que la mayoría había rechazado la ley.
Every member state must sign the treaty. | كل دولة عضو لازم تمضي على المعاهدة. | Jeder Mitgliedstaat muss den Vertrag unterzeichnen. | Elke lidstaat moet het verdrag ondertekenen. | Cada Estado miembro debe firmar el tratado.
The coalition needs the opposition. | الائتلاف محتاج المعارضة. | Die Koalition braucht die Opposition. | De coalitie heeft de oppositie nodig. | La coalición necesita a la oposición.
""",
        "grammar": {
            "de": G(("Konjunktiv I in reporting", "Konjunktiv I في نقل الأخبار"),
                    ("Journalists keep a distance from what they report by using Konjunktiv I throughout, often without dass:\n- Der Sprecher sagte, die Mehrheit habe das Gesetz abgelehnt. Man werde weiter verhandeln.\n- Future: werde + infinitive: Die Union werde handeln.\n- Questions: ob / question word: Er fragte, ob das stimme.\n- Commands: sollen/mögen: Er forderte, man solle schneller handeln.\n\nReporting verbs: betonen, erklären, kritisieren, einräumen (admit), bestreiten (deny).",
                     "الصحفيين بيبعدوا نفسهم عن الكلام اللي بينقلوه باستخدام Konjunktiv I طول الوقت، وكتير من غير dass:\n- Der Sprecher sagte, die Mehrheit habe das Gesetz abgelehnt. Man werde weiter verhandeln.\n- المستقبل: werde + مصدر: Die Union werde handeln.\n- الأسئلة: ob / أداة سؤال: Er fragte, ob das stimme.\n- الأوامر: sollen/mögen: Er forderte, man solle schneller handeln.\n\nأفعال النقل: betonen، erklären، kritisieren، einräumen (يعترف)، bestreiten (ينكر)."),
                    [("Er sagte, die Mehrheit ___ das Gesetz abgelehnt. (haben)", "habe", "haben"), ("Man ___ weiter verhandeln. (werden, KI)", "werde", "werden"),
                     ("Er fragte, ob das ___. (stimmen, KI)", "stimme", "stimmen"), ("Er forderte, man ___ schneller handeln. (sollen, KI)", "solle", "sollen")]),
            "nl": G(("Reporting in the news", "نقل الكلام في الأخبار"),
                    ("Dutch news reports use dat-clauses, zou for unconfirmed claims, and a rich set of reporting verbs:\n- Volgens de woordvoerder heeft de meerderheid de wet verworpen.\n- De minister zou op de hoogte zijn geweest. (= reportedly knew)\n- verbs: benadrukken (stress), toegeven (admit), ontkennen (deny), stellen (state), verklaren\n\nzou + infinitive is the Dutch way to keep a distance, close to German Konjunktiv I.",
                     "الأخبار الهولندية بتستخدم جمل dat، وzou للادعاءات اللي مش متأكدة، وأفعال نقل كتير:\n- Volgens de woordvoerder heeft de meerderheid de wet verworpen.\n- De minister zou op de hoogte zijn geweest. (= بيقولوا إنه كان عارف)\n- أفعال: benadrukken (يأكّد)، toegeven (يعترف)، ontkennen (ينكر)، stellen (يقرر)، verklaren\n\nوzou + مصدر هي طريقة الهولندي عشان يبعد نفسه، قريبة من Konjunktiv I الألماني."),
                    [("De minister ___ op de hoogte zijn geweest. (reportedly)", "zou", "zullen"), ("___ de woordvoerder is dat niet waar. (according to)", "Volgens", "volgens"),
                     ("Hij ___ dat hij fouten had gemaakt. (admitted, toegeven)", "gaf", "toegeven"), ("Ze ___ alles. (denied, ontkennen)", "ontkende", "ontkennen")]),
            "es": G(("Reporting in the news", "نقل الكلام في الأخبار"),
                    ("Spanish news uses reported speech with tense shift and the conditional for unconfirmed information (condicional de rumor):\n- El portavoz afirmó que la mayoría había rechazado la ley.\n- Según fuentes oficiales, el ministro habría conocido los hechos. (= reportedly)\n- Reporting verbs: subrayar, admitir, negar (+ subjunctive when negated: negó que fuera cierto), declarar, señalar.",
                     "الأخبار الإسبانية بتستخدم الكلام المنقول مع رجوع الأزمنة، والـ condicional للمعلومات اللي مش متأكدة (condicional de rumor):\n- El portavoz afirmó que la mayoría había rechazado la ley.\n- Según fuentes oficiales, el ministro habría conocido los hechos. (= بيقولوا)\n- أفعال النقل: subrayar، admitir، negar (+ subjuntivo مع النفي: negó que fuera cierto)، declarar، señalar."),
                    [("Afirmó que la mayoría ___ rechazado la ley.", "había", "haber"), ("El ministro ___ conocido los hechos. (reportedly)", "habría", "haber"),
                     ("Negó que ___ cierto. (ser)", "fuera", "ser"), ("___ fuentes oficiales, ... (according to)", "Según", "según")]),
        },
    },
    {
        "key": "u05", "write_en": "a popular science article on a health study", "write_ar": "مقال علمي مبسّط عن دراسة صحية",
        "words": """
evidence | n | evidence | دليل | der Nachweis, Nachweise | het bewijs, bewijzen | la evidencia, evidencias
method | n | method | منهج | die Methode, Methoden | de methode, methodes | el método, métodos
sample | n | sample (study) | عينة | die Stichprobe, Stichproben | de steekproef, steekproeven | la muestra, muestras
correlation | n | correlation | ارتباط | der Zusammenhang, Zusammenhänge | het verband, verbanden | la correlación, correlaciones
significant | adj | significant | ملحوظ | erheblich | aanzienlijk | significativo
presumably | adv | presumably | على الأرجح | vermutlich | vermoedelijk | presumiblemente
apparently | adv | apparently | على ما يبدو | anscheinend | blijkbaar | al parecer
tend_to | v | to tend to | يميل إلى | dazu neigen | geneigd zijn | tender a
suggest_indicate | v | to suggest, indicate | يشير إلى | darauf hindeuten | erop wijzen | indicar
assumption | n | assumption | افتراض | die Annahme, Annahmen | de aanname, aannames | la suposición, suposiciones
limitation | n | limitation | قصور | die Einschränkung, Einschränkungen | de beperking, beperkingen | la limitación, limitaciones
""",
        "sentences": """
The results suggest a correlation. | النتايج بتشير إلى ارتباط. | Die Ergebnisse deuten auf einen Zusammenhang hin. | De resultaten wijzen op een verband. | Los resultados indican una correlación.
The sample was apparently too small. | العينة على ما يبدو كانت صغيرة أوي. | Die Stichprobe war anscheinend zu klein. | De steekproef was blijkbaar te klein. | Al parecer, la muestra era demasiado pequeña.
This is presumably not the only cause. | ده على الأرجح مش السبب الوحيد. | Das ist vermutlich nicht die einzige Ursache. | Dat is vermoedelijk niet de enige oorzaak. | Presumiblemente no es la única causa.
""",
        "grammar": {
            "de": G(("Hedging and stance", "التحفظ والموقف"),
                    ("Careful writers avoid absolute claims. German tools:\n- adverbs: vermutlich, wahrscheinlich, anscheinend, offenbar, möglicherweise\n- verbs: scheinen zu, darauf hindeuten, sich zeigen, lassen vermuten\n- Konjunktiv II: Das könnte bedeuten, dass ... Man müsste prüfen, ob ...\n- impersonal phrases: Es ist anzunehmen, dass ... Es lässt sich nicht ausschließen, dass ...",
                     "الكتّاب الحريصين بيبعدوا عن الأحكام المطلقة. أدوات الألماني:\n- ظروف: vermutlich، wahrscheinlich، anscheinend، offenbar، möglicherweise\n- أفعال: scheinen zu، darauf hindeuten، sich zeigen، lassen vermuten\n- Konjunktiv II: Das könnte bedeuten, dass ... Man müsste prüfen, ob ...\n- عبارات غير شخصية: Es ist anzunehmen, dass ... Es lässt sich nicht ausschließen, dass ..."),
                    [("Das ___ bedeuten, dass ... (KII, können)", "könnte", "können"), ("Die Ergebnisse deuten ___ einen Zusammenhang hin.", "auf", "auf"),
                     ("Es ist ___, dass ... (anzunehmen)", "anzunehmen", "annehmen"), ("Er ___ müde zu sein. (scheinen)", "scheint", "scheinen")]),
            "nl": G(("Hedging and stance", "التحفظ والموقف"),
                    ("Dutch hedging tools:\n- adverbs: vermoedelijk, waarschijnlijk, blijkbaar, kennelijk, mogelijk\n- verbs: lijken te, schijnen te, erop wijzen dat, doen vermoeden\n- zou/zouden: Dat zou kunnen betekenen dat ...\n- impersonal: Het is aannemelijk dat ... Het valt niet uit te sluiten dat ...",
                     "أدوات التحفظ في الهولندي:\n- ظروف: vermoedelijk، waarschijnlijk، blijkbaar، kennelijk، mogelijk\n- أفعال: lijken te، schijnen te، erop wijzen dat، doen vermoeden\n- zou/zouden: Dat zou kunnen betekenen dat ...\n- عبارات غير شخصية: Het is aannemelijk dat ... Het valt niet uit te sluiten dat ..."),
                    [("Dat ___ kunnen betekenen dat ...", "zou", "zullen"), ("De resultaten wijzen ___ een verband.", "op", "op"),
                     ("Het valt niet uit te ___ dat ...", "sluiten", "sluiten"), ("Hij ___ moe te zijn. (lijken)", "lijkt", "lijken")]),
            "es": G(("Hedging and stance", "التحفظ والموقف"),
                    ("Spanish hedging tools:\n- adverbs: presumiblemente, probablemente, al parecer, aparentemente, posiblemente\n- verbs: parecer, indicar, sugerir, apuntar a\n- the conditional: Esto podría significar que ...\n- impersonal + subjunctive: Es posible que ... / No se puede descartar que haya ...\n- Es probable que + subjunctive; but Es evidente que + indicative.",
                     "أدوات التحفظ في الإسباني:\n- ظروف: presumiblemente، probablemente، al parecer، aparentemente، posiblemente\n- أفعال: parecer، indicar، sugerir، apuntar a\n- الـ condicional: Esto podría significar que ...\n- عبارات غير شخصية + subjuntivo: Es posible que ... / No se puede descartar que haya ...\n- Es probable que + subjuntivo؛ بس Es evidente que + indicativo."),
                    [("Esto ___ significar que ... (poder, cond.)", "podría", "poder"), ("Es posible que ___ otra causa. (haber, subj.)", "haya", "haber"),
                     ("Los datos ___ a una correlación. (apuntar)", "apuntan", "apuntar"), ("Es evidente que ___ un problema. (haber, ind.)", "hay", "haber")]),
        },
    },
    {
        "key": "u06", "write_en": "a review of a film that uses an unusual style", "write_ar": "نقد لفيلم بأسلوب غير معتاد",
        "words": """
scene | n | scene | مشهد | die Szene, Szenen | de scène, scènes | la escena, escenas
plot | n | plot | حبكة | die Handlung, Handlungen | de plot, plots | la trama, tramas
narrator | n | narrator | راوي | der Erzähler, Erzähler | de verteller, vertellers | el narrador, narradores
protagonist | n | protagonist | بطل القصة | der Protagonist, Protagonisten | de hoofdpersoon, hoofdpersonen | el protagonista, protagonistas
metaphor | n | metaphor | استعارة | die Metapher, Metaphern | de metafoor, metaforen | la metáfora, metáforas
irony | n | irony | سخرية | die Ironie | de ironie | la ironía
tension | n | tension, suspense | توتر / تشويق | die Spannung, Spannungen | de spanning, spanningen | la tensión, tensiones
subtle | adj | subtle | خفي | subtil | subtiel | sutil
depict | v | to depict | يصوّر | darstellen | uitbeelden | retratar
director | n | film director | مخرج | der Regisseur, Regisseure | de regisseur, regisseurs | el director de cine, directores de cine
moving | adj | moving | مؤثر | ergreifend | ontroerend | conmovedor
""",
        "sentences": """
The director depicts the war with subtle irony. | المخرج بيصوّر الحرب بسخرية خفية. | Der Regisseur stellt den Krieg mit subtiler Ironie dar. | De regisseur beeldt de oorlog uit met subtiele ironie. | El director retrata la guerra con una ironía sutil.
The tension rises from scene to scene. | التشويق بيزيد من مشهد لمشهد. | Die Spannung steigt von Szene zu Szene. | De spanning stijgt van scène tot scène. | La tensión aumenta de escena en escena.
The narrator is not the protagonist. | الراوي مش بطل القصة. | Der Erzähler ist nicht der Protagonist. | De verteller is niet de hoofdpersoon. | El narrador no es el protagonista.
""",
        "grammar": {
            "de": G(("Stylistic devices", "الأدوات البلاغية"),
                    ("To discuss style, name the device and its effect:\n- die Metapher: Das Leben ist eine Reise.\n- der Vergleich (simile): stark wie ein Bär\n- die Wiederholung / Anapher: Ich kam, ich sah, ich siegte.\n- die Ironie: saying the opposite of what is meant\n- die rhetorische Frage\n- word order for emphasis: Den Film habe ich nicht verstanden. (object first = focus)\n\nUseful verbs: Der Autor verwendet ..., um ... zu ...; Dadurch wird ... betont.",
                     "عشان تتكلم عن الأسلوب، سمّي الأداة وأثرها:\n- die Metapher: Das Leben ist eine Reise.\n- der Vergleich (تشبيه): stark wie ein Bär\n- die Wiederholung / Anapher: Ich kam, ich sah, ich siegte.\n- die Ironie: إنك تقول عكس اللي تقصده\n- die rhetorische Frage (سؤال بلاغي)\n- ترتيب الكلمات للتأكيد: Den Film habe ich nicht verstanden. (المفعول الأول = تركيز)\n\nأفعال مفيدة: Der Autor verwendet ..., um ... zu ...؛ Dadurch wird ... betont."),
                    [("stark ___ ein Bär (simile)", "wie", "wie"), ("Der Autor verwendet Ironie, ___ Kritik zu üben.", "um", "um"),
                     ("Dadurch ___ die Spannung betont. (passive)", "wird", "werden"), ("Das Leben ist eine Reise: eine ___", "Metapher", "Metapher")]),
            "nl": G(("Stylistic devices", "الأدوات البلاغية"),
                    ("Naming devices in Dutch:\n- de metafoor: Het leven is een reis.\n- de vergelijking: sterk als een beer\n- de herhaling / anafoor\n- de ironie, de retorische vraag\n- inversion for emphasis: Die film heb ik niet begrepen.\n\nUseful phrases: De schrijver gebruikt ... om ... te ...; Daardoor wordt ... benadrukt.",
                     "أسماء الأدوات بالهولندي:\n- de metafoor: Het leven is een reis.\n- de vergelijking (تشبيه): sterk als een beer\n- de herhaling / anafoor\n- de ironie، de retorische vraag\n- قلب الترتيب للتأكيد: Die film heb ik niet begrepen.\n\nعبارات مفيدة: De schrijver gebruikt ... om ... te ...؛ Daardoor wordt ... benadrukt."),
                    [("sterk ___ een beer (simile)", "als", "als"), ("De schrijver gebruikt ironie ___ kritiek te geven.", "om", "om"),
                     ("Daardoor ___ de spanning benadrukt.", "wordt", "worden"), ("Het leven is een reis: een ___", "metafoor", "metafoor")]),
            "es": G(("Stylistic devices", "الأدوات البلاغية"),
                    ("Naming devices in Spanish:\n- la metáfora: La vida es un viaje.\n- el símil / la comparación: fuerte como un oso\n- la anáfora, la repetición\n- la ironía, la pregunta retórica\n- fronting with a pronoun for emphasis: Esa película no la entendí.\n\nUseful phrases: El autor utiliza ... para ...; De este modo se subraya ...",
                     "أسماء الأدوات بالإسباني:\n- la metáfora: La vida es un viaje.\n- el símil / la comparación (تشبيه): fuerte como un oso\n- la anáfora، la repetición\n- la ironía، la pregunta retórica\n- تقديم المفعول مع ضمير للتأكيد: Esa película no la entendí.\n\nعبارات مفيدة: El autor utiliza ... para ...؛ De este modo se subraya ..."),
                    [("fuerte ___ un oso (simile)", "como", "como"), ("Esa película no ___ entendí. (pronoun)", "la", "la"),
                     ("El autor utiliza la ironía ___ criticar.", "para", "para"), ("De este modo se ___ la tensión. (subrayar)", "subraya", "subrayar")]),
        },
    },
    {
        "key": "u07", "write_en": "what home means to someone who lives between two countries", "write_ar": "يعني إيه وطن لحد عايش بين بلدين",
        "words": """
identity | n | identity | هوية | die Identität, Identitäten | de identiteit, identiteiten | la identidad, identidades
belonging | n | belonging | انتماء | die Zugehörigkeit | het erbij horen | la pertenencia
homeland | n | homeland | وطن | die Heimat | het vaderland | la patria, patrias
integration | n | integration | اندماج | die Integration | de integratie | la integración
emigrate | v | to emigrate | يهاجر | auswandern | emigreren | emigrar
residence_permit | n | residence permit | إقامة | die Aufenthaltserlaubnis | de verblijfsvergunning, verblijfsvergunningen | el permiso de residencia, permisos de residencia
diversity | n | diversity | تنوع | die Vielfalt | de diversiteit | la diversidad
homesickness | n | homesickness | حنين للوطن | das Heimweh | het heimwee | la nostalgia
roots | n | roots | جذور | die Wurzel, Wurzeln | de wortel, wortels | la raíz, raíces
whereas | conj | whereas | في حين إن | während | terwijl | mientras que
insofar_as | conj | insofar as | بقدر ما | insofern | voor zover | en la medida en que
""",
        "sentences": """
My roots are in Egypt, whereas my children feel Dutch. | جذوري في مصر، في حين إن ولادي حاسين إنهم هولنديين. | Meine Wurzeln liegen in Ägypten, während meine Kinder sich als Niederländer fühlen. | Mijn wortels liggen in Egypte, terwijl mijn kinderen zich Nederlands voelen. | Mis raíces están en Egipto, mientras que mis hijos se sienten neerlandeses.
Homesickness is part of my identity. | الحنين للوطن جزء من هويتي. | Heimweh ist Teil meiner Identität. | Heimwee hoort bij mijn identiteit. | La nostalgia forma parte de mi identidad.
Diversity enriches a society. | التنوع بيغني المجتمع. | Vielfalt bereichert eine Gesellschaft. | Diversiteit verrijkt een samenleving. | La diversidad enriquece una sociedad.
""",
        "grammar": {
            "de": G(("Advanced connectors", "أدوات ربط متقدمة"),
                    ("Precise connectors show exact logical relations:\n- während / wohingegen: contrast: Ich bleibe, wohingegen er auswandert.\n- insofern (als): to the extent that: Das stimmt insofern, als ...\n- sofern / vorausgesetzt, dass: provided that\n- indem: by (doing): Man lernt, indem man spricht.\n- geschweige denn: let alone\n- zumal / zumindest / allerdings / immerhin\n\nwährend, wohingegen, sofern and indem send the verb to the end.",
                     "أدوات الربط الدقيقة بتوضّح العلاقة المنطقية بالظبط:\n- während / wohingegen: مقارنة: Ich bleibe, wohingegen er auswandert.\n- insofern (als): بقدر ما: Das stimmt insofern, als ...\n- sofern / vorausgesetzt, dass: بشرط إن\n- indem: عن طريق: Man lernt, indem man spricht.\n- geschweige denn: ناهيك عن\n- zumal / zumindest / allerdings / immerhin\n\nwährend وwohingegen وsofern وindem بيبعتوا الفعل للآخر."),
                    [("Man lernt, ___ man spricht. (by)", "indem", "indem"), ("Ich bleibe, ___ er auswandert. (whereas)", "wohingegen", "wohingegen"),
                     ("Das stimmt insofern, ___ ...", "als", "als"), ("Er spricht kein Englisch, geschweige ___ Deutsch.", "denn", "denn")]),
            "nl": G(("Advanced connectors", "أدوات ربط متقدمة"),
                    ("Precise Dutch connectors:\n- terwijl / daarentegen: contrast: Ik blijf, terwijl hij emigreert.\n- voor zover: insofar as\n- mits / op voorwaarde dat: provided that\n- doordat / door te: by, because of: Je leert door te spreken.\n- laat staan: let alone\n- althans, overigens, immers\n\nterwijl, mits and doordat take subordinate word order.",
                     "أدوات ربط هولندية دقيقة:\n- terwijl / daarentegen: مقارنة: Ik blijf, terwijl hij emigreert.\n- voor zover: بقدر ما\n- mits / op voorwaarde dat: بشرط إن\n- doordat / door te: عن طريق، بسبب: Je leert door te spreken.\n- laat staan: ناهيك عن\n- althans، overigens، immers\n\nterwijl وmits وdoordat بياخدوا ترتيب الجملة الفرعية."),
                    [("Je leert door ___ spreken.", "te", "te"), ("Ik blijf, ___ hij emigreert. (whereas)", "terwijl", "terwijl"),
                     ("Ik kom, ___ het niet regent. (provided that)", "mits", "mits"), ("Hij spreekt geen Engels, laat ___ Nederlands.", "staan", "staan")]),
            "es": G(("Advanced connectors", "أدوات ربط متقدمة"),
                    ("Precise Spanish connectors:\n- mientras que / en cambio: contrast: Yo me quedo, mientras que él emigra.\n- en la medida en que: insofar as\n- siempre que / con tal de que + subjunctive: provided that\n- gerund for 'by': Se aprende hablando.\n- ni mucho menos / y mucho menos: let alone\n- de ahí que + subjunctive: hence\n- si bien: although (formal, + indicative)",
                     "أدوات ربط إسبانية دقيقة:\n- mientras que / en cambio: مقارنة: Yo me quedo, mientras que él emigra.\n- en la medida en que: بقدر ما\n- siempre que / con tal de que + subjuntivo: بشرط إن\n- الـ gerundio بمعنى 'عن طريق': Se aprende hablando.\n- ni mucho menos / y mucho menos: ناهيك عن\n- de ahí que + subjuntivo: عشان كده\n- si bien: رغم إن (رسمي، + indicativo)"),
                    [("Se aprende ___. (hablar, by)", "hablando", "hablar"), ("Yo me quedo, mientras ___ él emigra.", "que", "que"),
                     ("Vengo siempre que no ___. (llover, subj.)", "llueva", "llover"), ("De ahí que ___ nostalgia. (tener, subj., él)", "tenga", "tener")]),
        },
    },
    {
        "key": "u08", "write_en": "a funny misunderstanding you had in a foreign language", "write_ar": "سوء فهم مضحك حصل لك في لغة أجنبية",
        "words": """
joke | n | joke | نكتة | der Witz, Witze | de grap, grappen | el chiste, chistes
idiom | n | idiom | تعبير اصطلاحي | die Redewendung, Redewendungen | de uitdrukking, uitdrukkingen | la expresión idiomática, expresiones idiomáticas
pun | n | pun | تلاعب بالألفاظ | das Wortspiel, Wortspiele | de woordspeling, woordspelingen | el juego de palabras, juegos de palabras
sarcastic | adj | sarcastic | ساخر | sarkastisch | sarcastisch | sarcástico
exaggerate | v | to exaggerate | يبالغ | übertreiben | overdrijven | exagerar
tease | v | to tease | يغلّس على / يهزر مع | necken | plagen | tomar el pelo
laugh_at | v | to laugh at | يضحك على | auslachen | uitlachen | reírse de
punchline | n | punchline | قفلة النكتة | die Pointe, Pointen | de clou, clous | el remate, remates
not_my_cup_of_tea | phr | not my cup of tea | مش بتاعي | nicht mein Ding | niet mijn ding | no es lo mío
piece_of_cake | phr | a piece of cake | سهلة جدًا | ein Kinderspiel | een eitje | pan comido
pull_someones_leg | phr | to pull someone's leg | يشتغل حد | jemanden auf den Arm nehmen | iemand voor de gek houden | tomarle el pelo a alguien
""",
        "sentences": """
Are you pulling my leg? | إنت بتشتغلني؟ | Willst du mich auf den Arm nehmen? | Hou je me voor de gek? | ¿Me estás tomando el pelo?
The exam was a piece of cake. | الامتحان كان سهل جدًا. | Die Prüfung war ein Kinderspiel. | Het examen was een eitje. | El examen fue pan comido.
Opera is not my cup of tea. | الأوبرا مش بتاعتي. | Oper ist nicht mein Ding. | Opera is niet mijn ding. | La ópera no es lo mío.
""",
        "grammar": {
            "de": G(("Idiomatic expressions", "التعبيرات الاصطلاحية"),
                    ("Idioms cannot be translated word for word. Learn them as whole chunks with their register:\n- Ich verstehe nur Bahnhof. (I don't understand a thing)\n- Das ist nicht mein Bier. (not my business)\n- Tomaten auf den Augen haben (to miss the obvious)\n- jemanden auf den Arm nehmen (pull someone's leg)\n- Daumen drücken (keep your fingers crossed)\n\nThe verb inside an idiom still conjugates and moves: Ich drücke dir die Daumen.",
                     "التعبيرات الاصطلاحية ما بتتترجمش كلمة كلمة. احفظها كقطعة واحدة مع مستواها:\n- Ich verstehe nur Bahnhof. (مش فاهم حاجة)\n- Das ist nicht mein Bier. (مش شغلي)\n- Tomaten auf den Augen haben (مش شايف الحاجة الواضحة)\n- jemanden auf den Arm nehmen (يشتغل حد)\n- Daumen drücken (يتمنى له الحظ)\n\nوالفعل جوه التعبير بيتصرّف ويتحرك عادي: Ich drücke dir die Daumen."),
                    [("Ich verstehe nur ___. (nothing)", "Bahnhof", "Bahnhof"), ("Ich drücke dir die ___.", "Daumen", "Daumen"),
                     ("Willst du mich auf den ___ nehmen?", "Arm", "Arm"), ("Das ist nicht mein ___. (not my business)", "Bier", "Bier")]),
            "nl": G(("Idiomatic expressions", "التعبيرات الاصطلاحية"),
                    ("Dutch idioms to learn as chunks:\n- Nu komt de aap uit de mouw. (now the truth comes out)\n- Dat is een eitje. (piece of cake)\n- iemand voor de gek houden (pull someone's leg)\n- de kat uit de boom kijken (wait and see)\n- duimen voor iemand (keep your fingers crossed)\n- Ik snap er geen bal van. (informal: I don't get it at all)",
                     "تعبيرات هولندية تحفظها كقطعة واحدة:\n- Nu komt de aap uit de mouw. (دلوقتي الحقيقة بانت)\n- Dat is een eitje. (سهلة جدًا)\n- iemand voor de gek houden (يشتغل حد)\n- de kat uit de boom kijken (يستنى ويشوف)\n- duimen voor iemand (يتمنى له الحظ)\n- Ik snap er geen bal van. (عامية: مش فاهم أي حاجة)"),
                    [("Nu komt de aap uit de ___.", "mouw", "mouw"), ("Dat is een ___. (easy)", "eitje", "eitje"),
                     ("Hou je me voor de ___?", "gek", "gek"), ("de kat uit de ___ kijken", "boom", "boom")]),
            "es": G(("Idiomatic expressions", "التعبيرات الاصطلاحية"),
                    ("Spanish idioms to learn as chunks:\n- ser pan comido (piece of cake)\n- tomar el pelo a alguien (pull someone's leg)\n- no tener pelos en la lengua (to speak one's mind)\n- estar en las nubes (to daydream)\n- costar un ojo de la cara (cost an arm and a leg)\n- meter la pata (to put your foot in it)\n\nThe verb conjugates: Siempre meto la pata.",
                     "تعبيرات إسبانية تحفظها كقطعة واحدة:\n- ser pan comido (سهلة جدًا)\n- tomar el pelo a alguien (يشتغل حد)\n- no tener pelos en la lengua (بيقول اللي في دماغه)\n- estar en las nubes (سرحان)\n- costar un ojo de la cara (غالي جدًا)\n- meter la pata (يهبب الدنيا)\n\nوالفعل بيتصرّف: Siempre meto la pata."),
                    [("El examen fue ___ comido.", "pan", "pan"), ("¿Me estás tomando el ___?", "pelo", "pelo"),
                     ("Siempre ___ la pata. (yo, meter)", "meto", "meter"), ("Cuesta un ojo de la ___.", "cara", "cara")]),
        },
    },
    {
        "key": "u09", "write_en": "should AI decide who gets a loan or a job", "write_ar": "هل الذكاء الاصطناعي المفروض يقرر مين ياخد قرض أو شغلانة",
        "words": """
artificial_intelligence | n | artificial intelligence | ذكاء اصطناعي | die künstliche Intelligenz | de kunstmatige intelligentie | la inteligencia artificial
robot | n | robot | روبوت | der Roboter, Roboter | de robot, robots | el robot, robots
algorithm | n | algorithm | خوارزمية | der Algorithmus, Algorithmen | het algoritme, algoritmes | el algoritmo, algoritmos
risk | n | risk | خطر | das Risiko, Risiken | het risico, risico's | el riesgo, riesgos
surveillance | n | surveillance | مراقبة | die Überwachung | het toezicht | la vigilancia
automate | v | to automate | يميكن | automatisieren | automatiseren | automatizar
replace | v | to replace | يستبدل | ersetzen | vervangen | sustituir
transparent | adj | transparent | شفاف | transparent | transparant | transparente
bias | n | bias | تحيز | die Voreingenommenheit | de vooringenomenheid | el sesgo, sesgos
regulate | v | to regulate | ينظّم بقانون | regulieren | reguleren | regular
accountable | adj | accountable | مسؤول (يتحاسب) | rechenschaftspflichtig | verantwoordelijk | responsable
""",
        "sentences": """
The decisions made by the algorithm must be transparent. | القرارات اللي بتاخدها الخوارزمية لازم تبقى شفافة. | Die vom Algorithmus getroffenen Entscheidungen müssen transparent sein. | De door het algoritme genomen beslissingen moeten transparant zijn. | Las decisiones tomadas por el algoritmo deben ser transparentes.
Many jobs are being replaced by robots. | شغلانات كتير بتتبدل بروبوتات. | Viele Arbeitsplätze werden durch Roboter ersetzt. | Veel banen worden door robots vervangen. | Muchos empleos están siendo sustituidos por robots.
Artificial intelligence has to be regulated. | الذكاء الاصطناعي لازم يتنظّم بقانون. | Künstliche Intelligenz muss reguliert werden. | Kunstmatige intelligentie moet gereguleerd worden. | La inteligencia artificial tiene que ser regulada.
""",
        "grammar": {
            "de": G(("Advanced passive and participle constructions", "المبني للمجهول والـ Partizip المتقدم"),
                    ("Advanced passive forms:\n- with modals: muss reguliert werden; hätte geprüft werden müssen\n- state passive (sein): Die Daten sind gespeichert.\n- agents: von (person/agent) vs durch (means): durch Roboter ersetzt\n- participle attributes with agent: die vom Algorithmus getroffenen Entscheidungen\n- zu + Partizip I (must be done): die zu prüfenden Daten (= die Daten, die geprüft werden müssen)",
                     "صيغ مبني للمجهول متقدمة:\n- مع أفعال الوجه: muss reguliert werden؛ hätte geprüft werden müssen\n- مبني للمجهول للحالة (sein): Die Daten sind gespeichert.\n- الفاعل: von (شخص/فاعل) وdurch (وسيلة): durch Roboter ersetzt\n- صفات Partizip مع فاعل: die vom Algorithmus getroffenen Entscheidungen\n- zu + Partizip I (لازم يتعمل): die zu prüfenden Daten (= die Daten, die geprüft werden müssen)"),
                    [("KI muss reguliert ___.", "werden", "werden"), ("die vom Algorithmus ___ Entscheidungen (treffen)", "getroffenen", "treffen"),
                     ("Viele Jobs werden ___ Roboter ersetzt. (means)", "durch", "durch"), ("die zu ___ Daten (prüfen, must be checked)", "prüfenden", "prüfen")]),
            "nl": G(("Advanced passive constructions", "المبني للمجهول المتقدم"),
                    ("Advanced Dutch passive forms:\n- with modals: moet gereguleerd worden; had gecontroleerd moeten worden\n- worden (action) vs zijn (result): De gegevens worden opgeslagen. / zijn opgeslagen.\n- agent with door: door robots vervangen\n- participle attributes with agent: de door het algoritme genomen beslissingen\n- te + infinitive: de te controleren gegevens (= that must be checked)",
                     "صيغ مبني للمجهول هولندية متقدمة:\n- مع أفعال الوجه: moet gereguleerd worden؛ had gecontroleerd moeten worden\n- worden (فعل) وzijn (نتيجة): De gegevens worden opgeslagen. / zijn opgeslagen.\n- الفاعل بـ door: door robots vervangen\n- صفات بالـ participle مع فاعل: de door het algoritme genomen beslissingen\n- te + مصدر: de te controleren gegevens (= اللي لازم تتراجع)"),
                    [("KI moet gereguleerd ___.", "worden", "worden"), ("de door het algoritme ___ beslissingen (nemen)", "genomen", "nemen"),
                     ("Banen worden ___ robots vervangen.", "door", "door"), ("de ___ controleren gegevens (must be checked)", "te", "te")]),
            "es": G(("Advanced passive constructions", "المبني للمجهول المتقدم"),
                    ("Advanced Spanish passive forms:\n- ser + participle with modals: tiene que ser regulada; debería haber sido revisado\n- estar siendo + participle: están siendo sustituidos\n- estar + participle for a resulting state: Los datos están guardados.\n- agent with por: tomadas por el algoritmo\n- participle clauses: Una vez tomada la decisión, ... (absolute participle)",
                     "صيغ مبني للمجهول إسبانية متقدمة:\n- ser + اسم مفعول مع أفعال الوجه: tiene que ser regulada؛ debería haber sido revisado\n- estar siendo + اسم مفعول: están siendo sustituidos\n- estar + اسم مفعول للحالة: Los datos están guardados.\n- الفاعل بـ por: tomadas por el algoritmo\n- جمل اسم المفعول: Una vez tomada la decisión, ... (participio absoluto)"),
                    [("La IA tiene que ser ___. (regular)", "regulada", "regular"), ("Muchos empleos están ___ sustituidos.", "siendo", "ser"),
                     ("decisiones tomadas ___ el algoritmo", "por", "por"), ("Una vez ___ la decisión, ... (tomar)", "tomada", "tomar")]),
        },
    },
    {
        "key": "u10", "write_en": "differences you noticed between regions of one country", "write_ar": "فروق لاحظتها بين مناطق في نفس البلد",
        "words": """
austria | n | Austria | النمسا | Österreich | Oostenrijk | Austria
switzerland | n | Switzerland | سويسرا | die Schweiz | Zwitserland | Suiza
flanders | n | Flanders | فلاندرز | Flandern | Vlaanderen | Flandes
latin_america | n | Latin America | أمريكا اللاتينية | Lateinamerika | Latijns-Amerika | América Latina
accent | n | accent | لكنة | der Akzent, Akzente | het accent, accenten | el acento, acentos
variety | n | variety (of a language) | نوع / صيغة | die Varietät, Varietäten | de variant, varianten | la variedad, variedades
standard_language | n | standard language | اللغة الفصحى | die Standardsprache | de standaardtaal | la lengua estándar
pronunciation | n | pronunciation | نطق | die Aussprache | de uitspraak | la pronunciación
region | n | region | منطقة | die Region, Regionen | de regio, regio's | la región, regiones
regional | adj | regional | إقليمي | regional | regionaal | regional
local | adj | local | محلي | einheimisch | plaatselijk | local
""",
        "sentences": """
In Austria people say Jänner instead of Januar. | في النمسا بيقولوا Jänner بدل Januar. | In Österreich sagt man Jänner statt Januar. | In Oostenrijk zegt men Jänner in plaats van Januar. | En Austria se dice Jänner en lugar de Januar.
In Flanders the pronunciation is softer. | في فلاندرز النطق أنعم. | In Flandern ist die Aussprache weicher. | In Vlaanderen is de uitspraak zachter. | En Flandes la pronunciación es más suave.
In Latin America people say ustedes instead of vosotros. | في أمريكا اللاتينية بيقولوا ustedes بدل vosotros. | In Lateinamerika sagt man ustedes statt vosotros. | In Latijns-Amerika zegt men ustedes in plaats van vosotros. | En América Latina se dice ustedes en lugar de vosotros.
""",
        "grammar": {
            "de": G(("Regional variation", "الاختلاف الإقليمي"),
                    ("German is a pluricentric language: Germany, Austria and Switzerland each have a standard.\n- Austria: Jänner (Januar), Paradeiser (Tomate), heuer (dieses Jahr), Sackerl (Tüte); perfect of sitzen/stehen/liegen with sein: Ich bin gesessen.\n- Switzerland: no ß (Strasse), Velo (Fahrrad), parkieren (parken), grüezi.\n- South Germany: Grüß Gott, Servus; north: Moin.",
                     "الألماني لغة ليها أكتر من مركز: ألمانيا والنمسا وسويسرا كل واحدة ليها فصحى.\n- النمسا: Jänner (Januar)، Paradeiser (Tomate)، heuer (dieses Jahr)، Sackerl (Tüte)؛ والماضي التام لـ sitzen/stehen/liegen بـ sein: Ich bin gesessen.\n- سويسرا: مفيش ß (Strasse)، Velo (Fahrrad)، parkieren (parken)، grüezi.\n- جنوب ألمانيا: Grüß Gott، Servus؛ والشمال: Moin."),
                    [("Austria: Januar → ___", "Jänner", "Januar"), ("Switzerland: Fahrrad → ___", "Velo", "Fahrrad"),
                     ("Austria: Ich ___ gesessen. (auxiliary)", "bin", "sein"), ("Switzerland: Straße → ___", "Strasse", "Straße")]),
            "nl": G(("Netherlands and Flanders", "هولندا وفلاندرز"),
                    ("Dutch has two main standards, Netherlands Dutch and Belgian Dutch (Flemish):\n- Flemish uses gij/ge in speech and the diminutive -ke: manneke.\n- vocabulary: NL pinnen / BE bankkaart gebruiken, NL leuk / BE plezant (fun), NL bellen / BE telefoneren, NL op dit moment / BE momenteel, BE goesting (= zin).\n- Flemish pronunciation has a soft g and less 'r' variation; Dutch in the north has a hard g.",
                     "الهولندي ليه فصحتين أساسيتين: هولندي هولندا وهولندي بلجيكا (الفلمنكي):\n- الفلمنكي بيستخدم gij/ge في الكلام والتصغير ‎-ke: manneke.\n- كلمات: NL pinnen / BE bankkaart gebruiken، NL leuk / BE plezant (لطيف)، NL bellen / BE telefoneren، BE goesting (= zin، رغبة).\n- النطق الفلمنكي فيه g ناعمة؛ والهولندي في الشمال فيه g خشنة."),
                    [("Flemish 'you' in speech: ___", "gij", "jij"), ("Flemish: leuk → ___", "plezant", "leuk"),
                     ("Flemish diminutive: man → mann___", "eke", "-tje"), ("Flemish: zin → ___", "goesting", "zin")]),
            "es": G(("Spain and Latin America", "إسبانيا وأمريكا اللاتينية"),
                    ("Spanish varies across more than 20 countries:\n- Latin America uses ustedes for all plural 'you'; vosotros is only used in Spain.\n- voseo: vos instead of tú in Argentina, Uruguay and Central America: vos tenés, vos sos.\n- seseo: z/ce/ci pronounced like s in Latin America and parts of Spain.\n- vocabulary: coche / carro / auto, ordenador / computadora, móvil / celular, coger (Spain) / tomar.",
                     "الإسباني بيختلف في أكتر من ٢٠ بلد:\n- أمريكا اللاتينية بتستخدم ustedes لكل 'إنتو'؛ وvosotros في إسبانيا بس.\n- الـ voseo: vos بدل tú في الأرجنتين وأوروجواي وأمريكا الوسطى: vos tenés، vos sos.\n- الـ seseo: z/ce/ci بتتنطق s في أمريكا اللاتينية وأجزاء من إسبانيا.\n- كلمات: coche / carro / auto، ordenador / computadora، móvil / celular، coger (إسبانيا) / tomar."),
                    [("Latin America: vosotros → ___", "ustedes", "vosotros"), ("Argentina: tú eres → vos ___", "sos", "ser"),
                     ("Latin America: ordenador → ___", "computadora", "ordenador"), ("Latin America: móvil → ___", "celular", "móvil")]),
        },
    },
    {
        "key": "u11", "write_en": "the conclusion of a presentation on your favourite topic", "write_ar": "ختام عرض تقديمي عن موضوعك المفضل",
        "words": """
presentation | n | presentation | عرض تقديمي | die Präsentation, Präsentationen | de presentatie, presentaties | la presentación, presentaciones
audience | n | audience | جمهور | das Publikum | het publiek | el público
conclusion | n | conclusion | خاتمة | das Fazit, Fazits | de conclusie, conclusies | la conclusión, conclusiones
slide | n | slide (presentation) | شريحة | die Folie, Folien | de dia, dia's | la diapositiva, diapositivas
emphasise | v | to emphasise | يأكّد على | hervorheben | benadrukken | destacar
illustrate | v | to illustrate | يوضّح | veranschaulichen | illustreren | ilustrar
refute | v | to refute | يفنّد | widerlegen | weerleggen | refutar
moreover | adv | moreover | علاوة على ذلك | darüber hinaus | bovendien | además
first_of_all | phr | first of all | أولًا | zunächst | allereerst | en primer lugar
to_sum_up | phr | to sum up | باختصار | zusammenfassend | samenvattend | en resumen
as_mentioned | phr | as mentioned | زي ما قلت | wie bereits erwähnt | zoals gezegd | como ya se ha mencionado
""",
        "sentences": """
First of all I would like to thank the audience. | أولًا حابب أشكر الجمهور. | Zunächst möchte ich dem Publikum danken. | Allereerst wil ik het publiek bedanken. | En primer lugar quiero dar las gracias al público.
This slide illustrates the problem. | الشريحة دي بتوضّح المشكلة. | Diese Folie veranschaulicht das Problem. | Deze dia illustreert het probleem. | Esta diapositiva ilustra el problema.
To sum up, I would like to emphasise three points. | باختصار، حابب أأكّد على تلات نقط. | Zusammenfassend möchte ich drei Punkte hervorheben. | Samenvattend wil ik drie punten benadrukken. | En resumen, quiero destacar tres puntos.
""",
        "grammar": {
            "de": G(("Discourse markers", "علامات الخطاب"),
                    ("Discourse markers guide listeners through a talk:\n- opening: Zunächst möchte ich ... / Im Folgenden werde ich ...\n- moving on: Damit komme ich zum nächsten Punkt. / Kommen wir nun zu ...\n- referring back: Wie bereits erwähnt, ...\n- emphasising: Hervorzuheben ist, dass ... / Entscheidend ist ...\n- example: Nehmen wir zum Beispiel ...\n- closing: Zusammenfassend lässt sich sagen, dass ... / Vielen Dank für Ihre Aufmerksamkeit.",
                     "علامات الخطاب بتوجّه المستمعين خلال العرض:\n- البداية: Zunächst möchte ich ... / Im Folgenden werde ich ...\n- الانتقال: Damit komme ich zum nächsten Punkt. / Kommen wir nun zu ...\n- الرجوع لحاجة: Wie bereits erwähnt, ...\n- التأكيد: Hervorzuheben ist, dass ... / Entscheidend ist ...\n- مثال: Nehmen wir zum Beispiel ...\n- الختام: Zusammenfassend lässt sich sagen, dass ... / Vielen Dank für Ihre Aufmerksamkeit."),
                    [("Damit ___ ich zum nächsten Punkt.", "komme", "kommen"), ("Wie bereits ___, ...", "erwähnt", "erwähnen"),
                     ("Zusammenfassend ___ sich sagen, dass ...", "lässt", "lassen"), ("Vielen Dank für Ihre ___.", "Aufmerksamkeit", "Aufmerksamkeit")]),
            "nl": G(("Discourse markers", "علامات الخطاب"),
                    ("Signposts for a Dutch presentation:\n- opening: Allereerst wil ik ... / In deze presentatie ga ik ...\n- moving on: Dan kom ik nu bij het volgende punt.\n- referring back: Zoals gezegd, ... / Zoals ik al eerder zei, ...\n- emphasising: Belangrijk is dat ... / Ik wil benadrukken dat ...\n- example: Neem bijvoorbeeld ...\n- closing: Samenvattend kun je zeggen dat ... / Bedankt voor uw aandacht.",
                     "علامات لعرض تقديمي بالهولندي:\n- البداية: Allereerst wil ik ... / In deze presentatie ga ik ...\n- الانتقال: Dan kom ik nu bij het volgende punt.\n- الرجوع لحاجة: Zoals gezegd, ... / Zoals ik al eerder zei, ...\n- التأكيد: Belangrijk is dat ... / Ik wil benadrukken dat ...\n- مثال: Neem bijvoorbeeld ...\n- الختام: Samenvattend kun je zeggen dat ... / Bedankt voor uw aandacht."),
                    [("Dan ___ ik nu bij het volgende punt.", "kom", "komen"), ("Zoals ___, ... (as mentioned)", "gezegd", "zeggen"),
                     ("___ bijvoorbeeld ... (take)", "Neem", "nemen"), ("Bedankt voor uw ___.", "aandacht", "aandacht")]),
            "es": G(("Discourse markers", "علامات الخطاب"),
                    ("Signposts for a Spanish presentation:\n- opening: En primer lugar, ... / A continuación voy a ...\n- moving on: Paso ahora al siguiente punto. / Pasemos a ...\n- referring back: Como ya se ha mencionado, ...\n- emphasising: Cabe destacar que ... / Lo fundamental es ...\n- example: Pongamos por caso ... / Por ejemplo, ...\n- closing: En resumen, ... / Para concluir, ... / Muchas gracias por su atención.",
                     "علامات لعرض تقديمي بالإسباني:\n- البداية: En primer lugar, ... / A continuación voy a ...\n- الانتقال: Paso ahora al siguiente punto. / Pasemos a ...\n- الرجوع لحاجة: Como ya se ha mencionado, ...\n- التأكيد: Cabe destacar que ... / Lo fundamental es ...\n- مثال: Pongamos por caso ... / Por ejemplo, ...\n- الختام: En resumen, ... / Para concluir, ... / Muchas gracias por su atención."),
                    [("___ ahora al siguiente punto. (pasar, yo)", "Paso", "pasar"), ("Cabe ___ que ... (destacar)", "destacar", "destacar"),
                     ("Como ya se ha ___, ...", "mencionado", "mencionar"), ("Muchas gracias por su ___.", "atención", "atención")]),
        },
    },
]
