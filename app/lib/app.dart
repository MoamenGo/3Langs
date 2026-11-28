import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/localization.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/responsive.dart';
import 'core/theme.dart';
import 'services/update/app_update.dart';
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
    // Android: say once per start when a newer build is published.
    if (!kIsWeb && currentBuild > 0) {
      fetchLatestBuild().then((latest) {
        if (latest == null || !latest.isNewer) return;
        final ui = ref.read(currentSettingsProvider)?.uiLanguage ?? 'ar';
        _messenger.currentState?.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 10),
            content: Text(
              ui == 'ar'
                  ? 'في تحديث جديد (بناء ${latest.build})'
                  : 'Update available (build ${latest.build})',
            ),
            action: SnackBarAction(
              label: ui == 'ar' ? 'تحديث' : 'Update',
              onPressed: () => installUpdate(latest),
            ),
          ),
        );
      });
    }
  }

  final _messenger = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final startup = ref.watch(startupStateProvider);
    final settings = ref.watch(currentSettingsProvider);
    final uiLanguage = settings?.uiLanguage ?? 'ar';
    final lang = ref.watch(activeLangProvider);
    final appTheme = ref.watch(appThemeProvider).value ?? startup.appTheme;
    final mode = ref.watch(themeModeProvider).value ?? startup.themeMode;
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messenger,
      theme: buildTheme(Brightness.light, lang: lang, appTheme: appTheme),
      darkTheme: buildTheme(Brightness.dark, lang: lang, appTheme: appTheme),
      themeMode: mode,
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
