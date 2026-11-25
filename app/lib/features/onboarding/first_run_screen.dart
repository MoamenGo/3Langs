// The first screen of a new install: choose the languages to learn before
// anything else. The choice builds the weekly roadmap (Polyglot Matrix
// planner) and switches the guided A0-C1 curriculum on or off per language.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/bidi.dart';
import '../../core/lang/lang.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../data/models/content.dart' show ExplainLang;
import '../../data/models/learner.dart';
import '../polyglot/controller.dart';
import '../polyglot/models.dart';
import '../polyglot/planner.dart';
import '../polyglot/ui.dart' show TrX;
import '../today/today_plan.dart';

/// Whether the first-run language choice is done. Read from the device
/// database before the first frame (see `main.dart`); true in tests.
abstract final class FirstRun {
  static bool done = true;

  /// Meta key, shared with the older welcome flow.
  static const metaKey = 'onboarded';
}

class FirstRunScreen extends ConsumerStatefulWidget {
  const FirstRunScreen({super.key});

  @override
  ConsumerState<FirstRunScreen> createState() => _FirstRunScreenState();
}

class _FirstRunScreenState extends ConsumerState<FirstRunScreen> {
  /// Picked languages, in the order they were picked.
  /// A new install starts with none; reopening from Settings shows the
  /// current choice.
  late final List<String> _picked = [
    if (FirstRun.done) ...ref.read(polyglotProvider).active,
  ];
  late final Map<String, String> _levels = {
    for (final l in ref.read(polyglotProvider).languages)
      l.code: FirstRun.done ? l.level : 'A0',
  };
  late int _minutes = ref.read(polyglotProvider).plan.minutesPerDay;
  late PlanStrategy _strategy = ref.read(polyglotProvider).plan.strategy;
  bool _saving = false;

  void _toggle(String code) => setState(() {
    _picked.contains(code) ? _picked.remove(code) : _picked.add(code);
  });

  PlanConfig get _plan {
    final core = [
      ..._picked.where((c) => Lang.tryParse(c) != null),
      ..._picked.where((c) => Lang.tryParse(c) == null),
    ].take(2).toList();
    return PlanConfig(
      strategy: _picked.length < 3 && _strategy == PlanStrategy.coreLight
          ? PlanStrategy.equal
          : _strategy,
      minutesPerDay: _minutes,
      core: core,
      focus: _picked.isEmpty ? 'de' : _picked.first,
    );
  }

  Future<void> _finish() async {
    if (_picked.isEmpty || _saving) return;
    setState(() => _saving = true);
    final plan = _plan;
    ref
        .read(polyglotProvider.notifier)
        .setupLanguages(active: _picked, levels: _levels, plan: plan);

    // The guided course: on for the picked languages it has, off for the rest.
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final tracks = await ref.read(trackRepositoryProvider).all();
    for (final lang in Lang.values) {
      final t = tracks[lang] ?? LanguageTrack.defaultFor(lang, today);
      final on = _picked.contains(t.lang.name);
      final level = _levels[t.lang.name];
      await ref
          .read(trackRepositoryProvider)
          .save(
            t.copyWith(
              status: on ? TrackStatus.active : TrackStatus.paused,
              startDate: on ? today : null,
              currentLevel: on && cefrLevels.contains(level) ? level : null,
            ),
          );
    }
    final settings = ref.read(currentSettingsProvider);
    if (settings != null) {
      await ref
          .read(settingsRepositoryProvider)
          .save(settings.copyWith(dailyGoalMinutes: _minutes));
    }
    await ref.read(localDbProvider).setMeta(FirstRun.metaKey, true);
    FirstRun.done = true;
    await rebuildTodayPlan(ref);
    ref.read(syncServiceProvider).schedule();
    if (mounted) GoRouter.maybeOf(context)?.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(polyglotProvider);
    final settings = ref.watch(currentSettingsProvider);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= 640;
    final weights = planWeights(_plan, _picked);
    final langMinutes = (_minutes - reviewMinutes).clamp(0, 1000);

    Widget section(int n, String title, [String? hint]) => Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mx.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$n',
              style: t.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BidiText(title, style: t.titleLarge),
                if (hint != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: BidiText(hint, style: t.bodySmall),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                // Header and interface language.
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mx.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.translate_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BidiText(
                        context.tr('Welcome to 3Lang', 'أهلاً بك في 3Lang'),
                        style: t.headlineMedium,
                      ),
                    ),
                    if (settings != null)
                      SegmentedButton<String>(
                        key: const Key('first-run-ui'),
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: 'ar', label: Text('ع')),
                          ButtonSegment(value: 'en', label: Text('EN')),
                        ],
                        selected: {settings.uiLanguage},
                        onSelectionChanged: (v) => ref
                            .read(settingsRepositoryProvider)
                            .save(
                              settings.copyWith(
                                uiLanguage: v.first,
                                explanationLanguage: v.first == 'en'
                                    ? ExplainLang.en
                                    : ExplainLang.ar,
                              ),
                            ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                BidiText(
                  context.tr(
                    'Start by choosing the languages you want to learn. '
                        'Your weekly roadmap and your curriculum are built '
                        'from this choice, and you can change it later.',
                    'ابدأ باختيار اللغات التي تريد تعلمها. خطتك الأسبوعية '
                        'ومنهجك الدراسي يُبنيان على هذا الاختيار، ويمكنك '
                        'تغييره لاحقاً.',
                  ),
                  style: t.bodyLarge?.copyWith(color: mx.muted),
                ),

                // 1. Languages.
                section(
                  1,
                  context.tr(
                    'Which languages do you want to learn?',
                    'ما اللغات التي تريد تعلمها؟',
                  ),
                  context.tr(
                    'Pick one or more. German, Dutch and Spanish come with '
                        'the full A0 to C1 course.',
                    'اختر لغة أو أكثر. الألمانية والهولندية والإسبانية لها '
                        'منهج كامل من A0 إلى C1.',
                  ),
                ),
                LayoutBuilder(
                  builder: (context, c) {
                    final cols = c.maxWidth >= 600 ? 3 : 2;
                    final w = (c.maxWidth - 12 * (cols - 1)) / cols;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final l in s.languages)
                          SizedBox(
                            width: w,
                            child: _LanguageCard(
                              lang: l,
                              selected: _picked.contains(l.code),
                              order: _picked.indexOf(l.code) + 1,
                              hasCourse: Lang.tryParse(l.code) != null,
                              onTap: () => _toggle(l.code),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // 2. Levels.
                if (_picked.isNotEmpty) ...[
                  section(
                    2,
                    context.tr('Your level in each', 'مستواك في كل لغة'),
                    context.tr(
                      'Not sure? Start at A0. You can take a placement '
                          'test later.',
                      'مش متأكد؟ ابدأ من A0، ويمكنك أخذ اختبار تحديد '
                          'المستوى لاحقاً.',
                    ),
                  ),
                  for (final code in _picked)
                    if (s.lang(code) case final l?)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: wide ? 150 : double.infinity,
                              child: BidiText(
                                '${l.flag}  ${context.isAr ? l.nameAr : l.name}',
                                style: t.titleMedium,
                              ),
                            ),
                            for (final lv in cefrLevels)
                              ChoiceChip(
                                key: Key('level-$code-$lv'),
                                showCheckmark: false,
                                label: Text(lv),
                                selected: (_levels[code] ?? 'A0') == lv,
                                onSelected: (_) =>
                                    setState(() => _levels[code] = lv),
                              ),
                          ],
                        ),
                      ),
                ],

                // 3. Daily time and how to share it.
                section(
                  _picked.isEmpty ? 2 : 3,
                  context.tr('Daily study time', 'وقت الدراسة اليومي'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        key: const Key('first-run-minutes'),
                        value: _minutes.toDouble().clamp(30, 240),
                        min: 30,
                        max: 240,
                        divisions: 14,
                        onChanged: (v) => setState(() => _minutes = v.round()),
                      ),
                    ),
                    SizedBox(
                      width: 86,
                      child: BidiText(
                        context.tr('$_minutes min', '$_minutes دقيقة'),
                        style: t.titleMedium,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final st in PlanStrategy.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ChoiceTile(
                      key: Key('strategy-${st.name}'),
                      selected: _strategy == st,
                      title: context.isAr ? st.ar : st.en,
                      subtitle: context.isAr ? st.descAr : st.descEn,
                      onTap: () => setState(() => _strategy = st),
                    ),
                  ),

                // 4. Roadmap preview.
                if (_picked.isNotEmpty) ...[
                  section(
                    _picked.isEmpty ? 3 : 4,
                    context.tr('Your roadmap', 'خطتك'),
                    context.tr(
                      'Minutes a day for each language, plus '
                          '$reviewMinutes minutes of mixed review.',
                      'دقائق كل لغة في اليوم، بالإضافة إلى $reviewMinutes '
                          'دقيقة مراجعة مختلطة.',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: mx.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: mx.rule),
                    ),
                    child: Column(
                      children: [
                        for (final code in _picked)
                          if (s.lang(code) case final l?)
                            _RoadmapRow(
                              lang: l,
                              share: weights[code] ?? 0,
                              minutes: ((weights[code] ?? 0) * langMinutes)
                                  .round(),
                              hasCourse: Lang.tryParse(code) != null,
                            ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),
                FilledButton.icon(
                  key: const Key('finish-first-run'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  onPressed: _picked.isEmpty || _saving ? null : _finish,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.rocket_launch_outlined),
                  label: BidiText(
                    _picked.isEmpty
                        ? context.tr(
                            'Pick at least one language',
                            'اختر لغة واحدة على الأقل',
                          )
                        : context.tr(
                            'Build my plan (${_picked.length})',
                            'ابنِ خطتي (${_picked.length})',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.lang,
    required this.selected,
    required this.order,
    required this.hasCourse,
    required this.onTap,
  });
  final LanguageDef lang;
  final bool selected;
  final int order;
  final bool hasCourse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Frosted(
      radius: 12,
      child: Material(
        color: selected ? mx.primary.withValues(alpha: 0.08) : mx.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? mx.primary : mx.rule,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          key: Key('pick-${lang.code}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(lang.flag, style: const TextStyle(fontSize: 28)),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? mx.primary : Colors.transparent,
                        border: Border.all(
                          color: selected ? mx.primary : mx.muted,
                          width: 1.5,
                        ),
                      ),
                      child: selected
                          ? Text(
                              '$order',
                              style: t.labelMedium?.copyWith(
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BidiText(
                  context.isAr ? lang.nameAr : lang.name,
                  style: t.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                BidiText(
                  lang.nativeName,
                  style: t.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: (hasCourse ? mx.primary : mx.amber).withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BidiText(
                    hasCourse
                        ? context.tr('Full course A0-C1', 'منهج كامل A0-C1')
                        : context.tr('Deck & roadmap', 'بطاقات وخطة'),
                    style: t.labelSmall?.copyWith(
                      color: hasCourse ? mx.primary : mx.ink,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    super.key,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final bool selected;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Material(
      color: selected ? mx.primary.withValues(alpha: 0.08) : mx.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: selected ? mx.primary : mx.rule),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? mx.primary : mx.muted,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BidiText(title, style: t.titleSmall),
                    BidiText(subtitle, style: t.bodySmall),
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

class _RoadmapRow extends StatelessWidget {
  const _RoadmapRow({
    required this.lang,
    required this.share,
    required this.minutes,
    required this.hasCourse,
  });
  final LanguageDef lang;
  final double share;
  final int minutes;
  final bool hasCourse;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: BidiText(
              '${lang.flag}  ${context.isAr ? lang.nameAr : lang.name}',
              style: t.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: share,
                minHeight: 10,
                color: Color(lang.colorValue),
                backgroundColor: mx.surface2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 64,
            child: BidiText(
              context.tr('$minutes min', '$minutes د'),
              style: t.labelLarge,
              textAlign: TextAlign.end,
            ),
          ),
          Icon(
            hasCourse ? Icons.school_outlined : Icons.grid_view_outlined,
            size: 18,
            color: mx.muted,
          ),
        ],
      ),
    );
  }
}
