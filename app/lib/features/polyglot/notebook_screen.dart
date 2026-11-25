// 4+ Language Notebook Planner (مذكرة اللغات الأربع فأكثر): the weekly
// plan (strategy, time allocation, daily blocks with tasks to tick off,
// skill balance) and the notebook of entries that link one idea across
// several languages.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'controller.dart';
import 'models.dart';
import 'planner.dart';
import 'ui.dart';

class NotebookScreen extends ConsumerStatefulWidget {
  const NotebookScreen({super.key});

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PolyTopBar(
            title: context.tr('Notebook Planner', 'مذكرة اللغات'),
            subtitle: context.tr(
              '4+ LANGUAGE STUDY NOTEBOOK',
              'مذكرة دراسة أربع لغات فأكثر',
            ),
          ),
          Container(
            color: context.mx.canvas,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SegmentedButton<int>(
                  segments: [
                    ButtonSegment(
                      value: 0,
                      icon: const Icon(Icons.calendar_view_week_outlined),
                      label: Text(
                        context.tr('Weekly planner', 'المخطط الأسبوعي'),
                      ),
                    ),
                    ButtonSegment(
                      value: 1,
                      icon: const Icon(Icons.sticky_note_2_outlined),
                      label: Text(context.tr('Notebook', 'المذكرة')),
                    ),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (v) => setState(() => _tab = v.first),
                ),
              ),
            ),
          ),
          Expanded(child: _tab == 0 ? const _Planner() : const _Notebook()),
        ],
      ),
    );
  }
}

// ================================================================= planner

const _daysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _daysAr = [
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد',
];

String dayName(BuildContext c, int d) => c.isAr ? _daysAr[d] : _daysEn[d];

class _Planner extends ConsumerStatefulWidget {
  const _Planner();

  @override
  ConsumerState<_Planner> createState() => _PlannerState();
}

class _PlannerState extends ConsumerState<_Planner> {
  late int _day = ref.read(polyglotProvider.notifier).todayIndex;
  String? _langFilter;
  Skill? _skillFilter;
  bool _pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(polyglotProvider);
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final planned = s.tasks.fold<int>(0, (a, x) => a + x.minutes);
    final done = s.tasks
        .where((x) => x.done)
        .fold<int>(0, (a, x) => a + x.minutes);
    final monday = DateTime.parse(s.weekStart);
    final sunday = monday.add(const Duration(days: 6));
    String md(DateTime d) => '${d.day}/${d.month}';
    final weekNo =
        ((monday.difference(DateTime(monday.year, 1, 1)).inDays +
                    DateTime(monday.year, 1, 1).weekday -
                    1) /
                7)
            .floor() +
        1;

    final dayTasks = [
      for (final x in s.tasks)
        if (x.day == _day &&
            (_langFilter == null || x.lang == _langFilter || x.lang == '*') &&
            (_skillFilter == null || x.skill == _skillFilter) &&
            (!_pendingOnly || !x.done))
          x,
    ];

    return PageBody(
      maxWidth: 1100,
      children: [
        // ---- week header
        Panel(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(
                context.tr('Weekly atelier ledger', 'سجل الأسبوع'),
                icon: Icons.event_note_outlined,
                trailing: Tag(
                  context.tr('Saved on this device', 'محفوظ على هذا الجهاز'),
                  icon: Icons.check_circle_outline,
                  color: mx.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(
                  'Multi-language study planner',
                  'مخطط دراسة متعدد اللغات',
                ),
                style: t.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(
                  'Week $weekNo · ${md(monday)} – ${md(sunday)} · ${s.active.length} languages',
                  'الأسبوع $weekNo · ${md(monday)} – ${md(sunday)} · ${s.active.length} لغات',
                ),
                style: monoStyle(context, size: 12),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr(
                        'Weekly target progress',
                        'التقدم نحو هدف الأسبوع',
                      ),
                      style: t.labelLarge,
                    ),
                  ),
                  Text(
                    '${(done / 60).toStringAsFixed(1)} / ${(planned / 60).toStringAsFixed(1)} h',
                    textDirection: TextDirection.ltr,
                    style: monoStyle(context, size: 12, color: mx.ink),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: planned == 0 ? 0 : done / planned,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _StrategyCard(state: s),
        const SizedBox(height: 14),
        _AllocationCard(state: s),
        const SizedBox(height: 20),
        // ---- day picker
        SectionLabel(
          context.tr('Schedule & skills', 'الجدول والمهارات'),
          icon: Icons.schedule,
          color: mx.ink,
        ),
        const SizedBox(height: 10),
        ChipRow(
          spacing: 6,
          children: [
            for (var d = 0; d < 7; d++)
              _DayChip(
                label: dayName(context, d),
                date: monday.add(Duration(days: d)).day,
                today: d == ctl.todayIndex,
                selected: d == _day,
                done: s.tasks.where((x) => x.day == d && x.done).length,
                total: s.tasks.where((x) => x.day == d).length,
                onTap: () => setState(() => _day = d),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ChipRow(
          spacing: 6,
          children: [
            FilterPill(
              label: context.tr('All languages', 'كل اللغات'),
              selected: _langFilter == null,
              onTap: () => setState(() => _langFilter = null),
            ),
            for (final l in s.activeLanguages)
              FilterPill(
                label: '${l.flag} ${l.iso3}',
                selected: _langFilter == l.code,
                onTap: () => setState(
                  () => _langFilter = _langFilter == l.code ? null : l.code,
                ),
              ),
            PopupMenuButton<Skill?>(
              tooltip: context.tr('Skill', 'المهارة'),
              onSelected: (v) => setState(() => _skillFilter = v),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: null,
                  child: Text(context.tr('Every skill', 'كل المهارات')),
                ),
                for (final sk in Skill.values)
                  PopupMenuItem(value: sk, child: Text(sk.label(context.ui))),
              ],
              child: IgnorePointer(
                child: FilterPill(
                  label:
                      _skillFilter?.label(context.ui) ??
                      context.tr('Every skill', 'كل المهارات'),
                  icon: Icons.filter_list,
                  selected: _skillFilter != null,
                  onTap: () {},
                ),
              ),
            ),
            FilterPill(
              key: const Key('pending-only'),
              label: context.tr('Pending only', 'غير المنجزة فقط'),
              icon: Icons.radio_button_unchecked,
              selected: _pendingOnly,
              onTap: () => setState(() => _pendingOnly = !_pendingOnly),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (dayTasks.isEmpty)
          Panel(
            child: Text(
              _day >= s.plan.studyDays
                  ? context.tr(
                      'Rest day in your plan. Add a task if you want light practice.',
                      'يوم راحة في خطتك. أضف مهمة إن أردت تدريبًا خفيفًا.',
                    )
                  : context.tr(
                      'No tasks match these filters.',
                      'لا توجد مهام تطابق هذه المرشحات.',
                    ),
              style: t.bodyMedium!.copyWith(color: mx.muted),
            ),
          ),
        for (var slot = 0; slot < 3; slot++)
          if (dayTasks.any((x) => x.slot == slot)) ...[
            _SlotBlock(
              slot: slot,
              tasks: [
                for (final x in dayTasks)
                  if (x.slot == slot) x,
              ],
              state: s,
            ),
            const SizedBox(height: 12),
          ],
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.icon(
            key: const Key('add-task'),
            onPressed: () => showTaskDialog(context, ref, ctl.newTask(_day)),
            icon: const Icon(Icons.add),
            label: Text(
              context.tr(
                'Add task on ${dayName(context, _day)}',
                'إضافة مهمة يوم ${dayName(context, _day)}',
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _SkillBalance(state: s),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.date,
    required this.today,
    required this.selected,
    required this.done,
    required this.total,
    required this.onTap,
  });
  final String label;
  final int date;
  final bool today;
  final bool selected;
  final int done;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final fg = selected ? Colors.white : mx.ink;
    return Material(
      color: selected ? mx.primary : mx.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: today && !selected
              ? mx.amber
              : (selected ? mx.primary : mx.rule),
          width: today ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 74,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium!
                      .copyWith(color: fg),
                ),
                Text(
                  '$date',
                  style: Theme.of(context).textTheme.titleLarge!
                      .copyWith(color: fg, height: 1.2),
                ),
                Text(
                  total == 0 ? '—' : '$done/$total',
                  style: monoStyle(
                    context,
                    size: 10,
                    color: selected ? Colors.white70 : mx.muted,
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

class _StrategyCard extends ConsumerWidget {
  const _StrategyCard({required this.state});
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final cfg = state.plan;
    final t = Theme.of(context).textTheme;
    final mx = context.mx;
    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(
            context.tr('Study plan', 'خطة الدراسة'),
            icon: Icons.route_outlined,
            color: mx.ink,
          ),
          const SizedBox(height: 12),
          ChipRow(
            children: [
              for (final st in PlanStrategy.values)
                FilterPill(
                  key: Key('strategy-${st.name}'),
                  label: st.label(context.ui),
                  selected: cfg.strategy == st,
                  onTap: () => ctl.setPlan(cfg.copyWith(strategy: st)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(cfg.strategy.desc(context.ui), style: t.bodySmall),
          if (cfg.strategy == PlanStrategy.coreLight) ...[
            const SizedBox(height: 12),
            Text(
              context.tr('Core languages', 'اللغات الأساسية'),
              style: t.labelLarge,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final l in state.activeLanguages)
                  FilterChip(
                    label: Text('${l.flag} ${l.displayName(context.ui)}'),
                    selected: cfg.core.contains(l.code),
                    onSelected: (on) => ctl.setPlan(
                      cfg.copyWith(
                        core: on
                            ? [...cfg.core, l.code]
                            : [
                                for (final c in cfg.core)
                                  if (c != l.code) c,
                              ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
          if (cfg.strategy == PlanStrategy.focusSprint) ...[
            const SizedBox(height: 12),
            Text(
              context.tr('Sprint language', 'لغة السباق'),
              style: t.labelLarge,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final l in state.activeLanguages)
                  ChoiceChip(
                    label: Text('${l.flag} ${l.displayName(context.ui)}'),
                    selected: cfg.focus == l.code,
                    onSelected: (_) => ctl.setPlan(cfg.copyWith(focus: l.code)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('Minutes per day', 'دقائق في اليوم'),
                  style: t.labelLarge,
                ),
              ),
              Text(
                '${cfg.minutesPerDay} min',
                style: monoStyle(context, size: 12, color: mx.ink),
              ),
            ],
          ),
          Slider(
            value: cfg.minutesPerDay.toDouble().clamp(30, 240),
            min: 30,
            max: 240,
            divisions: 14,
            label: '${cfg.minutesPerDay}',
            onChanged: (v) =>
                ctl.setPlan(cfg.copyWith(minutesPerDay: v.round())),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                context.tr('Study days per week', 'أيام الدراسة في الأسبوع'),
                style: t.labelLarge,
              ),
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (final d in [4, 5, 6, 7])
                    ButtonSegment(value: d, label: Text('$d')),
                ],
                selected: {cfg.studyDays.clamp(4, 7)},
                onSelectionChanged: (v) =>
                    ctl.setPlan(cfg.copyWith(studyDays: v.first)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              'Changing the plan rebuilds this week’s schedule; your own tasks stay. Close pairs (German/Dutch, Spanish/French) are kept in different blocks to limit mix-ups.',
              'تغيير الخطة يعيد بناء جدول الأسبوع وتبقى مهامك الخاصة. اللغات المتقاربة (الألمانية/الهولندية، الإسبانية/الفرنسية) توضع في فترات مختلفة لتقليل الخلط.',
            ),
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({required this.state});
  final PolyglotState state;

  @override
  Widget build(BuildContext context) {
    final weights = planWeights(state.plan, state.active);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final langs = state.activeLanguages;
    final weekly = {
      for (final l in langs)
        l.code: state.tasks
            .where((x) => x.lang == l.code)
            .fold<int>(0, (a, x) => a + x.minutes),
    };
    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(
            context.tr('Active weight allocation', 'توزيع الوقت على اللغات'),
            icon: Icons.donut_large_outlined,
            color: mx.ink,
            trailing: Text(
              context.tr(
                '${langs.length} target matrix',
                '${langs.length} لغات',
              ),
              style: monoStyle(context),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  for (final l in langs)
                    Expanded(
                      flex: ((weights[l.code] ?? 0) * 1000).round().clamp(
                        1,
                        1000,
                      ),
                      child: Container(color: langColor(l)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              final cols = (c.maxWidth / 200).floor().clamp(1, 5);
              final w = (c.maxWidth - 8 * (cols - 1)) / cols;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final l in langs)
                    SizedBox(
                      width: w,
                      child: Inset(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 28,
                              color: langColor(l),
                            ),
                            const SizedBox(width: 8),
                            Text(l.flag),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${l.iso3} · ${((weights[l.code] ?? 0) * 100).round()}%',
                                style: monoStyle(
                                  context,
                                  size: 11.5,
                                  color: mx.ink,
                                ),
                              ),
                            ),
                            Text(
                              '${((weekly[l.code] ?? 0) / 60).toStringAsFixed(1)}h',
                              style: t.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SlotBlock extends ConsumerWidget {
  const _SlotBlock({
    required this.slot,
    required this.tasks,
    required this.state,
  });
  final int slot;
  final List<StudyTask> tasks;
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final minutes = tasks.fold<int>(0, (a, x) => a + x.minutes);
    final allDone = tasks.every((x) => x.done);
    final (name, focus) = switch (slot) {
      0 => (
        context.tr('Morning block', 'فترة الصباح'),
        context.tr(
          'Focus: receptive input (listening, reading)',
          'التركيز: الاستقبال (استماع وقراءة)',
        ),
      ),
      1 => (
        context.tr('Afternoon block', 'فترة الظهيرة'),
        context.tr(
          'Focus: production (speaking, writing, grammar)',
          'التركيز: الإنتاج (تحدث وكتابة وقواعد)',
        ),
      ),
      _ => (
        context.tr('Evening synthesis', 'مراجعة المساء'),
        context.tr(
          'Focus: spaced review across all languages',
          'التركيز: مراجعة متباعدة لكل اللغات',
        ),
      ),
    };
    return Panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: mx.surface2,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '0${slot + 1}',
                  style: monoStyle(context, color: mx.ink),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text('$name ($minutes min)', style: t.titleMedium),
              ),
              Tag(
                allDone
                    ? context.tr('Completed', 'مكتملة')
                    : context.tr('Open', 'مفتوحة'),
                icon: allDone ? Icons.done_all : Icons.pending_outlined,
                color: allDone ? mx.primary : mx.amber,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(focus, style: t.labelSmall),
          const SizedBox(height: 8),
          for (final x in tasks) _TaskTile(task: x, state: state),
        ],
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task, required this.state});
  final StudyTask task;
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final l = state.lang(task.lang);
    final name = task.lang == '*'
        ? context.tr('All languages', 'كل اللغات')
        : (l?.displayName(context.ui) ?? task.lang);
    final flag = task.lang == '*'
        ? state.activeLanguages.map((x) => x.flag).join()
        : (l?.flag ?? '');
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Inset(
        color: task.done ? mx.primary.withValues(alpha: 0.06) : null,
        padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              key: Key('task-${task.id}'),
              value: task.done,
              onChanged: (_) => ctl.toggleTask(task.id),
            ),
            Expanded(
              child: InkWell(
                onTap: () => showTaskDialog(context, ref, task),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '$flag  $name · ${task.minutes} min',
                              overflow: TextOverflow.ellipsis,
                              style: t.titleSmall,
                            ),
                          ),
                          if (task.done) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: mx.primary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        taskTitle(task, name, context.ui),
                        style: t.bodyMedium!.copyWith(
                          decoration: task.done
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.done ? mx.muted : mx.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [
                          Tag(
                            task.skill.label(context.ui),
                            icon: skillIcon(task.skill),
                            color: mx.primary,
                          ),
                          if (task.custom)
                            Tag(
                              context.tr('my task', 'مهمتي'),
                              color: mx.amber,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: context.tr('Edit', 'تعديل'),
              onPressed: () => showTaskDialog(context, ref, task),
              icon: const Icon(Icons.edit_outlined, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTaskDialog(
  BuildContext context,
  WidgetRef ref,
  StudyTask task,
) async {
  final s = ref.read(polyglotProvider);
  final ctl = ref.read(polyglotProvider.notifier);
  final exists = s.tasks.any((x) => x.id == task.id);
  final l = s.lang(task.lang);
  final title = TextEditingController(
    text: task.title.isNotEmpty
        ? task.title
        : (exists
              ? taskTitle(task, l?.displayName(context.ui) ?? '', context.ui)
              : ''),
  );
  var lang = task.lang;
  var skill = task.skill;
  var minutes = task.minutes;
  var day = task.day;
  var slot = task.slot;
  await showDialog<void>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(
          exists
              ? c.tr('Edit task', 'تعديل المهمة')
              : c.tr('New task', 'مهمة جديدة'),
        ),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                field(
                  title,
                  c.tr('What to do', 'ماذا ستفعل'),
                  maxLines: 2,
                  key: const Key('task-title'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: lang,
                  decoration: InputDecoration(
                    labelText: c.tr('Language', 'اللغة'),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '*',
                      child: Text(c.tr('All languages', 'كل اللغات')),
                    ),
                    for (final x in s.activeLanguages)
                      DropdownMenuItem(
                        value: x.code,
                        child: Text('${x.flag} ${x.displayName(c.ui)}'),
                      ),
                    if (lang != '*' && !s.active.contains(lang))
                      DropdownMenuItem(value: lang, child: Text(lang)),
                  ],
                  onChanged: (v) => setState(() => lang = v ?? lang),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Skill>(
                  initialValue: skill,
                  decoration: InputDecoration(
                    labelText: c.tr('Skill', 'المهارة'),
                  ),
                  items: [
                    for (final sk in Skill.values)
                      DropdownMenuItem(value: sk, child: Text(sk.label(c.ui))),
                  ],
                  onChanged: (v) => setState(() => skill = v ?? skill),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: day,
                        decoration: InputDecoration(
                          labelText: c.tr('Day', 'اليوم'),
                        ),
                        items: [
                          for (var d = 0; d < 7; d++)
                            DropdownMenuItem(
                              value: d,
                              child: Text(dayName(c, d)),
                            ),
                        ],
                        onChanged: (v) => setState(() => day = v ?? day),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: slot,
                        decoration: InputDecoration(
                          labelText: c.tr('Block', 'الفترة'),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(c.tr('Morning', 'صباح')),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(c.tr('Afternoon', 'ظهيرة')),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(c.tr('Evening', 'مساء')),
                          ),
                        ],
                        onChanged: (v) => setState(() => slot = v ?? slot),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(c.tr('Minutes', 'الدقائق')),
                    Expanded(
                      child: Slider(
                        value: minutes.toDouble().clamp(5, 120),
                        min: 5,
                        max: 120,
                        divisions: 23,
                        label: '$minutes',
                        onChanged: (v) => setState(() => minutes = v.round()),
                      ),
                    ),
                    Text('$minutes', style: monoStyle(c, size: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (exists)
            TextButton(
              onPressed: () {
                ctl.deleteTask(task.id);
                Navigator.pop(c);
              },
              child: Text(
                c.tr('Delete', 'حذف'),
                style: TextStyle(color: Theme.of(c).colorScheme.error),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(c.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            key: const Key('task-save'),
            onPressed: () {
              final changedTitle = title.text.trim();
              final generated = taskTitle(
                task,
                l?.displayName(c.ui) ?? '',
                c.ui,
              );
              ctl.saveTask(
                task.copyWith(
                  lang: lang,
                  skill: skill,
                  minutes: minutes,
                  day: day,
                  slot: slot,
                  // Keep generated titles translatable unless the learner
                  // wrote their own.
                  title: changedTitle == generated && !task.custom
                      ? ''
                      : changedTitle,
                ),
              );
              Navigator.pop(c);
            },
            child: Text(c.tr('Save', 'حفظ')),
          ),
        ],
      ),
    ),
  );
}

/// Checkpoints across all skills: minutes planned per language and skill
/// this week, and how much of it is done.
class _SkillBalance extends StatelessWidget {
  const _SkillBalance({required this.state});
  final PolyglotState state;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final langs = state.activeLanguages;
    final skills = [
      for (final s in Skill.values)
        if (s != Skill.review) s,
    ];
    (int, int) cell(String lang, Skill sk) {
      var planned = 0, done = 0;
      for (final x in state.tasks) {
        if (x.lang == lang && x.skill == sk) {
          planned += x.minutes;
          if (x.done) done += x.minutes;
        }
      }
      return (done, planned);
    }

    final review = state.tasks.where((x) => x.skill == Skill.review);
    final reviewDone = review.where((x) => x.done).length;
    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(
            context.tr('Skill balance matrix', 'مصفوفة توازن المهارات'),
            icon: Icons.grid_on_outlined,
            color: mx.ink,
          ),
          const SizedBox(height: 4),
          Text(
            context.tr(
              'Minutes planned this week per language and skill. Gaps (—) show what the week is missing.',
              'الدقائق المخططة هذا الأسبوع لكل لغة ومهارة. الفراغات (—) تُظهر ما ينقص الأسبوع.',
            ),
            style: t.bodySmall,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(78),
              columnWidths: const {0: FixedColumnWidth(150)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: mx.rule)),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        context.tr('SKILL', 'المهارة'),
                        style: t.labelSmall,
                      ),
                    ),
                    for (final l in langs)
                      Center(
                        child: Text(
                          '${l.flag} ${l.iso3}',
                          style: monoStyle(context, size: 10.5),
                        ),
                      ),
                  ],
                ),
                for (final sk in skills)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(skillIcon(sk), size: 16, color: mx.muted),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                sk.label(context.ui),
                                style: t.labelLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (final l in langs)
                        Builder(
                          builder: (context) {
                            final (done, planned) = cell(l.code, sk);
                            if (planned == 0) {
                              return Center(
                                child: Text('—', style: t.bodySmall),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$planned′',
                                    style: monoStyle(
                                      context,
                                      size: 11,
                                      color: mx.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      minHeight: 4,
                                      value: done / planned,
                                      color: langColor(l),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(skillIcon(Skill.review), size: 16, color: mx.amber),
              const SizedBox(width: 6),
              Text(
                context.tr(
                  'Spaced review sessions: $reviewDone / ${review.length} done',
                  'جلسات المراجعة المتباعدة: $reviewDone / ${review.length} منجزة',
                ),
                style: t.labelLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================================================================ notebook

class _Notebook extends ConsumerStatefulWidget {
  const _Notebook();

  @override
  ConsumerState<_Notebook> createState() => _NotebookState();
}

class _NotebookState extends ConsumerState<_Notebook> {
  final _q = TextEditingController();
  String? _lang;
  Skill? _skill;
  String? _tag;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(polyglotProvider);
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final q = _q.text.trim().toLowerCase();
    final notes = [
      for (final n in s.notes)
        if ((_lang == null || (n.perLang[_lang]?.isNotEmpty ?? false)) &&
            (_skill == null || n.skill == _skill) &&
            (_tag == null || n.tags.contains(_tag)) &&
            (q.isEmpty ||
                [
                  n.title,
                  n.body,
                  ...n.perLang.values,
                  ...n.tags,
                ].join(' ').toLowerCase().contains(q)))
          n,
    ];
    final tags = {for (final n in s.notes) ...n.tags}.toList()..sort();
    return PageBody(
      maxWidth: 1000,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _q,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: context.tr(
                    'Search your notebook',
                    'ابحث في مذكرتك',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              key: const Key('new-note'),
              onPressed: () => showNoteEditor(context, ref, ctl.newNote()),
              icon: const Icon(Icons.add),
              label: Text(context.tr('New entry', 'مدخل جديد')),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ChipRow(
          spacing: 6,
          children: [
            FilterPill(
              label: context.tr('All', 'الكل'),
              selected: _lang == null,
              onTap: () => setState(() => _lang = null),
            ),
            for (final l in s.activeLanguages)
              FilterPill(
                label: '${l.flag} ${l.iso3}',
                selected: _lang == l.code,
                onTap: () =>
                    setState(() => _lang = _lang == l.code ? null : l.code),
              ),
            for (final sk in [
              Skill.grammar,
              Skill.vocabulary,
              Skill.pronunciation,
              Skill.listening,
              Skill.speaking,
              Skill.reading,
              Skill.writing,
              Skill.culture,
            ])
              FilterPill(
                label: sk.label(context.ui),
                icon: skillIcon(sk),
                selected: _skill == sk,
                onTap: () => setState(() => _skill = _skill == sk ? null : sk),
              ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          ChipRow(
            spacing: 6,
            children: [
              for (final t in tags)
                Tag(
                  '#$t',
                  color: _tag == t ? mx.primary : mx.muted,
                  filled: _tag == t,
                  onTap: () => setState(() => _tag = _tag == t ? null : t),
                ),
            ],
          ),
        ],
        const SizedBox(height: 14),
        if (notes.isEmpty)
          Panel(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.sticky_note_2_outlined, size: 36, color: mx.muted),
                const SizedBox(height: 8),
                Text(
                  context.tr(
                    'No entries here yet. Pin a concept from the Matrix or start a new entry.',
                    'لا توجد مدخلات بعد. ثبّت مفهومًا من المصفوفة أو ابدأ مدخلًا جديدًا.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        for (final n in notes) ...[
          _NoteCard(note: n, state: s),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _NoteCard extends ConsumerWidget {
  const _NoteCard({required this.note, required this.state});
  final NoteEntry note;
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Panel(
      key: Key('note-${note.id}'),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title.isEmpty
                          ? context.tr('Untitled', 'بلا عنوان')
                          : note.title,
                      style: t.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Tag(
                          note.skill.label(context.ui),
                          icon: skillIcon(note.skill),
                          color: mx.primary,
                        ),
                        for (final tg in note.tags) Tag('#$tg'),
                        Text(
                          dayKey(note.created),
                          style: monoStyle(context, size: 10.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') showNoteEditor(context, ref, note);
                  if (v == 'delete') ctl.deleteNote(note.id);
                  if (v == 'concept' && note.conceptId != null) {
                    ctl.showConcept(note.conceptId!);
                    context.go('/');
                  }
                  if (v == 'link') openLink(context, note.link);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(context.tr('Edit', 'تعديل')),
                  ),
                  if (note.conceptId != null)
                    PopupMenuItem(
                      value: 'concept',
                      child: Text(
                        context.tr('Open in the Matrix', 'فتح في المصفوفة'),
                      ),
                    ),
                  if (note.link.isNotEmpty)
                    PopupMenuItem(
                      value: 'link',
                      child: Text(context.tr('Open link', 'فتح الرابط')),
                    ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(context.tr('Delete', 'حذف')),
                  ),
                ],
              ),
            ],
          ),
          if (note.body.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Text(note.body, style: t.bodyMedium),
            ),
          ],
          if (note.perLang.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Inset(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final e in note.perLang.entries)
                      if (e.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 64,
                                child: Text(
                                  '${state.lang(e.key)?.flag ?? ''} ${state.lang(e.key)?.iso3 ?? e.key.toUpperCase()}',
                                  style: monoStyle(context, size: 10.5),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.value,
                                  textDirection: dirOf(state.lang(e.key)),
                                  style: t.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
          if (note.link.isNotEmpty)
            TextButton.icon(
              onPressed: () => openLink(context, note.link),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text(Uri.tryParse(note.link)?.host ?? note.link),
            ),
        ],
      ),
    );
  }
}

Future<void> showNoteEditor(
  BuildContext context,
  WidgetRef ref,
  NoteEntry note,
) async {
  final s = ref.read(polyglotProvider);
  final title = TextEditingController(text: note.title);
  final body = TextEditingController(text: note.body);
  final tags = TextEditingController(text: note.tags.join(', '));
  final link = TextEditingController(text: note.link);
  final langs = {
    ...{for (final l in s.active) l: ''},
    ...note.perLang,
  };
  final perLang = {
    for (final e in langs.entries) e.key: TextEditingController(text: e.value),
  };
  var skill = note.skill;
  await showDialog<void>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(c.tr('Notebook entry', 'مدخل المذكرة')),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                field(
                  title,
                  c.tr('Title', 'العنوان'),
                  key: const Key('note-title'),
                ),
                field(
                  body,
                  c.tr(
                    'Note (rule, insight, mnemonic)',
                    'الملاحظة (قاعدة، فكرة، وسيلة تذكر)',
                  ),
                  maxLines: 4,
                  key: const Key('note-body'),
                ),
                DropdownButtonFormField<Skill>(
                  initialValue: skill,
                  decoration: InputDecoration(
                    labelText: c.tr('Skill', 'المهارة'),
                  ),
                  items: [
                    for (final sk in Skill.values)
                      DropdownMenuItem(value: sk, child: Text(sk.label(c.ui))),
                  ],
                  onChanged: (v) => setState(() => skill = v ?? skill),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    c.tr(
                      'The same idea in each language',
                      'الفكرة نفسها في كل لغة',
                    ),
                    style: Theme.of(c).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 8),
                for (final e in perLang.entries)
                  field(
                    e.value,
                    '${s.lang(e.key)?.flag ?? ''} ${s.lang(e.key)?.displayName(c.ui) ?? e.key}',
                    dir: dirOf(s.lang(e.key)),
                  ),
                field(
                  tags,
                  c.tr('Tags (comma separated)', 'وسوم (مفصولة بفواصل)'),
                ),
                field(
                  link,
                  c.tr('Resource link (optional)', 'رابط مصدر (اختياري)'),
                  dir: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(c.tr('Cancel', 'إلغاء')),
          ),
          FilledButton(
            key: const Key('note-save'),
            onPressed: () {
              ref
                  .read(polyglotProvider.notifier)
                  .saveNote(
                    NoteEntry(
                      id: note.id,
                      title: title.text.trim(),
                      body: body.text.trim(),
                      created: note.created,
                      conceptId: note.conceptId,
                      perLang: {
                        for (final e in perLang.entries)
                          if (e.value.text.trim().isNotEmpty)
                            e.key: e.value.text.trim(),
                      },
                      tags: [
                        for (final t in tags.text.split(','))
                          if (t.trim().isNotEmpty) t.trim(),
                      ],
                      skill: skill,
                      link: link.text.trim(),
                    ),
                  );
              Navigator.pop(c);
            },
            child: Text(c.tr('Save', 'حفظ')),
          ),
        ],
      ),
    ),
  );
}
