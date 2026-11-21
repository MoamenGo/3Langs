// Localization delegates for the app UI (en, nl, es).
//
// Flutter 3.47+ moved Material and Cupertino into the material_ui and
// cupertino_ui packages, and the generated
// AppLocalizations.localizationsDelegates still points at the old
// flutter_localizations classes, which no longer register Material texts.
// This list uses the new ones.

import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';

const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  cupertino.GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];
