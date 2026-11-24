import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../data/models/learner.dart';
import '../course/exercises.dart';
import '../today/today_plan.dart';
import '../../core/lang/lang.dart';

/// Spaced-repetition review. Front: the meaning in the explanation language.
/// Back: the German word, audio and example. The learner grades recall and
/// FSRS schedules the next showing.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, this.lang});

  /// Only this language's cards (from the daily plan), or all when null.
  final Lang? lang;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  List<CardState>? _queue;
  int _done = 0;
  bool _revealed = false;
  DateTime _shownAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    var limit = ref.read(settingsProvider).value?.newCardsPerDay ?? 20;
    final lang = widget.lang;
    if (lang != null) {
      final plan = ref.read(todayPlanProvider).value;
      limit = plan?.newCardLimit[lang] ?? limit;
    }
    final cards = await ref
        .read(srsRepositoryProvider)
        .dueCards(newLimit: limit, lang: lang);
    setState(() {
      _queue = cards;
      _shownAt = DateTime.now();
    });
  }

  Future<void> _rate(CardState card, Rating rating) async {
    final updated = await ref
        .read(srsRepositoryProvider)
        .answer(
          card,
          rating,
          durationMs: DateTime.now().difference(_shownAt).inMilliseconds,
        );
    setState(() {
      _queue!.removeAt(0);
      // Cards due again within this session (learning steps) go to the back.
      if (updated.due.isBefore(
        DateTime.now().add(const Duration(minutes: 20)),
      )) {
        _queue!.add(updated);
      }
      _done++;
      _revealed = false;
      _shownAt = DateTime.now();
    });
  }

  String _fmt(Duration d) => d.inDays >= 1
      ? '${d.inDays}d'
      : d.inHours >= 1
      ? '${d.inHours}h'
      : '${d.inMinutes.clamp(1, 59)}m';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = ref.watch(explainLangProvider);
    final all = ref.watch(allContentProvider);
    return StudyTimer(
      activity: Activity.review,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.lang == null
                ? l.flashcards
                : '${l.flashcards} · ${widget.lang!.displayName(ref.watch(uiLanguageProvider))}',
          ),
        ),
        body: AsyncView(
          value: all,
          builder: (levels) {
            if (_queue == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_queue!.isEmpty) {
              return Center(
                child: Text(_done == 0 ? l.reviewEmpty : l.reviewDone),
              );
            }
            final card = _queue!.first;
            final level = levels.firstWhere(
              (c) => c.vocab.containsKey(card.cardId),
              orElse: () => levels.first,
            );
            final item = level.vocab[card.cardId];
            if (item == null) {
              // Content was removed in an update; skip the orphan card.
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => setState(() => _queue!.removeAt(0)),
              );
              return const SizedBox.shrink();
            }
            final preview = ref
                .read(srsRepositoryProvider)
                .fsrs
                .preview(card, DateTime.now());
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${_queue!.length}', textAlign: TextAlign.end),
                      Expanded(
                        child: Center(
                          child: _revealed
                              ? SingleChildScrollView(
                                  child: WordCard(item: item, content: level),
                                )
                              : Text(
                                  item.translations.get(lang),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                      if (!_revealed)
                        FilledButton(
                          onPressed: () {
                            setState(() => _revealed = true);
                            ref.read(ttsProvider).speak(item.display);
                          },
                          child: Text(l.showAnswer),
                        )
                      else
                        Row(
                          children: [
                            for (final (rating, label, color) in [
                              (Rating.again, l.rateAgain, Colors.red),
                              (Rating.hard, l.rateHard, Colors.orange),
                              (Rating.good, l.rateGood, Colors.green),
                              (Rating.easy, l.rateEasy, Colors.blue),
                            ])
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: color,
                                    ),
                                    onPressed: () => _rate(card, rating),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(label),
                                        Text(
                                          _fmt(preview[rating]!),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
