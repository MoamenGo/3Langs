import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../core/bidi.dart';
import '../polyglot/ui.dart' show TrX;

/// Branch indexes, in the order of the router's shell branches.
abstract final class Tabs {
  static const matrix = 0;
  static const today = 1;
  static const course = 2;
  static const practice = 3;
  static const progress = 4;
  static const notebook = 5;
  static const dictionary = 6;
  static const resources = 7;

  /// The guided course (Today, Course, Practice, Progress) sits under one
  /// "Study" item on phones.
  static const study = {today, course, practice, progress};
}

/// Bottom navigation on phones, a side rail on wide screens (web, tablets).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final mx = context.mx;
    final items = <(int, IconData, IconData, String)>[
      (
        Tabs.matrix,
        Icons.grid_view_outlined,
        Icons.grid_view_rounded,
        context.tr('Matrix', 'المصفوفة'),
      ),
      (Tabs.today, Icons.today_outlined, Icons.today, l.navToday),
      (Tabs.course, Icons.school_outlined, Icons.school, l.navCourse),
      (
        Tabs.practice,
        Icons.fitness_center_outlined,
        Icons.fitness_center,
        l.navPractice,
      ),
      (Tabs.progress, Icons.insights_outlined, Icons.insights, l.navProgress),
      (
        Tabs.notebook,
        Icons.edit_calendar_outlined,
        Icons.edit_calendar,
        context.tr('Notebook', 'المذكرة'),
      ),
      (
        Tabs.dictionary,
        Icons.menu_book_outlined,
        Icons.menu_book,
        context.tr('Dictionary', 'القاموس'),
      ),
      (
        Tabs.resources,
        Icons.local_library_outlined,
        Icons.local_library,
        context.tr('Free Hub', 'المصادر'),
      ),
    ];
    void go(int i) =>
        shell.goBranch(i, initialLocation: i == shell.currentIndex);

    final wide = MediaQuery.sizeOf(context).width >= 840;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            Frosted(
              radius: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: mx.surface,
                  border: BorderDirectional(end: BorderSide(color: mx.rule)),
                ),
                child: LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          selectedIndex: shell.currentIndex,
                          onDestinationSelected: go,
                          labelType: NavigationRailLabelType.all,
                          minWidth: 84,
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: BidiText(
                              l.appTitle,
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(color: mx.primary),
                            ),
                          ),
                          destinations: [
                            for (final (_, icon, selected, label) in items)
                              NavigationRailDestination(
                                icon: Icon(icon),
                                selectedIcon: Icon(selected),
                                label: BidiText(label),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: shell),
          ],
        ),
      );
    }

    // Phones: Matrix, Study (sheet), Notebook, Dictionary, Free Hub.
    final bar = [
      items[0],
      (-1, Icons.school_outlined, Icons.school, context.tr('Study', 'الدراسة')),
      items[5],
      items[6],
      items[7],
    ];
    final current = shell.currentIndex;
    final selected = Tabs.study.contains(current)
        ? 1
        : bar.indexWhere((b) => b.$1 == current).clamp(0, bar.length - 1);
    return Scaffold(
      body: shell,
      bottomNavigationBar: Frosted(
        radius: 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: mx.rule)),
          ),
          child: NavigationBar(
            selectedIndex: selected,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (i) {
              final target = bar[i].$1;
              if (target >= 0) {
                go(target);
                return;
              }
              _showStudySheet(context, items, go, current);
            },
            destinations: [
              for (final (_, icon, sel, label) in bar)
                NavigationDestination(
                  icon: Icon(icon),
                  selectedIcon: Icon(sel),
                  label: label,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStudySheet(
    BuildContext context,
    List<(int, IconData, IconData, String)> items,
    void Function(int) go,
    int current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (i, icon, sel, label) in items)
              if (Tabs.study.contains(i))
                ListTile(
                  key: Key('study-$i'),
                  leading: Icon(i == current ? sel : icon),
                  selected: i == current,
                  title: BidiText(label),
                  onTap: () {
                    Navigator.pop(c);
                    go(i);
                  },
                ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
