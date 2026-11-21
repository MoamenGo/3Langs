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
  String monthsRange(int from, int to) {
    return 'Months $from–$to';
  }

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
  String whichMeans(String word) {
    return 'Which German word means “$word”?';
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
  String get typeHere => 'Type in German';

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
  String get writingCheck => 'Check my German';

  @override
  String get noIssues => 'No problems found. Gut gemacht!';

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
  String get courseTimeline => 'Your 2-year path';

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
}
