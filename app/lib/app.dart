import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/localization.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'l10n/app_localizations.dart';

class ThreeLangApp extends ConsumerStatefulWidget {
  const ThreeLangApp({super.key});

  @override
  ConsumerState<ThreeLangApp> createState() => _ThreeLangAppState();
}

class _ThreeLangAppState extends ConsumerState<ThreeLangApp> {
  @override
  void initState() {
    super.initState();
    ref.read(syncServiceProvider).start();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final uiLanguage = settings?.uiLanguage ?? 'ar';
    final lang = ref.watch(activeLangProvider);
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light, lang: lang),
      darkTheme: buildTheme(Brightness.dark, lang: lang),
      locale: Locale(uiLanguage),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
