"""B1: units 1-15 (unit 16 is the review and mock exam).

words:     concept | pos | English | Arabic | German | Dutch | Spanish
sentences: English | Arabic | German | Dutch | Spanish
"""

CAN_DO = [
    {"en": "Follow the main points of clear talk on familiar topics", "ar": "تفهم النقط الأساسية في كلام واضح عن مواضيع مألوفة"},
    {"en": "Deal with most situations while travelling and living abroad", "ar": "تتصرف في أغلب المواقف وإنت مسافر أو عايش برة"},
    {"en": "Give reasons and explanations for opinions and plans", "ar": "تدي أسباب وتوضيح لآرائك وخططك"},
]


def G(title, text, exercises, table=None):
    g = {"title": title, "text": text, "exercises": exercises}
    if table:
        g["table"] = table
    return g


UNITS = [
    {
        "key": "u01", "write_en": "how you learn best and a good teacher you remember", "write_ar": "إزاي بتتعلم أحسن ومدرس كويس فاكره",
        "words": """
education | n | education | تعليم | die Bildung | het onderwijs | la educación
university | n | university | جامعة | die Universität, Universitäten | de universiteit, universiteiten | la universidad, universidades
course | n | course | كورس | der Kurs, Kurse | de cursus, cursussen | el curso, cursos
exam | n | exam | امتحان | die Prüfung, Prüfungen | het examen, examens | el examen, exámenes
pass_exam | v | to pass (an exam) | ينجح | bestehen | slagen | aprobar
subject | n | subject (at school) | مادة | das Fach, Fächer | het vak, vakken | la asignatura, asignaturas
knowledge | n | knowledge | معرفة | das Wissen | de kennis | el conocimiento
understand | v | to understand | يفهم | verstehen | begrijpen | entender
explain | v | to explain | يشرح | erklären | uitleggen | explicar
improve | v | to improve | يحسّن | verbessern | verbeteren | mejorar
""",
        "sentences": """
Last year I passed the exam. | السنة اللي فاتت نجحت في الامتحان. | Letztes Jahr bestand ich die Prüfung. | Vorig jaar slaagde ik voor het examen. | El año pasado aprobé el examen.
The teacher explained the grammar very well. | المدرس شرح القواعد كويس جدًا. | Die Lehrerin erklärte die Grammatik sehr gut. | De lerares legde de grammatica heel goed uit. | La profesora explicó muy bien la gramática.
I want to improve my knowledge. | عايز أحسّن معرفتي. | Ich möchte mein Wissen verbessern. | Ik wil mijn kennis verbeteren. | Quiero mejorar mis conocimientos.
""",
        "grammar": {
            "de": G(("The Präteritum", "الماضي البسيط (Präteritum)"),
                    ("In writing and stories German uses the Präteritum. Regular verbs: stem + -te: ich erklärte, du erklärtest, er erklärte, wir erklärten. Irregular verbs change their vowel and have no ending for ich/er: gehen → ging, kommen → kam, bestehen → bestand, verstehen → verstand.\n\nModal verbs: konnte, musste, wollte, durfte, sollte.",
                     "في الكتابة والحكايات الألماني بيستخدم الـ Präteritum. الأفعال المنتظمة: الجذر + ‎-te: ich erklärte, du erklärtest, er erklärte, wir erklärten. والشاذة بيتغير حرفها المتحرك ومن غير نهاية مع ich/er: gehen ← ging، kommen ← kam، bestehen ← bestand، verstehen ← verstand.\n\nأفعال الوجه: konnte، musste، wollte، durfte، sollte."),
                    [("Die Lehrerin ___ die Grammatik. (erklären)", "erklärte", "erklären"), ("Letztes Jahr ___ ich die Prüfung. (bestehen)", "bestand", "bestehen"),
                     ("Wir ___ nach Hause. (gehen)", "gingen", "gehen"), ("Ich ___ nicht kommen. (können)", "konnte", "können")]),
            "nl": G(("The imperfectum (simple past)", "الماضي البسيط (imperfectum)"),
                    ("Regular verbs: stem + -te(n) or -de(n), by the same 't kofschip rule as the participle: werken → werkte, werkten; leren → leerde, leerden; uitleggen → legde uit.\n\nIrregular verbs change the vowel: gaan → ging, komen → kwam, begrijpen → begreep, slagen is regular (slaagde).\n\nDutch uses the perfect more in speech, the imperfectum in stories.",
                     "الأفعال المنتظمة: الجذر + ‎-te(n) أو ‎-de(n)، بنفس قاعدة 't kofschip: werken ← werkte، werkten؛ leren ← leerde، leerden؛ uitleggen ← legde uit.\n\nالشاذة بيتغير حرفها المتحرك: gaan ← ging، komen ← kwam، begrijpen ← begreep، وslagen منتظم (slaagde).\n\nالهولندي في الكلام بيستخدم الـ perfect أكتر، والـ imperfectum في الحكايات."),
                    [("Vorig jaar ___ ik voor het examen. (slagen)", "slaagde", "slagen"), ("De lerares ___ de grammatica uit. (uitleggen)", "legde", "uitleggen"),
                     ("Wij ___ naar huis. (gaan)", "gingen", "gaan"), ("Hij ___ het niet. (begrijpen)", "begreep", "begrijpen")]),
            "es": G(("Irregular indefinido", "الـ indefinido الشاذ"),
                    ("Many common verbs have an irregular indefinido stem with endings -e, -iste, -o, -imos, -isteis, -ieron: tener → tuve, estar → estuve, poder → pude, hacer → hice (hizo), venir → vine, querer → quise.\n\ndecir and traer take -eron: dijeron, trajeron. Regular: aprobé, explicó (c → qu in yo: expliqué).",
                     "أفعال كتير منتشرة ليها جذر شاذ في الـ indefinido بالنهايات ‎-e, -iste, -o, -imos, -isteis, -ieron: tener ← tuve، estar ← estuve، poder ← pude، hacer ← hice (hizo)، venir ← vine، querer ← quise.\n\ndecir وtraer بياخدوا ‎-eron: dijeron، trajeron. والمنتظم: aprobé، explicó (وفي yo الـ c بتبقى qu: expliqué)."),
                    [("Ayer ___ mucho trabajo. (yo, tener)", "tuve", "tener"), ("¿Qué ___ el fin de semana? (tú, hacer)", "hiciste", "hacer"),
                     ("La profesora ___ la gramática. (explicar)", "explicó", "explicar"), ("No ___ venir. (yo, poder)", "pude", "poder")]),
        },
    },
    {
        "key": "u02", "write_en": "an application email for a job you would like", "write_ar": "إيميل تقديم على شغلانة نفسك فيها",
        "words": """
application | n | application | طلب تقديم | die Bewerbung, Bewerbungen | de sollicitatie, sollicitaties | la solicitud, solicitudes
apply | v | to apply | يقدّم على | sich bewerben | solliciteren | solicitar
cv | n | CV | سي في | der Lebenslauf, Lebensläufe | het cv, cv's | el currículum, currículums
experience | n | experience | خبرة | die Erfahrung, Erfahrungen | de ervaring, ervaringen | la experiencia, experiencias
interview | n | job interview | انترفيو | das Vorstellungsgespräch, Vorstellungsgespräche | het sollicitatiegesprek, sollicitatiegesprekken | la entrevista, entrevistas
position | n | position, post | وظيفة | die Stelle, Stellen | de functie, functies | el puesto, puestos
skill | n | skill | مهارة | die Fähigkeit, Fähigkeiten | de vaardigheid, vaardigheden | la habilidad, habilidades
employer | n | employer | صاحب الشغل | der Arbeitgeber, Arbeitgeber | de werkgever, werkgevers | el empleador, empleadores
contract | n | contract | عقد | der Vertrag, Verträge | het contract, contracten | el contrato, contratos
unemployed | adj | unemployed | عاطل | arbeitslos | werkloos | en paro
""",
        "sentences": """
I am applying for a job that suits me. | بقدّم على شغلانة تناسبني. | Ich bewerbe mich um eine Stelle, die zu mir passt. | Ik solliciteer naar een functie die bij me past. | Solicito un puesto que me va bien.
The man who interviewed me was very friendly. | الراجل اللي عمل معايا الانترفيو كان لطيف جدًا. | Der Mann, der mich interviewt hat, war sehr freundlich. | De man die me interviewde, was heel vriendelijk. | El hombre que me entrevistó fue muy amable.
This is the contract that I signed. | ده العقد اللي مضيته. | Das ist der Vertrag, den ich unterschrieben habe. | Dit is het contract dat ik heb ondertekend. | Este es el contrato que firmé.
""",
        "grammar": {
            "de": G(("Relative clauses (nominative, accusative)", "الجمل الموصولة (فاعل ومفعول)"),
                    ("A relative clause describes a noun and sends the verb to the end. The relative pronoun has the gender of the noun and the case of its role in the clause.\n\nNominative: der, die, das, die (pl.): Der Mann, der mich interviewt hat, ... Accusative: den, die, das, die: Der Vertrag, den ich unterschrieben habe, ...",
                     "الجملة الموصولة بتوصف اسم وبتبعت الفعل للآخر. ضمير الوصل بياخد جنس الاسم وحالته من دوره في الجملة.\n\nفاعل: der, die, das, die (جمع): Der Mann, der mich interviewt hat, ... ومفعول: den, die, das, die: Der Vertrag, den ich unterschrieben habe, ..."),
                    [("Der Mann, ___ mich interviewt hat, war nett.", "der", "der"), ("Der Vertrag, ___ ich unterschrieben habe, ...", "den", "der"),
                     ("Die Stelle, ___ zu mir passt, ...", "die", "die"), ("Das Gespräch, ___ ich hatte, war gut.", "das", "das")],
                    [["", "masc.", "fem.", "neut.", "plural"], ["nominative", "der", "die", "das", "die"], ["accusative", "den", "die", "das", "die"]]),
            "nl": G(("Relative clauses with die and dat", "الجمل الموصولة بـ die وdat"),
                    ("Dutch relative pronouns: die for de-words and all plurals, dat for het-words. The verb goes to the end: De man die me interviewde, ... Het contract dat ik heb ondertekend, ...\n\nThere is no case change: die/dat is the same as subject or object. After a preposition, use wie for people: de collega met wie ik werk.",
                     "ضماير الوصل في الهولندي: die لكلمات de وكل الجمع، وdat لكلمات het. والفعل بيروح للآخر: De man die me interviewde, ... Het contract dat ik heb ondertekend, ...\n\nمفيش تغيير بالحالة: die/dat زي ما هي فاعل أو مفعول. وبعد حرف جر استخدم wie للأشخاص: de collega met wie ik werk."),
                    [("De man ___ me interviewde, was aardig.", "die", "die / dat"), ("Het contract ___ ik heb ondertekend.", "dat", "die / dat"),
                     ("De functies ___ ik zoek, ...", "die", "die / dat"), ("De collega met ___ ik werk.", "wie", "wie")]),
            "es": G(("Relative clauses with que, quien, el que", "الجمل الموصولة بـ que وquien وel que"),
                    ("que is the all-purpose relative pronoun for people and things: El hombre que me entrevistó ... El contrato que firmé ... The word order doesn't change.\n\nAfter a preposition: el/la/los/las que or quien(es) for people: la persona con quien trabajo, la empresa en la que trabajo.",
                     "que هو ضمير الوصل اللي ينفع لكل حاجة، أشخاص وحاجات: El hombre que me entrevistó ... El contrato que firmé ... وترتيب الكلام مش بيتغير.\n\nبعد حرف جر: el/la/los/las que أو quien(es) للأشخاص: la persona con quien trabajo، la empresa en la que trabajo."),
                    [("El hombre ___ me entrevistó fue amable.", "que", "que"), ("La persona con ___ trabajo. (person)", "quien", "quien"),
                     ("La empresa en ___ que trabajo. (fem.)", "la", "el/la que"), ("Este es el contrato ___ firmé.", "que", "que")]),
        },
    },
    {
        "key": "u03", "write_en": "rules for living together in a shared flat", "write_ar": "قواعد للعيشة في شقة مشتركة",
        "words": """
flatmate | n | flatmate | شريك في السكن | der Mitbewohner, Mitbewohner | de huisgenoot, huisgenoten | el compañero de piso
rule | n | rule | قاعدة | die Regel, Regeln | de regel, regels | la norma, normas
noise | n | noise | دوشة | der Lärm | het lawaai | el ruido
clean | v | to clean | ينضّف | putzen | schoonmaken | limpiar
rubbish | n | rubbish | زبالة | der Müll | het afval | la basura
share | v | to share | يشارك، يقسم | teilen | delen | compartir
respect | v | to respect | يحترم | respektieren | respecteren | respetar
complain | v | to complain | يشتكي | sich beschweren | klagen | quejarse
conflict | n | conflict | خلاف | der Konflikt, Konflikte | het conflict, conflicten | el conflicto, conflictos
let | v | to let, to have (something done) | يخلّي | lassen | laten | dejar
""",
        "sentences": """
That is the flatmate with whom I share the kitchen. | ده الشريك اللي بقسم معاه المطبخ. | Das ist der Mitbewohner, mit dem ich die Küche teile. | Dat is de huisgenoot met wie ik de keuken deel. | Ese es el compañero de piso con quien comparto la cocina.
I am having my bike repaired. | بصلّح العجلة (عند حد). | Ich lasse mein Fahrrad reparieren. | Ik laat mijn fiets repareren. | Llevo mi bici a reparar.
The neighbours complain about the noise. | الجيران بيشتكوا من الدوشة. | Die Nachbarn beschweren sich über den Lärm. | De buren klagen over het lawaai. | Los vecinos se quejan del ruido.
""",
        "grammar": {
            "de": G(("Relative clauses with prepositions; lassen", "الجمل الموصولة مع حروف الجر؛ lassen"),
                    ("When the relative pronoun follows a preposition, the preposition decides the case: der Mitbewohner, mit dem ich die Küche teile (mit + dative); die Wohnung, in der ich wohne.\n\nlassen = to let, or to have something done: Ich lasse mein Fahrrad reparieren (someone else repairs it). Lass mich in Ruhe! = Leave me alone.",
                     "لما ضمير الوصل ييجي بعد حرف جر، حرف الجر هو اللي بيحدد الحالة: der Mitbewohner, mit dem ich die Küche teile (mit + داتيف)؛ die Wohnung, in der ich wohne.\n\nlassen = يخلّي، أو يخلّي حد يعمل حاجة: Ich lasse mein Fahrrad reparieren (حد تاني بيصلحها). Lass mich in Ruhe! = سيبني في حالي."),
                    [("Der Mitbewohner, mit ___ ich wohne.", "dem", "der"), ("Die Wohnung, in ___ ich wohne.", "der", "die"),
                     ("Ich ___ mein Fahrrad reparieren.", "lasse", "lassen"), ("Die Nachbarn beschweren ___ über den Lärm.", "sich", "sich")]),
            "nl": G(("Prepositions in relative clauses; laten", "حروف الجر في الجمل الموصولة؛ laten"),
                    ("With people: preposition + wie: de huisgenoot met wie ik deel. With things: waar + preposition: het huis waarin ik woon, de regels waarover we praten.\n\nlaten = to let or have done: Ik laat mijn fiets repareren. Laat me met rust! = Leave me alone.\n\nklagen over = to complain about.",
                     "مع الأشخاص: حرف الجر + wie: de huisgenoot met wie ik deel. ومع الحاجات: waar + حرف الجر: het huis waarin ik woon، de regels waarover we praten.\n\nlaten = يخلّي أو يخلّي حد يعمل: Ik laat mijn fiets repareren. Laat me met rust! = سيبني في حالي.\n\nklagen over = يشتكي من."),
                    [("De huisgenoot met ___ ik de keuken deel.", "wie", "wie"), ("Het huis ___ ik woon. (in which)", "waarin", "waar + in"),
                     ("Ik ___ mijn fiets repareren.", "laat", "laten"), ("De buren klagen ___ het lawaai.", "over", "over")]),
            "es": G(("Prepositions + relative pronouns; dejar", "حروف الجر مع ضماير الوصل؛ dejar"),
                    ("Preposition + el/la/los/las que (things or people) or quien (people): la cocina en la que cocino, el compañero con quien vivo.\n\ndejar + infinitive = to let: Déjame pensar. To have something done, Spanish often just uses the verb or llevar a: Llevo mi bici a reparar.\n\nquejarse de = to complain about: Se quejan del ruido.",
                     "حرف جر + el/la/los/las que (حاجات أو أشخاص) أو quien (أشخاص): la cocina en la que cocino، el compañero con quien vivo.\n\ndejar + مصدر = يخلّي: Déjame pensar. وعشان تخلي حد يعمل حاجة، الإسباني غالبًا بيستخدم الفعل نفسه أو llevar a: Llevo mi bici a reparar.\n\nquejarse de = يشتكي من: Se quejan del ruido."),
                    [("El compañero con ___ vivo. (person)", "quien", "quien"), ("La cocina en la ___ cocino.", "que", "que"),
                     ("___ pensar. (tú, dejar + me)", "Déjame", "dejar"), ("Los vecinos se quejan ___ ruido.", "del", "de + el")]),
        },
    },
    {
        "key": "u04", "write_en": "what you spend money on and how you save", "write_ar": "بتصرف فلوسك على إيه وبتحوّش إزاي",
        "words": """
spend | v | to spend (money) | يصرف | ausgeben | uitgeven | gastar
save | v | to save (money) | يحوّش | sparen | sparen | ahorrar
account | n | bank account | حساب بنكي | das Konto, Konten | de rekening, rekeningen | la cuenta bancaria
debt | n | debt | دين | die Schulden | de schuld, schulden | la deuda, deudas
receipt | n | receipt | إيصال | die Quittung, Quittungen | de bon, bonnen | el recibo, recibos
offer | n | offer, deal | عرض | das Angebot, Angebote | de aanbieding, aanbiedingen | la oferta, ofertas
customer | n | customer | زبون | der Kunde, Kunden | de klant, klanten | el cliente, clientes
consumer | n | consumer | مستهلك | der Verbraucher, Verbraucher | de consument, consumenten | el consumidor, consumidores
exchange | v | to exchange (goods) | يبدّل، يرجّع | umtauschen | ruilen | cambiar
expensive_b1 | adj | costly, valuable | قيّم، غالي | wertvoll | waardevol | valioso
""",
        "sentences": """
The product can be exchanged. | المنتج ممكن يتبدّل. | Das Produkt kann umgetauscht werden. | Het product kan worden geruild. | El producto se puede cambiar.
I spend too much money on clothes. | بصرف فلوس كتير أوي على الهدوم. | Ich gebe zu viel Geld für Kleidung aus. | Ik geef te veel geld uit aan kleding. | Gasto demasiado dinero en ropa.
The customer wants to speak to the manager. | الزبون عايز يكلم المدير. | Der Kunde möchte mit dem Chef sprechen. | De klant wil de manager spreken. | El cliente quiere hablar con el gerente.
""",
        "grammar": {
            "de": G(("Passive with modal verbs; n-declension", "المجهول مع أفعال الوجه؛ تصريف n"),
                    ("Modal verb + participle + werden (at the end): Das Produkt kann umgetauscht werden. Die Rechnung muss bezahlt werden.\n\nSome masculine nouns add -(e)n in every case except the nominative singular: der Kunde → den Kunden, dem Kunden, des Kunden. Others: der Kollege, der Student, der Mensch, der Nachbar, der Herr (Herrn).",
                     "فعل وجه + اسم المفعول + werden (في الآخر): Das Produkt kann umgetauscht werden. Die Rechnung muss bezahlt werden.\n\nفيه أسماء مذكرة بتزود ‎-(e)n في كل الحالات إلا الفاعل المفرد: der Kunde ← den Kunden، dem Kunden، des Kunden. وغيرها: der Kollege، der Student، der Mensch، der Nachbar، der Herr (Herrn)."),
                    [("Das Produkt kann umgetauscht ___.", "werden", "werden"), ("Die Rechnung ___ bezahlt werden.", "muss", "müssen"),
                     ("Ich spreche mit dem ___. (Kunde)", "Kunden", "der Kunde"), ("Ich gebe zu viel Geld ___. (ausgeben)", "aus", "ausgeben")]),
            "nl": G(("Passive with modal verbs; uitgeven aan", "المجهول مع أفعال الوجه؛ uitgeven aan"),
                    ("Modal + worden + participle (both orders are fine at the end): Het product kan worden geruild / kan geruild worden. De rekening moet worden betaald.\n\nDutch nouns don't decline: de klant, met de klant.\n\nSpend on = uitgeven aan: Ik geef te veel geld uit aan kleding.",
                     "فعل وجه + worden + اسم المفعول (الترتيبين ينفعوا في الآخر): Het product kan worden geruild / kan geruild worden. De rekening moet worden betaald.\n\nالأسماء الهولندية مش بتتصرف: de klant، met de klant.\n\nيصرف على = uitgeven aan: Ik geef te veel geld uit aan kleding."),
                    [("Het product kan worden ___. (ruilen)", "geruild", "ruilen"), ("De rekening ___ worden betaald.", "moet", "moeten"),
                     ("Ik geef te veel geld uit ___ kleding.", "aan", "aan"), ("Ik geef te veel geld ___.", "uit", "uitgeven")]),
            "es": G(("Passive with se and poder; gastar en", "المجهول بـ se مع poder؛ gastar en"),
                    ("With modal verbs the passive se goes before the modal or attaches to the infinitive: El producto se puede cambiar = puede cambiarse. La factura se tiene que pagar.\n\nThe ser passive exists but is formal: La factura fue pagada.\n\nspend on = gastar en: Gasto demasiado dinero en ropa.",
                     "مع أفعال الوجه، se بتاعة المجهول بتيجي قبل الفعل أو بتتلزق في المصدر: El producto se puede cambiar = puede cambiarse. La factura se tiene que pagar.\n\nالمجهول بـ ser موجود بس رسمي: La factura fue pagada.\n\nيصرف على = gastar en: Gasto demasiado dinero en ropa."),
                    [("El producto ___ puede cambiar.", "se", "se"), ("Gasto mucho dinero ___ ropa.", "en", "en"),
                     ("La factura fue ___. (pagar)", "pagada", "pagar"), ("Quiero ___ dinero. (save)", "ahorrar", "ahorrar")]),
        },
    },
    {
        "key": "u05", "write_en": "an environmental problem in your city and what could be done", "write_ar": "مشكلة بيئية في مدينتك وممكن يتعمل إيه",
        "words": """
environment | n | environment | البيئة | die Umwelt | het milieu | el medio ambiente
nature | n | nature | الطبيعة | die Natur | de natuur | la naturaleza
climate | n | climate | المناخ | das Klima | het klimaat | el clima
energy | n | energy | طاقة | die Energie, Energien | de energie | la energía, energías
pollution | n | pollution | تلوث | die Verschmutzung | de vervuiling | la contaminación
protect | v | to protect | يحمي | schützen | beschermen | proteger
recycle | v | to recycle | يعيد التدوير | recyceln | recyclen | reciclar
tree | n | tree | شجرة | der Baum, Bäume | de boom, bomen | el árbol, árboles
waste_v | v | to waste | يهدر | verschwenden | verspillen | desperdiciar
future | n | future | المستقبل | die Zukunft | de toekomst | el futuro
""",
        "sentences": """
Every year many trees are cut down. | كل سنة شجر كتير بيتقطع. | Jedes Jahr werden viele Bäume gefällt. | Elk jaar worden veel bomen gekapt. | Cada año se talan muchos árboles.
The climate is getting warmer. | المناخ بيسخن. | Das Klima wird wärmer. | Het klimaat wordt warmer. | El clima se está volviendo más cálido.
We must protect nature. | لازم نحمي الطبيعة. | Wir müssen die Natur schützen. | We moeten de natuur beschermen. | Tenemos que proteger la naturaleza.
""",
        "grammar": {
            "de": G(("The passive in all tenses; werden as main verb", "المجهول في كل الأزمنة؛ werden كفعل أساسي"),
                    ("Passive = werden + participle. Present: Die Bäume werden gefällt. Präteritum: Die Bäume wurden gefällt. Perfect: Die Bäume sind gefällt worden (worden, not geworden). The agent: von + dative: von der Stadt.\n\nwerden alone means to become: Das Klima wird wärmer. Er ist Lehrer geworden.",
                     "المجهول = werden + اسم المفعول. المضارع: Die Bäume werden gefällt. الـ Präteritum: Die Bäume wurden gefällt. الـ Perfekt: Die Bäume sind gefällt worden (worden مش geworden). والفاعل: von + داتيف: von der Stadt.\n\nwerden لوحدها معناها يبقى/يصير: Das Klima wird wärmer. Er ist Lehrer geworden."),
                    [("Jedes Jahr ___ viele Bäume gefällt.", "werden", "werden"), ("Die Bäume ___ letztes Jahr gefällt. (past)", "wurden", "werden"),
                     ("Die Bäume sind gefällt ___.", "worden", "werden"), ("Das Klima ___ wärmer.", "wird", "werden")]),
            "nl": G(("The passive in different tenses; worden", "المجهول في الأزمنة المختلفة؛ worden"),
                    ("Present: Er worden bomen gekapt. Past: Er werden bomen gekapt. Perfect: Er zijn bomen gekapt (Dutch drops geworden in the perfect passive). Agent: door: door de gemeente.\n\nworden = to become: Het klimaat wordt warmer. Hij is leraar geworden.\n\nWith an indefinite subject Dutch likes er: Er worden veel bomen gekapt.",
                     "المضارع: Er worden bomen gekapt. الماضي: Er werden bomen gekapt. والـ perfect: Er zijn bomen gekapt (الهولندي بيشيل geworden في المجهول التام). والفاعل: door: door de gemeente.\n\nworden = يبقى: Het klimaat wordt warmer. Hij is leraar geworden.\n\nمع فاعل غير محدد الهولندي بيحب er: Er worden veel bomen gekapt."),
                    [("Elk jaar ___ veel bomen gekapt.", "worden", "worden"), ("Vorig jaar ___ veel bomen gekapt.", "werden", "worden"),
                     ("De bomen zijn gekapt ___ de gemeente.", "door", "door"), ("Het klimaat ___ warmer.", "wordt", "worden")]),
            "es": G(("Passive se, ser + participle; volverse", "المجهول بـ se وser + اسم المفعول؛ volverse"),
                    ("Everyday passive: se + verb agreeing with the thing: Se talan muchos árboles. Se recicla el plástico.\n\nFormal passive: ser + participle (agreeing) + por: Los árboles fueron talados por la empresa.\n\nTo become: hacerse, ponerse, volverse: El clima se vuelve más cálido. Se hizo profesor.",
                     "المجهول اليومي: se + فعل بيطابق الحاجة: Se talan muchos árboles. Se recicla el plástico.\n\nالمجهول الرسمي: ser + اسم المفعول (مطابق) + por: Los árboles fueron talados por la empresa.\n\nيبقى: hacerse، ponerse، volverse: El clima se vuelve más cálido. Se hizo profesor."),
                    [("___ talan muchos árboles.", "Se", "se"), ("Los árboles fueron ___ por la empresa. (talar)", "talados", "talar"),
                     ("Tenemos que ___ la naturaleza.", "proteger", "proteger"), ("El clima se ___ más cálido. (volver)", "vuelve", "volverse")]),
        },
    },
    {
        "key": "u06", "write_en": "a piece of news you read recently and what you think of it", "write_ar": "خبر قريته قريب ورأيك فيه",
        "words": """
news | n | news | أخبار | die Nachrichten | het nieuws | las noticias
article | n | article | مقالة | der Artikel, Artikel | het artikel, artikelen | el artículo, artículos
report | v | to report | يبلّغ، يغطّي (خبر) | berichten | berichten | informar
journalist | n | journalist | صحفي | der Journalist, Journalisten | de journalist, journalisten | el periodista, periodistas
opinion | n | opinion | رأي | die Meinung, Meinungen | de mening, meningen | la opinión, opiniones
claim | v | to claim | يدّعي | behaupten | beweren | afirmar
although | conj | although | رغم إن | obwohl | hoewel | aunque
nevertheless | adv | nevertheless | ومع ذلك | trotzdem | toch | sin embargo
true | adj | true | حقيقي، صح | wahr | waar | verdadero
source | n | source | مصدر | die Quelle, Quellen | de bron, bronnen | la fuente, fuentes
""",
        "sentences": """
The journalist says that the news is true. | الصحفي بيقول إن الخبر صح. | Der Journalist sagt, die Nachricht sei wahr. | De journalist zegt dat het nieuws waar is. | El periodista dice que la noticia es verdadera.
Although it was late, I read the article. | رغم إن الوقت كان متأخر، قريت المقالة. | Obwohl es spät war, habe ich den Artikel gelesen. | Hoewel het laat was, heb ik het artikel gelezen. | Aunque era tarde, leí el artículo.
It was raining; nevertheless we went out. | كانت بتمطر؛ ومع ذلك خرجنا. | Es regnete; trotzdem sind wir hinausgegangen. | Het regende; toch zijn we naar buiten gegaan. | Llovía; sin embargo, salimos.
""",
        "grammar": {
            "de": G(("obwohl vs. trotzdem; indirect speech (intro)", "obwohl ولا trotzdem؛ الكلام المنقول (مقدمة)"),
                    ("obwohl (although) starts a subordinate clause, verb at the end: Obwohl es spät war, ... trotzdem (nevertheless) is an adverb in position 1 or 3, followed by the verb: Es regnete. Trotzdem sind wir hinausgegangen.\n\nNews reports use Konjunktiv I for reported speech, mainly er sei / er habe: Er sagt, die Nachricht sei wahr. In speech, dass + indicative is fine.",
                     "obwohl (رغم إن) بتبدأ جملة فرعية والفعل في الآخر: Obwohl es spät war, ... وtrotzdem (ومع ذلك) ظرف في المكان الأول أو التالت وبعده الفعل: Es regnete. Trotzdem sind wir hinausgegangen.\n\nالأخبار بتستخدم Konjunktiv I للكلام المنقول، غالبًا er sei / er habe: Er sagt, die Nachricht sei wahr. وفي الكلام العادي dass + المضارع العادي تمام."),
                    [("___ es spät war, las ich den Artikel.", "Obwohl", "obwohl / trotzdem"), ("Es regnete. ___ gingen wir hinaus.", "Trotzdem", "obwohl / trotzdem"),
                     ("Er sagt, die Nachricht ___ wahr.", "sei", "sein, Konj. I"), ("Sie sagt, sie ___ keine Zeit.", "habe", "haben, Konj. I")]),
            "nl": G(("hoewel vs. toch; reported speech", "hoewel ولا toch؛ الكلام المنقول"),
                    ("hoewel (although) sends the verb to the end: Hoewel het laat was, ... toch (still, nevertheless) is an adverb followed by the verb: Het regende; toch zijn we gegaan.\n\nDutch has no special verb form for reported speech: Hij zegt dat het nieuws waar is. Volgens de krant ... = according to the paper.",
                     "hoewel (رغم إن) بتبعت الفعل للآخر: Hoewel het laat was, ... وtoch (ومع ذلك) ظرف وبعده الفعل: Het regende; toch zijn we gegaan.\n\nالهولندي مفيهوش صيغة خاصة للكلام المنقول: Hij zegt dat het nieuws waar is. وVolgens de krant ... = حسب الجرنال."),
                    [("___ het laat was, las ik het artikel.", "Hoewel", "hoewel / toch"), ("Het regende; ___ gingen we naar buiten.", "toch", "hoewel / toch"),
                     ("Hij zegt ___ het waar is.", "dat", "dat"), ("___ de krant is het waar. (according to)", "Volgens", "volgens")]),
            "es": G(("aunque, sin embargo; reported speech", "aunque وsin embargo؛ الكلام المنقول"),
                    ("aunque + indicative = although (a fact): Aunque era tarde, leí el artículo. sin embargo = nevertheless, between sentences.\n\nReported speech shifts tenses after a past verb: Dice que es verdad → Dijo que era verdad. Dijo que vendría.",
                     "aunque + indicativo = رغم إن (حقيقة): Aunque era tarde, leí el artículo. وsin embargo = ومع ذلك، بين الجمل.\n\nالكلام المنقول بيغير الزمن بعد فعل ماضي: Dice que es verdad ← Dijo que era verdad. Dijo que vendría."),
                    [("___ era tarde, leí el artículo.", "Aunque", "aunque"), ("Llovía; sin ___, salimos.", "embargo", "sin embargo"),
                     ("Dijo que ___ verdad. (ser, past)", "era", "ser"), ("Dijo que ___ mañana. (venir, conditional)", "vendría", "venir")]),
        },
    },
    {
        "key": "u07", "write_en": "how the health system works in your country", "write_ar": "النظام الصحي في بلدك شغال إزاي",
        "words": """
health_insurance | n | health insurance | تأمين صحي | die Krankenversicherung | de zorgverzekering | el seguro médico
hospital | n | hospital | مستشفى | das Krankenhaus, Krankenhäuser | het ziekenhuis, ziekenhuizen | el hospital, hospitales
patient | n | patient | مريض | der Patient, Patienten | de patiënt, patiënten | el paciente, pacientes
prescription | n | prescription | روشتة | das Rezept, Rezepte | het recept, recepten | la receta, recetas
treatment | n | treatment | علاج | die Behandlung, Behandlungen | de behandeling, behandelingen | el tratamiento, tratamientos
emergency | n | emergency | طوارئ | der Notfall, Notfälle | het noodgeval, noodgevallen | la emergencia, emergencias
nurse | n | nurse | ممرض | die Pflegekraft, Pflegekräfte | de verpleegkundige, verpleegkundigen | el enfermero, enfermeros
avoid | v | to avoid | يتجنّب | vermeiden | vermijden | evitar
in_order_to | conj | in order to | عشان (هدف) | um ... zu | om ... te | para
so_that | conj | so that | عشان (يحصل كذا) | damit | zodat | para que
""",
        "sentences": """
I go to the doctor in order to get a prescription. | بروح للدكتور عشان آخد روشتة. | Ich gehe zum Arzt, um ein Rezept zu bekommen. | Ik ga naar de dokter om een recept te krijgen. | Voy al médico para conseguir una receta.
It is important to have health insurance. | مهم يكون عندك تأمين صحي. | Es ist wichtig, eine Krankenversicherung zu haben. | Het is belangrijk om een zorgverzekering te hebben. | Es importante tener seguro médico.
The nurse explains it so that the patient understands. | الممرضة بتشرح عشان المريض يفهم. | Die Pflegekraft erklärt es, damit der Patient es versteht. | De verpleegkundige legt het uit, zodat de patiënt het begrijpt. | La enfermera lo explica para que el paciente lo entienda.
""",
        "grammar": {
            "de": G(("zu + infinitive; um ... zu and damit", "zu + مصدر؛ um ... zu وdamit"),
                    ("Many verbs and phrases take zu + infinitive at the end: Es ist wichtig, eine Versicherung zu haben. Ich versuche, gesund zu leben. With separable verbs zu goes inside: anzurufen.\n\nPurpose: um ... zu when the subject is the same (Ich gehe zum Arzt, um ein Rezept zu bekommen); damit when it is different (..., damit der Patient es versteht).",
                     "أفعال وتعبيرات كتير بتاخد zu + مصدر في الآخر: Es ist wichtig, eine Versicherung zu haben. Ich versuche, gesund zu leben. ومع الأفعال المنفصلة zu بتدخل جوه: anzurufen.\n\nالهدف: um ... zu لما الفاعل واحد (Ich gehe zum Arzt, um ein Rezept zu bekommen)؛ وdamit لما الفاعل مختلف (..., damit der Patient es versteht)."),
                    [("Es ist wichtig, eine Versicherung ___ haben.", "zu", "zu"), ("Ich gehe zum Arzt, ___ ein Rezept zu bekommen.", "um", "um ... zu"),
                     ("Sie erklärt es, ___ er es versteht.", "damit", "damit"), ("Vergiss nicht, mich ___! (anrufen)", "anzurufen", "anrufen")]),
            "nl": G(("om ... te and zodat", "om ... te وzodat"),
                    ("Dutch puts te before the infinitive at the end, often with om: Het is belangrijk om een verzekering te hebben. Purpose: om ... te with the same subject: Ik ga naar de dokter om een recept te krijgen.\n\nWith a different subject: zodat + verb at the end: ..., zodat de patiënt het begrijpt.\n\nSeparable verbs: op te bellen.",
                     "الهولندي بيحط te قبل المصدر في الآخر، وغالبًا مع om: Het is belangrijk om een verzekering te hebben. والهدف: om ... te لما الفاعل واحد: Ik ga naar de dokter om een recept te krijgen.\n\nلما الفاعل مختلف: zodat + الفعل في الآخر: ..., zodat de patiënt het begrijpt.\n\nالأفعال المنفصلة: op te bellen."),
                    [("Het is belangrijk om een verzekering ___ hebben.", "te", "te"), ("Ik ga naar de dokter ___ een recept te krijgen.", "om", "om ... te"),
                     ("Ze legt het uit, ___ hij het begrijpt.", "zodat", "zodat"), ("Vergeet niet me op ___ bellen.", "te", "te")]),
            "es": G(("para + infinitive and para que + subjunctive", "para + مصدر وpara que + subjuntivo"),
                    ("Same subject: para + infinitive: Voy al médico para conseguir una receta.\n\nDifferent subject: para que + present subjunctive: Lo explica para que el paciente lo entienda. Subjunctive: -ar verbs take -e endings, -er/-ir verbs take -a endings: hable, entienda, viva.\n\nEs importante + infinitive: Es importante tener seguro.",
                     "نفس الفاعل: para + مصدر: Voy al médico para conseguir una receta.\n\nفاعل مختلف: para que + المضارع الـ subjuntivo: Lo explica para que el paciente lo entienda. الـ subjuntivo: أفعال ‎-ar بتاخد نهايات ‎-e، وأفعال ‎-er/-ir بتاخد ‎-a: hable، entienda، viva.\n\nEs importante + مصدر: Es importante tener seguro."),
                    [("Voy al médico ___ conseguir una receta.", "para", "para"), ("Lo explica para que el paciente lo ___. (entender)", "entienda", "entender"),
                     ("Habla despacio para que yo ___. (comprender)", "comprenda", "comprender"), ("Es importante ___ seguro. (tener)", "tener", "tener")]),
        },
    },
    {
        "key": "u08", "write_en": "a film, concert or exhibition you saw and what had happened before", "write_ar": "فيلم أو حفلة أو معرض شفته وإيه اللي حصل قبلها",
        "words": """
art | n | art | فن | die Kunst | de kunst | el arte
exhibition | n | exhibition | معرض | die Ausstellung, Ausstellungen | de tentoonstelling, tentoonstellingen | la exposición, exposiciones
painting | n | painting (picture) | لوحة | das Gemälde, Gemälde | de schilderij-tentoonstelling | la pintura, pinturas
artist | n | artist | فنان | der Künstler, Künstler | de kunstenaar, kunstenaars | el artista, artistas
concert | n | concert | حفلة موسيقية | das Konzert, Konzerte | het concert, concerten | el concierto, conciertos
theatre | n | theatre | مسرح | das Theater, Theater | het theater, theaters | el teatro, teatros
audience | n | audience | الجمهور | das Publikum | het publiek | el público
after_conj | conj | after (doing) | بعد ما | nachdem | nadat | después de que
before_conj | conj | before (doing) | قبل ما | bevor | voordat | antes de que
famous | adj | famous | مشهور | berühmt | beroemd | famoso
""",
        "sentences": """
After we had eaten, we went to the concert. | بعد ما كنا أكلنا، رحنا الحفلة. | Nachdem wir gegessen hatten, gingen wir ins Konzert. | Nadat we hadden gegeten, gingen we naar het concert. | Después de que habíamos comido, fuimos al concierto.
Before the exhibition opened, many people were waiting. | قبل ما المعرض يفتح، ناس كتير كانوا مستنيين. | Bevor die Ausstellung öffnete, warteten viele Leute. | Voordat de tentoonstelling openging, wachtten veel mensen. | Antes de que abriera la exposición, mucha gente esperaba.
The artist is very famous. | الفنان مشهور جدًا. | Der Künstler ist sehr berühmt. | De kunstenaar is heel beroemd. | El artista es muy famoso.
""",
        "grammar": {
            "de": G(("Plusquamperfekt; nachdem, bevor", "الماضي الأسبق (Plusquamperfekt)؛ nachdem وbevor"),
                    ("The past before the past: hatte/war + participle: Wir hatten gegessen. Er war schon gegangen.\n\nnachdem (after) usually goes with Plusquamperfekt in the clause and Präteritum/Perfekt in the main clause: Nachdem wir gegessen hatten, gingen wir ins Konzert.\n\nbevor (before) takes the same tense as the main clause: Bevor die Ausstellung öffnete, warteten viele Leute.",
                     "الماضي قبل الماضي: hatte/war + اسم المفعول: Wir hatten gegessen. Er war schon gegangen.\n\nnachdem (بعد ما) غالبًا مع الـ Plusquamperfekt في جملتها، والـ Präteritum/Perfekt في الجملة الأساسية: Nachdem wir gegessen hatten, gingen wir ins Konzert.\n\nbevor (قبل ما) بتاخد نفس زمن الجملة الأساسية: Bevor die Ausstellung öffnete, warteten viele Leute."),
                    [("Nachdem wir gegessen ___, gingen wir.", "hatten", "haben"), ("Er ___ schon gegangen. (past perfect)", "war", "sein"),
                     ("___ die Ausstellung öffnete, warteten wir.", "Bevor", "bevor / nachdem"), ("___ er angekommen war, aßen wir.", "Nachdem", "bevor / nachdem")]),
            "nl": G(("Plusquamperfectum; nadat, voordat", "الماضي الأسبق؛ nadat وvoordat"),
                    ("had/was + participle: We hadden gegeten. Hij was al vertrokken.\n\nnadat (after) + past perfect, verb at the end: Nadat we hadden gegeten, gingen we naar het concert. voordat (before): Voordat de tentoonstelling openging, wachtten veel mensen.\n\nNote: nadat/voordat are conjunctions; na/voor are prepositions: na het eten, voor het concert.",
                     "had/was + اسم المفعول: We hadden gegeten. Hij was al vertrokken.\n\nnadat (بعد ما) + الماضي الأسبق والفعل في الآخر: Nadat we hadden gegeten, gingen we naar het concert. وvoordat (قبل ما): Voordat de tentoonstelling openging, wachtten veel mensen.\n\nخلي بالك: nadat/voordat أدوات ربط؛ وna/voor حروف جر: na het eten، voor het concert."),
                    [("Nadat we ___ gegeten, gingen we.", "hadden", "hebben"), ("Hij ___ al vertrokken. (past perfect)", "was", "zijn"),
                     ("___ de tentoonstelling openging, wachtten we.", "Voordat", "voordat"), ("___ het eten gingen we weg. (after, prep.)", "Na", "na")]),
            "es": G(("Pluscuamperfecto; después de, antes de", "الماضي الأسبق؛ después de وantes de"),
                    ("había + participle: Habíamos comido. Él ya se había ido.\n\nWith the same subject use después de / antes de + infinitive: Después de comer, fuimos al concierto. With a different subject: después de que / antes de que + verb; antes de que always takes the subjunctive: Antes de que abriera la exposición, ...",
                     "había + اسم المفعول: Habíamos comido. Él ya se había ido.\n\nمع نفس الفاعل استخدم después de / antes de + مصدر: Después de comer, fuimos al concierto. ومع فاعل مختلف: después de que / antes de que + فعل؛ وantes de que دايمًا بتاخد subjuntivo: Antes de que abriera la exposición, ..."),
                    [("Ya ___ comido. (nosotros)", "habíamos", "haber"), ("Después ___ comer, fuimos al concierto.", "de", "de"),
                     ("Él ya se había ___. (ir)", "ido", "ir"), ("Antes ___ que abriera, esperábamos.", "de", "de")]),
        },
    },
    {
        "key": "u09", "write_en": "how you get around and the problems of traffic in your city", "write_ar": "بتتنقل إزاي ومشاكل المرور في مدينتك",
        "words": """
traffic | n | traffic | مرور، زحمة | der Verkehr | het verkeer | el tráfico
traffic_jam | n | traffic jam | زحمة | der Stau, Staus | de file, files | el atasco, atascos
delay | n | delay | تأخير | die Verspätung, Verspätungen | de vertraging, vertragingen | el retraso, retrasos
bicycle | n | bicycle | عجلة | das Fahrrad, Fahrräder | de fiets, fietsen | la bicicleta, bicicletas
connection | n | connection (transport) | مواصلة | die Verbindung, Verbindungen | de verbinding, verbindingen | la conexión, conexiones
public_transport | n | public transport | مواصلات عامة | die öffentlichen Verkehrsmittel | het openbaar vervoer | el transporte público
because_of | prep | because of | بسبب | wegen | vanwege | debido a
instead_of | prep | instead of | بدل | statt | in plaats van | en lugar de
arrive | v | to arrive | يوصل | ankommen | aankomen | llegar
miss | v | to miss (a train) | يفوّت | verpassen | missen | perder
""",
        "sentences": """
Because of the traffic jam I missed the train. | بسبب الزحمة فوّت القطر. | Wegen des Staus habe ich den Zug verpasst. | Vanwege de file heb ik de trein gemist. | Debido al atasco perdí el tren.
During the journey the train had a delay. | خلال الرحلة القطر اتأخر. | Während der Fahrt hatte der Zug Verspätung. | Tijdens de reis had de trein vertraging. | Durante el viaje el tren tuvo retraso.
Instead of the car I take the bike. | بدل العربية باخد العجلة. | Statt des Autos nehme ich das Fahrrad. | In plaats van de auto neem ik de fiets. | En lugar del coche tomo la bicicleta.
""",
        "grammar": {
            "de": G(("Genitive and genitive prepositions", "الجينيتيف وحروف الجر بتاعته"),
                    ("wegen (because of), während (during), statt (instead of), trotz (despite) take the genitive in writing: wegen des Staus, während der Fahrt, statt des Autos, trotz des Regens. Masculine and neuter nouns add -(e)s.\n\nIn speech you often hear the dative: wegen dem Stau.",
                     "wegen (بسبب)، während (خلال)، statt (بدل)، trotz (رغم) بياخدوا جينيتيف في الكتابة: wegen des Staus، während der Fahrt، statt des Autos، trotz des Regens. والمذكر والمحايد بيزودوا ‎-(e)s.\n\nفي الكلام بتسمع الداتيف كتير: wegen dem Stau."),
                    [("Wegen ___ Staus kam ich zu spät.", "des", "der Stau"), ("Während ___ Fahrt schlief ich.", "der", "die Fahrt"),
                     ("Statt des ___ nehme ich das Fahrrad.", "Autos", "das Auto"), ("Trotz ___ Regens gingen wir.", "des", "der Regen")]),
            "nl": G(("vanwege, tijdens, in plaats van, ondanks", "vanwege وtijdens وin plaats van وondanks"),
                    ("Dutch uses these prepositions without any case change: vanwege de file, tijdens de reis, in plaats van de auto, ondanks de regen.\n\nmissen = to miss (a train, a person): Ik heb de trein gemist. Ik mis je. Note German vermissen for people, verpassen for trains.",
                     "الهولندي بيستخدم حروف الجر دي من غير تغيير: vanwege de file، tijdens de reis، in plaats van de auto، ondanks de regen.\n\nmissen = يفوّت (قطر) أو يوحشه (شخص): Ik heb de trein gemist. Ik mis je. وخلي بالك: الألماني بيقول vermissen للأشخاص وverpassen للقطر."),
                    [("___ de file kwam ik te laat. (because of)", "Vanwege", "vanwege"), ("In ___ van de auto neem ik de fiets.", "plaats", "in plaats van"),
                     ("Ik heb de trein ___. (missen)", "gemist", "missen"), ("___ de regen gingen we. (despite)", "Ondanks", "ondanks")]),
            "es": G(("debido a, durante, en lugar de, a pesar de", "debido a وdurante وen lugar de وa pesar de"),
                    ("Spanish prepositions of cause and contrast: debido a / por (because of), durante (during), en lugar de / en vez de (instead of), a pesar de (despite). a + el = al, de + el = del: debido al atasco, en lugar del coche.\n\nperder = to miss (a train) and to lose: Perdí el tren.",
                     "حروف الجر للسبب والمقارنة في الإسباني: debido a / por (بسبب)، durante (خلال)، en lugar de / en vez de (بدل)، a pesar de (رغم). وa + el = al، de + el = del: debido al atasco، en lugar del coche.\n\nperder = يفوّت (قطر) ويضيّع: Perdí el tren."),
                    [("Debido ___ atasco llegué tarde.", "al", "a + el"), ("En lugar ___ coche tomo la bici.", "del", "de + el"),
                     ("A pesar ___ la lluvia salimos.", "de", "de"), ("Ayer ___ el tren. (yo, perder)", "perdí", "perder")]),
        },
    },
    {
        "key": "u10", "write_en": "what you would change if you were the mayor of your city", "write_ar": "كنت هتغير إيه لو كنت محافظ مدينتك",
        "words": """
politics | n | politics | سياسة | die Politik | de politiek | la política
government | n | government | حكومة | die Regierung, Regierungen | de regering, regeringen | el gobierno, gobiernos
election | n | election | انتخابات | die Wahl, Wahlen | de verkiezing, verkiezingen | las elecciones
vote | v | to vote | ينتخب، يصوّت | wählen | stemmen | votar
citizen | n | citizen | مواطن | der Bürger, Bürger | de burger, burgers | el ciudadano, ciudadanos
society | n | society | مجتمع | die Gesellschaft, Gesellschaften | de samenleving, samenlevingen | la sociedad, sociedades
law | n | law | قانون | das Gesetz, Gesetze | de wet, wetten | la ley, leyes
right_n | n | right (entitlement) | حق | das Recht, Rechte | het recht, rechten | el derecho, derechos
equal | adj | equal | متساوي | gleich | gelijk | igual
the_more | conj | the more ... the more | كل ما ... كل ما | je ... desto | hoe ... hoe | cuanto más ... más
""",
        "sentences": """
If I had voted, the result would have been different. | لو كنت صوّت، النتيجة كانت هتبقى مختلفة. | Wenn ich gewählt hätte, wäre das Ergebnis anders gewesen. | Als ik had gestemd, was de uitslag anders geweest. | Si hubiera votado, el resultado habría sido diferente.
The more people vote, the better. | كل ما الناس تصوّت أكتر، كل ما يبقى أحسن. | Je mehr Menschen wählen, desto besser. | Hoe meer mensen stemmen, hoe beter. | Cuantas más personas votan, mejor.
All citizens have equal rights. | كل المواطنين ليهم حقوق متساوية. | Alle Bürger haben gleiche Rechte. | Alle burgers hebben gelijke rechten. | Todos los ciudadanos tienen los mismos derechos.
""",
        "grammar": {
            "de": G(("Konjunktiv II past; je ... desto", "الـ Konjunktiv II في الماضي؛ je ... desto"),
                    ("Unreal past: hätte/wäre + participle: Wenn ich gewählt hätte, wäre das Ergebnis anders gewesen. Ich hätte das nicht gemacht. With modal verbs: Ich hätte kommen können.\n\nje + comparative (verb at the end), desto + comparative + verb: Je mehr Menschen wählen, desto besser ist es.",
                     "الماضي غير الحقيقي: hätte/wäre + اسم المفعول: Wenn ich gewählt hätte, wäre das Ergebnis anders gewesen. Ich hätte das nicht gemacht. ومع أفعال الوجه: Ich hätte kommen können.\n\nje + صيغة مقارنة (الفعل في الآخر)، desto + صيغة مقارنة + الفعل: Je mehr Menschen wählen, desto besser ist es."),
                    [("Wenn ich gewählt ___, ...", "hätte", "haben"), ("..., ___ das Ergebnis anders gewesen.", "wäre", "sein"),
                     ("___ mehr Menschen wählen, desto besser.", "Je", "je"), ("Je früher, ___ besser.", "desto", "desto")]),
            "nl": G(("Unreal past; hoe ... hoe", "الماضي غير الحقيقي؛ hoe ... hoe"),
                    ("Unreal past in Dutch often uses the past perfect: Als ik had gestemd, was de uitslag anders geweest. Or with zou: ..., zou de uitslag anders zijn geweest.\n\nThe more ... the more: hoe + comparative ..., hoe + comparative: Hoe meer mensen stemmen, hoe beter. Also: hoe ..., des te ...",
                     "الماضي غير الحقيقي في الهولندي غالبًا بالماضي الأسبق: Als ik had gestemd, was de uitslag anders geweest. أو بـ zou: ..., zou de uitslag anders zijn geweest.\n\nكل ما ... كل ما: hoe + صيغة مقارنة ...، hoe + صيغة مقارنة: Hoe meer mensen stemmen, hoe beter. وكمان: hoe ..., des te ..."),
                    [("Als ik ___ gestemd, ...", "had", "hebben"), ("..., ___ de uitslag anders geweest.", "was", "zijn"),
                     ("___ meer mensen stemmen, hoe beter.", "Hoe", "hoe"), ("..., zou het anders zijn ___.", "geweest", "zijn")]),
            "es": G(("Past unreal conditions; cuanto más", "الشرط غير الحقيقي في الماضي؛ cuanto más"),
                    ("si + pluscuamperfecto de subjuntivo (hubiera + participle), then condicional compuesto (habría + participle): Si hubiera votado, el resultado habría sido diferente.\n\ncuanto más ..., más ...; cuanto + noun agrees: cuantas más personas: Cuantas más personas votan, mejor.",
                     "si + pluscuamperfecto de subjuntivo (hubiera + اسم المفعول)، وبعدها condicional compuesto (habría + اسم المفعول): Si hubiera votado, el resultado habría sido diferente.\n\ncuanto más ...، más ...؛ وcuanto بتطابق الاسم: cuantas más personas: Cuantas más personas votan, mejor."),
                    [("Si ___ votado, ... (yo)", "hubiera", "haber"), ("..., el resultado ___ sido diferente.", "habría", "haber"),
                     ("___ más personas votan, mejor.", "Cuantas", "cuanto"), ("Cuanto más estudio, ___ aprendo.", "más", "más")]),
        },
    },
    {
        "key": "u11", "write_en": "a person who is important to you and why", "write_ar": "شخص مهم بالنسبالك وليه",
        "words": """
feeling | n | feeling | إحساس | das Gefühl, Gefühle | het gevoel, gevoelens | el sentimiento, sentimientos
happy | adj | happy | مبسوط، سعيد | glücklich | gelukkig | feliz
sad | adj | sad | زعلان | traurig | verdrietig | triste
angry | adj | angry | متضايق، غضبان | wütend | boos | enfadado
jealous | adj | jealous | غيران | eifersüchtig | jaloers | celoso
trust | v | to trust | يثق | vertrauen | vertrouwen | confiar
wait_for | v | to wait for | يستنى (حد) | warten auf | wachten op | esperar
think_of | v | to think of | يفكر في | denken an | denken aan | pensar en
be_afraid | v | to be afraid of | يخاف من | Angst haben vor | bang zijn voor | tener miedo de
dream | v | to dream of | يحلم بـ | träumen von | dromen van | soñar con
""",
        "sentences": """
I often think of my family. | بفكر في عيلتي كتير. | Ich denke oft an meine Familie. | Ik denk vaak aan mijn familie. | Pienso a menudo en mi familia.
What are you waiting for? – For the bus. | مستني إيه؟ – الأتوبيس. | Worauf wartest du? – Auf den Bus. | Waarop wacht je? – Op de bus. | ¿Qué esperas? – El autobús.
She dreams of a house by the sea. | بتحلم ببيت على البحر. | Sie träumt von einem Haus am Meer. | Ze droomt van een huis aan zee. | Sueña con una casa junto al mar.
""",
        "grammar": {
            "de": G(("Verbs with prepositions; da- and wo- words", "أفعال مع حروف جر؛ كلمات da- وwo-"),
                    ("Many verbs have a fixed preposition: denken an (+acc.), warten auf (+acc.), träumen von (+dat.), Angst haben vor (+dat.), sich freuen auf/über.\n\nFor things, questions use wo(r)- + preposition: Worauf wartest du? Wovon träumst du? Answers can use da(r)-: Ich warte darauf. For people: Auf wen wartest du? Ich warte auf ihn.",
                     "أفعال كتير ليها حرف جر ثابت: denken an (+أكوزاتيف)، warten auf (+أكوزاتيف)، träumen von (+داتيف)، Angst haben vor (+داتيف)، sich freuen auf/über.\n\nللحاجات، السؤال بـ wo(r)- + حرف الجر: Worauf wartest du? Wovon träumst du? والإجابة ممكن بـ da(r)-: Ich warte darauf. وللأشخاص: Auf wen wartest du? Ich warte auf ihn."),
                    [("Ich denke oft ___ meine Familie.", "an", "denken an"), ("___ wartest du? (what for)", "Worauf", "wo + auf"),
                     ("Sie träumt ___ einem Haus.", "von", "träumen von"), ("Ich warte ___. (for it)", "darauf", "da + auf")]),
            "nl": G(("Verbs with prepositions; waar- and er-", "أفعال مع حروف جر؛ waar- وer-"),
                    ("Fixed prepositions: denken aan, wachten op, dromen van, bang zijn voor, houden van.\n\nFor things: waar + preposition in questions (Waarop wacht je? Waarvan droom je?), er + preposition in answers (Ik wacht erop). Often split: Waar wacht je op? Ik wacht er al lang op.\n\nFor people: Op wie wacht je?",
                     "حروف جر ثابتة: denken aan، wachten op، dromen van، bang zijn voor، houden van.\n\nللحاجات: waar + حرف الجر في السؤال (Waarop wacht je? Waarvan droom je?)، وer + حرف الجر في الإجابة (Ik wacht erop). وغالبًا بيتفصلوا: Waar wacht je op? Ik wacht er al lang op.\n\nللأشخاص: Op wie wacht je?"),
                    [("Ik denk vaak ___ mijn familie.", "aan", "denken aan"), ("___ wacht je? (what for)", "Waarop", "waar + op"),
                     ("Ze droomt ___ een huis aan zee.", "van", "dromen van"), ("Ik wacht ___. (for it)", "erop", "er + op")]),
            "es": G(("Verbs with prepositions", "أفعال مع حروف جر"),
                    ("Spanish verbs also have fixed prepositions, often different from German and Dutch: pensar en (think of), soñar con (dream of), tener miedo de (be afraid of), confiar en (trust), enamorarse de (fall in love with).\n\nesperar takes no preposition: Espero el autobús. Questions keep the preposition first: ¿En qué piensas? ¿Con qué sueñas?",
                     "الأفعال الإسبانية برضه ليها حروف جر ثابتة، وغالبًا مختلفة عن الألماني والهولندي: pensar en (يفكر في)، soñar con (يحلم بـ)، tener miedo de (يخاف من)، confiar en (يثق في)، enamorarse de (يحب).\n\nesperar من غير حرف جر: Espero el autobús. والسؤال بيبدأ بحرف الجر: ¿En qué piensas? ¿Con qué sueñas?"),
                    [("Pienso a menudo ___ mi familia.", "en", "pensar en"), ("Sueña ___ una casa junto al mar.", "con", "soñar con"),
                     ("Tengo miedo ___ los perros.", "de", "tener miedo de"), ("¿___ qué piensas?", "En", "en")]),
        },
    },
    {
        "key": "u12", "write_en": "a technology you use every day and how it has changed your life", "write_ar": "تكنولوجيا بتستخدمها كل يوم وغيّرت حياتك إزاي",
        "words": """
science | n | science | علم | die Wissenschaft, Wissenschaften | de wetenschap, wetenschappen | la ciencia, ciencias
research | n | research | بحث | die Forschung | het onderzoek | la investigación
invention | n | invention | اختراع | die Erfindung, Erfindungen | de uitvinding, uitvindingen | el invento, inventos
develop | v | to develop | يطوّر | entwickeln | ontwikkelen | desarrollar
device | n | device | جهاز | das Gerät, Geräte | het apparaat, apparaten | el aparato, aparatos
data | n | data | بيانات | die Daten | de gegevens | los datos
robot | n | robot | روبوت | der Roboter, Roboter | de robot, robots | el robot, robots
progress | n | progress | تقدم | der Fortschritt, Fortschritte | de vooruitgang | el progreso
growing | adj | growing | متزايد | wachsend | groeiend | creciente
developed | adj | developed | متطور | entwickelt | ontwikkeld | desarrollado
""",
        "sentences": """
The newly developed device is very fast. | الجهاز اللي اتطور جديد سريع جدًا. | Das neu entwickelte Gerät ist sehr schnell. | Het nieuw ontwikkelde apparaat is heel snel. | El aparato recién desarrollado es muy rápido.
The growing amount of data is a problem. | كمية البيانات المتزايدة مشكلة. | Die wachsende Menge an Daten ist ein Problem. | De groeiende hoeveelheid gegevens is een probleem. | La creciente cantidad de datos es un problema.
Research makes progress every day. | البحث بيتقدم كل يوم. | Die Forschung macht jeden Tag Fortschritte. | Het onderzoek boekt elke dag vooruitgang. | La investigación progresa cada día.
""",
        "grammar": {
            "de": G(("Participles as adjectives", "اسم الفاعل واسم المفعول كصفات"),
                    ("Present participle = infinitive + d, describes something happening: wachsen → wachsend: die wachsende Menge. Past participle describes something done: entwickeln → entwickelt: das entwickelte Gerät.\n\nBefore a noun both take normal adjective endings: ein schnell wachsender Markt, die neu entwickelten Geräte.",
                     "اسم الفاعل = المصدر + d، بيوصف حاجة بتحصل: wachsen ← wachsend: die wachsende Menge. واسم المفعول بيوصف حاجة اتعملت: entwickeln ← entwickelt: das entwickelte Gerät.\n\nقبل الاسم الاتنين بياخدوا نهايات الصفات العادية: ein schnell wachsender Markt، die neu entwickelten Geräte."),
                    [("die ___ Menge (wachsen)", "wachsende", "wachsen"), ("das neu ___ Gerät (entwickeln)", "entwickelte", "entwickeln"),
                     ("ein ___ Kind (schlafen)", "schlafendes", "schlafen"), ("die ___ Daten (speichern)", "gespeicherten", "speichern")]),
            "nl": G(("Participles as adjectives", "اسم الفاعل واسم المفعول كصفات"),
                    ("Present participle = infinitive + d(e): groeien → groeiend, de groeiende hoeveelheid. Past participle: ontwikkelen → ontwikkeld, het ontwikkelde apparaat. They follow the normal adjective -e rule: een groeiende markt, een ontwikkeld land.\n\nboeken here means to achieve: vooruitgang boeken = to make progress.",
                     "اسم الفاعل = المصدر + d(e): groeien ← groeiend، de groeiende hoeveelheid. واسم المفعول: ontwikkelen ← ontwikkeld، het ontwikkelde apparaat. وبيمشوا على قاعدة ‎-e العادية: een groeiende markt، een ontwikkeld land.\n\nboeken هنا معناها يحقق: vooruitgang boeken = يتقدم."),
                    [("de ___ hoeveelheid (groeien)", "groeiende", "groeien"), ("het nieuw ___ apparaat (ontwikkelen)", "ontwikkelde", "ontwikkelen"),
                     ("een ___ land (ontwikkelen)", "ontwikkeld", "ontwikkelen"), ("Het onderzoek boekt ___.", "vooruitgang", "vooruitgang")]),
            "es": G(("Participles and -ente adjectives", "اسم المفعول وصفات ‎-ente"),
                    ("Past participles work as adjectives and agree: el aparato desarrollado, las ciudades desarrolladas. recién + participle = newly: recién desarrollado.\n\nMany adjectives in -ante / -ente come from verbs: creciente (growing), interesante, sorprendente. They change only for number: crecientes.",
                     "اسم المفعول بيشتغل صفة وبيطابق: el aparato desarrollado، las ciudades desarrolladas. وrecién + اسم المفعول = لسه/حديثًا: recién desarrollado.\n\nصفات كتير بتخلص بـ ‎-ante / -ente جاية من أفعال: creciente (متزايد)، interesante، sorprendente. وبتتغير في العدد بس: crecientes."),
                    [("el aparato ___ (desarrollar)", "desarrollado", "desarrollar"), ("las ciudades ___ (desarrollar)", "desarrolladas", "desarrollar"),
                     ("la ___ cantidad de datos (crecer)", "creciente", "crecer"), ("un aparato ___ desarrollado (newly)", "recién", "recién")]),
        },
    },
    {
        "key": "u13", "write_en": "a sport or hobby you would recommend and why", "write_ar": "رياضة أو هواية تنصح بيها وليه",
        "words": """
team | n | team | فريق | die Mannschaft, Mannschaften | het team, teams | el equipo, equipos
match | n | match, game | ماتش | das Spiel, Spiele | de wedstrijd, wedstrijden | el partido, partidos
win | v | to win | يكسب | gewinnen | winnen | ganar
lose | v | to lose | يخسر | verlieren | verliezen | perder
training | n | training | تمرين | das Training | de training, trainingen | el entrenamiento
competition | n | competition | مسابقة | der Wettbewerb, Wettbewerbe | de wedstrijd-competitie | la competición, competiciones
hobby | n | hobby | هواية | das Hobby, Hobbys | de hobby, hobby's | el pasatiempo, pasatiempos
both_and | conj | both ... and | سواء ... أو، الاتنين | sowohl ... als auch | zowel ... als | tanto ... como
neither_nor | conj | neither ... nor | لا ... ولا | weder ... noch | noch ... noch | ni ... ni
either_or | conj | either ... or | يا ... يا | entweder ... oder | óf ... óf | o ... o
""",
        "sentences": """
I like both football and tennis. | بحب الكورة والتنس الاتنين. | Ich mag sowohl Fußball als auch Tennis. | Ik hou zowel van voetbal als van tennis. | Me gustan tanto el fútbol como el tenis.
Our team neither won nor lost. | فريقنا لا كسب ولا خسر. | Unsere Mannschaft hat weder gewonnen noch verloren. | Ons team heeft noch gewonnen noch verloren. | Nuestro equipo ni ganó ni perdió.
Either we train today or tomorrow. | يا نتمرن النهاردة يا بكرة. | Entweder trainieren wir heute oder morgen. | Óf we trainen vandaag, óf morgen. | O entrenamos hoy o mañana.
""",
        "grammar": {
            "de": G(("Two-part conjunctions", "أدوات الربط المزدوجة"),
                    ("sowohl ... als auch = both ... and; weder ... noch = neither ... nor; entweder ... oder = either ... or; nicht nur ... sondern auch = not only ... but also; zwar ... aber = admittedly ... but.\n\nentweder at the start can be followed directly by the verb: Entweder trainieren wir heute oder morgen.",
                     "sowohl ... als auch = الاتنين؛ weder ... noch = لا ... ولا؛ entweder ... oder = يا ... يا؛ nicht nur ... sondern auch = مش بس ... لكن كمان؛ zwar ... aber = صحيح ... بس.\n\nentweder في أول الجملة ممكن ييجي بعدها الفعل على طول: Entweder trainieren wir heute oder morgen."),
                    [("Ich mag sowohl Fußball ___ auch Tennis.", "als", "sowohl ... als auch"), ("Wir haben weder gewonnen ___ verloren.", "noch", "weder ... noch"),
                     ("___ heute oder morgen.", "Entweder", "entweder ... oder"), ("nicht nur schnell, ___ auch stark", "sondern", "nicht nur ... sondern auch")]),
            "nl": G(("Two-part conjunctions", "أدوات الربط المزدوجة"),
                    ("zowel ... als = both ... and; noch ... noch = neither ... nor; óf ... óf = either ... or (with accents for stress); niet alleen ... maar ook = not only ... but also.\n\nNote: German weder ... noch vs. Dutch noch ... noch; German sowohl ... als auch vs. Dutch zowel ... als.",
                     "zowel ... als = الاتنين؛ noch ... noch = لا ... ولا؛ óf ... óf = يا ... يا (بعلامة للتأكيد)؛ niet alleen ... maar ook = مش بس ... لكن كمان.\n\nخلي بالك: الألماني weder ... noch والهولندي noch ... noch؛ والألماني sowohl ... als auch والهولندي zowel ... als."),
                    [("Ik hou zowel van voetbal ___ van tennis.", "als", "zowel ... als"), ("We hebben noch gewonnen ___ verloren.", "noch", "noch ... noch"),
                     ("niet alleen snel, ___ ook sterk", "maar", "niet alleen ... maar ook"), ("___ vandaag, óf morgen.", "Óf", "óf ... óf")]),
            "es": G(("Two-part conjunctions", "أدوات الربط المزدوجة"),
                    ("tanto ... como = both ... and; ni ... ni = neither ... nor (with no before the verb if ni comes after it: No ganó ni perdió); o ... o = either ... or; no solo ... sino también = not only ... but also.\n\no becomes u before o-/ho-: siete u ocho. y becomes e before i-/hi-: padres e hijos.",
                     "tanto ... como = الاتنين؛ ni ... ni = لا ... ولا (ومع no قبل الفعل لو ni جت بعده: No ganó ni perdió)؛ o ... o = يا ... يا؛ no solo ... sino también = مش بس ... لكن كمان.\n\no بتبقى u قبل كلمة بتبدأ بـ o/ho: siete u ocho. وy بتبقى e قبل i/hi: padres e hijos."),
                    [("Me gustan tanto el fútbol ___ el tenis.", "como", "tanto ... como"), ("Nuestro equipo ___ ganó ni perdió.", "ni", "ni ... ni"),
                     ("no solo rápido ___ también fuerte", "sino", "no solo ... sino"), ("siete ___ ocho", "u", "o")]),
        },
    },
    {
        "key": "u14", "write_en": "your plans for living or studying abroad", "write_ar": "خططك للعيشة أو الدراسة برة",
        "words": """
abroad_live | v | to emigrate | يهاجر | auswandern | emigreren | emigrar
foreigner | n | foreigner | أجنبي | der Ausländer, Ausländer | de buitenlander, buitenlanders | el extranjero, extranjeros
integration | n | integration | اندماج | die Integration | de integratie | la integración
homesickness | n | homesickness | الحنين للوطن | das Heimweh | de heimwee | la nostalgia
culture | n | culture | ثقافة | die Kultur, Kulturen | de cultuur, culturen | la cultura, culturas
language | n | language | لغة | die Sprache, Sprachen | de taal, talen | el idioma, idiomas
get_used | v | to get used to | يتعوّد | sich gewöhnen an | wennen aan | acostumbrarse a
plan_v | v | to plan | يخطط | planen | plannen | planear
visa | n | visa | فيزا | das Visum, Visa | het visum, visa | el visado, visados
probably | adv | probably | غالبًا، على الأرجح | wahrscheinlich | waarschijnlijk | probablemente
""",
        "sentences": """
Next year I will move to Spain. | السنة الجاية هعزّل إسبانيا. | Nächstes Jahr werde ich nach Spanien ziehen. | Volgend jaar ga ik naar Spanje verhuizen. | El año que viene me mudaré a España.
I will probably have homesickness. | غالبًا هيوحشني بلدي. | Ich werde wahrscheinlich Heimweh haben. | Ik zal waarschijnlijk heimwee hebben. | Probablemente tendré nostalgia.
You get used to a new culture. | الواحد بيتعوّد على ثقافة جديدة. | Man gewöhnt sich an eine neue Kultur. | Je went aan een nieuwe cultuur. | Uno se acostumbra a una nueva cultura.
""",
        "grammar": {
            "de": G(("The future with werden", "المستقبل بـ werden"),
                    ("Future = werden + infinitive at the end: Nächstes Jahr werde ich nach Spanien ziehen. ich werde, du wirst, er wird, wir werden, ihr werdet, sie werden.\n\nIn everyday speech the present with a time word is usual: Nächstes Jahr ziehe ich nach Spanien. werden + infinitive also expresses a guess: Er wird wohl krank sein.",
                     "المستقبل = werden + مصدر في الآخر: Nächstes Jahr werde ich nach Spanien ziehen. ich werde, du wirst, er wird, wir werden, ihr werdet, sie werden.\n\nفي الكلام اليومي المضارع مع كلمة وقت هو المعتاد: Nächstes Jahr ziehe ich nach Spanien. وwerden + مصدر بتعبر كمان عن توقع: Er wird wohl krank sein (غالبًا عيان)."),
                    [("Nächstes Jahr ___ ich nach Spanien ziehen.", "werde", "werden"), ("Du ___ Heimweh haben.", "wirst", "werden"),
                     ("Man gewöhnt sich ___ eine neue Kultur.", "an", "an"), ("Er ___ wohl krank sein.", "wird", "werden")]),
            "nl": G(("The future with zullen and gaan", "المستقبل بـ zullen وgaan"),
                    ("Dutch has two futures: gaan + infinitive for plans (Volgend jaar ga ik verhuizen) and zullen + infinitive for predictions and promises (Ik zal waarschijnlijk heimwee hebben. Ik zal je helpen).\n\nzullen: ik zal, jij zult/zal, hij zal, wij zullen.\n\nwennen aan = to get used to: Je went eraan.",
                     "الهولندي فيه مستقبلين: gaan + مصدر للخطط (Volgend jaar ga ik verhuizen)، وzullen + مصدر للتوقعات والوعود (Ik zal waarschijnlijk heimwee hebben. Ik zal je helpen).\n\nzullen: ik zal, jij zult/zal, hij zal, wij zullen.\n\nwennen aan = يتعوّد على: Je went eraan."),
                    [("Volgend jaar ___ ik naar Spanje verhuizen. (plan)", "ga", "gaan"), ("Ik ___ waarschijnlijk heimwee hebben.", "zal", "zullen"),
                     ("Je went ___ een nieuwe cultuur.", "aan", "aan"), ("Wij ___ je helpen. (promise)", "zullen", "zullen")]),
            "es": G(("The future tense and ir a", "المستقبل وir a"),
                    ("ir a + infinitive for plans: Voy a mudarme. Simple future = infinitive + -é, -ás, -á, -emos, -éis, -án: me mudaré, tendrás. Irregular stems: tener → tendr-, hacer → har-, poder → podr-, salir → saldr-, venir → vendr-, decir → dir-.\n\nThe future also expresses guesses: Serán las diez = it's probably ten.",
                     "ir a + مصدر للخطط: Voy a mudarme. والمستقبل البسيط = المصدر + ‎-é, -ás, -á, -emos, -éis, -án: me mudaré، tendrás. والجذور الشاذة: tener ← tendr-، hacer ← har-، poder ← podr-، salir ← saldr-، venir ← vendr-، decir ← dir-.\n\nالمستقبل بيعبر كمان عن التخمين: Serán las diez = غالبًا الساعة عشرة."),
                    [("El año que viene me ___ a España. (mudarse)", "mudaré", "mudarse"), ("Probablemente ___ nostalgia. (yo, tener)", "tendré", "tener"),
                     ("Uno se acostumbra ___ una nueva cultura.", "a", "a"), ("___ a estudiar en Madrid. (yo, ir)", "Voy", "ir")]),
        },
    },
    {
        "key": "u15", "write_en": "a formal email asking for information about a course", "write_ar": "إيميل رسمي تسأل فيه عن معلومات كورس",
        "words": """
request | n | request | طلب | die Anfrage, Anfragen | het verzoek, verzoeken | la petición, peticiones
inform | v | to inform | يبلّغ | informieren | informeren | informar
attach | v | to attach | يرفق | anhängen | bijvoegen | adjuntar
reply_n | n | reply | رد | die Antwort, Antworten | het antwoord, antwoorden | la respuesta, respuestas
regards | phr | kind regards | مع خالص التحية | mit freundlichen Grüßen | met vriendelijke groet | atentamente
dear_formal | phr | Dear Sir or Madam | السادة الأفاضل | sehr geehrte Damen und Herren | geachte heer, mevrouw | estimados señores
confirm | v | to confirm | يأكّد | bestätigen | bevestigen | confirmar
cancel | v | to cancel | يلغي | absagen | afzeggen | cancelar
registration | n | registration | تسجيل | die Anmeldung, Anmeldungen | de aanmelding, aanmeldingen | la inscripción, inscripciones
grateful | adj | grateful | ممتن | dankbar | dankbaar | agradecido
""",
        "sentences": """
I would be grateful for a quick reply. | أكون ممتن لو رديتوا بسرعة. | Für eine schnelle Antwort wäre ich Ihnen dankbar. | Ik zou u dankbaar zijn voor een snel antwoord. | Le agradecería una respuesta rápida.
Please find my CV attached. | مرفق السي في بتاعي. | Im Anhang finden Sie meinen Lebenslauf. | Bijgevoegd vindt u mijn cv. | Adjunto le envío mi currículum.
I would like to confirm my registration. | حابب أأكد تسجيلي. | Ich möchte meine Anmeldung bestätigen. | Ik wil graag mijn aanmelding bevestigen. | Quisiera confirmar mi inscripción.
""",
        "grammar": {
            "de": G(("Formal register and nominal style", "الأسلوب الرسمي والأسلوب الاسمي"),
                    ("Formal letters use Sie, Ihnen, Ihr with capitals, and open with Sehr geehrte Damen und Herren, / Sehr geehrter Herr Weber, / Sehr geehrte Frau Klein, and close with Mit freundlichen Grüßen.\n\nWritten German likes nouns instead of verbs: anmelden → die Anmeldung, antworten → die Antwort: Für eine schnelle Antwort wäre ich dankbar (instead of: wenn Sie schnell antworten). Polite forms: Ich möchte ..., Könnten Sie ...?, Ich wäre Ihnen dankbar, wenn ...",
                     "الجوابات الرسمية بتستخدم Sie وIhnen وIhr بحرف كبير، وبتبدأ بـ Sehr geehrte Damen und Herren, / Sehr geehrter Herr Weber, / Sehr geehrte Frau Klein، وتخلص بـ Mit freundlichen Grüßen.\n\nالألماني المكتوب بيحب الأسماء بدل الأفعال: anmelden ← die Anmeldung، antworten ← die Antwort: Für eine schnelle Antwort wäre ich dankbar (بدل: wenn Sie schnell antworten). والصيغ المؤدبة: Ich möchte ...، Könnten Sie ...?، Ich wäre Ihnen dankbar, wenn ..."),
                    [("Sehr ___ Damen und Herren,", "geehrte", "geehrt"), ("Mit freundlichen ___", "Grüßen", "Gruß"),
                     ("___ Sie mir bitte helfen? (polite, können)", "Könnten", "können"), ("Ich möchte meine ___ bestätigen. (anmelden → noun)", "Anmeldung", "anmelden")]),
            "nl": G(("Formal register in emails", "الأسلوب الرسمي في الإيميلات"),
                    ("Formal Dutch uses u and uw (lower case): Kunt u mij informeren? Ik stuur u mijn cv.\n\nOpenings: Geachte heer Jansen, / Geachte mevrouw De Vries, / Geachte heer, mevrouw,. Closing: Met vriendelijke groet.\n\nPolite phrases: Ik zou graag ... willen, Zou u ... kunnen ...?, Bijgevoegd vindt u ...",
                     "الهولندي الرسمي بيستخدم u وuw (بحرف صغير): Kunt u mij informeren? Ik stuur u mijn cv.\n\nالبداية: Geachte heer Jansen, / Geachte mevrouw De Vries, / Geachte heer, mevrouw,. والنهاية: Met vriendelijke groet.\n\nتعبيرات مؤدبة: Ik zou graag ... willen، Zou u ... kunnen ...?، Bijgevoegd vindt u ..."),
                    [("___ heer Jansen,", "Geachte", "geacht"), ("Met vriendelijke ___", "groet", "groet"),
                     ("___ u mij kunnen helpen?", "Zou", "zullen"), ("Bijgevoegd vindt u ___ cv. (my)", "mijn", "mijn")]),
            "es": G(("Formal register: usted and polite forms", "الأسلوب الرسمي: usted والصيغ المؤدبة"),
                    ("Formal Spanish uses usted/ustedes with third-person verbs and the pronouns le/les, su: Le envío mi currículum. ¿Podría usted informarme?\n\nOpenings: Estimado señor García: / Estimada señora López: / Estimados señores: (with a colon). Closings: Atentamente, / Un cordial saludo,\n\nPolite verbs: quisiera, podría, le agradecería.",
                     "الإسباني الرسمي بيستخدم usted/ustedes مع أفعال الغايب والضماير le/les وsu: Le envío mi currículum. ¿Podría usted informarme?\n\nالبداية: Estimado señor García: / Estimada señora López: / Estimados señores: (بنقطتين). والنهاية: Atentamente, / Un cordial saludo,\n\nأفعال مؤدبة: quisiera، podría، le agradecería."),
                    [("___ señores:", "Estimados", "estimado"), ("¿___ usted informarme? (poder, polite)", "Podría", "poder"),
                     ("___ confirmar mi inscripción. (querer, polite)", "Quisiera", "querer"), ("Le ___ una respuesta rápida. (agradecer)", "agradecería", "agradecer")]),
        },
    },
]
