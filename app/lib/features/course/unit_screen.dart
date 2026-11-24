import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import 'lesson_type_ui.dart';
import '../../core/bidi.dart';

class UnitScreen extends ConsumerWidget {
  const UnitScreen({super.key, required this.unitId});

  /// For example `de.a1.u03`; the language and level come from the id.
  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final progress = ref.watch(lessonProgressProvider).value ?? const {};
    return AsyncView(
      value: ref.watch(levelContentProvider(packKeyOf(unitId))),
      builder: (c) {
        final unit = c.units.firstWhere((u) => u.id == unitId);
        return Scaffold(
          appBar: AppBar(
            title: BidiText('${l.unitN(unit.order)} · ${unit.theme.get(lang)}'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final goal in unit.goals)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.flag_outlined),
                  title: BidiText(goal.get(lang)),
                ),
              const Divider(),
              for (final lesson in c.lessonsOf(unit))
                Card(
                  child: ListTile(
                    leading: Icon(lesson.type.icon),
                    title: BidiText(lesson.title.get(lang)),
                    subtitle: BidiText(lesson.type.label(l)),
                    trailing:
                        progress[lesson.id]?.status == LessonStatus.completed
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.chevron_right),
                    onTap: () => context.push('/lesson/${lesson.id}'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
