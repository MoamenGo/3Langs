// Sample entries of the Unified Polyglot Dictionary: 14 word groups, each
// in German, English, Dutch, Spanish, French and Arabic. Entries of one
// group are shown side by side as cross-language equivalents.

import 'models.dart';

/// One row: lang, term, gender/article, ipa, pos.
typedef _W = (String, String, String, String);

class _Group {
  const _Group(
    this.id,
    this.pos,
    this.en,
    this.ar,
    this.tags,
    this.words, {
    this.example = const {},
    this.notes = const {},
  });
  final String id;
  final String pos;
  final String en;
  final String ar;
  final List<String> tags;

  /// lang -> (term, gender, ipa, unused)
  final Map<String, _W> words;

  /// lang -> example sentence.
  final Map<String, String> example;
  final Map<String, String> notes;
}

const _wiktionary = 'https://en.wiktionary.org/wiki/';

const _groups = [
  _Group(
    'c.house',
    'noun',
    'house',
    'بيت',
    ['home', 'A1', 'cognate'],
    {
      'de': ('Haus', 'das', '[haʊs]', ''),
      'en': ('house', '', '[haʊs]', ''),
      'nl': ('huis', 'het', '[ɦœys]', ''),
      'es': ('casa', 'la', '[ˈkasa]', ''),
      'fr': ('maison', 'la', '[mɛ.zɔ̃]', ''),
      'ar': ('بيت', 'مذكر', '[bajt]', ''),
    },
    example: {
      'de': 'Das Haus ist groß.',
      'nl': 'Het huis is groot.',
      'es': 'La casa es grande.',
      'fr': 'La maison est grande.',
      'en': 'The house is big.',
      'ar': 'البيت كبير.',
    },
    notes: {
      'nl': 'ui = [œy], a sound between "ow" and German "eu".',
      'de': 'Plural: die Häuser. Zu Hause = at home.',
    },
  ),
  _Group(
    'c.big',
    'adjective',
    'big, large',
    'كبير',
    ['size', 'A1'],
    {
      'de': ('groß', '', '[ɡʁoːs]', ''),
      'en': ('big', '', '[bɪɡ]', ''),
      'nl': ('groot', '', '[ɣroːt]', ''),
      'es': ('grande', '', '[ˈɡɾande]', ''),
      'fr': ('grand', '', '[ɡʁɑ̃]', ''),
      'ar': ('كبير', '', '[ka.biːr]', ''),
    },
    notes: {
      'de': 'ß = double s. Swiss German writes gross.',
      'fr': 'Feminine grande [ɡʁɑ̃d]: the d is heard only in the feminine.',
    },
  ),
  _Group(
    'c.time',
    'noun',
    'time',
    'وقت',
    ['time', 'A1', 'cognate'],
    {
      'de': ('Zeit', 'die', '[tsaɪ̯t]', ''),
      'en': ('time', '', '[taɪm]', ''),
      'nl': ('tijd', 'de', '[tɛit]', ''),
      'es': ('tiempo', 'el', '[ˈtjempo]', ''),
      'fr': ('temps', 'le', '[tɑ̃]', ''),
      'ar': ('وقت', 'مذكر', '[waqt]', ''),
    },
    example: {
      'de': 'Die Zeit drängt.',
      'nl': 'De tijd dringt.',
      'es': 'El tiempo apremia.',
      'fr': 'Le temps presse.',
      'en': 'Time is pressing.',
      'ar': 'الوقت يداهمنا.',
    },
    notes: {
      'es': 'Also "weather": ¿Qué tiempo hace?',
      'fr': 'Also "weather": Quel temps fait-il ?',
      'de': 'Cognate of English tide.',
    },
  ),
  _Group(
    'c.decision',
    'noun',
    'decision',
    'قرار',
    ['collocation', 'A2'],
    {
      'de': ('Entscheidung', 'die', '[ɛntˈʃaɪ̯dʊŋ]', ''),
      'en': ('decision', '', '[dɪˈsɪʒən]', ''),
      'nl': ('beslissing', 'de', '[bəˈslɪsɪŋ]', ''),
      'es': ('decisión', 'la', '[deθiˈsjon]', ''),
      'fr': ('décision', 'la', '[de.si.zjɔ̃]', ''),
      'ar': ('قرار', 'مذكر', '[qa.raːr]', ''),
    },
    notes: {
      'de': 'eine Entscheidung treffen (to "hit" a decision).',
      'nl': 'een beslissing nemen (to take).',
      'es': 'tomar una decisión (to take).',
      'fr': 'prendre une décision (to take).',
      'ar': 'اتخذ قرارًا.',
    },
  ),
  _Group(
    'c.market',
    'noun',
    'market',
    'سوق',
    ['city', 'A1', 'cognate'],
    {
      'de': ('Markt', 'der', '[maʁkt]', ''),
      'en': ('market', '', '[ˈmɑːkɪt]', ''),
      'nl': ('markt', 'de', '[mɑrkt]', ''),
      'es': ('mercado', 'el', '[meɾˈkaðo]', ''),
      'fr': ('marché', 'le', '[maʁ.ʃe]', ''),
      'ar': ('سوق', 'مؤنث/مذكر', '[suːq]', ''),
    },
  ),
  _Group(
    'c.eat',
    'verb',
    'to eat',
    'يأكل',
    ['food', 'A1'],
    {
      'de': ('essen', '', '[ˈɛsn̩]', ''),
      'en': ('eat', '', '[iːt]', ''),
      'nl': ('eten', '', '[ˈeːtə]', ''),
      'es': ('comer', '', '[koˈmeɾ]', ''),
      'fr': ('manger', '', '[mɑ̃.ʒe]', ''),
      'ar': ('أكل', '', '[ʔa.ka.la]', ''),
    },
    example: {
      'de': 'Ich habe schon gegessen.',
      'nl': 'Ik heb al gegeten.',
      'es': 'Ya he comido.',
      'fr': 'J’ai déjà mangé.',
      'en': 'I have already eaten.',
      'ar': 'لقد أكلت بالفعل.',
    },
    notes: {
      'de': 'Strong verb: essen – aß – gegessen; du isst.',
      'nl': 'eten – at – gegeten.',
    },
  ),
  _Group(
    'c.station',
    'noun',
    'train station',
    'محطة القطار',
    ['travel', 'A1'],
    {
      'de': ('Bahnhof', 'der', '[ˈbaːnhoːf]', ''),
      'en': ('station', '', '[ˈsteɪʃən]', ''),
      'nl': ('station', 'het', '[staːˈʃɔn]', ''),
      'es': ('estación', 'la', '[estaˈθjon]', ''),
      'fr': ('gare', 'la', '[ɡaʁ]', ''),
      'ar': ('محطة', 'مؤنث', '[ma.ħaṭ.ṭa]', ''),
    },
    notes: {
      'fr': 'False friend: une station is a metro stop; a train station is une gare.',
    },
  ),
  _Group(
    'c.speak',
    'verb',
    'to speak',
    'يتكلم',
    ['communication', 'A1'],
    {
      'de': ('sprechen', '', '[ˈʃpʁɛçn̩]', ''),
      'en': ('speak', '', '[spiːk]', ''),
      'nl': ('spreken', '', '[ˈspreːkə]', ''),
      'es': ('hablar', '', '[aˈβlaɾ]', ''),
      'fr': ('parler', '', '[paʁ.le]', ''),
      'ar': ('تكلّم', '', '[ta.kal.la.ma]', ''),
    },
    notes: {
      'de': 'sp at the start of a word = [ʃp].',
      'nl': 'praten = to talk (more everyday).',
      'es': 'The h is silent.',
    },
  ),
  _Group(
    'c.slow',
    'adverb',
    'slowly',
    'ببطء',
    ['communication', 'A1'],
    {
      'de': ('langsam', '', '[ˈlaŋzaːm]', ''),
      'en': ('slowly', '', '[ˈsləʊli]', ''),
      'nl': ('langzaam', '', '[ˈlɑŋzaːm]', ''),
      'es': ('despacio', '', '[desˈpaθjo]', ''),
      'fr': ('lentement', '', '[lɑ̃t.mɑ̃]', ''),
      'ar': ('ببطء', '', '[bi.butˤʔ]', ''),
    },
  ),
  _Group(
    'c.shop',
    'noun',
    'shop, store',
    'متجر',
    ['city', 'A1'],
    {
      'de': ('Laden', 'der', '[ˈlaːdn̩]', ''),
      'en': ('shop', '', '[ʃɒp]', ''),
      'nl': ('winkel', 'de', '[ˈʋɪŋkəl]', ''),
      'es': ('tienda', 'la', '[ˈtjenda]', ''),
      'fr': ('magasin', 'le', '[ma.ɡa.zɛ̃]', ''),
      'ar': ('متجر', 'مذكر', '[mat.ʒar]', ''),
    },
    notes: {
      'de': 'Also das Geschäft. der Laden is also "shutter" in some regions.',
    },
  ),
  _Group(
    'c.letter',
    'noun',
    'letter (mail)',
    'رسالة',
    ['writing', 'A1', 'false friend'],
    {
      'de': ('Brief', 'der', '[bʁiːf]', ''),
      'en': ('letter', '', '[ˈletə]', ''),
      'nl': ('brief', 'de', '[brif]', ''),
      'es': ('carta', 'la', '[ˈkaɾta]', ''),
      'fr': ('lettre', 'la', '[lɛtʁ]', ''),
      'ar': ('رسالة', 'مؤنث', '[ri.saː.la]', ''),
    },
    notes: {
      'en': 'False friend: German/Dutch Brief/brief = letter, not "short".',
      'es': 'carta also means a restaurant menu.',
    },
  ),
  _Group(
    'c.morning',
    'noun',
    'morning',
    'صباح',
    ['time', 'A0'],
    {
      'de': ('Morgen', 'der', '[ˈmɔʁɡn̩]', ''),
      'en': ('morning', '', '[ˈmɔːnɪŋ]', ''),
      'nl': ('ochtend', 'de', '[ˈɔxtənt]', ''),
      'es': ('mañana', 'la', '[maˈɲana]', ''),
      'fr': ('matin', 'le', '[ma.tɛ̃]', ''),
      'ar': ('صباح', 'مذكر', '[ṣa.baːħ]', ''),
    },
    notes: {
      'de': 'morgen (small m) = tomorrow.',
      'es': 'mañana (no article) = tomorrow.',
      'nl': 'morgen = tomorrow / morning; ochtend = morning.',
    },
  ),
  _Group(
    'c.thanks',
    'expression',
    'thank you',
    'شكرًا',
    ['politeness', 'A0'],
    {
      'de': ('danke', '', '[ˈdaŋkə]', ''),
      'en': ('thank you', '', '[ˈθæŋk juː]', ''),
      'nl': ('dank je', '', '[dɑŋk jə]', ''),
      'es': ('gracias', '', '[ˈɡɾaθjas]', ''),
      'fr': ('merci', '', '[mɛʁ.si]', ''),
      'ar': ('شكرًا', '', '[ʃuk.ran]', ''),
    },
    notes: {
      'nl': 'Formal: dank u. Also very common: bedankt.',
      'de': 'Stronger: vielen Dank.',
    },
  ),
  _Group(
    'c.35',
    'number',
    'thirty-five',
    'خمسة وثلاثون',
    ['numbers', 'A1'],
    {
      'de': ('fünfunddreißig', '', '[ˈfʏnf.ʊnt.ˌdʁaɪ̯.sɪç]', ''),
      'en': ('thirty-five', '', '[ˌθɜːti ˈfaɪv]', ''),
      'nl': ('vijfendertig', '', '[ˈvɛi.vən.ˌdɛr.təx]', ''),
      'es': ('treinta y cinco', '', '[ˈtɾejnta i ˈθiŋko]', ''),
      'fr': ('trente-cinq', '', '[tʁɑ̃t sɛ̃k]', ''),
      'ar': ('خمسة وثلاثون', '', '[xam.sa wa.θa.laː.θuːn]', ''),
    },
    notes: {'de': 'Units before tens, like Dutch and Arabic.'},
  ),
];

/// Builds the sample dictionary. Some words start as "learning" or
/// "mastered" so the filters show something right away.
List<DictEntry> buildSeedDictionary() {
  final out = <DictEntry>[];
  for (final g in _groups) {
    for (final e in g.words.entries) {
      final (term, gender, ipa, _) = e.value;
      final stage = switch ((g.tags.contains('A0'), e.key)) {
        (_, 'en') || (_, 'ar') => Stage.mastered,
        (true, _) => Stage.learning,
        _ => Stage.fresh,
      };
      out.add(
        DictEntry(
          id: '${g.id}.${e.key}',
          lang: e.key,
          term: term,
          group: g.id,
          pos: g.pos,
          gender: gender,
          ipa: ipa,
          meaningEn: g.en,
          meaningAr: g.ar,
          example: g.example[e.key] ?? '',
          exampleEn: g.example['en'] ?? '',
          note: g.notes[e.key] ?? '',
          tags: g.tags,
          stage: stage,
          source: e.key == 'ar'
              ? 'https://ar.wiktionary.org/wiki/${Uri.encodeComponent(term)}'
              : '$_wiktionary${Uri.encodeComponent(term)}',
        ),
      );
    }
  }
  return out;
}
