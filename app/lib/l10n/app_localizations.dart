import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'3Lang'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get navCourse;

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @todayGoal.
  ///
  /// In en, this message translates to:
  /// **'Today: {minutes} of {goal} min'**
  String todayGoal(int minutes, int goal);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1-day streak} other{{count}-day streak}}'**
  String streakDays(num count);

  /// No description provided for @cardsDue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No cards due} =1{1 card due} other{{count} cards due}}'**
  String cardsDue(num count);

  /// No description provided for @startReview.
  ///
  /// In en, this message translates to:
  /// **'Review now'**
  String get startReview;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get continueLearning;

  /// No description provided for @allLessonsDone.
  ///
  /// In en, this message translates to:
  /// **'All available lessons are done. New units are on the way.'**
  String get allLessonsDone;

  /// No description provided for @unitN.
  ///
  /// In en, this message translates to:
  /// **'Unit {n}'**
  String unitN(int n);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String hoursShort(int hours);

  /// No description provided for @lessonVocab.
  ///
  /// In en, this message translates to:
  /// **'New words'**
  String get lessonVocab;

  /// No description provided for @lessonGrammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get lessonGrammar;

  /// No description provided for @lessonListening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get lessonListening;

  /// No description provided for @lessonReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get lessonReading;

  /// No description provided for @lessonReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get lessonReview;

  /// No description provided for @lessonExam.
  ///
  /// In en, this message translates to:
  /// **'Mock exam'**
  String get lessonExam;

  /// No description provided for @lessonWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get lessonWriting;

  /// No description provided for @lessonSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Speaking'**
  String get lessonSpeaking;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Answer: {answer}'**
  String wrongAnswer(String answer);

  /// No description provided for @lessonDone.
  ///
  /// In en, this message translates to:
  /// **'Lesson complete!'**
  String get lessonDone;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score: {percent}%'**
  String scoreLabel(int percent);

  /// No description provided for @wordsAddedToReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No new words for your review cards} =1{1 word added to your review cards} other{{count} words added to your review cards}}'**
  String wordsAddedToReview(num count);

  /// No description provided for @backToCourse.
  ///
  /// In en, this message translates to:
  /// **'Back to course'**
  String get backToCourse;

  /// No description provided for @whichMeans.
  ///
  /// In en, this message translates to:
  /// **'Which {language} word means “{word}”?'**
  String whichMeans(String word, String language);

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @plural.
  ///
  /// In en, this message translates to:
  /// **'Plural: {plural}'**
  String plural(String plural);

  /// No description provided for @showAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// No description provided for @rateAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get rateAgain;

  /// No description provided for @rateHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get rateHard;

  /// No description provided for @rateGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get rateGood;

  /// No description provided for @rateEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get rateEasy;

  /// No description provided for @reviewDone.
  ///
  /// In en, this message translates to:
  /// **'All done for now! Come back later for more.'**
  String get reviewDone;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cards yet. Finish a lesson to add words.'**
  String get reviewEmpty;

  /// No description provided for @listenAndType.
  ///
  /// In en, this message translates to:
  /// **'Listen and type what you hear'**
  String get listenAndType;

  /// No description provided for @playAudio.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playAudio;

  /// No description provided for @playSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get playSlow;

  /// No description provided for @typeHere.
  ///
  /// In en, this message translates to:
  /// **'Type in {language}'**
  String typeHere(String language);

  /// No description provided for @showTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show translation'**
  String get showTranslation;

  /// No description provided for @glossary.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get glossary;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openLink;

  /// No description provided for @externalHint.
  ///
  /// In en, this message translates to:
  /// **'This is a free external resource. Open it in your browser.'**
  String get externalHint;

  /// No description provided for @writingCheck.
  ///
  /// In en, this message translates to:
  /// **'Check my writing'**
  String get writingCheck;

  /// No description provided for @noIssues.
  ///
  /// In en, this message translates to:
  /// **'No problems found. Well done!'**
  String get noIssues;

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordCount(int count);

  /// No description provided for @checkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check right now. Are you online?'**
  String get checkFailed;

  /// No description provided for @speakingIntro.
  ///
  /// In en, this message translates to:
  /// **'Listen, then say the sentence out loud. How did it go?'**
  String get speakingIntro;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours studied'**
  String totalHours(String hours);

  /// No description provided for @wordsKnown.
  ///
  /// In en, this message translates to:
  /// **'{count} words known'**
  String wordsKnown(int count);

  /// No description provided for @lessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} lessons'**
  String lessonsCompleted(int done, int total);

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @courseTimeline.
  ///
  /// In en, this message translates to:
  /// **'Your A0–C1 path'**
  String get courseTimeline;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @explanationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Explanation language'**
  String get explanationLanguage;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoal;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String minutesShort(int n);

  /// No description provided for @newCardsPerDay.
  ///
  /// In en, this message translates to:
  /// **'New cards per day'**
  String get newCardsPerDay;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account and sync'**
  String get account;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String lastSynced(String time);

  /// No description provided for @syncDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sync is off: this build has no Supabase settings. Everything is saved on this device.'**
  String get syncDisabled;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm your account.'**
  String get checkEmail;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About and credits'**
  String get about;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'3Lang uses only free and openly licensed content. Every word and sentence keeps its source and licence, listed below.'**
  String get aboutText;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String errorMessage(String message);

  /// No description provided for @noContentYet.
  ///
  /// In en, this message translates to:
  /// **'Lessons for {language} are coming in the next update.'**
  String noContentYet(String language);

  /// No description provided for @startsOn.
  ///
  /// In en, this message translates to:
  /// **'Your plan starts this language on {date}.'**
  String startsOn(String date);

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Your languages'**
  String get languages;

  /// No description provided for @trackActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get trackActive;

  /// No description provided for @trackScheduled.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String trackScheduled(String date);

  /// No description provided for @trackPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get trackPaused;

  /// No description provided for @pauseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseLanguage;

  /// No description provided for @resumeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get resumeLanguage;

  /// No description provided for @levelN.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelN(String level);

  /// No description provided for @unitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String unitsCount(int count);

  /// No description provided for @sameForAllLanguages.
  ///
  /// In en, this message translates to:
  /// **'The same units in German, Spanish and Dutch. Hours are per language.'**
  String get sameForAllLanguages;

  /// No description provided for @explainArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get explainArabic;

  /// No description provided for @explainEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get explainEnglish;

  /// No description provided for @contrastDictionary.
  ///
  /// In en, this message translates to:
  /// **'Contrast dictionary'**
  String get contrastDictionary;

  /// No description provided for @contrastIntro.
  ///
  /// In en, this message translates to:
  /// **'Words that look alike but mean different things, words you can learn together, and nouns whose gender changes between languages.'**
  String get contrastIntro;

  /// No description provided for @inOtherLanguages.
  ///
  /// In en, this message translates to:
  /// **'In your other languages'**
  String get inOtherLanguages;

  /// No description provided for @contrastAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get contrastAll;

  /// No description provided for @falseFriends.
  ///
  /// In en, this message translates to:
  /// **'False friends'**
  String get falseFriends;

  /// No description provided for @nearCognates.
  ///
  /// In en, this message translates to:
  /// **'Look alike'**
  String get nearCognates;

  /// No description provided for @genderMismatches.
  ///
  /// In en, this message translates to:
  /// **'Gender changes'**
  String get genderMismatches;

  /// No description provided for @levelDone.
  ///
  /// In en, this message translates to:
  /// **'You finished level {level}!'**
  String levelDone(String level);

  /// No description provided for @startLevel.
  ///
  /// In en, this message translates to:
  /// **'Start level {level}'**
  String startLevel(String level);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
