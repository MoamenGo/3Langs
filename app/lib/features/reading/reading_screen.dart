import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import 'reading_view.dart';

class ReadingListScreen extends ConsumerWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(settingsProvider).value?.currentLevel ?? 'A1';
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.lessonReading)),
      body: AsyncView(
        value: ref.watch(levelContentProvider(level)),
        builder: (c) => ListView(
          children: [
            for (final t in c.texts.values)
              ListTile(
                leading: Icon(
                  t.kind == 'external'
                      ? Icons.open_in_new
                      : Icons.article_outlined,
                ),
                title: Text(t.title),
                subtitle: Text('${t.level} · ${t.source}'),
                onTap: () => context.push('/practice/reading/${t.id}'),
              ),
          ],
        ),
      ),
    );
  }
}

class ReadingScreen extends ConsumerWidget {
  const ReadingScreen({super.key, required this.textId});
  final String textId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(settingsProvider).value?.currentLevel ?? 'A1';
    return StudyTimer(
      activity: Activity.reading,
      child: Scaffold(
        appBar: AppBar(),
        body: AsyncView(
          value: ref.watch(levelContentProvider(level)),
          builder: (c) => ReadingView(
            text: c.texts[textId]!,
            content: c,
            onDone: (_) => context.pop(),
          ),
        ),
      ),
    );
  }
}
