// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => '3Lang';

  @override
  String get navHome => 'Inicio';

  @override
  String get navCourse => 'Curso';

  @override
  String get navPractice => 'Practicar';

  @override
  String get navProgress => 'Progreso';

  @override
  String todayGoal(int minutes, int goal) {
    return 'Hoy: $minutes de $goal min';
  }

  @override
  String streakDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días seguidos',
      one: '1 día seguido',
    );
    return '$_temp0';
  }

  @override
  String cardsDue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas pendientes',
      one: '1 tarjeta pendiente',
      zero: 'No hay tarjetas pendientes',
    );
    return '$_temp0';
  }

  @override
  String get startReview => 'Repasar ahora';

  @override
  String get continueLearning => 'Seguir aprendiendo';

  @override
  String get allLessonsDone =>
      'Has completado todas las lecciones disponibles. Pronto habrá más unidades.';

  @override
  String unitN(int n) {
    return 'Unidad $n';
  }

  @override
  String get comingSoon => 'Próximamente';

  @override
  String monthsRange(int from, int to) {
    return 'Meses $from–$to';
  }

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String get lessonVocab => 'Palabras nuevas';

  @override
  String get lessonGrammar => 'Gramática';

  @override
  String get lessonListening => 'Comprensión auditiva';

  @override
  String get lessonReading => 'Lectura';

  @override
  String get lessonReview => 'Repaso';

  @override
  String get lessonExam => 'Examen de prueba';

  @override
  String get lessonWriting => 'Expresión escrita';

  @override
  String get lessonSpeaking => 'Expresión oral';

  @override
  String get flashcards => 'Tarjetas';

  @override
  String get next => 'Siguiente';

  @override
  String get check => 'Comprobar';

  @override
  String get correct => '¡Correcto!';

  @override
  String wrongAnswer(String answer) {
    return 'No del todo. Respuesta: $answer';
  }

  @override
  String get lessonDone => '¡Lección completada!';

  @override
  String scoreLabel(int percent) {
    return 'Puntuación: $percent %';
  }

  @override
  String wordsAddedToReview(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras añadidas a tus tarjetas de repaso',
      one: '1 palabra añadida a tus tarjetas de repaso',
      zero: 'No hay palabras nuevas para tus tarjetas',
    );
    return '$_temp0';
  }

  @override
  String get backToCourse => 'Volver al curso';

  @override
  String whichMeans(String word) {
    return '¿Qué palabra alemana significa «$word»?';
  }

  @override
  String get example => 'Ejemplo';

  @override
  String plural(String plural) {
    return 'Plural: $plural';
  }

  @override
  String get showAnswer => 'Mostrar respuesta';

  @override
  String get rateAgain => 'Otra vez';

  @override
  String get rateHard => 'Difícil';

  @override
  String get rateGood => 'Bien';

  @override
  String get rateEasy => 'Fácil';

  @override
  String get reviewDone => '¡Todo listo por ahora! Vuelve más tarde.';

  @override
  String get reviewEmpty =>
      'Aún no hay tarjetas. Completa una lección para añadir palabras.';

  @override
  String get listenAndType => 'Escucha y escribe lo que oyes';

  @override
  String get playAudio => 'Reproducir';

  @override
  String get playSlow => 'Despacio';

  @override
  String get typeHere => 'Escribe en alemán';

  @override
  String get showTranslation => 'Mostrar traducción';

  @override
  String get glossary => 'Palabras';

  @override
  String get questions => 'Preguntas';

  @override
  String get openLink => 'Abrir en el navegador';

  @override
  String get externalHint =>
      'Es un recurso externo gratuito. Ábrelo en tu navegador.';

  @override
  String get writingCheck => 'Revisar mi alemán';

  @override
  String get noIssues => 'No se encontraron errores. Gut gemacht!';

  @override
  String wordCount(int count) {
    return '$count palabras';
  }

  @override
  String get checkFailed => 'No se pudo revisar ahora. ¿Tienes conexión?';

  @override
  String get speakingIntro =>
      'Escucha y di la frase en voz alta. ¿Qué tal te ha salido?';

  @override
  String totalHours(String hours) {
    return '$hours horas de estudio';
  }

  @override
  String wordsKnown(int count) {
    return '$count palabras aprendidas';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done de $total lecciones';
  }

  @override
  String get last7Days => 'Últimos 7 días';

  @override
  String get courseTimeline => 'Tu camino de 2 años';

  @override
  String get settings => 'Ajustes';

  @override
  String get appLanguage => 'Idioma de la aplicación';

  @override
  String get explanationLanguage => 'Idioma de las explicaciones';

  @override
  String get dailyGoal => 'Objetivo diario';

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String get newCardsPerDay => 'Tarjetas nuevas al día';

  @override
  String get account => 'Cuenta y sincronización';

  @override
  String get signIn => 'Inicia sesión para sincronizar';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String signedInAs(String email) {
    return 'Sesión iniciada como $email';
  }

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String lastSynced(String time) {
    return 'Última sincronización $time';
  }

  @override
  String get syncDisabled =>
      'La sincronización está desactivada: esta versión no tiene configuración de Supabase. Todo se guarda en este dispositivo.';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get checkEmail => 'Revisa tu correo para confirmar tu cuenta.';

  @override
  String get about => 'Acerca de y créditos';

  @override
  String get aboutText =>
      '3Lang usa solo contenido gratuito y con licencia abierta. Cada palabra y frase conserva su fuente y licencia, indicadas abajo.';

  @override
  String errorMessage(String message) {
    return 'Algo salió mal: $message';
  }
}
