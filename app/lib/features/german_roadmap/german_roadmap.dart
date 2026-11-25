// The German roadmap follows Piece of German (pieceofgerman.com), a free
// week-by-week plan by Ahmed Essam with Arabic notes and curated videos from
// other creators. We keep only its outline (levels, weeks, links) and the
// learner's own ticks; each week opens the author's page inside the app, so
// the notes, videos and PDFs stay theirs and up to date.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/bidi.dart';
import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../data/models/learner.dart';
import '../polyglot/ui.dart' show TrX;

const _host = 'www.pieceofgerman.com';

/// One level of the plan as the site publishes it.
class PogLevel {
  const PogLevel(
    this.id,
    this.titleEn,
    this.titleAr,
    this.weeks, {
    this.planned,
    this.unit = 'week',
    this.exam = false,
  });
  final String id;
  final String titleEn, titleAr;

  /// Weeks (or lessons) online now.
  final int weeks;

  /// Total the author plans, when the level is still being written.
  final int? planned;

  /// `week` or `lesson`, as in the site's addresses.
  final String unit;

  /// A1 ends with an exam week.
  final bool exam;

  bool get complete => planned == null;

  List<PogWeek> get items => [
    for (var i = 1; i <= weeks; i++) PogWeek(this, i),
    if (exam) PogWeek(this, 0),
  ];
}

/// One week (or lesson) page. Number 0 is the exam week.
class PogWeek {
  const PogWeek(this.level, this.number);
  final PogLevel level;
  final int number;

  String get id => '${level.id}.${number == 0 ? 'exam' : number}';

  Uri get url => Uri.https(
    _host,
    number == 0
        ? '/${level.id}/exam-week'
        : '/${level.id}/${level.unit}-$number',
  );

  String label(BuildContext context) {
    if (number == 0) return context.tr('Exam week', 'أسبوع الامتحان');
    return level.unit == 'lesson'
        ? context.tr('Lesson $number', 'الدرس $number')
        : context.tr('Week $number', 'الأسبوع $number');
  }
}

/// The outline of pieceofgerman.com/roadmap (checked 2026-11-25).
const pogLevels = [
  PogLevel(
    'a1',
    'From sounds to your first conversations',
    'من الأصوات إلى أول محادثاتك',
    12,
    exam: true,
  ),
  PogLevel(
    'a2',
    'German in everyday situations',
    'الألمانية في مواقف الحياة اليومية',
    12,
  ),
  PogLevel('b1', 'Independent German', 'ألمانية مستقلة', 3, planned: 16),
  PogLevel(
    'b2',
    'Fluent, detailed German',
    'ألمانية طليقة ومفصّلة',
    2,
    planned: 11,
    unit: 'lesson',
  ),
  PogLevel(
    'c1',
    'Advanced German',
    'ألمانية متقدمة',
    2,
    planned: 18,
    unit: 'lesson',
  ),
];

final pogRoadmapUrl = Uri.https(_host, '/roadmap');

/// Ids of the weeks the learner ticked as done (kept on this device).
final pogDoneProvider = StreamProvider<Set<String>>(
  (ref) => ref
      .watch(localDbProvider)
      .watchMeta('pog_done')
      .map((v) => {...((v as List?) ?? const []).cast<String>()}),
);

Future<void> setPogDone(WidgetRef ref, String id, bool done) async {
  final db = ref.read(localDbProvider);
  final now = {
    ...((await db.getMeta<List>('pog_done')) ?? const []).cast<String>(),
  };
  done ? now.add(id) : now.remove(id);
  await db.setMeta('pog_done', now.toList()..sort());
}

/// The site level that matches a course level (A0 starts in A1 week 1).
String pogLevelFor(String cefr) => switch (cefr) {
  'A0' || 'A1' => 'a1',
  'A2' => 'a2',
  'B1' => 'b1',
  'B2' => 'b2',
  _ => 'c1',
};

/// The first week not ticked yet, from the learner's German level on.
PogWeek? nextPogWeek(String cefr, Set<String> done) {
  final start = pogLevels.indexWhere((l) => l.id == pogLevelFor(cefr));
  for (final level in pogLevels.skip(start < 0 ? 0 : start)) {
    for (final w in level.items) {
      if (!done.contains(w.id)) return w;
    }
  }
  return null;
}

/// Opens a page of the plan inside the app (a Custom Tab on Android, a new
/// tab on the web). Its videos play there.
Future<void> openPog(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class GermanRoadmapScreen extends ConsumerWidget {
  const GermanRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final done = ref.watch(pogDoneProvider).value ?? const <String>{};
    final track =
        ref.watch(tracksProvider).value?[Lang.de] ??
        LanguageTrack.defaultFor(Lang.de, DateTime.now().toUtc());
    final next = nextPogWeek(track.currentLevel, done);
    final total = [for (final l in pogLevels) ...l.items].length;

    return Scaffold(
      appBar: AppBar(
        title: BidiText(context.tr('German roadmap', 'خطة الألماني')),
        actions: [
          IconButton(
            tooltip: context.tr('Open the site', 'افتح الموقع'),
            onPressed: () => openPog(pogRoadmapUrl),
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              BidiText(
                context.tr(
                  'Your German plan follows Piece of German by Ahmed Essam: '
                      'a free week-by-week path with Arabic notes and the '
                      'best free videos. Each week opens inside the app.',
                  'خطة الألماني عندك ماشية على Piece of German لأحمد عصام: '
                      'مسار مجاني أسبوع بأسبوع بملاحظات بالعربي وأفضل '
                      'الفيديوهات المجانية. كل أسبوع بيفتح جوه التطبيق.',
                ),
                style: t.bodyMedium?.copyWith(color: mx.muted),
              ),
              const SizedBox(height: 16),
              if (next != null)
                _ThisWeek(week: next, done: done.length, total: total),
              const SizedBox(height: 8),
              for (final level in pogLevels)
                _LevelSection(
                  level: level,
                  done: done,
                  current: next?.id,
                  expanded: level.id == next?.level.id,
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: mx.amber.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.download_outlined, color: mx.ink, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BidiText(
                        context.tr(
                          'Offline: the videos belong to their YouTube '
                              'creators, so 3Lang cannot save them. Use the '
                              'Download button in the YouTube app where it is '
                              'offered. PDFs and word lists open from the week '
                              'page and can be saved from there.',
                          'بدون إنترنت: الفيديوهات ملك أصحاب قنواتها على '
                              'يوتيوب، فـ3Lang مش بيقدر يحفظها. استخدم زر '
                              'التنزيل في تطبيق يوتيوب لو متاح. ملفات PDF '
                              'وقوائم الكلمات بتفتح من صفحة الأسبوع وتقدر '
                              'تحفظها من هناك.',
                        ),
                        style: t.bodySmall?.copyWith(color: mx.ink),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThisWeek extends ConsumerWidget {
  const _ThisWeek({
    required this.week,
    required this.done,
    required this.total,
  });
  final PogWeek week;
  final int done, total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Container(
      key: const Key('pog-this-week'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: mx.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BidiText(
            context.tr('Up next', 'التالي عليك'),
            style: t.labelLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          BidiText(
            '${week.level.id.toUpperCase()} · ${week.label(context)}',
            style: t.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 6,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(height: 6),
          BidiText(
            context.tr('$done of $total weeks done', '$done من $total أسبوع'),
            style: t.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                key: const Key('pog-open-next'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: mx.primary,
                ),
                onPressed: () => openPog(week.url),
                icon: const Icon(Icons.play_circle_outline),
                label: BidiText(context.tr('Open this week', 'افتح الأسبوع')),
              ),
              OutlinedButton.icon(
                key: const Key('pog-mark-next'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.white70),
                ),
                onPressed: () => setPogDone(ref, week.id, true),
                icon: const Icon(Icons.check),
                label: BidiText(context.tr('Mark as done', 'خلصته')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelSection extends ConsumerWidget {
  const _LevelSection({
    required this.level,
    required this.done,
    required this.current,
    required this.expanded,
  });
  final PogLevel level;
  final Set<String> done;
  final String? current;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final items = level.items;
    final ticked = items.where((w) => done.contains(w.id)).length;
    return Card(
      child: ExpansionTile(
        key: PageStorageKey('pog-${level.id}'),
        initiallyExpanded: expanded,
        leading: CircleAvatar(
          backgroundColor: mx.primary.withValues(alpha: 0.12),
          foregroundColor: mx.primary,
          child: Text(level.id.toUpperCase()),
        ),
        title: BidiText(context.tr(level.titleEn, level.titleAr)),
        subtitle: BidiText(
          level.complete
              ? context.tr(
                  '$ticked of ${items.length} done',
                  '$ticked من ${items.length} خلصت',
                )
              : context.tr(
                  '$ticked of ${items.length} done · ${level.weeks} of '
                      '${level.planned} online so far',
                  '$ticked من ${items.length} خلصت · منشور ${level.weeks} '
                      'من ${level.planned} لحد دلوقتي',
                ),
          style: t.bodySmall,
        ),
        children: [
          for (final w in items)
            ListTile(
              key: Key('pog-${w.id}'),
              dense: true,
              selected: w.id == current,
              leading: Checkbox(
                value: done.contains(w.id),
                onChanged: (v) => setPogDone(ref, w.id, v ?? false),
              ),
              title: BidiText(w.label(context)),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => openPog(w.url),
            ),
        ],
      ),
    );
  }
}

/// Entry card on the German course page.
class GermanRoadmapCard extends ConsumerWidget {
  const GermanRoadmapCard({super.key, required this.onOpen});
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mx = context.mx;
    final done = ref.watch(pogDoneProvider).value ?? const <String>{};
    final track =
        ref.watch(tracksProvider).value?[Lang.de] ??
        LanguageTrack.defaultFor(Lang.de, DateTime.now().toUtc());
    final next = nextPogWeek(track.currentLevel, done);
    return Card(
      key: const Key('german-roadmap-card'),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: mx.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.route_outlined),
        ),
        title: BidiText(
          context.tr(
            'German roadmap · Piece of German',
            'خطة الألماني · Piece of German',
          ),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: BidiText(
          next == null
              ? context.tr('All weeks done!', 'خلصت كل الأسابيع!')
              : context.tr(
                  'Up next: ${next.level.id.toUpperCase()} ${next.label(context)}',
                  'التالي: ${next.level.id.toUpperCase()} ${next.label(context)}',
                ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onOpen,
      ),
    );
  }
}
