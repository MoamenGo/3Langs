// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '3Lang';

  @override
  String get navHome => 'Home';

  @override
  String get navCourse => 'Course';

  @override
  String get navPractice => 'Practice';

  @override
  String get navProgress => 'Progress';

  @override
  String todayGoal(int minutes, int goal) {
    return 'Today: $minutes of $goal min';
  }

  @override
  String streakDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-day streak',
      one: '1-day streak',
    );
    return '$_temp0';
  }

  @override
  String cardsDue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards due',
      one: '1 card due',
      zero: 'No cards due',
    );
    return '$_temp0';
  }

  @override
  String get startReview => 'Review now';

  @override
  String get continueLearning => 'Continue learning';

  @override
  String get allLessonsDone =>
      'All available lessons are done. New units are on the way.';

  @override
  String unitN(int n) {
    return 'Unit $n';
  }

  @override
  String get comingSoon => 'Coming soon';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String get lessonVocab => 'New words';

  @override
  String get lessonGrammar => 'Grammar';

  @override
  String get lessonListening => 'Listening';

  @override
  String get lessonReading => 'Reading';

  @override
  String get lessonReview => 'Review';

  @override
  String get lessonExam => 'Mock exam';

  @override
  String get lessonWriting => 'Writing';

  @override
  String get lessonSpeaking => 'Speaking';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get next => 'Next';

  @override
  String get check => 'Check';

  @override
  String get correct => 'Correct!';

  @override
  String wrongAnswer(String answer) {
    return 'Not quite. Answer: $answer';
  }

  @override
  String get lessonDone => 'Lesson complete!';

  @override
  String scoreLabel(int percent) {
    return 'Score: $percent%';
  }

  @override
  String wordsAddedToReview(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words added to your review cards',
      one: '1 word added to your review cards',
      zero: 'No new words for your review cards',
    );
    return '$_temp0';
  }

  @override
  String get backToCourse => 'Back to course';

  @override
  String whichMeans(String word, String language) {
    return 'Which $language word means “$word”?';
  }

  @override
  String get example => 'Example';

  @override
  String plural(String plural) {
    return 'Plural: $plural';
  }

  @override
  String get showAnswer => 'Show answer';

  @override
  String get rateAgain => 'Again';

  @override
  String get rateHard => 'Hard';

  @override
  String get rateGood => 'Good';

  @override
  String get rateEasy => 'Easy';

  @override
  String get reviewDone => 'All done for now! Come back later for more.';

  @override
  String get reviewEmpty => 'No cards yet. Finish a lesson to add words.';

  @override
  String get listenAndType => 'Listen and type what you hear';

  @override
  String get playAudio => 'Play';

  @override
  String get playSlow => 'Slow';

  @override
  String typeHere(String language) {
    return 'Type in $language';
  }

  @override
  String get showTranslation => 'Show translation';

  @override
  String get glossary => 'Words';

  @override
  String get questions => 'Questions';

  @override
  String get openLink => 'Open in browser';

  @override
  String get externalHint =>
      'This is a free external resource. Open it in your browser.';

  @override
  String get writingCheck => 'Check my writing';

  @override
  String get noIssues => 'No problems found. Well done!';

  @override
  String wordCount(int count) {
    return '$count words';
  }

  @override
  String get checkFailed => 'Couldn\'t check right now. Are you online?';

  @override
  String get speakingIntro =>
      'Listen, then say the sentence out loud. How did it go?';

  @override
  String totalHours(String hours) {
    return '$hours hours studied';
  }

  @override
  String wordsKnown(int count) {
    return '$count words known';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done of $total lessons';
  }

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get courseTimeline => 'Your A0–C1 path';

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App language';

  @override
  String get explanationLanguage => 'Explanation language';

  @override
  String get dailyGoal => 'Daily goal';

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get newCardsPerDay => 'New cards per day';

  @override
  String get account => 'Account and sync';

  @override
  String get signIn => 'Sign in to sync';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String lastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncDisabled =>
      'Sync is off: this build has no Supabase settings. Everything is saved on this device.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get createAccount => 'Create account';

  @override
  String get checkEmail => 'Check your email to confirm your account.';

  @override
  String get about => 'About and credits';

  @override
  String get aboutText =>
      '3Lang uses only free and openly licensed content. Every word and sentence keeps its source and licence, listed below.';

  @override
  String errorMessage(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String noContentYet(String language) {
    return 'Lessons for $language are coming in the next update.';
  }

  @override
  String startsOn(String date) {
    return 'Your plan starts this language on $date.';
  }

  @override
  String get languages => 'Your languages';

  @override
  String get trackActive => 'Active';

  @override
  String trackScheduled(String date) {
    return 'Starts $date';
  }

  @override
  String get trackPaused => 'Paused';

  @override
  String get pauseLanguage => 'Pause';

  @override
  String get resumeLanguage => 'Start now';

  @override
  String levelN(String level) {
    return 'Level $level';
  }

  @override
  String unitsCount(int count) {
    return '$count units';
  }

  @override
  String get sameForAllLanguages =>
      'The same units in German, Spanish and Dutch. Hours are per language.';

  @override
  String get explainArabic => 'Arabic';

  @override
  String get explainEnglish => 'English';

  @override
  String get contrastDictionary => 'Contrast dictionary';

  @override
  String get contrastIntro =>
      'Words that look alike but mean different things, words you can learn together, and nouns whose gender changes between languages.';

  @override
  String get inOtherLanguages => 'In your other languages';

  @override
  String get contrastAll => 'All';

  @override
  String get falseFriends => 'False friends';

  @override
  String get nearCognates => 'Look alike';

  @override
  String get genderMismatches => 'Gender changes';

  @override
  String levelDone(String level) {
    return 'You finished level $level!';
  }

  @override
  String startLevel(String level) {
    return 'Start level $level';
  }

  @override
  String get navToday => 'Today';

  @override
  String get welcomeTitle => 'Set up your three languages';

  @override
  String get welcomeSubtitle =>
      'Choose your languages, daily time and starting level.';

  @override
  String get setUp => 'Set up';

  @override
  String get todaysPlan => 'Today\'s plan';

  @override
  String planMinutes(int total, int left) {
    return '$total min planned · $left min left';
  }

  @override
  String get rebuildPlan => 'Rebuild today\'s plan';

  @override
  String get planEmpty => 'Nothing to study today. Enjoy your day off!';

  @override
  String get planDone => 'Today\'s plan is done. Great work!';

  @override
  String get startPlan => 'Start today\'s session';

  @override
  String get continuePlan => 'Continue';

  @override
  String blockReview(String lang) {
    return 'Review · $lang';
  }

  @override
  String blockLesson(String lang) {
    return 'New lesson · $lang';
  }

  @override
  String get blockContrast => 'Contrast drill';

  @override
  String get blockContrastHint => 'The words you mix up between languages';

  @override
  String get yourLanguages => 'Your languages';

  @override
  String get drillEmpty =>
      'No words to compare yet. Finish a few lessons in two languages first.';

  @override
  String get myMixups => 'Your mix-ups';

  @override
  String get noMixups => 'No mix-ups yet.';

  @override
  String mixupGiven(String given, String lang) {
    return 'You chose $given ($lang)';
  }

  @override
  String get done => 'Done';

  @override
  String examIntro(String level, int count, int pass) {
    return '$level exam: $count questions from the whole level. Score $pass% or more to move up.';
  }

  @override
  String get startExam => 'Start';

  @override
  String examPassed(String level) {
    return 'You passed $level!';
  }

  @override
  String examFailed(String level) {
    return 'Not yet. Review $level and try again.';
  }

  @override
  String nowAtLevel(String level) {
    return 'You are now at $level.';
  }

  @override
  String get tryAgain => 'Try again';

  @override
  String mixupHint(String lang) {
    return 'That one is $lang: a mix-up between languages.';
  }

  @override
  String placementTitle(String lang) {
    return 'Placement test · $lang';
  }

  @override
  String placementResult(String lang, String level) {
    return 'You start $lang at $level.';
  }

  @override
  String placementIntro(String lang) {
    return 'A few words from each level, from A1 up. It stops when it gets hard, about 5 minutes. Not sure? Start as a beginner.';
  }

  @override
  String get placementBeginner => 'I\'m a complete beginner (A0)';

  @override
  String placementLevel(String level) {
    return 'Level $level';
  }

  @override
  String get welcomeIntro =>
      '3Lang teaches German, Dutch and Spanish side by side, from A0 to C1. Every day it plans a session across your languages: reviews first, new lessons in two languages, a skill in the third, and a contrast drill when you mix them up.';

  @override
  String get stepInterface => '1. App language';

  @override
  String get stepMinutes => '2. Minutes a day';

  @override
  String minutesPerLanguage(int total, int each) {
    return '$total min a day, about $each min per language';
  }

  @override
  String get stepLanguages => '3. Languages and start';

  @override
  String get stepLanguagesHint =>
      'German and Dutch are close, so Dutch starts later by default. Take a placement test if you already know some.';

  @override
  String get startIn => 'Start:';

  @override
  String get startNow => 'Now';

  @override
  String weekN(int n) {
    return 'Week $n';
  }

  @override
  String get placementButton => 'Placement test';

  @override
  String get finishSetup => 'Save and go to today';

  @override
  String c1By(String date) {
    return 'C1 by about $date';
  }

  @override
  String get mixupMap => 'Mix-ups between languages';

  @override
  String get languagesAndPlan => 'Languages and plan';

  @override
  String get languagesAndPlanHint =>
      'Pause a language, change start dates, placement tests';

  @override
  String get appearance => 'Appearance';

  @override
  String get colorTheme => 'Colour theme';

  @override
  String get themeLanguage => 'Language colours';

  @override
  String get themeAurora => 'Aurora';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get modeSystem => 'Auto';

  @override
  String get modeLight => 'Light';

  @override
  String get modeDark => 'Dark';

  @override
  String get humanVoice => 'Human voice';

  @override
  String get humanVoiceHint =>
      'Words play real recordings by native speakers (Lingua Libre, free licence). Sentences use the most natural voice on your device.';

  @override
  String get nativeSpeaker => 'Native speaker';

  @override
  String get watchOnYouTube => 'Watch on YouTube';

  @override
  String get videosTitle => 'Videos on this topic';

  @override
  String get videosHint => 'Opens YouTube with lessons on this exact topic.';

  @override
  String get videoInArabic => 'Explained in Arabic';

  @override
  String get videoInEnglish => 'Explained in English';

  @override
  String videoNative(String language) {
    return 'In $language only';
  }

  @override
  String get keyPoints => 'Key points';

  @override
  String get examplesTitle => 'Examples';

  @override
  String get remember => 'Remember';

  @override
  String get listenAll => 'Listen to all';
}
