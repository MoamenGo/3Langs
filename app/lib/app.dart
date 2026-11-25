import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/localization.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/responsive.dart';
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
    final startup = ref.watch(startupStateProvider);
    final settings = ref.watch(currentSettingsProvider);
    final uiLanguage = settings?.uiLanguage ?? 'ar';
    final lang = ref.watch(activeLangProvider);
    final appTheme = ref.watch(appThemeProvider).value ?? startup.appTheme;
    final mode = ref.watch(themeModeProvider).value ?? startup.themeMode;
    final glass = ref.watch(glassProvider).value ?? startup.glass;
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(
        Brightness.light,
        lang: lang,
        appTheme: appTheme,
        glass: glass,
      ),
      darkTheme: buildTheme(
        Brightness.dark,
        lang: lang,
        appTheme: appTheme,
        glass: glass,
      ),
      themeMode: appTheme == AppTheme.midnight ? ThemeMode.dark : mode,
      builder: (context, child) => GlassBackground(
        child: ResponsiveFrame(child: child ?? const SizedBox.shrink()),
      ),
      locale: Locale(uiLanguage),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
