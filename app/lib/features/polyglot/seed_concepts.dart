// Built-in languages and the sample parallel deck: 15 concepts covering the
// seven learning methods, each written in German, English, Dutch, Spanish,
// French and Arabic with IPA and a word-for-word gloss.
//
// IPA is broad (phonemic-leaning) transcription for learners, not a
// narrow phonetic one.

import 'models.dart';

const seedLanguages = [
  LanguageDef(
    code: 'de',
    name: 'German',
    nameAr: 'الألمانية',
    nativeName: 'Deutsch',
    flag: '🇩🇪',
    tts: 'de-DE',
    level: 'A1',
    colorValue: 0xFFB08900,
  ),
  LanguageDef(
    code: 'en',
    name: 'English',
    nameAr: 'الإنجليزية',
    nativeName: 'English',
    flag: '🇬🇧',
    tts: 'en-GB',
    level: 'B2',
    colorValue: 0xFF2F5D8A,
  ),
  LanguageDef(
    code: 'nl',
    name: 'Dutch',
    nameAr: 'الهولندية',
    nativeName: 'Nederlands',
    flag: '🇳🇱',
    tts: 'nl-NL',
    level: 'A0',
    colorValue: 0xFFD2601A,
  ),
  LanguageDef(
    code: 'es',
    name: 'Spanish',
    nameAr: 'الإسبانية',
    nativeName: 'Español',
    flag: '🇪🇸',
    tts: 'es-ES',
    level: 'A1',
    colorValue: 0xFFB3261E,
  ),
  LanguageDef(
    code: 'fr',
    name: 'French',
    nameAr: 'الفرنسية',
    nativeName: 'Français',
    flag: '🇫🇷',
    tts: 'fr-FR',
    level: 'A0',
    colorValue: 0xFF3B4CA8,
  ),
  LanguageDef(
    code: 'ar',
    name: 'Arabic',
    nameAr: 'العربية',
    nativeName: 'العربية',
    flag: '🇪🇬',
    tts: 'ar-EG',
    rtl: true,
    level: 'C1',
    colorValue: 0xFF2A7B76,
  ),
];

/// Languages on the deck the first time (four or more).
const seedActive = ['de', 'en', 'nl', 'es', 'fr'];

ConceptLine _l(
  String text,
  String ipa,
  String literal, [
  String natural = '',
]) => ConceptLine(text: text, ipa: ipa, literal: literal, natural: natural);

final seedConcepts = <Concept>[
  // ---------------------------------------------------------------- vocab
  Concept(
    id: 'k.house-big',
    aspect: Aspect.vocabulary,
    level: 'A1',
    titleEn: 'House & size',
    titleAr: 'البيت والحجم',
    meaningEn: 'The house is big.',
    meaningAr: 'البيت كبير.',
    noteEn:
        'German Haus, Dutch huis and English house are one Germanic word. '
        'Spanish casa and French maison come from Latin. Watch gender: '
        'das Haus (neuter), het huis (neuter), la casa / la maison (feminine).',
    noteAr:
        'Haus الألمانية و huis الهولندية و house الإنجليزية كلمة جرمانية واحدة. '
        'أما casa الإسبانية و maison الفرنسية فمن اللاتينية. انتبه للجنس: '
        'das Haus محايد، het huis محايد، la casa و la maison مؤنث.',
    wordGroups: ['c.house', 'c.big'],
    lines: {
      'de': _l(
        'Das Haus ist groß.',
        '[das haʊs ɪst ɡʁoːs]',
        'the house is big',
      ),
      'en': _l('The house is big.', '[ðə haʊs ɪz bɪɡ]', 'the house is big'),
      'nl': _l('Het huis is groot.', '[ɦət ɦœys ɪs ɣroːt]', 'the house is big'),
      'es': _l(
        'La casa es grande.',
        '[la ˈkasa es ˈɡɾande]',
        'the house is big',
      ),
      'fr': _l(
        'La maison est grande.',
        '[la mɛ.zɔ̃ ɛ ɡʁɑ̃d]',
        'the house is big',
      ),
      'ar': _l('البيتُ كبيرٌ.', '[al.bajtu ka.biː.run]', 'the-house big'),
    },
  ),
  Concept(
    id: 'k.make-decision',
    aspect: Aspect.vocabulary,
    level: 'A2',
    titleEn: 'Collocation: make a decision',
    titleAr: 'تلازم لفظي: يتخذ قرارًا',
    meaningEn: 'I have to make a decision.',
    meaningAr: 'يجب أن أتخذ قرارًا.',
    noteEn:
        'The verb is not "make" everywhere: German "trifft" (hits) a '
        'decision, Dutch, Spanish and French "take" one, Arabic "adopts" one. '
        'Learn verb + noun as one chunk.',
    noteAr:
        'الفعل ليس "يصنع" في كل اللغات: الألمانية "تصيب" القرار (treffen)، '
        'والهولندية والإسبانية والفرنسية "تأخذه"، والعربية "تتخذه". '
        'احفظ الفعل مع الاسم كقطعة واحدة.',
    wordGroups: ['c.decision'],
    lines: {
      'de': _l(
        'Ich muss eine Entscheidung treffen.',
        '[ɪç mʊs ˈaɪ̯nə ɛntˈʃaɪ̯dʊŋ ˈtʁɛfn̩]',
        'I must a decision hit',
      ),
      'en': _l(
        'I have to make a decision.',
        '[aɪ hæv tə meɪk ə dɪˈsɪʒən]',
        'I have to make a decision',
      ),
      'nl': _l(
        'Ik moet een beslissing nemen.',
        '[ɪk mut ən bəˈslɪsɪŋ ˈneːmə]',
        'I must a decision take',
      ),
      'es': _l(
        'Tengo que tomar una decisión.',
        '[ˈteŋɡo ke toˈmaɾ ˈuna deθiˈsjon]',
        'I-have that take a decision',
      ),
      'fr': _l(
        'Je dois prendre une décision.',
        '[ʒə dwa pʁɑ̃dʁ yn de.si.zjɔ̃]',
        'I must take a decision',
      ),
      'ar': _l(
        'يجبُ أن أتخذَ قرارًا.',
        '[ja.ʒi.bu ʔan ʔat.ta.xi.ða qa.raː.ran]',
        'must that I-adopt a-decision',
      ),
    },
  ),
  Concept(
    id: 'k.time-presses',
    aspect: Aspect.vocabulary,
    level: 'B1',
    titleEn: 'Time / urgency',
    titleAr: 'الوقت والاستعجال',
    meaningEn: 'Time is pressing.',
    meaningAr: 'الوقت يداهمنا.',
    noteEn:
        'German Zeit and Dutch tijd share a root with English tide. Spanish '
        'tiempo and French temps (from Latin tempus) also mean "weather". '
        'Arabic waqt is a point or span of time.',
    noteAr:
        'Zeit الألمانية و tijd الهولندية من جذر tide الإنجليزية. '
        'tiempo الإسبانية و temps الفرنسية (من اللاتينية tempus) تعنيان أيضًا "الطقس". '
        'و"الوقت" العربي نقطة أو مدة زمنية.',
    wordGroups: ['c.time'],
    lines: {
      'de': _l('Die Zeit drängt.', '[diː tsaɪ̯t dʁɛŋt]', 'the time presses'),
      'en': _l('Time is pressing.', '[taɪm ɪz ˈpɹesɪŋ]', 'time is pressing'),
      'nl': _l('De tijd dringt.', '[də tɛit drɪŋt]', 'the time presses'),
      'es': _l('El tiempo apremia.', '[el ˈtjempo aˈpɾemja]', 'the time urges'),
      'fr': _l('Le temps presse.', '[lə tɑ̃ pʁɛs]', 'the time presses'),
      'ar': _l(
        'الوقتُ يداهمُنا.',
        '[al.waq.tu ju.daː.hi.mu.naː]',
        'the-time raids-us',
      ),
    },
  ),
  // -------------------------------------------------------------- grammar
  Concept(
    id: 'k.v2-market',
    aspect: Aspect.grammar,
    level: 'A1',
    titleEn: 'Word order: verb second',
    titleAr: 'ترتيب الكلمات: الفعل في المركز الثاني',
    meaningEn: 'Today I am going to the market.',
    meaningAr: 'اليوم أذهب إلى السوق.',
    noteEn:
        'German and Dutch keep the verb in position 2: when "today" comes '
        'first, the subject moves after the verb (gehe ich / ga ik). English, '
        'Spanish and French keep subject before verb. Spanish drops the '
        'pronoun: voy already means "I go".',
    noteAr:
        'في الألمانية والهولندية يبقى الفعل في المركز الثاني: إذا بدأت الجملة بـ"اليوم" '
        'ينتقل الفاعل بعد الفعل (gehe ich / ga ik). الإنجليزية والإسبانية والفرنسية '
        'تبقي الفاعل قبل الفعل. والإسبانية تحذف الضمير: voy تعني "أذهب".',
    wordGroups: ['c.market'],
    lines: {
      'de': _l(
        'Heute gehe ich zum Markt.',
        '[ˈhɔʏ̯tə ˈɡeːə ɪç tsʊm maʁkt]',
        'today go I to-the market',
      ),
      'en': _l(
        'Today I am going to the market.',
        '[təˈdeɪ aɪm ˈɡəʊɪŋ tə ðə ˈmɑːkɪt]',
        'today I am going to the market',
      ),
      'nl': _l(
        'Vandaag ga ik naar de markt.',
        '[vɑnˈdaːx ɣaː ɪk naːr də mɑrkt]',
        'today go I to the market',
      ),
      'es': _l(
        'Hoy voy al mercado.',
        '[oj boj al meɾˈkaðo]',
        'today (I)-go to-the market',
      ),
      'fr': _l(
        'Aujourd’hui, je vais au marché.',
        '[o.ʒuʁ.dɥi ʒə vɛ o maʁ.ʃe]',
        'today I go to-the market',
      ),
      'ar': _l(
        'اليومَ أذهبُ إلى السوقِ.',
        '[al.jaw.ma ʔað.ha.bu ʔi.laː s.suː.qi]',
        'today I-go to the-market',
      ),
    },
  ),
  Concept(
    id: 'k.perfect-eaten',
    aspect: Aspect.grammar,
    level: 'A2',
    titleEn: 'Present perfect: have + participle',
    titleAr: 'الماضي التام: have + اسم المفعول',
    meaningEn: 'I have already eaten.',
    meaningAr: 'لقد أكلتُ بالفعل.',
    noteEn:
        'All four European languages build it with "have" + participle, but '
        'German and Dutch send the participle to the end (habe ... gegessen, '
        'heb ... gegeten). Spanish and French keep it together (he comido, '
        'ai mangé). Arabic uses the past tense with qad.',
    noteAr:
        'اللغات الأوروبية الأربع تبنيه بـ"have" + اسم المفعول، لكن الألمانية والهولندية '
        'ترسلان اسم المفعول إلى آخر الجملة (habe ... gegessen). الإسبانية والفرنسية '
        'تبقيانه ملاصقًا (he comido, ai mangé). والعربية تستعمل الماضي مع "قد".',
    wordGroups: ['c.eat'],
    lines: {
      'de': _l(
        'Ich habe schon gegessen.',
        '[ɪç ˈhaːbə ʃoːn ɡəˈɡɛsn̩]',
        'I have already eaten',
      ),
      'en': _l(
        'I have already eaten.',
        '[aɪ həv ɔːlˈɹedi ˈiːtn̩]',
        'I have already eaten',
      ),
      'nl': _l(
        'Ik heb al gegeten.',
        '[ɪk ɦɛp ɑl ɣəˈɣeːtə]',
        'I have already eaten',
      ),
      'es': _l('Ya he comido.', '[ʝa e koˈmiðo]', 'already (I)-have eaten'),
      'fr': _l('J’ai déjà mangé.', '[ʒe de.ʒa mɑ̃.ʒe]', 'I-have already eaten'),
      'ar': _l(
        'لقد أكلتُ بالفعلِ.',
        '[la.qad ʔa.kal.tu bil.fiʕ.li]',
        'indeed I-ate in-fact',
      ),
    },
  ),
  Concept(
    id: 'k.conditional-travel',
    aspect: Aspect.grammar,
    level: 'B1',
    titleEn: 'Unreal conditional',
    titleAr: 'الشرط غير الواقعي',
    meaningEn: 'If I had time, I would travel.',
    meaningAr: 'لو كان عندي وقت، لسافرت.',
    noteEn:
        'German uses Konjunktiv II (hätte) + würde; Dutch uses the past + zou. '
        'Spanish needs the imperfect subjunctive (tuviera) + conditional '
        '(viajaría); French uses imperfect (avais) + conditional (voyagerais). '
        'In German and Dutch the verb of the if-clause goes to the end.',
    noteAr:
        'الألمانية تستعمل Konjunktiv II (hätte) + würde، والهولندية الماضي + zou. '
        'الإسبانية تحتاج المضارع التام الشرطي (tuviera) + الشرطي (viajaría)، '
        'والفرنسية الماضي الناقص (avais) + الشرطي (voyagerais). '
        'وفي الألمانية والهولندية يذهب فعل جملة الشرط إلى آخرها.',
    wordGroups: ['c.time'],
    lines: {
      'de': _l(
        'Wenn ich Zeit hätte, würde ich reisen.',
        '[vɛn ɪç tsaɪ̯t ˈhɛtə ˈvʏʁdə ɪç ˈʁaɪ̯zn̩]',
        'if I time had, would I travel',
      ),
      'en': _l(
        'If I had time, I would travel.',
        '[ɪf aɪ hæd taɪm aɪ wʊd ˈtɹævəl]',
        'if I had time, I would travel',
      ),
      'nl': _l(
        'Als ik tijd had, zou ik reizen.',
        '[ɑls ɪk tɛit ɦɑt zɑu ɪk ˈrɛizə]',
        'if I time had, would I travel',
      ),
      'es': _l(
        'Si tuviera tiempo, viajaría.',
        '[si tuˈβjeɾa ˈtjempo bjaxaˈɾia]',
        'if (I)-had time, (I)-would-travel',
      ),
      'fr': _l(
        'Si j’avais le temps, je voyagerais.',
        '[si ʒa.vɛ lə tɑ̃ ʒə vwa.ja.ʒʁɛ]',
        'if I-had the time, I would-travel',
      ),
      'ar': _l(
        'لو كان عندي وقتٌ، لسافرتُ.',
        '[law kaː.na ʕin.diː waq.tun la.saː.far.tu]',
        'if was with-me time, then-I-travelled',
      ),
    },
  ),
  // ------------------------------------------------------------ listening
  Concept(
    id: 'k.station',
    aspect: Aspect.listening,
    level: 'A1',
    titleEn: 'Sounds: ch, g, j, r',
    titleAr: 'أصوات: ch و g و j و r',
    meaningEn: 'I am looking for the train station.',
    meaningAr: 'أبحث عن محطة القطار.',
    noteEn:
        'Listen for the throat sounds: German ich [ç], Dutch g [ɣ/x], '
        'Spanish j and c/z [x, θ], French r [ʁ]. Arabic has close cousins: '
        'خ [x], غ [ɣ]. Play each line slowly, then shadow it.',
    noteAr:
        'استمع إلى الأصوات الحلقية: ich الألمانية [ç]، و g الهولندية [ɣ/x]، '
        'و j و c/z الإسبانية [x، θ]، و r الفرنسية [ʁ]. للعربية أقارب قريبة: '
        'خ [x] و غ [ɣ]. شغّل كل سطر ببطء ثم كرره.',
    wordGroups: ['c.station'],
    lines: {
      'de': _l(
        'Ich suche den Bahnhof.',
        '[ɪç ˈzuːxə deːn ˈbaːnhoːf]',
        'I seek the train-yard',
      ),
      'en': _l(
        'I’m looking for the train station.',
        '[aɪm ˈlʊkɪŋ fə ðə tɹeɪn ˈsteɪʃən]',
        'I am looking for the train station',
      ),
      'nl': _l(
        'Ik zoek het station.',
        '[ɪk zuk ət staːˈʃɔn]',
        'I seek the station',
      ),
      'es': _l(
        'Busco la estación de tren.',
        '[ˈbusko la estaˈθjon de tɾen]',
        '(I)-seek the station of train',
      ),
      'fr': _l('Je cherche la gare.', '[ʒə ʃɛʁʃ la ɡaʁ]', 'I seek the station'),
      'ar': _l(
        'أبحثُ عن محطةِ القطارِ.',
        '[ʔab.ħa.θu ʕan ma.ħaṭ.ṭa.ti l.qi.ṭaː.ri]',
        'I-search about station the-train',
      ),
    },
  ),
  Concept(
    id: 'k.thirty-five',
    aspect: Aspect.listening,
    level: 'A1',
    titleEn: 'Numbers: 35',
    titleAr: 'الأعداد: 35',
    meaningEn: 'thirty-five',
    meaningAr: 'خمسة وثلاثون',
    noteEn:
        'German, Dutch and Arabic say the units first: "five-and-thirty". '
        'English, Spanish and French say the tens first. Train your ear: '
        'write the digits while you listen.',
    noteAr:
        'الألمانية والهولندية والعربية تقول الآحاد أولًا: "خمسة وثلاثون". '
        'أما الإنجليزية والإسبانية والفرنسية فتبدأ بالعشرات. درّب أذنك: '
        'اكتب الأرقام وأنت تستمع.',
    wordGroups: ['c.35'],
    lines: {
      'de': _l('fünfunddreißig', '[ˈfʏnf.ʊnt.ˌdʁaɪ̯.sɪç]', 'five-and-thirty'),
      'en': _l('thirty-five', '[ˌθɜːti ˈfaɪv]', 'thirty-five'),
      'nl': _l('vijfendertig', '[ˈvɛi.vən.ˌdɛr.təx]', 'five-and-thirty'),
      'es': _l('treinta y cinco', '[ˈtɾejnta i ˈθiŋko]', 'thirty and five'),
      'fr': _l('trente-cinq', '[tʁɑ̃t sɛ̃k]', 'thirty-five'),
      'ar': _l(
        'خمسةٌ وثلاثون',
        '[xam.sa.tun wa.θa.laː.θuːn]',
        'five and-thirty',
      ),
    },
  ),
  // ------------------------------------------------------------- speaking
  Concept(
    id: 'k.speak-slowly',
    aspect: Aspect.speaking,
    level: 'A1',
    titleEn: 'Survival phrase: speak slowly',
    titleAr: 'عبارة نجاة: تحدث ببطء',
    meaningEn: 'Could you speak more slowly, please?',
    meaningAr: 'هل يمكنك أن تتكلم ببطء أكثر من فضلك؟',
    noteEn:
        'Shadow it: play, pause, repeat aloud three times, then say it '
        'without the audio. Notice the polite forms: Sie (DE), u (NL), '
        'usted via podría (ES), vous (FR).',
    noteAr:
        'حاكِ العبارة: شغّل، أوقف، وكرر بصوت عالٍ ثلاث مرات، ثم قلها بدون الصوت. '
        'لاحظ صيغ الاحترام: Sie (ألماني)، u (هولندي)، usted عبر podría (إسباني)، vous (فرنسي).',
    wordGroups: ['c.speak', 'c.slow'],
    lines: {
      'de': _l(
        'Könnten Sie bitte langsamer sprechen?',
        '[ˈkœntn̩ ziː ˈbɪtə ˈlaŋzaːmɐ ˈʃpʁɛçn̩]',
        'could you please slower speak',
      ),
      'en': _l(
        'Could you speak more slowly, please?',
        '[kʊd juː spiːk mɔː ˈsləʊli pliːz]',
        'could you speak more slowly please',
      ),
      'nl': _l(
        'Kunt u alstublieft langzamer praten?',
        '[kʏnt y ɑlstyˈblift ˈlɑŋzaːmər ˈpraːtə]',
        'can you please slower talk',
      ),
      'es': _l(
        '¿Podría hablar más despacio, por favor?',
        '[poˈðɾia aˈβlaɾ mas desˈpaθjo poɾ faˈβoɾ]',
        'could-(you) speak more slowly, for favour',
      ),
      'fr': _l(
        'Pourriez-vous parler plus lentement, s’il vous plaît ?',
        '[pu.ʁje vu paʁ.le ply lɑ̃t.mɑ̃ sil vu plɛ]',
        'could-you speak more slowly, if-it you pleases',
      ),
      'ar': _l(
        'هل يمكنك أن تتكلمَ ببطءٍ أكثرَ من فضلك؟',
        '[hal jum.ki.nu.ka ʔan ta.ta.kal.la.ma bi.butˤʔin ʔak.θa.ra min faḍ.lik]',
        'is it-possible-for-you that you-speak with-slowness more from your-grace',
      ),
    },
  ),
  Concept(
    id: 'k.from-egypt',
    aspect: Aspect.speaking,
    level: 'A0',
    titleEn: 'Introduce yourself',
    titleAr: 'عرّف بنفسك',
    meaningEn: 'I come from Egypt and I live in Cairo.',
    meaningAr: 'أنا من مصر وأسكن في القاهرة.',
    noteEn:
        'Same pattern, different prepositions: aus / uit / de / d’ for '
        '"from", in / en / au for "in". French uses au with Caire because the '
        'city name has the article (le Caire).',
    noteAr:
        'النمط نفسه بحروف جر مختلفة: aus / uit / de / d’ بمعنى "من"، و in / en / au بمعنى "في". '
        'الفرنسية تقول au Caire لأن اسم المدينة فيه أداة التعريف (le Caire).',
    lines: {
      'de': _l(
        'Ich komme aus Ägypten und wohne in Kairo.',
        '[ɪç ˈkɔmə aʊ̯s ɛˈɡʏptn̩ ʊnt ˈvoːnə ɪn ˈkaɪ̯ʁo]',
        'I come out-of Egypt and live in Cairo',
      ),
      'en': _l(
        'I come from Egypt and I live in Cairo.',
        '[aɪ kʌm fɹəm ˈiːdʒɪpt ənd aɪ lɪv ɪn ˈkaɪɹəʊ]',
        'I come from Egypt and I live in Cairo',
      ),
      'nl': _l(
        'Ik kom uit Egypte en ik woon in Caïro.',
        '[ɪk kɔm œyt eːˈɣɪptə ɛn ɪk ʋoːn ɪn kaːˈiroː]',
        'I come out-of Egypt and I live in Cairo',
      ),
      'es': _l(
        'Soy de Egipto y vivo en El Cairo.',
        '[soj de eˈxipto i ˈbiβo en el ˈkajɾo]',
        '(I)-am from Egypt and (I)-live in the Cairo',
      ),
      'fr': _l(
        'Je viens d’Égypte et j’habite au Caire.',
        '[ʒə vjɛ̃ de.ʒipt e ʒa.bit o kɛʁ]',
        'I come from-Egypt and I-live at-the Cairo',
      ),
      'ar': _l(
        'أنا من مصرَ وأسكنُ في القاهرةِ.',
        '[ʔa.naː min miṣ.ra wa.ʔas.ku.nu fil.qaː.hi.ra]',
        'I from Egypt and-I-live in Cairo',
      ),
    },
  ),
  // -------------------------------------------------------------- reading
  Concept(
    id: 'k.shop-hours',
    aspect: Aspect.reading,
    level: 'A1',
    titleEn: 'Reading a sign: opening hours',
    titleAr: 'قراءة لافتة: مواعيد العمل',
    meaningEn: 'The shop opens at nine and closes at six.',
    meaningAr: 'يفتح المتجر في التاسعة ويغلق في السادسة.',
    noteEn:
        'Dutch splits the verbs: gaat ... open, gaat ... dicht (separable '
        'phrases). Spanish and French tell the hour with a feminine article '
        '(a las nueve, à neuf heures). Read once for the gist, once for detail.',
    noteAr:
        'الهولندية تفصل الأفعال: gaat ... open و gaat ... dicht. '
        'والإسبانية والفرنسية تذكران الساعة بأداة مؤنثة (a las nueve, à neuf heures). '
        'اقرأ مرة للفكرة العامة ومرة للتفاصيل.',
    wordGroups: ['c.shop'],
    lines: {
      'de': _l(
        'Der Laden öffnet um neun und schließt um sechs.',
        '[deːɐ̯ ˈlaːdn̩ ˈœfnət ʊm nɔʏ̯n ʊnt ʃliːst ʊm zɛks]',
        'the shop opens at nine and closes at six',
      ),
      'en': _l(
        'The shop opens at nine and closes at six.',
        '[ðə ʃɒp ˈəʊpənz ət naɪn ənd ˈkləʊzɪz ət sɪks]',
        'the shop opens at nine and closes at six',
      ),
      'nl': _l(
        'De winkel gaat om negen uur open en om zes uur dicht.',
        '[də ˈʋɪŋkəl ɣaːt ɔm ˈneːɣə yr ˈoːpə ɛn ɔm zɛs yr dɪxt]',
        'the shop goes at nine hour open and at six hour shut',
      ),
      'es': _l(
        'La tienda abre a las nueve y cierra a las seis.',
        '[la ˈtjenda ˈaβɾe a las ˈnweβe i ˈθjera a las sejs]',
        'the shop opens at the nine and closes at the six',
      ),
      'fr': _l(
        'Le magasin ouvre à neuf heures et ferme à six heures.',
        '[lə ma.ɡa.zɛ̃ uvʁ a nœ.vœʁ e fɛʁm a si.zœʁ]',
        'the shop opens at nine hours and closes at six hours',
      ),
      'ar': _l(
        'يفتحُ المتجرُ في التاسعةِ ويغلقُ في السادسةِ.',
        '[jaf.ta.ħu l.mat.ʒa.ru fit.taː.si.ʕa wa.juɣ.li.qu fis.saː.di.sa]',
        'opens the-shop at the-ninth and-closes at the-sixth',
      ),
    },
  ),
  // -------------------------------------------------------------- writing
  Concept(
    id: 'k.dear-anna',
    aspect: Aspect.writing,
    level: 'A1',
    titleEn: 'Opening a friendly letter',
    titleAr: 'بداية رسالة ودية',
    meaningEn: 'Dear Anna, thank you very much for your letter.',
    meaningAr: 'عزيزتي آنا، شكرًا جزيلًا على رسالتك.',
    noteEn:
        'Recall drill: hide the line and write it from memory. "Dear" agrees '
        'with the reader: Liebe Anna / Lieber Paul, Querida / Querido, '
        'Chère / Cher. Dutch "Lieve" is warm; "Beste" is neutral.',
    noteAr:
        'تمرين استرجاع: أخفِ السطر واكتبه من الذاكرة. "عزيزي" تتبع المخاطَب: '
        'Liebe Anna / Lieber Paul، Querida / Querido، Chère / Cher. '
        'و"Lieve" الهولندية دافئة، و"Beste" محايدة.',
    wordGroups: ['c.letter', 'c.thanks'],
    lines: {
      'de': _l(
        'Liebe Anna, vielen Dank für deinen Brief.',
        '[ˈliːbə ˈana ˈfiːlən daŋk fyːɐ̯ ˈdaɪ̯nən bʁiːf]',
        'dear Anna, many thanks for your letter',
      ),
      'en': _l(
        'Dear Anna, thank you very much for your letter.',
        '[dɪə ˈænə θæŋk juː ˈveɹi mʌtʃ fə jɔː ˈletə]',
        'dear Anna, thank you very much for your letter',
      ),
      'nl': _l(
        'Lieve Anna, hartelijk dank voor je brief.',
        '[ˈlivə ˈɑnaː ˈɦɑrtələk dɑŋk voːr jə brif]',
        'dear Anna, heartily thanks for your letter',
      ),
      'es': _l(
        'Querida Ana, muchas gracias por tu carta.',
        '[keˈɾiða ˈana ˈmutʃas ˈɡɾaθjas poɾ tu ˈkaɾta]',
        'dear Ana, many thanks for your letter',
      ),
      'fr': _l(
        'Chère Anna, merci beaucoup pour ta lettre.',
        '[ʃɛʁ a.na mɛʁ.si bo.ku puʁ ta lɛtʁ]',
        'dear Anna, thanks much for your letter',
      ),
      'ar': _l(
        'عزيزتي آنا، شكرًا جزيلًا على رسالتِك.',
        '[ʕa.ziː.za.tiː ʔaː.naː ʃuk.ran ʒa.ziː.lan ʕa.laː ri.saː.la.tik]',
        'my-dear Anna, thanks abundant on your-letter',
      ),
    },
  ),
  Concept(
    id: 'k.good-morning',
    aspect: Aspect.writing,
    level: 'A0',
    titleEn: 'Greeting: good morning',
    titleAr: 'تحية: صباح الخير',
    meaningEn: 'Good morning!',
    meaningAr: 'صباح الخير!',
    noteEn:
        'Spelling traps for recall: German capitalises nouns (Morgen), Dutch '
        'writes goedemorgen as one word, Spanish opens with ¡ and uses the '
        'plural (buenos días), French puts a space before ! and says '
        'bonjour all day.',
    noteAr:
        'فخاخ إملائية: الألمانية تكتب الأسماء بحرف كبير (Morgen)، والهولندية تكتب '
        'goedemorgen كلمة واحدة، والإسبانية تبدأ بـ ¡ وتستعمل الجمع (buenos días)، '
        'والفرنسية تضع مسافة قبل ! وتقول bonjour طوال النهار.',
    wordGroups: ['c.morning'],
    lines: {
      'de': _l('Guten Morgen!', '[ˈɡuːtn̩ ˈmɔʁɡn̩]', 'good morning'),
      'en': _l('Good morning!', '[ɡʊd ˈmɔːnɪŋ]', 'good morning'),
      'nl': _l('Goedemorgen!', '[ˌɣudəˈmɔrɣə]', 'good-morning'),
      'es': _l('¡Buenos días!', '[ˈbwenos ˈði.as]', 'good days'),
      'fr': _l('Bonjour !', '[bɔ̃.ʒuʁ]', 'good-day'),
      'ar': _l('صباحُ الخير!', '[ṣa.baː.ħu l.xajr]', 'morning-of the-good'),
    },
  ),
  // ----------------------------------------------------------- pragmatics
  Concept(
    id: 'k.how-are-you-formal',
    aspect: Aspect.pragmatics,
    level: 'A1',
    titleEn: 'Formal you: how are you?',
    titleAr: 'صيغة الاحترام: كيف حالك؟',
    meaningEn: 'How are you? (formal)',
    meaningAr: 'كيف حال حضرتك؟',
    noteEn:
        'Use the formal "you" with strangers, officials and older people: '
        'Sie (DE), u (NL), usted (ES), vous (FR). English has no formal '
        'pronoun; tone and "sir/madam" do the job. Egyptian Arabic uses '
        'حضرتك (ḥaḍretak).',
    noteAr:
        'استعمل صيغة الاحترام مع الغرباء والموظفين والأكبر سنًا: Sie (ألماني)، '
        'u (هولندي)، usted (إسباني)، vous (فرنسي). الإنجليزية ليس فيها ضمير احترام، '
        'وتقوم النبرة و sir/madam بالمهمة. وفي العامية المصرية: حضرتك.',
    lines: {
      'de': _l(
        'Wie geht es Ihnen?',
        '[viː ɡeːt ɛs ˈiːnən]',
        'how goes it to-you(formal)',
      ),
      'en': _l('How are you?', '[haʊ ɑː juː]', 'how are you'),
      'nl': _l(
        'Hoe gaat het met u?',
        '[ɦu ɣaːt ət mɛt y]',
        'how goes it with you(formal)',
      ),
      'es': _l(
        '¿Cómo está usted?',
        '[ˈkomo esˈta usˈteð]',
        'how is you(formal)',
      ),
      'fr': _l(
        'Comment allez-vous ?',
        '[kɔ.mɑ̃ a.le vu]',
        'how go-you(formal)',
      ),
      'ar': _l(
        'كيف حالُ حضرتِك؟',
        '[kajf ħaː.lu ħaḍ.ra.tik]',
        'how state your-presence',
      ),
    },
  ),
  Concept(
    id: 'k.enjoy-meal',
    aspect: Aspect.pragmatics,
    level: 'A1',
    titleEn: 'At the table',
    titleAr: 'على المائدة',
    meaningEn: 'Enjoy your meal!',
    meaningAr: 'بالهناء والشفاء!',
    noteEn:
        'A fixed expression said before eating. English speakers often say '
        'nothing, or borrow "bon appétit". Dutch eet smakelijk literally '
        'means "eat tastily".',
    noteAr:
        'تعبير ثابت يقال قبل الأكل. كثير من متحدثي الإنجليزية لا يقولون شيئًا '
        'أو يستعيرون "bon appétit". و eet smakelijk الهولندية حرفيًا "كُل بلذة".',
    lines: {
      'de': _l('Guten Appetit!', '[ˈɡuːtn̩ apeˈtiːt]', 'good appetite'),
      'en': _l('Enjoy your meal!', '[ɪnˈdʒɔɪ jɔː miːl]', 'enjoy your meal'),
      'nl': _l('Eet smakelijk!', '[eːt ˈsmaːkələk]', 'eat tastily'),
      'es': _l('¡Buen provecho!', '[bwem pɾoˈβetʃo]', 'good benefit'),
      'fr': _l('Bon appétit !', '[bɔ.n‿a.pe.ti]', 'good appetite'),
      'ar': _l(
        'بالهناءِ والشفاء!',
        '[bil.ha.naːʔ wa.ʃ.ʃi.faːʔ]',
        'with-delight and-healing',
      ),
    },
  ),
];
