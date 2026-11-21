// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => '3Lang';

  @override
  String get navHome => 'Start';

  @override
  String get navCourse => 'Cursus';

  @override
  String get navPractice => 'Oefenen';

  @override
  String get navProgress => 'Voortgang';

  @override
  String todayGoal(int minutes, int goal) {
    return 'Vandaag: $minutes van $goal min';
  }

  @override
  String streakDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen op rij',
      one: '1 dag op rij',
    );
    return '$_temp0';
  }

  @override
  String cardsDue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaarten te herhalen',
      one: '1 kaart te herhalen',
      zero: 'Geen kaarten te herhalen',
    );
    return '$_temp0';
  }

  @override
  String get startReview => 'Nu herhalen';

  @override
  String get continueLearning => 'Verder leren';

  @override
  String get allLessonsDone =>
      'Alle beschikbare lessen zijn klaar. Nieuwe units komen eraan.';

  @override
  String unitN(int n) {
    return 'Unit $n';
  }

  @override
  String get comingSoon => 'Binnenkort';

  @override
  String monthsRange(int from, int to) {
    return 'Maanden $from–$to';
  }

  @override
  String hoursShort(int hours) {
    return '$hours u';
  }

  @override
  String get lessonVocab => 'Nieuwe woorden';

  @override
  String get lessonGrammar => 'Grammatica';

  @override
  String get lessonListening => 'Luisteren';

  @override
  String get lessonReading => 'Lezen';

  @override
  String get lessonReview => 'Herhaling';

  @override
  String get lessonExam => 'Proefexamen';

  @override
  String get lessonWriting => 'Schrijven';

  @override
  String get lessonSpeaking => 'Spreken';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get next => 'Volgende';

  @override
  String get check => 'Controleren';

  @override
  String get correct => 'Goed!';

  @override
  String wrongAnswer(String answer) {
    return 'Niet helemaal. Antwoord: $answer';
  }

  @override
  String get lessonDone => 'Les voltooid!';

  @override
  String scoreLabel(int percent) {
    return 'Score: $percent%';
  }

  @override
  String wordsAddedToReview(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count woorden toegevoegd aan je herhaalkaarten',
      one: '1 woord toegevoegd aan je herhaalkaarten',
      zero: 'Geen nieuwe woorden voor je herhaalkaarten',
    );
    return '$_temp0';
  }

  @override
  String get backToCourse => 'Terug naar cursus';

  @override
  String whichMeans(String word) {
    return 'Welk Duits woord betekent ‘$word’?';
  }

  @override
  String get example => 'Voorbeeld';

  @override
  String plural(String plural) {
    return 'Meervoud: $plural';
  }

  @override
  String get showAnswer => 'Toon antwoord';

  @override
  String get rateAgain => 'Opnieuw';

  @override
  String get rateHard => 'Moeilijk';

  @override
  String get rateGood => 'Goed';

  @override
  String get rateEasy => 'Makkelijk';

  @override
  String get reviewDone => 'Voor nu klaar! Kom later terug voor meer.';

  @override
  String get reviewEmpty =>
      'Nog geen kaarten. Maak een les af om woorden toe te voegen.';

  @override
  String get listenAndType => 'Luister en typ wat je hoort';

  @override
  String get playAudio => 'Afspelen';

  @override
  String get playSlow => 'Langzaam';

  @override
  String get typeHere => 'Typ in het Duits';

  @override
  String get showTranslation => 'Toon vertaling';

  @override
  String get glossary => 'Woorden';

  @override
  String get questions => 'Vragen';

  @override
  String get openLink => 'Openen in browser';

  @override
  String get externalHint =>
      'Dit is een gratis externe bron. Open hem in je browser.';

  @override
  String get writingCheck => 'Controleer mijn Duits';

  @override
  String get noIssues => 'Geen fouten gevonden. Gut gemacht!';

  @override
  String wordCount(int count) {
    return '$count woorden';
  }

  @override
  String get checkFailed => 'Controleren lukt nu niet. Ben je online?';

  @override
  String get speakingIntro => 'Luister en zeg de zin hardop. Hoe ging het?';

  @override
  String totalHours(String hours) {
    return '$hours uur gestudeerd';
  }

  @override
  String wordsKnown(int count) {
    return '$count woorden gekend';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done van $total lessen';
  }

  @override
  String get last7Days => 'Afgelopen 7 dagen';

  @override
  String get courseTimeline => 'Jouw traject van 2 jaar';

  @override
  String get settings => 'Instellingen';

  @override
  String get appLanguage => 'Taal van de app';

  @override
  String get explanationLanguage => 'Taal van de uitleg';

  @override
  String get dailyGoal => 'Dagdoel';

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get newCardsPerDay => 'Nieuwe kaarten per dag';

  @override
  String get account => 'Account en synchronisatie';

  @override
  String get signIn => 'Inloggen om te synchroniseren';

  @override
  String get signOut => 'Uitloggen';

  @override
  String signedInAs(String email) {
    return 'Ingelogd als $email';
  }

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String lastSynced(String time) {
    return 'Laatst gesynchroniseerd $time';
  }

  @override
  String get syncDisabled =>
      'Synchronisatie staat uit: deze versie heeft geen Supabase-instellingen. Alles wordt op dit apparaat bewaard.';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get createAccount => 'Account aanmaken';

  @override
  String get checkEmail => 'Kijk in je e-mail om je account te bevestigen.';

  @override
  String get about => 'Over en bronnen';

  @override
  String get aboutText =>
      '3Lang gebruikt alleen gratis en open gelicenseerde inhoud. Elk woord en elke zin houdt zijn bron en licentie, hieronder vermeld.';

  @override
  String errorMessage(String message) {
    return 'Er ging iets mis: $message';
  }
}
