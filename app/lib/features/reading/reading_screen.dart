import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import 'reading_view.dart';
import '../../core/bidi.dart';

class ReadingListScreen extends ConsumerWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: BidiText(context.l10n.lessonReading)),
      body: AsyncView(
        value: ref.watch(activeContentProvider),
        builder: (c) => c == null
            ? const NoContentYet()
            : ListView(
                children: [
                  for (final t in c.texts.values)
                    ListTile(
                      leading: Icon(
                        t.kind == 'external'
                            ? Icons.open_in_new
                            : Icons.article_outlined,
                      ),
                      title: BidiText(t.title),
                      subtitle: BidiText('${t.level} · ${t.source}'),
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
    return StudyTimer(
      activity: Activity.reading,
      child: Scaffold(
        appBar: AppBar(),
        body: AsyncView(
          value: ref.watch(levelContentProvider(packKeyOf(textId))),
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
