// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => '3Lang';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCourse => 'المنهج';

  @override
  String get navPractice => 'تدريب';

  @override
  String get navProgress => 'التقدم';

  @override
  String todayGoal(int minutes, int goal) {
    return 'النهارده: $minutes من $goal دقيقة';
  }

  @override
  String streakDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم ورا بعض',
      two: 'يومين ورا بعض',
      one: 'يوم واحد ورا بعض',
      zero: 'لسه ما بدأتش',
    );
    return '$_temp0';
  }

  @override
  String cardsDue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بطاقة مستحقة',
      two: 'بطاقتين مستحقين',
      one: 'بطاقة واحدة مستحقة',
      zero: 'مفيش بطاقات مستحقة',
    );
    return '$_temp0';
  }

  @override
  String get startReview => 'راجع دلوقتي';

  @override
  String get continueLearning => 'كمّل التعلم';

  @override
  String get allLessonsDone =>
      'خلصت كل الدروس المتاحة. وحدات جديدة جاية في الطريق.';

  @override
  String unitN(int n) {
    return 'الوحدة $n';
  }

  @override
  String get comingSoon => 'قريبًا';

  @override
  String hoursShort(int hours) {
    return '$hours ساعة';
  }

  @override
  String get lessonVocab => 'كلمات جديدة';

  @override
  String get lessonGrammar => 'قواعد';

  @override
  String get lessonListening => 'استماع';

  @override
  String get lessonReading => 'قراءة';

  @override
  String get lessonReview => 'مراجعة';

  @override
  String get lessonExam => 'اختبار تجريبي';

  @override
  String get lessonWriting => 'كتابة';

  @override
  String get lessonSpeaking => 'تحدث';

  @override
  String get flashcards => 'البطاقات';

  @override
  String get next => 'التالي';

  @override
  String get check => 'تحقق';

  @override
  String get correct => 'صح!';

  @override
  String wrongAnswer(String answer) {
    return 'مش بالظبط. الإجابة: $answer';
  }

  @override
  String get lessonDone => 'الدرس خلص!';

  @override
  String scoreLabel(int percent) {
    return 'النتيجة: $percent%';
  }

  @override
  String wordsAddedToReview(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اتضاف $count كلمة للمراجعة',
      two: 'اتضافت كلمتين للمراجعة',
      one: 'اتضافت كلمة واحدة للمراجعة',
      zero: 'مفيش كلمات جديدة للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String get backToCourse => 'ارجع للمنهج';

  @override
  String whichMeans(String word, String language) {
    return 'أنهي كلمة في $language معناها «$word»؟';
  }

  @override
  String get example => 'مثال';

  @override
  String plural(String plural) {
    return 'الجمع: $plural';
  }

  @override
  String get showAnswer => 'اعرض الإجابة';

  @override
  String get rateAgain => 'تاني';

  @override
  String get rateHard => 'صعب';

  @override
  String get rateGood => 'كويس';

  @override
  String get rateEasy => 'سهل';

  @override
  String get reviewDone => 'خلصت المراجعة! ارجع بعدين.';

  @override
  String get reviewEmpty => 'لسه مفيش بطاقات. خلّص درس عشان تضيف كلمات.';

  @override
  String get listenAndType => 'اسمع واكتب اللي سمعته';

  @override
  String get playAudio => 'تشغيل';

  @override
  String get playSlow => 'ببطء';

  @override
  String typeHere(String language) {
    return 'اكتب هنا ($language)';
  }

  @override
  String get showTranslation => 'اعرض الترجمة';

  @override
  String get glossary => 'الكلمات';

  @override
  String get questions => 'الأسئلة';

  @override
  String get openLink => 'افتح في المتصفح';

  @override
  String get externalHint => 'ده مصدر خارجي مجاني. افتحه في المتصفح.';

  @override
  String get writingCheck => 'صحّح كتابتي';

  @override
  String get noIssues => 'مفيش أخطاء. برافو!';

  @override
  String wordCount(int count) {
    return '$count كلمة';
  }

  @override
  String get checkFailed => 'مقدرتش أصحح دلوقتي. إنت متصل بالإنترنت؟';

  @override
  String get speakingIntro => 'اسمع، وبعدين قول الجملة بصوت عالي. عملت إيه؟';

  @override
  String totalHours(String hours) {
    return '$hours ساعة مذاكرة';
  }

  @override
  String wordsKnown(int count) {
    return '$count كلمة بتعرفها';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done من $total درس';
  }

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get courseTimeline => 'طريقك من A0 لـ C1';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get explanationLanguage => 'لغة الشرح';

  @override
  String get dailyGoal => 'الهدف اليومي';

  @override
  String minutesShort(int n) {
    return '$n دقيقة';
  }

  @override
  String get newCardsPerDay => 'بطاقات جديدة في اليوم';

  @override
  String get account => 'الحساب والمزامنة';

  @override
  String get signIn => 'سجّل دخول للمزامنة';

  @override
  String get signOut => 'تسجيل خروج';

  @override
  String signedInAs(String email) {
    return 'داخل باسم $email';
  }

  @override
  String get syncNow => 'زامن دلوقتي';

  @override
  String lastSynced(String time) {
    return 'آخر مزامنة $time';
  }

  @override
  String get syncDisabled =>
      'المزامنة مقفولة: النسخة دي مفيهاش إعدادات Supabase. كل حاجة متخزنة على الجهاز ده.';

  @override
  String get email => 'الإيميل';

  @override
  String get password => 'كلمة السر';

  @override
  String get createAccount => 'اعمل حساب';

  @override
  String get checkEmail => 'شوف إيميلك عشان تأكد الحساب.';

  @override
  String get about => 'عن التطبيق والمصادر';

  @override
  String get aboutText =>
      '3Lang بيستخدم محتوى مجاني ومفتوح الترخيص بس. كل كلمة وجملة محفوظ مصدرها وترخيصها، ومكتوبين تحت.';

  @override
  String errorMessage(String message) {
    return 'حصلت مشكلة: $message';
  }

  @override
  String noContentYet(String language) {
    return 'دروس $language جاية في التحديث الجاي.';
  }

  @override
  String startsOn(String date) {
    return 'خطتك بتبدأ اللغة دي يوم $date.';
  }

  @override
  String get languages => 'لغاتك';

  @override
  String get trackActive => 'شغالة';

  @override
  String trackScheduled(String date) {
    return 'تبدأ $date';
  }

  @override
  String get trackPaused => 'متوقفة';

  @override
  String get pauseLanguage => 'إيقاف';

  @override
  String get resumeLanguage => 'ابدأ دلوقتي';

  @override
  String levelN(String level) {
    return 'مستوى $level';
  }

  @override
  String unitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وحدة',
      few: '$count وحدات',
      two: 'وحدتين',
      one: 'وحدة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get sameForAllLanguages =>
      'نفس الوحدات في الألماني والإسباني والهولندي. الساعات لكل لغة.';

  @override
  String get explainArabic => 'العربي';

  @override
  String get explainEnglish => 'الإنجليزي';

  @override
  String get contrastDictionary => 'قاموس المقارنة';

  @override
  String get contrastIntro =>
      'كلمات شبه بعض بس معناها مختلف، وكلمات تقدر تحفظها مع بعض، وأسماء جنسها بيتغير من لغة للتانية.';

  @override
  String get inOtherLanguages => 'في لغاتك التانية';

  @override
  String get contrastAll => 'الكل';

  @override
  String get falseFriends => 'أصدقاء مزيفين';

  @override
  String get nearCognates => 'شبه بعض';

  @override
  String get genderMismatches => 'الجنس بيتغير';

  @override
  String levelDone(String level) {
    return 'خلصت مستوى $level!';
  }

  @override
  String startLevel(String level) {
    return 'ابدأ مستوى $level';
  }

  @override
  String get navToday => 'اليوم';

  @override
  String get welcomeTitle => 'جهّز اللغات التلاتة';

  @override
  String get welcomeSubtitle => 'اختار لغاتك ووقتك اليومي ومستوى البداية.';

  @override
  String get setUp => 'ابدأ الإعداد';

  @override
  String get todaysPlan => 'خطة النهاردة';

  @override
  String planMinutes(int total, int left) {
    return '$total دقيقة في الخطة · فاضل $left دقيقة';
  }

  @override
  String get rebuildPlan => 'اعمل خطة النهاردة من جديد';

  @override
  String get planEmpty => 'مفيش مذاكرة النهاردة. استمتع بيوم الراحة!';

  @override
  String get planDone => 'خلّصت خطة النهاردة. شغل عظيم!';

  @override
  String get startPlan => 'ابدأ جلسة النهاردة';

  @override
  String get continuePlan => 'كمّل';

  @override
  String blockReview(String lang) {
    return 'مراجعة · $lang';
  }

  @override
  String blockLesson(String lang) {
    return 'درس جديد · $lang';
  }

  @override
  String get blockContrast => 'تمرين المقارنة';

  @override
  String get blockContrastHint => 'الكلمات اللي بتلخبط فيها بين اللغات';

  @override
  String get yourLanguages => 'لغاتك';

  @override
  String get drillEmpty =>
      'لسه مفيش كلمات للمقارنة. خلّص كام درس في لغتين الأول.';

  @override
  String get myMixups => 'الحاجات اللي لخبطت فيها';

  @override
  String get noMixups => 'لسه مفيش لخبطة.';

  @override
  String mixupGiven(String given, String lang) {
    return 'اخترت $given ($lang)';
  }

  @override
  String get done => 'تمام';

  @override
  String examIntro(String level, int count, int pass) {
    return 'امتحان $level: $count سؤال من المستوى كله. محتاج $pass% أو أكتر عشان تطلع المستوى اللي بعده.';
  }

  @override
  String get startExam => 'ابدأ';

  @override
  String examPassed(String level) {
    return 'نجحت في $level!';
  }

  @override
  String examFailed(String level) {
    return 'لسه. راجع $level وجرّب تاني.';
  }

  @override
  String nowAtLevel(String level) {
    return 'إنت دلوقتي في مستوى $level.';
  }

  @override
  String get tryAgain => 'جرّب تاني';

  @override
  String mixupHint(String lang) {
    return 'دي $lang: لخبطة بين اللغات.';
  }

  @override
  String placementTitle(String lang) {
    return 'اختبار تحديد المستوى · $lang';
  }

  @override
  String placementResult(String lang, String level) {
    return 'هتبدأ $lang من مستوى $level.';
  }

  @override
  String placementIntro(String lang) {
    return 'كام كلمة من كل مستوى، من A1 وطالع. بيقف لما يصعب عليك، حوالي 5 دقايق. مش متأكد؟ ابدأ من الأول.';
  }

  @override
  String get placementBeginner => 'أنا مبتدئ خالص (A0)';

  @override
  String placementLevel(String level) {
    return 'مستوى $level';
  }

  @override
  String get welcomeIntro =>
      '3Lang بيعلّمك ألماني وهولندي وإسباني مع بعض، من A0 لحد C1. كل يوم بيعملك جلسة للغات كلها: المراجعة الأول، ودروس جديدة في لغتين، ومهارة في التالتة، وتمرين مقارنة لما تلخبط بينهم.';

  @override
  String get stepInterface => '1. لغة التطبيق';

  @override
  String get stepMinutes => '2. دقايق في اليوم';

  @override
  String minutesPerLanguage(int total, int each) {
    return '$total دقيقة في اليوم، حوالي $each دقيقة لكل لغة';
  }

  @override
  String get stepLanguages => '3. اللغات وميعاد البداية';

  @override
  String get stepLanguagesHint =>
      'الألماني والهولندي قريبين من بعض، فالهولندي بيبدأ متأخر شوية. اعمل اختبار تحديد مستوى لو بتعرف حاجة.';

  @override
  String get startIn => 'البداية:';

  @override
  String get startNow => 'دلوقتي';

  @override
  String weekN(int n) {
    return 'الأسبوع $n';
  }

  @override
  String get placementButton => 'اختبار المستوى';

  @override
  String get finishSetup => 'احفظ وروح لخطة النهاردة';

  @override
  String c1By(String date) {
    return 'C1 تقريبًا في $date';
  }

  @override
  String get mixupMap => 'اللخبطة بين اللغات';

  @override
  String get languagesAndPlan => 'اللغات والخطة';

  @override
  String get languagesAndPlanHint =>
      'وقّف لغة، غيّر ميعاد البداية، اختبار المستوى';

  @override
  String get appearance => 'الشكل';

  @override
  String get colorTheme => 'لون الثيم';

  @override
  String get themeLanguage => 'ألوان اللغة';

  @override
  String get themeAurora => 'شفق';

  @override
  String get themeOcean => 'محيط';

  @override
  String get themeSunset => 'غروب';

  @override
  String get themeForest => 'غابة';

  @override
  String get themeRose => 'وردي';

  @override
  String get themeMidnight => 'نص الليل';

  @override
  String get modeSystem => 'تلقائي';

  @override
  String get modeLight => 'فاتح';

  @override
  String get modeDark => 'غامق';

  @override
  String get humanVoice => 'صوت بشري';

  @override
  String get humanVoiceHint =>
      'الكلمات بتشغّل تسجيلات حقيقية لناس من أهل اللغة (Lingua Libre، رخصة مجانية). والجمل بتستخدم أطبع صوت موجود على جهازك.';

  @override
  String get nativeSpeaker => 'صوت من أهل اللغة';

  @override
  String get watchOnYouTube => 'اتفرج على يوتيوب';

  @override
  String get videosTitle => 'فيديوهات عن الموضوع ده';

  @override
  String get videosHint => 'بيفتح يوتيوب على دروس عن نفس الموضوع بالظبط.';

  @override
  String get videoInArabic => 'شرح بالعربي';

  @override
  String get videoInEnglish => 'شرح بالإنجليزي';

  @override
  String videoNative(String language) {
    return '$language بس';
  }

  @override
  String get keyPoints => 'أهم النقط';

  @override
  String get examplesTitle => 'أمثلة';

  @override
  String get remember => 'افتكر';

  @override
  String get listenAll => 'اسمع الكل';

  @override
  String get pieceOfGermanTitle => 'Piece of German: خطة الأسبوع ده';

  @override
  String get pieceOfGermanHint =>
      'خطة ألماني مجانية يوم بيوم فيها فيديوهات وملاحظات بالعربي (pieceofgerman.com).';
}
