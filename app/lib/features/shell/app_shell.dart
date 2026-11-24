import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import '../../core/widgets.dart';

/// Bottom navigation on phones, a side rail on wide screens (web, tablets).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Icons.today_outlined, Icons.today, l.navToday),
      (Icons.school_outlined, Icons.school, l.navCourse),
      (Icons.fitness_center_outlined, Icons.fitness_center, l.navPractice),
      (Icons.insights_outlined, Icons.insights, l.navProgress),
    ];
    void go(int i) =>
        shell.goBranch(i, initialLocation: i == shell.currentIndex);

    final wide = MediaQuery.sizeOf(context).width >= 840;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Glass(
                radius: 28,
                child: NavigationRail(
                  selectedIndex: shell.currentIndex,
                  onDestinationSelected: go,
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l.appTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  destinations: [
                    for (final (icon, selected, label) in items)
                      NavigationRailDestination(
                        icon: Icon(icon),
                        selectedIcon: Icon(selected),
                        label: Text(label),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(child: shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: shell,
      extendBody: true,
      bottomNavigationBar: Glass(
        radius: 0,
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          selectedIndex: shell.currentIndex,
          onDestinationSelected: go,
          destinations: [
            for (final (icon, selected, label) in items)
              NavigationDestination(
                icon: Icon(icon),
                selectedIcon: Icon(selected),
                label: label,
              ),
          ],
        ),
      ),
    );
  }
}
