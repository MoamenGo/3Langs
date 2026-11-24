"""B2: units 1-13 (unit 14 is the review and mock exam).

words:     concept | pos | English | Arabic | German | Dutch | Spanish
sentences: English | Arabic | German | Dutch | Spanish
"""

CAN_DO = [
    {"en": "Understand the main ideas of complex texts, including technical discussions", "ar": "تفهم الأفكار الأساسية في نصوص معقدة، حتى النقاشات المتخصصة"},
    {"en": "Talk fluently and spontaneously with native speakers", "ar": "تتكلم بطلاقة وتلقائية مع أهل اللغة"},
    {"en": "Write clear, detailed texts and argue for and against a view", "ar": "تكتب نصوص واضحة ومفصلة وتناقش الرأي بالمع والضد"},
]


def G(title, text, exercises, table=None):
    g = {"title": title, "text": text, "exercises": exercises}
    if table:
        g["table"] = table
    return g


UNITS = [
    {
        "key": "u01", "write_en": "the career you want in ten years and how you will get there", "write_ar": "الشغل اللي نفسك فيه بعد عشر سنين وإزاي هتوصله",
        "words": """
career | n | career | مسار مهني | die Karriere, Karrieren | de loopbaan, loopbanen | la carrera profesional, carreras profesionales
management | n | management | إدارة | die Geschäftsführung | de directie, directies | la dirección, direcciones
promotion | n | promotion (at work) | ترقية | die Beförderung, Beförderungen | de promotie, promoties | el ascenso, ascensos
responsibility_job | n | area of responsibility | مسؤولية | die Verantwortung | de verantwoordelijkheid, verantwoordelijkheden | la responsabilidad, responsabilidades
negotiate | v | to negotiate | يتفاوض | verhandeln | onderhandelen | negociar
decision | n | decision | قرار | die Entscheidung, Entscheidungen | de beslissing, beslissingen | la decisión, decisiones
development | n | development | تطوير | die Entwicklung, Entwicklungen | de ontwikkeling, ontwikkelingen | el desarrollo, desarrollos
achieve | v | to achieve | يحقق | erreichen | bereiken | lograr
staff | n | staff, workforce | الموظفين | die Belegschaft, Belegschaften | het personeel | la plantilla, plantillas
self_employed | adj | self-employed | شغال لحسابه | selbstständig | zelfstandig | autónomo
""",
        "sentences": """
The decision about my promotion comes next week. | القرار بتاع ترقيتي هيطلع الأسبوع الجاي. | Die Entscheidung über meine Beförderung kommt nächste Woche. | De beslissing over mijn promotie komt volgende week. | La decisión sobre mi ascenso llega la semana que viene.
The development of the staff is important to us. | تطوير الموظفين مهم بالنسبة لنا. | Die Entwicklung der Belegschaft ist uns wichtig. | De ontwikkeling van het personeel is belangrijk voor ons. | El desarrollo de la plantilla es importante para nosotros.
She wants to achieve a lot in her career. | هي عايزة تحقق حاجات كتير في مسارها المهني. | Sie möchte in ihrer Karriere viel erreichen. | Ze wil veel bereiken in haar loopbaan. | Quiere lograr mucho en su carrera profesional.
""",
        "grammar": {
            "de": G(("Nominalisation", "تحويل الفعل لاسم"),
                    ("Formal German often turns verbs and adjectives into nouns. Common patterns:\n- verb stem + -ung (feminine): entscheiden → die Entscheidung, entwickeln → die Entwicklung\n- infinitive as a neuter noun: verhandeln → das Verhandeln\n- adjective + -heit/-keit (feminine): frei → die Freiheit, möglich → die Möglichkeit\n\nThe object of the verb becomes a genitive: Man entwickelt die Firma → die Entwicklung der Firma.",
                     "الألماني الرسمي بيحوّل أفعال وصفات كتير لأسماء. أشهر الطرق:\n- جذر الفعل + ‎-ung (مؤنث): entscheiden ← die Entscheidung، entwickeln ← die Entwicklung\n- المصدر كاسم محايد: verhandeln ← das Verhandeln\n- الصفة + ‎-heit/-keit (مؤنث): frei ← die Freiheit، möglich ← die Möglichkeit\n\nمفعول الفعل بيبقى في حالة الإضافة: Man entwickelt die Firma ← die Entwicklung der Firma."),
                    [("entscheiden → die ___", "Entscheidung", "entscheiden"), ("befördern → die ___", "Beförderung", "befördern"),
                     ("möglich → die ___", "Möglichkeit", "möglich"), ("die Entwicklung ___ Firma (genitive)", "der", "die")]),
            "nl": G(("Nominalisation", "تحويل الفعل لاسم"),
                    ("Dutch makes nouns from verbs and adjectives like this:\n- verb stem + -ing (de-word): beslissen → de beslissing, ontwikkelen → de ontwikkeling\n- infinitive as a het-word: het onderhandelen, het lezen\n- adjective + -heid (de-word): vrij → de vrijheid, verantwoordelijk → de verantwoordelijkheid\n\nThe object follows with van: de ontwikkeling van het personeel.",
                     "الهولندي بيعمل أسماء من الأفعال والصفات كده:\n- جذر الفعل + ‎-ing (كلمة de): beslissen ← de beslissing، ontwikkelen ← de ontwikkeling\n- المصدر ككلمة het: het onderhandelen، het lezen\n- الصفة + ‎-heid (كلمة de): vrij ← de vrijheid، verantwoordelijk ← de verantwoordelijkheid\n\nوالمفعول بييجي بعدها بـ van: de ontwikkeling van het personeel."),
                    [("beslissen → de ___", "beslissing", "beslissen"), ("ontwikkelen → de ___", "ontwikkeling", "ontwikkelen"),
                     ("vrij → de ___", "vrijheid", "vrij"), ("___ onderhandelen kost tijd. (article)", "Het", "het")]),
            "es": G(("Nominalisation", "تحويل الفعل لاسم"),
                    ("Spanish forms nouns from verbs with suffixes such as -ción/-sión (feminine), -miento (masculine) and -dad (feminine, from adjectives): decidir → la decisión, desarrollar → el desarrollo, crecer → el crecimiento, responsable → la responsabilidad.\n\nThe infinitive can also act as a noun with el: El negociar no es fácil. The object follows with de: el desarrollo de la plantilla.",
                     "الإسباني بيعمل أسماء من الأفعال بلواحق زي ‎-ción/-sión (مؤنث)، ‎-miento (مذكر)، و‎-dad (مؤنث، من الصفات): decidir ← la decisión، desarrollar ← el desarrollo، crecer ← el crecimiento، responsable ← la responsabilidad.\n\nوالمصدر ممكن يبقى اسم مع el: El negociar no es fácil. والمفعول بييجي بعده بـ de: el desarrollo de la plantilla."),
                    [("decidir → la ___", "decisión", "decidir"), ("crecer → el ___", "crecimiento", "crecer"),
                     ("responsable → la ___", "responsabilidad", "responsable"), ("el desarrollo ___ la empresa", "de", "de")]),
        },
    },
    {
        "key": "u02", "write_en": "how globalisation changes the products you buy", "write_ar": "إزاي العولمة بتغيّر المنتجات اللي بتشتريها",
        "words": """
economy | n | economy | اقتصاد | die Wirtschaft | de economie, economieën | la economía, economías
market | n | market (economy) | سوق | der Markt, Märkte | de markt, markten | el mercado, mercados
trade | n | trade | تجارة | der Handel | de handel | el comercio
growth | n | growth | نمو | das Wachstum | de groei | el crecimiento
export | v | to export | يصدّر | exportieren | exporteren | exportar
import_v | v | to import | يستورد | importieren | importeren | importar
competition | n | competition | منافسة | die Konkurrenz | de concurrentie | la competencia
consumer | n | consumer | مستهلك | der Verbraucher, Verbraucher | de consument, consumenten | el consumidor, consumidores
rise | v | to rise | يزيد | steigen | stijgen | subir
crisis | n | crisis | أزمة | die Krise, Krisen | de crisis, crises | la crisis, crisis
""",
        "sentences": """
The rising prices worry the consumers. | الأسعار اللي بتزيد مقلقة المستهلكين. | Die steigenden Preise beunruhigen die Verbraucher. | De stijgende prijzen maken de consumenten ongerust. | Los precios que suben preocupan a los consumidores.
The economy grew after the crisis. | الاقتصاد نما بعد الأزمة. | Die Wirtschaft ist nach der Krise gewachsen. | De economie is na de crisis gegroeid. | La economía creció después de la crisis.
Germany exports many cars. | ألمانيا بتصدّر عربيات كتير. | Deutschland exportiert viele Autos. | Duitsland exporteert veel auto's. | Alemania exporta muchos coches.
""",
        "grammar": {
            "de": G(("Extended participle attributes", "الصفة الممتدة بالـ Partizip"),
                    ("Written German packs a whole relative clause before the noun, using a participle as an adjective:\n- Partizip I (active, ongoing): die steigenden Preise = die Preise, die steigen\n- Partizip II (passive or completed): das im Ausland produzierte Auto = das Auto, das im Ausland produziert wurde\n\nEverything between the article and the noun belongs to the attribute: die seit Jahren stark wachsende Wirtschaft. The participle takes normal adjective endings.",
                     "الألماني المكتوب بيحط جملة موصولة كاملة قبل الاسم، وبيستخدم الـ Partizip كصفة:\n- Partizip I (فاعل، مستمر): die steigenden Preise = die Preise, die steigen\n- Partizip II (مبني للمجهول أو خلص): das im Ausland produzierte Auto = das Auto, das im Ausland produziert wurde\n\nكل اللي بين أداة التعريف والاسم تبع الصفة: die seit Jahren stark wachsende Wirtschaft. والـ Partizip بياخد نهايات الصفة العادية."),
                    [("die ___ Preise (steigen, Partizip I)", "steigenden", "steigen"), ("das im Ausland ___ Auto (produzieren, Partizip II)", "produzierte", "produzieren"),
                     ("die stark ___ Wirtschaft (wachsen, Partizip I)", "wachsende", "wachsen"), ("die ___ Waren (importieren, Partizip II)", "importierten", "importieren")]),
            "nl": G(("Participles as adjectives", "اسم الفاعل والمفعول كصفة"),
                    ("Dutch also uses participles before a noun, with the normal -e ending:\n- present participle (infinitive + -d): stijgen → de stijgende prijzen\n- past participle: de in China geproduceerde telefoon (= die in China is geproduceerd)\n\nThese structures are common in newspapers. In speech a relative clause is more usual: de prijzen die stijgen.",
                     "الهولندي برضه بيستخدم الـ participle قبل الاسم بالنهاية العادية ‎-e:\n- اسم الفاعل (المصدر + ‎-d): stijgen ← de stijgende prijzen\n- اسم المفعول: de in China geproduceerde telefoon (= die in China is geproduceerd)\n\nالتركيب ده منتشر في الجرايد. وفي الكلام الجملة الموصولة أشهر: de prijzen die stijgen."),
                    [("de ___ prijzen (stijgen)", "stijgende", "stijgen"), ("de in China ___ telefoon (produceren)", "geproduceerde", "produceren"),
                     ("de ___ economie (groeien, present)", "groeiende", "groeien"), ("het ___ product (importeren, past)", "geïmporteerde", "importeren")]),
            "es": G(("Participles and gerunds as modifiers", "اسم المفعول والـ gerundio كوصف"),
                    ("The past participle works as an adjective and agrees with the noun: los productos importados, la economía globalizada.\n\nSpanish has few present participles (-ante/-iente: creciente, siguiente): una demanda creciente. Usually a relative clause is used instead: los precios que suben.\n\nThe gerund (-ando/-iendo) is not used as an adjective before a noun.",
                     "اسم المفعول بيشتغل كصفة وبيتطابق مع الاسم: los productos importados، la economía globalizada.\n\nالإسباني فيه اسم فاعل قليل (‎-ante/-iente: creciente، siguiente): una demanda creciente. وغالبًا بتستخدم جملة موصولة بداله: los precios que suben.\n\nوالـ gerundio (‎-ando/-iendo) ما بيتستخدمش كصفة قبل الاسم."),
                    [("los productos ___ (importar)", "importados", "importar"), ("la economía ___ (globalizar)", "globalizada", "globalizar"),
                     ("una demanda ___ (crecer, -iente)", "creciente", "crecer"), ("los precios que ___ (subir)", "suben", "subir")]),
        },
    },
    {
        "key": "u03", "write_en": "a scientific discovery that changed everyday life", "write_ar": "اكتشاف علمي غيّر الحياة اليومية",
        "words": """
experiment | n | experiment | تجربة علمية | das Experiment, Experimente | het experiment, experimenten | el experimento, experimentos
theory | n | theory | نظرية | die Theorie, Theorien | de theorie, theorieën | la teoría, teorías
result | n | result | نتيجة | das Ergebnis, Ergebnisse | het resultaat, resultaten | el resultado, resultados
research_n | n | research | بحث علمي | die Forschung, Forschungen | het onderzoek, onderzoeken | la investigación, investigaciones
researcher | n | researcher | باحث | der Forscher, Forscher | de onderzoeker, onderzoekers | el investigador, investigadores
prove | v | to prove | يثبت | beweisen | bewijzen | demostrar
measure | v | to measure | يقيس | messen | meten | medir
discovery | n | discovery | اكتشاف | die Entdeckung, Entdeckungen | de ontdekking, ontdekkingen | el descubrimiento, descubrimientos
explainable | adj | explainable | ممكن يتشرح | erklärbar | verklaarbaar | explicable
laboratory | n | laboratory | معمل | das Labor, Labore | het laboratorium, laboratoria | el laboratorio, laboratorios
""",
        "sentences": """
The result can easily be measured. | النتيجة ممكن تتقاس بسهولة. | Das Ergebnis lässt sich leicht messen. | Het resultaat is makkelijk te meten. | El resultado se puede medir fácilmente.
The theory has not been proven yet. | النظرية لسه ما اتثبتتش. | Die Theorie ist noch nicht bewiesen. | De theorie is nog niet bewezen. | La teoría todavía no se ha demostrado.
The researcher works in a laboratory. | الباحث بيشتغل في معمل. | Der Forscher arbeitet in einem Labor. | De onderzoeker werkt in een laboratorium. | El investigador trabaja en un laboratorio.
""",
        "grammar": {
            "de": G(("Alternatives to the passive", "بدائل المبني للمجهول"),
                    ("Instead of kann ... werden, German often says:\n- sich lassen + infinitive: Das Ergebnis lässt sich messen. (= kann gemessen werden)\n- adjective in -bar: Das ist messbar / erklärbar.\n- sein + zu + infinitive (can or must): Das Problem ist leicht zu lösen. Die Regeln sind zu beachten.\n- man: Man misst das Ergebnis.",
                     "بدل kann ... werden، الألماني كتير بيقول:\n- sich lassen + مصدر: Das Ergebnis lässt sich messen. (= kann gemessen werden)\n- صفة بـ ‎-bar: Das ist messbar / erklärbar.\n- sein + zu + مصدر (ممكن أو لازم): Das Problem ist leicht zu lösen. Die Regeln sind zu beachten.\n- man: Man misst das Ergebnis."),
                    [("Das Ergebnis ___ sich leicht messen.", "lässt", "lassen"), ("Das ist leicht ___. (erklären → -bar)", "erklärbar", "erklären"),
                     ("Das Problem ist leicht ___ lösen.", "zu", "zu"), ("Das Ergebnis ist mess___. (-bar)", "bar", "-bar")]),
            "nl": G(("Alternatives to the passive", "بدائل المبني للمجهول"),
                    ("Dutch alternatives to kan ... worden:\n- adjective in -baar: meetbaar, verklaarbaar, bereikbaar\n- zijn + te + infinitive: Het resultaat is makkelijk te meten. Dat is niet te geloven.\n- men or je: Men meet het resultaat. Je kunt het meten.\n- laten + infinitive with zich is rare in Dutch: use te + infinitive instead.",
                     "بدائل الهولندي لـ kan ... worden:\n- صفة بـ ‎-baar: meetbaar، verklaarbaar، bereikbaar\n- zijn + te + مصدر: Het resultaat is makkelijk te meten. Dat is niet te geloven.\n- men أو je: Men meet het resultaat. Je kunt het meten.\n- laten + مصدر مع zich نادر في الهولندي: استخدم te + مصدر بداله."),
                    [("Het resultaat is makkelijk ___ meten.", "te", "te"), ("verklaren → ___ (-baar)", "verklaarbaar", "verklaren"),
                     ("Dat is niet te ___. (geloven)", "geloven", "geloven"), ("___ meet het resultaat. (formal 'one')", "Men", "men")]),
            "es": G(("The passive with se", "المبني للمجهول بـ se"),
                    ("Spanish prefers the pasiva refleja to ser + participle: se + verb in 3rd person, agreeing with the thing:\n- Se mide el resultado. Se miden los resultados.\n- Se venden pisos. Aquí se habla alemán.\n\nWith poder: El resultado se puede medir. Ser + participle (fue demostrado) sounds formal or academic. Adjectives in -ble: medible, explicable.",
                     "الإسباني بيفضّل الـ pasiva refleja عن ser + اسم مفعول: se + فعل في الغايب، متطابق مع الحاجة:\n- Se mide el resultado. Se miden los resultados.\n- Se venden pisos. Aquí se habla alemán.\n\nمع poder: El resultado se puede medir. وser + اسم مفعول (fue demostrado) بيبان رسمي أو أكاديمي. والصفات بـ ‎-ble: medible، explicable."),
                    [("___ miden los resultados.", "Se", "se"), ("Se ___ pisos. (vender)", "venden", "vender"),
                     ("El resultado se ___ medir. (poder)", "puede", "poder"), ("explicar → ___ (-ble)", "explicable", "explicar")]),
        },
    },
    {
        "key": "u04", "write_en": "how you check if a news story is true", "write_ar": "إزاي بتتأكد إن الخبر صح",
        "words": """
source | n | source | مصدر | die Quelle, Quellen | de bron, bronnen | la fuente, fuentes
claim | v | to claim | يدّعي | behaupten | beweren | afirmar
report_v | v | to report | يبلّغ عن | berichten | berichten | informar sobre
fake | adj | fake | مزيف | gefälscht | nep | falso
headline | n | headline | عنوان رئيسي | die Schlagzeile, Schlagzeilen | de kop, koppen | el titular, titulares
journalist | n | journalist | صحفي | der Journalist, Journalisten | de journalist, journalisten | el periodista, periodistas
reliable | adj | reliable | موثوق | zuverlässig | betrouwbaar | fiable
influence | n | influence | تأثير | der Einfluss, Einflüsse | de invloed, invloeden | la influencia, influencias
spread | v | to spread | ينتشر / ينشر | verbreiten | verspreiden | difundir
statement | n | statement | تصريح | die Aussage, Aussagen | de uitspraak, uitspraken | la declaración, declaraciones
""",
        "sentences": """
The minister claims that the source is reliable. | الوزير بيدّعي إن المصدر موثوق. | Der Minister behauptet, die Quelle sei zuverlässig. | De minister beweert dat de bron betrouwbaar is. | El ministro afirma que la fuente es fiable.
The journalist said he had no time. | الصحفي قال إنه ماكانش عنده وقت. | Der Journalist sagte, er habe keine Zeit gehabt. | De journalist zei dat hij geen tijd had gehad. | El periodista dijo que no había tenido tiempo.
Fake news spreads quickly. | الأخبار المزيفة بتنتشر بسرعة. | Gefälschte Nachrichten verbreiten sich schnell. | Nepnieuws verspreidt zich snel. | Las noticias falsas se difunden rápido.
""",
        "grammar": {
            "de": G(("Indirect speech: Konjunktiv I", "الكلام المنقول: Konjunktiv I"),
                    ("News reports use Konjunktiv I to show that a statement is someone else's. Form: infinitive stem + -e, -est, -e, -en, -et, -en. In practice the 3rd person singular matters most: er habe, sie komme, er wisse, er könne. sein is irregular: ich sei, er sei, sie seien.\n\nPast: habe/sei + participle: Er sagte, er habe keine Zeit gehabt.\n\nWhen Konjunktiv I looks like the indicative (wir haben), use Konjunktiv II: Sie sagten, sie hätten keine Zeit.",
                     "الأخبار بتستخدم Konjunktiv I عشان توضّح إن الكلام ده كلام حد تاني. التكوين: جذر المصدر + ‎-e, -est, -e, -en, -et, -en. وعمليًا الغايب المفرد هو الأهم: er habe، sie komme، er wisse، er könne. وsein شاذ: ich sei، er sei، sie seien.\n\nالماضي: habe/sei + Partizip: Er sagte, er habe keine Zeit gehabt.\n\nولو الـ Konjunktiv I شبه الـ Indikativ (wir haben)، استخدم Konjunktiv II: Sie sagten, sie hätten keine Zeit."),
                    [("Er behauptet, die Quelle ___ zuverlässig. (sein)", "sei", "sein"), ("Sie sagt, sie ___ keine Zeit. (haben)", "habe", "haben"),
                     ("Er meint, er ___ morgen. (kommen)", "komme", "kommen"), ("Sie sagten, sie ___ keine Zeit. (haben, KII)", "hätten", "haben")],
                    [["", "sein", "haben", "können"], ["ich", "sei", "habe", "könne"], ["er/sie", "sei", "habe", "könne"], ["sie/Sie", "seien", "hätten", "könnten"]]),
            "nl": G(("Indirect speech", "الكلام المنقول"),
                    ("Dutch has no special verb form for indirect speech. Use dat + subordinate clause and shift the tense back after a past verb:\n- 'Ik heb geen tijd.' → Hij zei dat hij geen tijd had.\n- 'Ik heb het gedaan.' → Ze zei dat ze het had gedaan.\n- 'Ik kom morgen.' → Hij zei dat hij de volgende dag zou komen.\n\nQuestions use of or a question word: Ze vroeg of ik kwam. Ze vroeg waar ik woonde.",
                     "الهولندي مالوش صيغة فعل خاصة بالكلام المنقول. استخدم dat + جملة فرعية وارجع بالزمن لورا بعد فعل ماضي:\n- 'Ik heb geen tijd.' ← Hij zei dat hij geen tijd had.\n- 'Ik heb het gedaan.' ← Ze zei dat ze het had gedaan.\n- 'Ik kom morgen.' ← Hij zei dat hij de volgende dag zou komen.\n\nالأسئلة بتستخدم of أو أداة سؤال: Ze vroeg of ik kwam. Ze vroeg waar ik woonde."),
                    [("'Ik heb geen tijd.' → Hij zei dat hij geen tijd ___.", "had", "hebben"), ("'Ik kom morgen.' → Hij zei dat hij de volgende dag ___ komen.", "zou", "zullen"),
                     ("Ze vroeg ___ ik kwam. (whether)", "of", "of"), ("De minister beweert ___ de bron betrouwbaar is.", "dat", "dat")]),
            "es": G(("Reported speech", "الكلام المنقول"),
                    ("After a past reporting verb (dijo, afirmó, explicó) the tenses shift back:\n- presente → imperfecto: 'No tengo tiempo.' → Dijo que no tenía tiempo.\n- indefinido/perfecto → pluscuamperfecto: 'No he tenido tiempo.' → Dijo que no había tenido tiempo.\n- futuro → condicional: 'Vendré.' → Dijo que vendría.\n\nCommands become subjunctive: 'Ven.' → Me dijo que viniera.",
                     "بعد فعل نقل في الماضي (dijo، afirmó، explicó) الأزمنة بترجع لورا:\n- presente ← imperfecto: 'No tengo tiempo.' ← Dijo que no tenía tiempo.\n- indefinido/perfecto ← pluscuamperfecto: 'No he tenido tiempo.' ← Dijo que no había tenido tiempo.\n- futuro ← condicional: 'Vendré.' ← Dijo que vendría.\n\nوالأوامر بتبقى subjuntivo: 'Ven.' ← Me dijo que viniera."),
                    [("'No tengo tiempo.' → Dijo que no ___ tiempo.", "tenía", "tener"), ("'Vendré.' → Dijo que ___.", "vendría", "venir"),
                     ("'He terminado.' → Dijo que ___ terminado.", "había", "haber"), ("'Ven.' → Me dijo que ___.", "viniera", "venir")]),
        },
    },
    {
        "key": "u05", "write_en": "a tradition from your country that you would keep or change", "write_ar": "عادة من بلدك تحب تحافظ عليها أو تغيّرها",
        "words": """
value | n | value (moral) | قيمة | der Wert, Werte | de waarde, waarden | el valor, valores
equality | n | equality | مساواة | die Gleichberechtigung | de gelijkheid | la igualdad
tradition | n | tradition | تقليد | die Tradition, Traditionen | de traditie, tradities | la tradición, tradiciones
respect_n | n | respect | احترام | der Respekt | het respect | el respeto
prejudice | n | prejudice | حكم مسبق | das Vorurteil, Vorurteile | het vooroordeel, vooroordelen | el prejuicio, prejuicios
tolerant | adj | tolerant | متسامح | tolerant | tolerant | tolerante
religion | n | religion | دين | die Religion, Religionen | de religie, religies | la religión, religiones
society | n | society | مجتمع | die Gesellschaft, Gesellschaften | de samenleving, samenlevingen | la sociedad, sociedades
justice | n | justice | عدالة | die Gerechtigkeit | de rechtvaardigheid | la justicia
generation | n | generation | جيل | die Generation, Generationen | de generatie, generaties | la generación, generaciones
""",
        "sentences": """
Every society has its own values. | كل مجتمع ليه قيمه الخاصة. | Jede Gesellschaft hat ihre eigenen Werte. | Elke samenleving heeft haar eigen waarden. | Cada sociedad tiene sus propios valores.
Just look, that is an old tradition! | بص بقى، دي عادة قديمة! | Schau mal, das ist doch eine alte Tradition! | Kijk maar, dat is toch een oude traditie! | ¡Mira, si es una tradición antigua!
The young generation is more tolerant. | الجيل الصغير أكتر تسامح. | Die junge Generation ist toleranter. | De jonge generatie is toleranter. | La generación joven es más tolerante.
""",
        "grammar": {
            "de": G(("Modal particles: doch, mal, ja, eben", "كلمات النبرة: doch، mal، ja، eben"),
                    ("Modal particles add tone, not content. They are unstressed and come after the verb and pronouns:\n- ja: something we both know: Das ist ja interessant.\n- doch: contradiction or a gentle push: Komm doch mit! Das ist doch klar.\n- mal: makes a request casual: Schau mal! Kannst du mal helfen?\n- eben/halt: that's just how it is: Das ist eben so.",
                     "كلمات النبرة بتضيف إحساس مش معنى. بتيجي من غير ضغط بعد الفعل والضماير:\n- ja: حاجة إحنا الاتنين عارفينها: Das ist ja interessant.\n- doch: اعتراض أو دفعة لطيفة: Komm doch mit! Das ist doch klar.\n- mal: بتخلي الطلب خفيف: Schau mal! Kannst du mal helfen?\n- eben/halt: هو كده بقى: Das ist eben so."),
                    [("Komm ___ mit! (gentle push)", "doch", "doch"), ("Kannst du ___ helfen? (casual request)", "mal", "mal"),
                     ("Das ist ___ so. (that's how it is)", "eben", "eben"), ("Du weißt ___, dass ich keine Zeit habe. (shared knowledge)", "ja", "ja")]),
            "nl": G(("Modal particles: maar, even, toch, wel", "كلمات النبرة: maar، even، toch، wel"),
                    ("Dutch modal particles soften or colour a sentence:\n- even: makes a request short and polite: Kun je even helpen?\n- maar: encourages: Kom maar binnen. Kijk maar.\n- toch: you agree, don't you? / contradiction: Dat is toch duidelijk?\n- wel: yes, actually (against doubt): Hij komt wel. Dat is wel mooi.\nThey are often combined: Kom maar even zitten.",
                     "كلمات النبرة في الهولندي بتلطّف الجملة أو تلوّنها:\n- even: بتخلي الطلب قصير ومؤدب: Kun je even helpen?\n- maar: تشجيع: Kom maar binnen. Kijk maar.\n- toch: مش كده؟ / اعتراض: Dat is toch duidelijk?\n- wel: لأ، ده فعلًا (ضد الشك): Hij komt wel. Dat is wel mooi.\nوكتير بتتجمع: Kom maar even zitten."),
                    [("Kun je ___ helpen? (short, polite)", "even", "even"), ("Kom ___ binnen! (encouraging)", "maar", "maar"),
                     ("Dat is ___ duidelijk? (isn't it)", "toch", "toch"), ("Hij komt ___. (yes, he will)", "wel", "wel")]),
            "es": G(("Discourse particles: pues, si, es que, vaya", "كلمات الكلام: pues، si، es que، vaya"),
                    ("Spoken Spanish uses small words to add tone:\n- pues: well, so: Pues no sé. Pues vamos.\n- si at the start of an exclamation: but obviously: ¡Si es una tradición antigua!\n- es que: giving an excuse or reason: Es que no tengo tiempo.\n- vaya / anda: surprise: ¡Vaya, qué bonito!\n- ¿no? / ¿verdad? at the end: asking for agreement.",
                     "الإسباني المتكلم بيستخدم كلمات صغيرة عشان يضيف نبرة:\n- pues: طب، يعني: Pues no sé. Pues vamos.\n- si في أول جملة تعجب: ما هو واضح أهو: ¡Si es una tradición antigua!\n- es que: لما تدي عذر أو سبب: Es que no tengo tiempo.\n- vaya / anda: مفاجأة: ¡Vaya, qué bonito!\n- ¿no? / ¿verdad? في الآخر: بتطلب موافقة."),
                    [("___ que no tengo tiempo. (excuse)", "Es", "es"), ("___ no sé... (well)", "Pues", "pues"),
                     ("¡___, qué bonito! (surprise)", "Vaya", "vaya"), ("Es tolerante, ¿___? (right?)", "verdad", "verdad")]),
        },
    },
    {
        "key": "u06", "write_en": "what our cities will look like in 2050", "write_ar": "مدننا هتبقى شكلها إيه سنة ٢٠٥٠",
        "words": """
energy | n | energy | طاقة | die Energie, Energien | de energie | la energía, energías
sustainable | adj | sustainable | مستدام | nachhaltig | duurzaam | sostenible
climate_change | n | climate change | تغير المناخ | der Klimawandel | de klimaverandering | el cambio climático
solar_energy | n | solar energy | طاقة شمسية | die Solarenergie | de zonne-energie | la energía solar
emissions | n | emissions | انبعاثات | die Emission, Emissionen | de uitstoot | la emisión, emisiones
reduce | v | to reduce | يقلل | verringern | verminderen | reducir
consumption | n | consumption | استهلاك | der Verbrauch | het verbruik | el consumo
resources | n | resources | موارد | die Ressource, Ressourcen | de grondstof, grondstoffen | el recurso, recursos
predict | v | to predict | يتوقع | vorhersagen | voorspellen | predecir
by_then | adv | by then | ساعتها | bis dahin | tegen die tijd | para entonces
""",
        "sentences": """
By then we will have reduced our consumption. | ساعتها هنكون قللنا استهلاكنا. | Bis dahin werden wir unseren Verbrauch verringert haben. | Tegen die tijd zullen we ons verbruik verminderd hebben. | Para entonces habremos reducido nuestro consumo.
Solar energy is sustainable. | الطاقة الشمسية مستدامة. | Solarenergie ist nachhaltig. | Zonne-energie is duurzaam. | La energía solar es sostenible.
Nobody can predict the future exactly. | محدش يقدر يتوقع المستقبل بالظبط. | Niemand kann die Zukunft genau vorhersagen. | Niemand kan de toekomst precies voorspellen. | Nadie puede predecir el futuro con exactitud.
""",
        "grammar": {
            "de": G(("Future II and assumptions", "المستقبل التام والتخمين"),
                    ("Future II = werden + past participle + haben/sein. It says something will be finished by a point in the future: Bis 2050 werden wir den Verbrauch verringert haben.\n\nIt also expresses an assumption about the past: Er wird den Zug verpasst haben. (= He has probably missed the train.) Future I does the same for the present: Sie wird zu Hause sein. (= She is probably at home.)",
                     "المستقبل التام = werden + Partizip II + haben/sein. بيقول إن حاجة هتكون خلصت قبل وقت في المستقبل: Bis 2050 werden wir den Verbrauch verringert haben.\n\nوبيعبّر كمان عن تخمين عن الماضي: Er wird den Zug verpasst haben. (= غالبًا فاته القطر.) والمستقبل العادي بيعمل نفس الحاجة للحاضر: Sie wird zu Hause sein. (= غالبًا هي في البيت.)"),
                    [("Bis 2050 ___ wir den Verbrauch verringert haben.", "werden", "werden"), ("Er wird den Zug verpasst ___.", "haben", "haben"),
                     ("Sie wird schon nach Hause gegangen ___.", "sein", "sein"), ("Er ___ krank sein. (probably, present)", "wird", "werden")]),
            "nl": G(("Future perfect and assumptions", "المستقبل التام والتخمين"),
                    ("Future perfect = zullen + past participle + hebben/zijn: Tegen 2050 zullen we ons verbruik verminderd hebben.\n\nzullen also expresses a guess: Hij zal de trein wel gemist hebben. (= He probably missed the train.) Ze zal wel thuis zijn. The particle wel makes the guess clearer.",
                     "المستقبل التام = zullen + اسم مفعول + hebben/zijn: Tegen 2050 zullen we ons verbruik verminderd hebben.\n\nوzullen بيعبّر برضه عن تخمين: Hij zal de trein wel gemist hebben. (= غالبًا فاته القطر.) Ze zal wel thuis zijn. وكلمة wel بتوضّح إنه تخمين."),
                    [("Tegen 2050 ___ we ons verbruik verminderd hebben.", "zullen", "zullen"), ("Hij zal de trein wel gemist ___.", "hebben", "hebben"),
                     ("Ze zal ___ thuis zijn. (probably)", "wel", "wel"), ("Ze zullen al vertrokken ___.", "zijn", "zijn")]),
            "es": G(("Futuro perfecto and probability", "المستقبل التام والاحتمال"),
                    ("Futuro perfecto = haber in the future (habré, habrás, habrá, habremos, habréis, habrán) + participle: Para 2050 habremos reducido el consumo.\n\nThe future also expresses probability: ¿Dónde está Ana? Estará en casa. (= She is probably at home.) The futuro perfecto does this for the recent past: Habrá perdido el tren. (= He has probably missed the train.)",
                     "المستقبل التام = haber في المستقبل (habré, habrás, habrá, habremos, habréis, habrán) + اسم مفعول: Para 2050 habremos reducido el consumo.\n\nوالمستقبل بيعبّر برضه عن احتمال: ¿Dónde está Ana? Estará en casa. (= غالبًا في البيت.) والمستقبل التام بيعمل كده للماضي القريب: Habrá perdido el tren. (= غالبًا فاته القطر.)"),
                    [("Para 2050 ___ reducido el consumo. (nosotros)", "habremos", "haber"), ("___ perdido el tren. (él, probably)", "Habrá", "haber"),
                     ("Ana ___ en casa. (probably, estar)", "estará", "estar"), ("Para entonces ya ___ terminado. (yo)", "habré", "haber")]),
        },
    },
    {
        "key": "u07", "write_en": "how you deal with stress", "write_ar": "إزاي بتتعامل مع الضغط",
        "words": """
stress | n | stress | ضغط عصبي | der Stress | de stress | el estrés
mind | n | mind | عقل | der Verstand | het verstand | la mente, mentes
behaviour | n | behaviour | سلوك | das Verhalten | het gedrag | el comportamiento, comportamientos
anxiety | n | anxiety | قلق | die Angst, Ängste | de angst, angsten | la ansiedad, ansiedades
self_confidence | n | self-confidence | ثقة بالنفس | das Selbstvertrauen | het zelfvertrouwen | la autoestima
depressed | adj | depressed | مكتئب | deprimiert | depressief | deprimido
cope | v | to cope (with) | يتعامل مع | bewältigen | omgaan met | afrontar
relax | v | to relax | يسترخي | sich entspannen | ontspannen | relajarse
therapy | n | therapy | علاج نفسي | die Therapie, Therapien | de therapie, therapieën | la terapia, terapias
burnout | n | burnout | احتراق نفسي | das Burn-out | de burn-out | el agotamiento
""",
        "sentences": """
He must be very stressed. | أكيد عنده ضغط جامد. | Er muss sehr gestresst sein. | Hij moet erg gestrest zijn. | Debe de estar muy estresado.
Therapy can help with anxiety. | العلاج النفسي ممكن يساعد في القلق. | Eine Therapie kann bei Angst helfen. | Therapie kan helpen bij angst. | La terapia puede ayudar con la ansiedad.
She is said to have a lot of self-confidence. | بيقولوا عندها ثقة بالنفس كبيرة. | Sie soll viel Selbstvertrauen haben. | Ze schijnt veel zelfvertrouwen te hebben. | Dicen que tiene mucha autoestima.
""",
        "grammar": {
            "de": G(("Subjective use of modal verbs", "الاستخدام التقديري لأفعال الوجه"),
                    ("Modal verbs can show how sure the speaker is:\n- muss: almost certain: Er muss gestresst sein.\n- dürfte: probable: Das dürfte stimmen.\n- kann/könnte: possible: Sie könnte krank sein.\n- soll: people say: Sie soll sehr reich sein.\n- will: he claims: Er will alles allein geschafft haben.\n\nFor the past: modal + participle + haben/sein: Er muss den Bus verpasst haben.",
                     "أفعال الوجه ممكن توضّح المتكلم متأكد قد إيه:\n- muss: متأكد تقريبًا: Er muss gestresst sein.\n- dürfte: غالبًا: Das dürfte stimmen.\n- kann/könnte: ممكن: Sie könnte krank sein.\n- soll: الناس بتقول: Sie soll sehr reich sein.\n- will: هو بيدّعي: Er will alles allein geschafft haben.\n\nللماضي: فعل الوجه + Partizip + haben/sein: Er muss den Bus verpasst haben."),
                    [("Er ___ sehr gestresst sein. (almost certain)", "muss", "müssen"), ("Sie ___ viel Selbstvertrauen haben. (people say)", "soll", "sollen"),
                     ("Das ___ stimmen. (probable)", "dürfte", "dürfen"), ("Er muss den Bus verpasst ___.", "haben", "haben")]),
            "nl": G(("Modal verbs for probability", "أفعال الوجه للاحتمال"),
                    ("Dutch modals can also show how sure you are:\n- moet: almost certain: Hij moet erg gestrest zijn.\n- zal wel: probable: Dat zal wel kloppen.\n- kan/zou kunnen: possible: Ze zou ziek kunnen zijn.\n- zou: reportedly: Ze zou erg rijk zijn.\n- schijnen te: it seems: Ze schijnt veel zelfvertrouwen te hebben.",
                     "أفعال الوجه في الهولندي برضه بتوضّح إنت متأكد قد إيه:\n- moet: متأكد تقريبًا: Hij moet erg gestrest zijn.\n- zal wel: غالبًا: Dat zal wel kloppen.\n- kan/zou kunnen: ممكن: Ze zou ziek kunnen zijn.\n- zou: بيقولوا: Ze zou erg rijk zijn.\n- schijnen te: باين إن: Ze schijnt veel zelfvertrouwen te hebben."),
                    [("Hij ___ erg gestrest zijn. (almost certain)", "moet", "moeten"), ("Ze ___ veel zelfvertrouwen te hebben. (it seems)", "schijnt", "schijnen"),
                     ("Ze ___ erg rijk zijn. (reportedly)", "zou", "zullen"), ("Dat zal ___ kloppen. (probably)", "wel", "wel")]),
            "es": G(("deber de, poder and probability", "deber de وpoder والاحتمال"),
                    ("Spanish shows how sure you are with:\n- deber de + infinitive: probably: Debe de estar estresado. (deber + infinitive without de = obligation)\n- poder: possible: Puede que esté enferma (+ subjunctive). Puede estar enferma.\n- a lo mejor / quizás: maybe: A lo mejor está en casa.\n- dicen que / al parecer: reportedly: Al parecer tiene mucha autoestima.\n- the future: Estará cansado.",
                     "الإسباني بيوضّح إنت متأكد قد إيه بـ:\n- deber de + مصدر: غالبًا: Debe de estar estresado. (deber + مصدر من غير de = لازم)\n- poder: ممكن: Puede que esté enferma (+ subjuntivo). Puede estar enferma.\n- a lo mejor / quizás: يمكن: A lo mejor está en casa.\n- dicen que / al parecer: بيقولوا: Al parecer tiene mucha autoestima.\n- المستقبل: Estará cansado."),
                    [("Debe ___ estar estresado. (probably)", "de", "de"), ("Puede que ___ enferma. (estar, subj.)", "esté", "estar"),
                     ("A lo ___ está en casa.", "mejor", "mejor"), ("___ cansado. (probably, estar, future)", "Estará", "estar")]),
        },
    },
    {
        "key": "u08", "write_en": "a historical event from the point of view of someone who lived it", "write_ar": "حدث تاريخي من وجهة نظر حد عاشه",
        "words": """
history | n | history | تاريخ | die Geschichte | de geschiedenis | la historia
century | n | century | قرن | das Jahrhundert, Jahrhunderte | de eeuw, eeuwen | el siglo, siglos
war | n | war | حرب | der Krieg, Kriege | de oorlog, oorlogen | la guerra, guerras
peace | n | peace | سلام | der Frieden | de vrede | la paz
empire | n | empire | إمبراطورية | das Reich, Reiche | het rijk, rijken | el imperio, imperios
king | n | king | ملك | der König, Könige | de koning, koningen | el rey, reyes
revolution | n | revolution | ثورة | die Revolution, Revolutionen | de revolutie, revoluties | la revolución, revoluciones
conquer | v | to conquer | يحتل / يفتح | erobern | veroveren | conquistar
flee | v | to flee | يهرب | fliehen | vluchten | huir
border | n | border | حدود | die Grenze, Grenzen | de grens, grenzen | la frontera, fronteras
""",
        "sentences": """
In the last century there was a long war. | في القرن اللي فات كان فيه حرب طويلة. | Im letzten Jahrhundert gab es einen langen Krieg. | In de vorige eeuw was er een lange oorlog. | En el siglo pasado hubo una guerra larga.
Many people fled across the border. | ناس كتير هربوا عبر الحدود. | Viele Menschen flohen über die Grenze. | Veel mensen vluchtten over de grens. | Mucha gente huyó por la frontera.
After the revolution the king was gone. | بعد الثورة الملك كان مشي. | Nach der Revolution war der König weg. | Na de revolutie was de koning weg. | Después de la revolución el rey ya no estaba.
""",
        "grammar": {
            "de": G(("Präteritum in narrative texts", "الـ Präteritum في الحكي"),
                    ("Written stories and history texts use the Präteritum throughout, not the Perfekt. Many irregular verbs: geben → gab, fliehen → floh, ziehen → zog, sterben → starb, beginnen → begann, finden → fand.\n\nEvents before the story time use the Plusquamperfekt: hatte/war + participle: Nachdem der Krieg begonnen hatte, flohen viele.",
                     "الحكايات المكتوبة ونصوص التاريخ بتستخدم الـ Präteritum طول الوقت مش الـ Perfekt. أفعال شاذة كتير: geben ← gab، fliehen ← floh، ziehen ← zog، sterben ← starb، beginnen ← begann، finden ← fand.\n\nوالأحداث اللي قبل وقت الحكاية بتاخد Plusquamperfekt: hatte/war + Partizip: Nachdem der Krieg begonnen hatte, flohen viele."),
                    [("Viele Menschen ___ über die Grenze. (fliehen)", "flohen", "fliehen"), ("Im letzten Jahrhundert ___ es einen Krieg. (geben)", "gab", "geben"),
                     ("Der König ___ im Jahr 1888. (sterben)", "starb", "sterben"), ("Nachdem der Krieg begonnen ___, flohen viele.", "hatte", "haben")]),
            "nl": G(("Past tenses in narrative texts", "أزمنة الماضي في الحكي"),
                    ("Dutch stories mostly use the imperfectum for the sequence of events, and the perfectum for a summary or a link to now. Irregular verbs: geven → gaf, vluchten → vluchtte (regular), sterven → stierf, beginnen → begon, vinden → vond.\n\nEarlier events: plusquamperfectum: had/was + participle: Nadat de oorlog was begonnen, vluchtten velen.",
                     "الحكايات الهولندية غالبًا بتستخدم الـ imperfectum لتسلسل الأحداث، والـ perfectum للملخص أو للربط بالحاضر. أفعال شاذة: geven ← gaf، vluchten ← vluchtte (منتظم)، sterven ← stierf، beginnen ← begon، vinden ← vond.\n\nالأحداث اللي قبلها: plusquamperfectum: had/was + اسم مفعول: Nadat de oorlog was begonnen, vluchtten velen."),
                    [("Veel mensen ___ over de grens. (vluchten)", "vluchtten", "vluchten"), ("De koning ___ in 1890. (sterven)", "stierf", "sterven"),
                     ("De oorlog ___ in 1939. (beginnen)", "begon", "beginnen"), ("Nadat de oorlog ___ begonnen, vluchtten velen.", "was", "zijn")]),
            "es": G(("Indefinido and imperfecto in narrative", "الـ indefinido والـ imperfecto في الحكي"),
                    ("In a story the indefinido moves the action forward (what happened), and the imperfecto paints the background (what it was like, what was going on):\n- Hacía frío y la gente tenía miedo (background). Entonces empezó la guerra y muchos huyeron (events).\n\nhuir → huyó, huyeron; hubo (there was, event) vs. había (there was, description). Earlier events: pluscuamperfecto: había empezado.",
                     "في الحكاية الـ indefinido بيمشّي الأحداث (اللي حصل)، والـ imperfecto بيرسم الخلفية (كان شكله إيه، إيه اللي كان بيحصل):\n- Hacía frío y la gente tenía miedo (خلفية). Entonces empezó la guerra y muchos huyeron (أحداث).\n\nhuir ← huyó، huyeron؛ hubo (كان فيه، حدث) و había (كان فيه، وصف). والأحداث اللي قبلها: pluscuamperfecto: había empezado."),
                    [("Mucha gente ___ por la frontera. (huir)", "huyó", "huir"), ("En el siglo pasado ___ una guerra. (event, haber)", "hubo", "haber"),
                     ("___ frío y la gente tenía miedo. (background, hacer)", "Hacía", "hacer"), ("Cuando llegamos, la guerra ya ___ empezado.", "había", "haber")]),
        },
    },
    {
        "key": "u09", "write_en": "a book, film or poem that moved you", "write_ar": "كتاب أو فيلم أو قصيدة أثرت فيك",
        "words": """
novel | n | novel | رواية | der Roman, Romane | de roman, romans | la novela, novelas
poem | n | poem | قصيدة | das Gedicht, Gedichte | het gedicht, gedichten | el poema, poemas
author | n | author | مؤلف | der Autor, Autoren | de auteur, auteurs | el autor, autores
character | n | character (in a story) | شخصية | die Figur, Figuren | het personage, personages | el personaje, personajes
publish | v | to publish | ينشر | veröffentlichen | publiceren | publicar
describe | v | to describe | يوصف | beschreiben | beschrijven | describir
imaginative | adj | imaginative | خيالي | fantasievoll | fantasierijk | imaginativo
unreadable | adj | unreadable | ما ينفعش يتقري | unlesbar | onleesbaar | ilegible
exhibition | n | exhibition | معرض | die Ausstellung, Ausstellungen | de tentoonstelling, tentoonstellingen | la exposición, exposiciones
masterpiece | n | masterpiece | تحفة فنية | das Meisterwerk, Meisterwerke | het meesterwerk, meesterwerken | la obra maestra, obras maestras
""",
        "sentences": """
The author published her first novel last year. | المؤلفة نشرت أول رواية ليها السنة اللي فاتت. | Die Autorin veröffentlichte letztes Jahr ihren ersten Roman. | De auteur publiceerde vorig jaar haar eerste roman. | La autora publicó su primera novela el año pasado.
The poem describes a sad character. | القصيدة بتوصف شخصية حزينة. | Das Gedicht beschreibt eine traurige Figur. | Het gedicht beschrijft een droevig personage. | El poema describe a un personaje triste.
This painting is a masterpiece. | اللوحة دي تحفة فنية. | Dieses Bild ist ein Meisterwerk. | Dit schilderij is een meesterwerk. | Este cuadro es una obra maestra.
""",
        "grammar": {
            "de": G(("Word formation: prefixes and suffixes", "تكوين الكلمات: سوابق ولواحق"),
                    ("Knowing affixes helps you guess new words:\n- un-: opposite: lesbar → unlesbar, klar → unklar\n- -los: without: arbeitslos, fantasielos\n- -voll: full of: fantasievoll, wertvoll\n- -lich/-ig: adjectives: Freund → freundlich, Lust → lustig\n- -er/-in: person: lesen → der Leser, die Leserin\n- -schaft, -tum: abstract nouns: Freundschaft, Eigentum",
                     "لو عارف السوابق واللواحق هتقدر تخمّن كلمات جديدة:\n- un-: العكس: lesbar ← unlesbar، klar ← unklar\n- ‎-los: من غير: arbeitslos، fantasielos\n- ‎-voll: مليان: fantasievoll، wertvoll\n- ‎-lich/-ig: صفات: Freund ← freundlich، Lust ← lustig\n- ‎-er/-in: شخص: lesen ← der Leser، die Leserin\n- ‎-schaft، ‎-tum: أسماء مجردة: Freundschaft، Eigentum"),
                    [("lesbar → ___ (opposite)", "unlesbar", "lesbar"), ("full of fantasy: fantasie___", "voll", "-voll"),
                     ("without work: arbeits___", "los", "-los"), ("Freund → ___schaft", "Freund", "Freund")]),
            "nl": G(("Word formation: prefixes and suffixes", "تكوين الكلمات: سوابق ولواحق"),
                    ("Common Dutch affixes:\n- on-: opposite: leesbaar → onleesbaar, duidelijk → onduidelijk\n- -loos: without: werkloos, fantasieloos\n- -rijk/-vol: full of: fantasierijk, waardevol\n- -lijk/-ig: adjectives: vriend → vriendelijk, lust → lustig\n- -er/-ster: person: lezen → de lezer, de lezeres\n- -schap, -heid: abstract nouns: vriendschap, vrijheid",
                     "سوابق ولواحق هولندية مشهورة:\n- on-: العكس: leesbaar ← onleesbaar، duidelijk ← onduidelijk\n- ‎-loos: من غير: werkloos، fantasieloos\n- ‎-rijk/-vol: مليان: fantasierijk، waardevol\n- ‎-lijk/-ig: صفات: vriend ← vriendelijk، lust ← lustig\n- ‎-er/-ster: شخص: lezen ← de lezer، de lezeres\n- ‎-schap، ‎-heid: أسماء مجردة: vriendschap، vrijheid"),
                    [("leesbaar → ___ (opposite)", "onleesbaar", "leesbaar"), ("without work: werk___", "loos", "-loos"),
                     ("full of fantasy: fantasie___", "rijk", "-rijk"), ("vriend → vriend___ (abstract noun)", "schap", "-schap")]),
            "es": G(("Word formation: prefixes and suffixes", "تكوين الكلمات: سوابق ولواحق"),
                    ("Common Spanish affixes:\n- in-/i-/des-: opposite: legible → ilegible, posible → imposible, conocido → desconocido\n- -mente: adverbs from the feminine adjective: rápida → rápidamente\n- -dad/-eza: abstract nouns: libre → la libertad, triste → la tristeza\n- -dor/-dora: person: investigar → el investigador\n- -oso: full of: peligro → peligroso",
                     "سوابق ولواحق إسبانية مشهورة:\n- in-/i-/des-: العكس: legible ← ilegible، posible ← imposible، conocido ← desconocido\n- ‎-mente: ظرف من الصفة المؤنثة: rápida ← rápidamente\n- ‎-dad/-eza: أسماء مجردة: libre ← la libertad، triste ← la tristeza\n- ‎-dor/-dora: شخص: investigar ← el investigador\n- ‎-oso: مليان: peligro ← peligroso"),
                    [("legible → ___ (opposite)", "ilegible", "legible"), ("conocido → ___ (opposite)", "desconocido", "conocido"),
                     ("rápida → ___ (adverb)", "rápidamente", "rápida"), ("triste → la ___", "tristeza", "triste")]),
        },
    },
    {
        "key": "u10", "write_en": "a problem with a landlord or a company and how you solved it", "write_ar": "مشكلة مع صاحب سكن أو شركة وحليتها إزاي",
        "words": """
law | n | law | قانون | das Gesetz, Gesetze | de wet, wetten | la ley, leyes
right_legal | n | right (legal) | حق | das Recht, Rechte | het recht, rechten | el derecho, derechos
court | n | court | محكمة | das Gericht, Gerichte | de rechtbank, rechtbanken | el tribunal, tribunales
lawyer | n | lawyer | محامي | der Anwalt, Anwälte | de advocaat, advocaten | el abogado, abogados
complaint | n | complaint | شكوى | die Beschwerde, Beschwerden | de klacht, klachten | la reclamación, reclamaciones
fine | n | fine (penalty) | غرامة | die Strafe, Strafen | de boete, boetes | la multa, multas
guilty | adj | guilty | مذنب | schuldig | schuldig | culpable
obligation | n | obligation, duty | واجب | die Pflicht, Pflichten | de plicht, plichten | la obligación, obligaciones
due_to | prep | due to | بسبب | aufgrund | wegens | debido a
despite | prep | despite | رغم | trotz | ondanks | a pesar de
""",
        "sentences": """
Despite the rain the court case took place. | رغم المطر القضية اتعملت. | Trotz des Regens fand die Verhandlung statt. | Ondanks de regen vond de rechtszaak plaats. | A pesar de la lluvia el juicio tuvo lugar.
Due to the noise I made a complaint. | بسبب الدوشة قدمت شكوى. | Aufgrund des Lärms habe ich eine Beschwerde eingereicht. | Wegens het lawaai heb ik een klacht ingediend. | Debido al ruido presenté una reclamación.
Every tenant has rights and obligations. | كل ساكن ليه حقوق وعليه واجبات. | Jeder Mieter hat Rechte und Pflichten. | Elke huurder heeft rechten en plichten. | Cada inquilino tiene derechos y obligaciones.
""",
        "grammar": {
            "de": G(("Prepositions with the genitive", "حروف الجر مع حالة الإضافة"),
                    ("Formal German uses prepositions with the genitive:\n- wegen / aufgrund: because of: aufgrund des Lärms\n- trotz: despite: trotz des Regens\n- während: during: während der Woche\n- statt: instead of: statt eines Briefes\n- innerhalb / außerhalb: inside / outside: innerhalb eines Monats\n\nGenitive endings: des/eines + -s/-es (masc./neut.), der/einer (fem./pl.). In speech many people use the dative with wegen and trotz.",
                     "الألماني الرسمي بيستخدم حروف جر مع الـ Genitiv:\n- wegen / aufgrund: بسبب: aufgrund des Lärms\n- trotz: رغم: trotz des Regens\n- während: خلال: während der Woche\n- statt: بدل: statt eines Briefes\n- innerhalb / außerhalb: جوه / بره: innerhalb eines Monats\n\nنهايات الـ Genitiv: des/eines + ‎-s/-es (مذكر/محايد)، der/einer (مؤنث/جمع). وفي الكلام ناس كتير بتستخدم الـ Dativ مع wegen وtrotz."),
                    [("Trotz ___ Regens fand es statt. (der Regen)", "des", "der"), ("Aufgrund ___ Lärms (der Lärm)", "des", "der"),
                     ("während ___ Woche (die Woche)", "der", "die"), ("innerhalb eines ___ (der Monat)", "Monats", "Monat")]),
            "nl": G(("Formal prepositions", "حروف الجر الرسمية"),
                    ("Dutch has no genitive case, but formal texts use special prepositions:\n- wegens / vanwege: because of: wegens het lawaai\n- ondanks: despite: ondanks de regen\n- tijdens: during: tijdens de week\n- volgens: according to: volgens de wet\n- in plaats van: instead of\n- binnen: within: binnen een maand\n\nWith a clause use omdat (because) and hoewel (although): Hoewel het regende, ...",
                     "الهولندي مالوش حالة إضافة، بس النصوص الرسمية بتستخدم حروف جر خاصة:\n- wegens / vanwege: بسبب: wegens het lawaai\n- ondanks: رغم: ondanks de regen\n- tijdens: خلال: tijdens de week\n- volgens: حسب: volgens de wet\n- in plaats van: بدل\n- binnen: في خلال: binnen een maand\n\nومع جملة استخدم omdat (عشان) وhoewel (رغم إن): Hoewel het regende, ..."),
                    [("___ de regen vond het plaats. (despite)", "Ondanks", "ondanks"), ("___ het lawaai heb ik geklaagd. (because of)", "Wegens", "wegens"),
                     ("___ de wet is dat verboden. (according to)", "Volgens", "volgens"), ("___ het regende, gingen we weg. (although)", "Hoewel", "hoewel")]),
            "es": G(("Complex prepositions", "حروف الجر المركبة"),
                    ("Formal Spanish uses prepositional phrases:\n- debido a / a causa de: because of: debido al ruido (a + el = al)\n- a pesar de: despite: a pesar de la lluvia\n- durante: during: durante la semana\n- según: according to: según la ley\n- en vez de / en lugar de: instead of\n- dentro de: within: dentro de un mes\n\nWith a clause: a pesar de que, ya que, aunque.",
                     "الإسباني الرسمي بيستخدم عبارات جر:\n- debido a / a causa de: بسبب: debido al ruido (a + el = al)\n- a pesar de: رغم: a pesar de la lluvia\n- durante: خلال: durante la semana\n- según: حسب: según la ley\n- en vez de / en lugar de: بدل\n- dentro de: في خلال: dentro de un mes\n\nومع جملة: a pesar de que، ya que، aunque."),
                    [("A pesar ___ la lluvia", "de", "de"), ("Debido ___ ruido (a + el)", "al", "a"),
                     ("___ la ley, está prohibido. (according to)", "Según", "según"), ("___ de un mes (within)", "Dentro", "dentro")]),
        },
    },
    {
        "key": "u11", "write_en": "the advantages and dangers of social media", "write_ar": "مميزات ومخاطر السوشيال ميديا",
        "words": """
data | n | data | بيانات | die Daten | de gegevens | los datos
privacy | n | privacy | خصوصية | die Privatsphäre | de privacy | la privacidad
password | n | password | باسورد | das Passwort, Passwörter | het wachtwoord, wachtwoorden | la contraseña, contraseñas
download | v | to download | ينزّل | herunterladen | downloaden | descargar
user | n | user | مستخدم | der Nutzer, Nutzer | de gebruiker, gebruikers | el usuario, usuarios
network | n | network | شبكة | das Netzwerk, Netzwerke | het netwerk, netwerken | la red, redes
protect | v | to protect | يحمي | schützen | beschermen | proteger
addicted | adj | addicted | مدمن | süchtig | verslaafd | adicto
consequently | adv | consequently | وبالتالي | folglich | bijgevolg | por consiguiente
nevertheless | adv | nevertheless | ومع ذلك | dennoch | desondanks | no obstante
""",
        "sentences": """
Many users are addicted; consequently they sleep badly. | مستخدمين كتير مدمنين، وبالتالي بيناموا وحش. | Viele Nutzer sind süchtig, folglich schlafen sie schlecht. | Veel gebruikers zijn verslaafd; bijgevolg slapen ze slecht. | Muchos usuarios son adictos; por consiguiente, duermen mal.
The app is useful; nevertheless I protect my data. | الأبلكيشن مفيد، ومع ذلك بحمي بياناتي. | Die App ist nützlich, dennoch schütze ich meine Daten. | De app is handig; desondanks bescherm ik mijn gegevens. | La aplicación es útil; no obstante, protejo mis datos.
Never share your password. | ما تشاركش الباسورد بتاعك أبدًا. | Teile nie dein Passwort. | Deel nooit je wachtwoord. | Nunca compartas tu contraseña.
""",
        "grammar": {
            "de": G(("Connectors: folglich, dennoch, zumal", "أدوات الربط: folglich، dennoch، zumal"),
                    ("Adverb connectors take position 1, so the verb comes straight after:\n- folglich / deshalb / daher: consequence: Er ist süchtig, folglich schläft er schlecht.\n- dennoch / trotzdem: contrast: Die App ist nützlich, dennoch bin ich vorsichtig.\n\nzumal is a conjunction (verb to the end), meaning especially since: Ich lösche die App, zumal sie viele Daten sammelt.",
                     "أدوات الربط اللي هي ظروف بتاخد المكان الأول، فالفعل بييجي بعدها على طول:\n- folglich / deshalb / daher: نتيجة: Er ist süchtig, folglich schläft er schlecht.\n- dennoch / trotzdem: عكس: Die App ist nützlich, dennoch bin ich vorsichtig.\n\nوzumal أداة ربط (الفعل في الآخر) معناها خصوصًا إن: Ich lösche die App, zumal sie viele Daten sammelt."),
                    [("Er ist süchtig, folglich ___ er schlecht. (schlafen)", "schläft", "schlafen"), ("Sie ist nützlich, ___ bin ich vorsichtig. (nevertheless)", "dennoch", "dennoch"),
                     ("Ich lösche sie, zumal sie viele Daten ___. (sammeln)", "sammelt", "sammeln"), ("___ schütze ich meine Daten. (therefore)", "Deshalb", "deshalb")]),
            "nl": G(("Connectors: dus, daardoor, toch, aangezien", "أدوات الربط: dus، daardoor، toch، aangezien"),
                    ("Adverb connectors at the start take inversion: Daardoor slapen ze slecht. Desondanks bescherm ik mijn gegevens.\n- consequence: dus, daardoor, bijgevolg, daarom\n- contrast: toch, desondanks, echter\n\ndus can also stay in normal order: Hij is ziek, dus hij komt niet.\naangezien (since) is a subordinating conjunction: verb to the end: Aangezien de app gegevens verzamelt, ...",
                     "أدوات الربط اللي هي ظروف في أول الجملة بتقلب الترتيب: Daardoor slapen ze slecht. Desondanks bescherm ik mijn gegevens.\n- نتيجة: dus، daardoor، bijgevolg، daarom\n- عكس: toch، desondanks، echter\n\nوdus ممكن تفضل بالترتيب العادي: Hij is ziek, dus hij komt niet.\nوaangezien (بما إن) أداة ربط فرعية: الفعل في الآخر: Aangezien de app gegevens verzamelt, ..."),
                    [("Ze zijn verslaafd; daardoor ___ ze slecht. (slapen)", "slapen", "slapen"), ("De app is handig; ___ ben ik voorzichtig. (nevertheless)", "toch", "toch"),
                     ("Aangezien de app veel gegevens ___, ... (verzamelen)", "verzamelt", "verzamelen"), ("Hij is ziek, ___ hij komt niet. (so)", "dus", "dus")]),
            "es": G(("Connectors: por lo tanto, sin embargo, ya que", "أدوات الربط: por lo tanto، sin embargo، ya que"),
                    ("Written Spanish links ideas with:\n- consequence: por lo tanto, por consiguiente, así que\n- contrast: sin embargo, no obstante, aun así\n- cause: ya que, puesto que, dado que (+ indicative)\n\nConnectors like sin embargo and por lo tanto usually go between commas or after a semicolon: Es útil; sin embargo, tengo cuidado.",
                     "الإسباني المكتوب بيربط الأفكار بـ:\n- نتيجة: por lo tanto، por consiguiente، así que\n- عكس: sin embargo، no obstante، aun así\n- سبب: ya que، puesto que، dado que (+ indicativo)\n\nوأدوات زي sin embargo وpor lo tanto غالبًا بتيجي بين فاصلتين أو بعد فاصلة منقوطة: Es útil; sin embargo, tengo cuidado."),
                    [("Es útil; sin ___, tengo cuidado.", "embargo", "embargo"), ("Son adictos; por lo ___, duermen mal.", "tanto", "tanto"),
                     ("La borro, ya ___ recoge muchos datos.", "que", "que"), ("No ___, protejo mis datos. (nevertheless)", "obstante", "obstante")]),
        },
    },
    {
        "key": "u12", "write_en": "how people talk differently to friends and to a boss", "write_ar": "الناس بتتكلم إزاي مختلف مع صحابها ومع المدير",
        "words": """
dialect | n | dialect | لهجة | der Dialekt, Dialekte | het dialect, dialecten | el dialecto, dialectos
conversation | n | conversation | محادثة | das Gespräch, Gespräche | het gesprek, gesprekken | la conversación, conversaciones
polite | adj | polite | مؤدب | höflich | beleefd | educado
rude | adj | rude | قليل الأدب | unhöflich | onbeleefd | maleducado
misunderstanding | n | misunderstanding | سوء فهم | das Missverständnis, Missverständnisse | het misverstand, misverstanden | el malentendido, malentendidos
mother_tongue | n | mother tongue | لغة أم | die Muttersprache, Muttersprachen | de moedertaal, moedertalen | la lengua materna, lenguas maternas
express | v | to express | يعبّر | ausdrücken | uitdrukken | expresar
interrupt | v | to interrupt | يقاطع | unterbrechen | onderbreken | interrumpir
body_language | n | body language | لغة الجسد | die Körpersprache | de lichaamstaal | el lenguaje corporal
fluent | adj | fluent | بطلاقة | fließend | vloeiend | con fluidez
""",
        "sentences": """
Would you mind if I interrupted you briefly? | تسمح لي أقاطعك ثانية؟ | Würde es Sie stören, wenn ich Sie kurz unterbreche? | Zou u het erg vinden als ik u even onderbreek? | ¿Le importaría que le interrumpiera un momento?
That was a misunderstanding. | ده كان سوء فهم. | Das war ein Missverständnis. | Dat was een misverstand. | Eso fue un malentendido.
My mother tongue is Arabic. | لغتي الأم هي العربي. | Meine Muttersprache ist Arabisch. | Mijn moedertaal is Arabisch. | Mi lengua materna es el árabe.
""",
        "grammar": {
            "de": G(("Register and politeness", "مستوى الكلام والأدب"),
                    ("German has strong register differences:\n- du (friends, family, many workplaces) vs Sie (strangers, bosses, officials)\n- softening with Konjunktiv II: Könnten Sie ...? Würden Sie ...? Hätten Sie kurz Zeit?\n- indirect requests: Würde es Sie stören, wenn ...? Ich wollte fragen, ob ...\n- spoken shortcuts with friends: Haste mal Zeit? Geht's?\n\nUsually the older or senior person offers du.",
                     "الألماني فيه فروق كبيرة في مستوى الكلام:\n- du (صحاب، عيلة، شغلانات كتير) وSie (ناس غريبة، مدرا، موظفين حكومة)\n- التلطيف بـ Konjunktiv II: Könnten Sie ...? Würden Sie ...? Hätten Sie kurz Zeit?\n- طلبات غير مباشرة: Würde es Sie stören, wenn ...? Ich wollte fragen, ob ...\n- اختصارات الكلام مع الصحاب: Haste mal Zeit? Geht's?\n\nوعادةً الأكبر أو الأعلى في المنصب هو اللي بيعرض du."),
                    [("___ Sie mir helfen? (polite, können)", "Könnten", "können"), ("Würde es Sie ___, wenn ich kurz unterbreche?", "stören", "stören"),
                     ("___ Sie kurz Zeit? (polite, haben)", "Hätten", "haben"), ("Ich wollte fragen, ___ Sie Zeit haben.", "ob", "ob")]),
            "nl": G(("Register and politeness", "مستوى الكلام والأدب"),
                    ("Dutch moves to je/jij quickly, even at work, but u is used with older people, officials and in formal writing.\n- softening with zou: Zou u ... kunnen? Zou je het erg vinden als ...?\n- even and misschien soften requests: Heb je even tijd? Kun je misschien helpen?\n- directness is normal and not rude in Dutch: Dat klopt niet. is fine in a meeting.",
                     "الهولندي بينقل لـ je/jij بسرعة حتى في الشغل، بس u بتستخدم مع الكبار والموظفين وفي الكتابة الرسمية.\n- التلطيف بـ zou: Zou u ... kunnen? Zou je het erg vinden als ...?\n- even وmisschien بيلطّفوا الطلب: Heb je even tijd? Kun je misschien helpen?\n- الصراحة عادية ومش قلة أدب في الهولندي: Dat klopt niet. عادي في اجتماع."),
                    [("___ u mij kunnen helpen? (polite)", "Zou", "zullen"), ("Zou je het erg vinden ___ ik even onderbreek?", "als", "als"),
                     ("Heb je ___ tijd? (softener)", "even", "even"), ("Kun je ___ helpen? (maybe)", "misschien", "misschien")]),
            "es": G(("Register and politeness", "مستوى الكلام والأدب"),
                    ("Spain uses tú widely, even with colleagues; usted is for older people, clients and officials (Latin America uses usted more).\n- softening with the conditional: ¿Podría ...? ¿Le importaría ...? Querría ...\n- ¿Le importaría que + imperfect subjunctive?: ¿Le importaría que le interrumpiera?\n- the imperfect for polite requests: Quería preguntarle ...\n- diminutives soften: un momentito, un favorcito.",
                     "إسبانيا بتستخدم tú كتير حتى مع زمايل الشغل؛ وusted للكبار والعملا والموظفين (أمريكا اللاتينية بتستخدم usted أكتر).\n- التلطيف بالـ condicional: ¿Podría ...? ¿Le importaría ...? Querría ...\n- ¿Le importaría que + subjuntivo imperfecto?: ¿Le importaría que le interrumpiera?\n- الـ imperfecto للطلبات المؤدبة: Quería preguntarle ...\n- التصغير بيلطّف: un momentito، un favorcito."),
                    [("¿___ ayudarme? (polite, poder)", "Podría", "poder"), ("¿Le ___ que le interrumpiera? (importar)", "importaría", "importar"),
                     ("___ preguntarle algo. (polite, querer, imperfect)", "Quería", "querer"), ("un momento → un ___ (diminutive)", "momentito", "momento")]),
        },
    },
    {
        "key": "u13", "write_en": "an essay for or against a four-day working week", "write_ar": "مقال مع أو ضد أسبوع شغل أربع أيام",
        "words": """
argument | n | argument (reason) | حجة | das Argument, Argumente | het argument, argumenten | el argumento, argumentos
debate | n | debate | مناظرة | die Debatte, Debatten | het debat, debatten | el debate, debates
agree | v | to agree | يوافق | zustimmen | het eens zijn | estar de acuerdo
contradict | v | to contradict | يعارض | widersprechen | tegenspreken | contradecir
advantage | n | advantage | ميزة | der Vorteil, Vorteile | het voordeel, voordelen | la ventaja, ventajas
disadvantage | n | disadvantage | عيب | der Nachteil, Nachteile | het nadeel, nadelen | la desventaja, desventajas
convince | v | to convince | يقنع | überzeugen | overtuigen | convencer
in_conclusion | phr | in conclusion | في الختام | abschließend | tot slot | en conclusión
on_the_one_hand | phr | on the one hand | من ناحية | einerseits | enerzijds | por un lado
on_the_other_hand | phr | on the other hand | من ناحية تانية | andererseits | anderzijds | por otro lado
""",
        "sentences": """
On the one hand it is cheaper, on the other hand it takes longer. | من ناحية أرخص، ومن ناحية تانية بياخد وقت أطول. | Einerseits ist es billiger, andererseits dauert es länger. | Enerzijds is het goedkoper, anderzijds duurt het langer. | Por un lado es más barato, por otro lado tarda más.
Your argument does not convince me. | حجتك مش مقنعاني. | Dein Argument überzeugt mich nicht. | Jouw argument overtuigt me niet. | Tu argumento no me convence.
In conclusion, the advantages are bigger. | في الختام، المميزات أكبر. | Abschließend sind die Vorteile größer. | Tot slot zijn de voordelen groter. | En conclusión, las ventajas son mayores.
""",
        "grammar": {
            "de": G(("Structuring an argument", "ترتيب الحجة"),
                    ("A clear argument has signposts:\n- introducing: Zunächst möchte ich ... / Ein wichtiges Argument ist ...\n- adding: außerdem, darüber hinaus, hinzu kommt, dass ...\n- weighing: einerseits ... andererseits; zwar ... aber\n- conceding: Es stimmt zwar, dass ..., aber ...\n- concluding: abschließend, zusammenfassend, alles in allem\n\nAdverbs in position 1 take inversion: Andererseits dauert es länger.",
                     "الحجة الواضحة ليها علامات:\n- البداية: Zunächst möchte ich ... / Ein wichtiges Argument ist ...\n- الإضافة: außerdem، darüber hinaus، hinzu kommt, dass ...\n- الموازنة: einerseits ... andererseits؛ zwar ... aber\n- الاعتراف: Es stimmt zwar, dass ..., aber ...\n- الختام: abschließend، zusammenfassend، alles in allem\n\nوالظروف في المكان الأول بتقلب الترتيب: Andererseits dauert es länger."),
                    [("Einerseits ist es billiger, ___ dauert es länger.", "andererseits", "andererseits"), ("Es stimmt ___, dass es teuer ist, aber ...", "zwar", "zwar"),
                     ("Darüber ___ spart man Zeit.", "hinaus", "hinaus"), ("Alles in ___ bin ich dafür.", "allem", "alle")]),
            "nl": G(("Structuring an argument", "ترتيب الحجة"),
                    ("Signposts for a Dutch argument:\n- introducing: Ten eerste ... / Een belangrijk argument is ...\n- adding: bovendien, daarnaast, verder\n- weighing: enerzijds ... anderzijds; aan de ene kant ... aan de andere kant\n- conceding: Het is waar dat ..., maar ...\n- concluding: tot slot, kortom, al met al\n\nAdverbs at the start take inversion: Bovendien bespaar je tijd.",
                     "علامات الحجة في الهولندي:\n- البداية: Ten eerste ... / Een belangrijk argument is ...\n- الإضافة: bovendien، daarnaast، verder\n- الموازنة: enerzijds ... anderzijds؛ aan de ene kant ... aan de andere kant\n- الاعتراف: Het is waar dat ..., maar ...\n- الختام: tot slot، kortom، al met al\n\nوالظروف في الأول بتقلب الترتيب: Bovendien bespaar je tijd."),
                    [("Enerzijds is het goedkoper, ___ duurt het langer.", "anderzijds", "anderzijds"), ("___ bespaar je tijd. (moreover)", "Bovendien", "bovendien"),
                     ("Het is ___ dat het duur is, maar ...", "waar", "waar"), ("Al met ___ ben ik voor.", "al", "al")]),
            "es": G(("Structuring an argument", "ترتيب الحجة"),
                    ("Signposts for a Spanish argument:\n- introducing: En primer lugar ... / Un argumento importante es ...\n- adding: además, asimismo, por otra parte\n- weighing: por un lado ... por otro (lado)\n- conceding: Es cierto que ..., pero ... / Aunque + subjunctive for a point you accept only in theory\n- concluding: en conclusión, en resumen, en definitiva\n\nNo es que + subjunctive rejects a reason: No es que sea caro, sino que ...",
                     "علامات الحجة في الإسباني:\n- البداية: En primer lugar ... / Un argumento importante es ...\n- الإضافة: además، asimismo، por otra parte\n- الموازنة: por un lado ... por otro (lado)\n- الاعتراف: Es cierto que ..., pero ... / Aunque + subjuntivo لنقطة بتقبلها نظريًا بس\n- الختام: en conclusión، en resumen، en definitiva\n\nوNo es que + subjuntivo بترفض سبب: No es que sea caro, sino que ..."),
                    [("Por un lado es barato, por ___ lado tarda más.", "otro", "otro"), ("En primer ___, ...", "lugar", "lugar"),
                     ("Es ___ que es caro, pero ...", "cierto", "cierto"), ("No es que ___ caro, sino que ... (ser)", "sea", "ser")]),
        },
    },
]
