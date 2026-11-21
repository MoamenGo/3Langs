import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/content.dart';
import '../../data/models/learner.dart';
import '../../services/language_tool_service.dart';

/// Writing practice: pick a prompt, write in German, get corrections from
/// LanguageTool. Every attempt is saved and synced.
class WritingScreen extends ConsumerStatefulWidget {
  const WritingScreen({super.key});

  @override
  ConsumerState<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends ConsumerState<WritingScreen> {
  final _controller = TextEditingController();
  WritingPrompt? _prompt;
  List<WritingIssue>? _issues;
  bool _busy = false;
  String? _error;

  int get _words => _controller.text.trim().isEmpty
      ? 0
      : _controller.text.trim().split(RegExp(r'\s+')).length;

  Future<void> _check() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final lang = ref.read(explainLangProvider);
      final issues = await ref
          .read(languageToolProvider)
          .check(_controller.text, motherTongue: lang.name);
      await ref
          .read(writingRepositoryProvider)
          .save(
            promptId: _prompt?.id,
            body: _controller.text,
            issues: issues.map((i) => i.toJson()).toList(),
          );
      ref.read(syncServiceProvider).schedule();
      setState(() => _issues = issues);
    } catch (_) {
      setState(() => _error = context.l10n.checkFailed);
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final level = ref.watch(settingsProvider).value?.currentLevel ?? 'A1';
    return StudyTimer(
      activity: Activity.writing,
      child: Scaffold(
        appBar: AppBar(title: Text(l.lessonWriting)),
        body: AsyncView(
          value: ref.watch(levelContentProvider(level)),
          builder: (c) {
            _prompt ??= c.writingPrompts.firstOrNull;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (c.writingPrompts.isNotEmpty)
                  DropdownButton<WritingPrompt>(
                    isExpanded: true,
                    value: _prompt,
                    items: [
                      for (final p in c.writingPrompts)
                        DropdownMenuItem(
                          value: p,
                          child: Text(
                            p.prompt.get(lang),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (p) => setState(() => _prompt = p),
                  ),
                if (_prompt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _prompt!.prompt.get(lang),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: 14,
                  decoration: InputDecoration(hintText: l.typeHere),
                  onChanged: (_) => setState(() {}),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(l.wordCount(_words)),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _busy || _words < 1 ? null : _check,
                  icon: _busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.spellcheck),
                  label: Text(l.writingCheck),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                if (_issues != null) ...[
                  const SizedBox(height: 16),
                  if (_issues!.isEmpty) Text(l.noIssues),
                  for (final issue in _issues!)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.error_outline),
                        title: Text(
                          _controller.text.substring(
                            issue.offset,
                            (issue.offset + issue.length).clamp(
                              0,
                              _controller.text.length,
                            ),
                          ),
                        ),
                        subtitle: Text(issue.message),
                        trailing: issue.replacements.isEmpty
                            ? null
                            : Text(
                                '→ ${issue.replacements.first}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
