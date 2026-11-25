// Default landing view: the Simultaneous Multi-Language Hub. One concept is
// shown side by side in every active language ("Parallel Concept Deck"),
// with a learning-method switcher, a practice strip and the free resources
// drawer.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import 'controller.dart';
import 'language_dialogs.dart';
import 'models.dart';
import 'resources_screen.dart' show showResourcesDrawer;
import 'ui.dart';

class MatrixHubScreen extends ConsumerWidget {
  const MatrixHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(polyglotProvider);
    final ctl = ref.read(polyglotProvider.notifier);
    final deck = ctl.deck;
    final concept = deck.isEmpty
        ? null
        : deck[s.conceptIndex.clamp(0, deck.length - 1)];
    final langs = s.activeLanguages;
    return Scaffold(
      body: Column(
        children: [
          PolyTopBar(
            title: 'Polyglot Matrix',
            subtitle: context.tr(
              'SIMULTANEOUS MULTI-LANGUAGE HUB',
              'مركز تعلم اللغات المتزامن',
            ),
          ),
          Expanded(
            child: PageBody(
              children: [
                _LanguageLayers(state: s),
                const SizedBox(height: 16),
                _ModeSwitcher(current: s.aspect),
                const SizedBox(height: 16),
                if (concept == null)
                  Panel(
                    child: Text(
                      context.tr(
                        'No concepts for this method yet.',
                        'لا توجد مفاهيم لهذه الطريقة بعد.',
                      ),
                    ),
                  )
                else ...[
                  _ConceptHeader(
                    concept: concept,
                    index: s.conceptIndex.clamp(0, deck.length - 1),
                    total: deck.length,
                  ),
                  const SizedBox(height: 20),
                  SectionLabel(
                    context.tr(
                      'Comparative matrix cards',
                      'بطاقات المقارنة المتوازية',
                    ),
                    icon: Icons.view_column_outlined,
                    color: context.mx.ink,
                    trailing: Text(
                      context.tr(
                        '${langs.where((l) => concept.lines[l.code] != null).length} of ${langs.length} linked',
                        '${langs.where((l) => concept.lines[l.code] != null).length} من ${langs.length} مرتبطة',
                      ),
                      style: monoStyle(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ParallelDeck(concept: concept, langs: langs, mode: s.aspect),
                  const SizedBox(height: 20),
                  _PracticeStrip(
                    concept: concept,
                    langs: langs,
                    mode: s.aspect,
                  ),
                  const SizedBox(height: 16),
                  _SynthesisPrompt(concept: concept),
                  const SizedBox(height: 16),
                  _ResourcesTrigger(langs: langs, aspect: concept.aspect),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Synchronized matrix layers": language pills to switch languages on and
/// off, plus adding custom languages.
class _LanguageLayers extends ConsumerWidget {
  const _LanguageLayers({required this.state});
  final PolyglotState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final n = state.active.length;
    final mx = context.mx;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          context.tr(
            'Synchronized matrix layers ($n active)',
            'طبقات المصفوفة المتزامنة ($n مفعّلة)',
          ),
          icon: Icons.layers_outlined,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: mx.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              n >= 4
                  ? context.tr('Polyglot ×$n', 'متعدد ×$n')
                  : context.tr(
                      'Add ${4 - n} more for 4+',
                      'أضف ${4 - n} للوصول إلى 4+',
                    ),
              style: monoStyle(context, size: 10.5, color: mx.primary),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ChipRow(
          children: [
            for (final l in state.languages)
              LangChip(
                lang: l,
                selected: state.active.contains(l.code),
                showLevel: true,
                onTap: () => ctl.toggleLanguage(l.code),
              ),
            Material(
              color: mx.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: mx.rule),
              ),
              child: InkWell(
                key: const Key('add-language'),
                onTap: () => showAddLanguageDialog(context, ref),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: mx.primary),
                      const SizedBox(width: 4),
                      Text(
                        context.tr('Add language', 'إضافة لغة'),
                        style: Theme.of(context).textTheme.labelLarge!
                            .copyWith(color: mx.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: context.tr(
                'Manage languages & levels',
                'إدارة اللغات والمستويات',
              ),
              onPressed: () => showManageLanguages(context, ref),
              icon: const Icon(Icons.tune),
            ),
          ],
        ),
      ],
    );
  }
}

/// Learning method switcher (the seven aspects).
class _ModeSwitcher extends ConsumerWidget {
  const _ModeSwitcher({required this.current});
  final Aspect? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final concepts = ref.watch(polyglotProvider).concepts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          context.tr('Learning method', 'طريقة التعلم'),
          icon: Icons.tune_outlined,
          color: context.mx.muted,
        ),
        const SizedBox(height: 10),
        ChipRow(
          children: [
            FilterPill(
              key: const Key('mode-all'),
              label: context.tr('All methods', 'كل الطرق'),
              icon: Icons.apps,
              selected: current == null,
              count: concepts.length,
              onTap: () => ctl.setAspect(null),
            ),
            for (final a in Aspect.values)
              FilterPill(
                key: Key('mode-${a.name}'),
                label: a.label(context.ui),
                icon: aspectIcon(a),
                selected: current == a,
                count: concepts.where((c) => c.aspect == a).length,
                onTap: () => ctl.setAspect(a),
              ),
          ],
        ),
      ],
    );
  }
}

/// "Concept of the day" card with deck navigation and quick actions.
class _ConceptHeader extends ConsumerWidget {
  const _ConceptHeader({
    required this.concept,
    required this.index,
    required this.total,
  });
  final Concept concept;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final t = Theme.of(context).textTheme;
    final mx = context.mx;
    final wide = MediaQuery.sizeOf(context).width >= 700;
    return Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(aspectIcon(concept.aspect), size: 18, color: mx.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr(
                    'CONCEPT · ${concept.aspect.en.toUpperCase()}',
                    'المفهوم · ${concept.aspect.ar}',
                  ),
                  style: t.labelMedium!.copyWith(
                    color: mx.amber,
                    letterSpacing: context.isAr ? 0 : 1.1,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '${index + 1}/$total · ${concept.level}',
                  textDirection: TextDirection.ltr,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: monoStyle(context),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                key: const Key('concept-prev'),
                tooltip: context.tr('Previous', 'السابق'),
                onPressed: () => ctl.step(-1),
                icon: Icon(
                  context.isAr ? Icons.chevron_right : Icons.chevron_left,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                key: const Key('concept-next'),
                tooltip: context.tr('Next', 'التالي'),
                onPressed: () => ctl.step(1),
                icon: Icon(
                  context.isAr ? Icons.chevron_left : Icons.chevron_right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            concept.title(context.ui),
            style: wide ? t.headlineLarge : t.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: context.tr('Target expression: ', 'التعبير المستهدف: '),
                  style: t.bodyMedium!.copyWith(color: mx.muted),
                ),
                TextSpan(
                  text: '“${concept.meaning(context.ui)}”',
                  style: t.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                key: const Key('pin-concept'),
                onPressed: () {
                  ctl.pinConcept(concept);
                  showSnack(
                    context,
                    context.tr(
                      'Pinned to your notebook',
                      'تم التثبيت في المذكرة',
                    ),
                  );
                },
                icon: const Icon(Icons.push_pin_outlined, size: 18),
                label: Text(context.tr('Pin to notebook', 'تثبيت في المذكرة')),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  final en = concept.lines['en']?.text ?? concept.meaningEn;
                  final word = concept.wordGroups.isEmpty
                      ? ''
                      : concept.wordGroups.first;
                  context.go(
                    word.isEmpty
                        ? '/dictionary?q=${Uri.encodeQueryComponent(en.split(' ').last.replaceAll(RegExp(r'[^\w]'), ''))}'
                        : '/dictionary?group=${Uri.encodeQueryComponent(word)}',
                  );
                },
                icon: const Icon(Icons.manage_search, size: 18),
                label: Text(context.tr('Search lexicon', 'البحث في القاموس')),
              ),
              FilledButton.icon(
                key: const Key('play-all'),
                onPressed: () => _playAll(context, ref, concept),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: Text(
                  context.tr('Play all languages', 'تشغيل كل اللغات'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _playAll(BuildContext context, WidgetRef ref, Concept c) async {
  final s = ref.read(polyglotProvider);
  ref.read(polyglotProvider.notifier).practised();
  for (final l in s.activeLanguages) {
    final line = c.lines[l.code];
    if (line == null || line.text.isEmpty || !context.mounted) continue;
    await speak(context, ref, line.text, l);
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }
}

/// The side-by-side cards.
class _ParallelDeck extends StatelessWidget {
  const _ParallelDeck({
    required this.concept,
    required this.langs,
    required this.mode,
  });
  final Concept concept;
  final List<LanguageDef> langs;
  final Aspect? mode;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      const gap = 14.0;
      final cols = ((c.maxWidth + gap) / (300 + gap)).floor().clamp(1, 4);
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final l in langs)
            SizedBox(
              width: w,
              child: ConceptCard(
                key: ValueKey('card-${concept.id}-${l.code}-${mode?.name}'),
                concept: concept,
                lang: l,
                mode: mode,
              ),
            ),
        ],
      );
    },
  );
}

/// One language column of the deck.
class ConceptCard extends ConsumerStatefulWidget {
  const ConceptCard({
    super.key,
    required this.concept,
    required this.lang,
    this.mode,
  });
  final Concept concept;
  final LanguageDef lang;
  final Aspect? mode;

  @override
  ConsumerState<ConceptCard> createState() => _ConceptCardState();
}

class _ConceptCardState extends ConsumerState<ConceptCard> {
  bool _revealed = false;
  final _answer = TextEditingController();
  bool? _correct;

  bool get _hideText =>
      !_revealed &&
      (widget.mode == Aspect.listening || widget.mode == Aspect.writing);

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _check(String target) {
    String norm(String s) => s
        .toLowerCase()
        .replaceAll(RegExp('[ً-ْ]'), '') // Arabic short vowels
        .replaceAll(
          RegExp(
            r'[.,!?;:¿¡"„“”’'
            "'"
            r'«»؟،\-]',
          ),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    setState(() {
      _correct = norm(_answer.text) == norm(target);
      if (_correct!) _revealed = true;
    });
    ref.read(polyglotProvider.notifier).practised();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(polyglotProvider);
    final ctl = ref.read(polyglotProvider.notifier);
    final c = widget.concept;
    final l = widget.lang;
    final line = c.lines[l.code];
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final stage = ctl.mastery(c.id, l.code);
    final saved = ctl.inDictionary(c.id, l.code);
    final dir = dirOf(l);

    final header = Row(
      children: [
        Expanded(child: LangBadge(l)),
        if (l.rtl) ...[Tag('RTL', color: mx.amber), const SizedBox(width: 6)],
        Tooltip(
          message: context.tr(
            'Mastery: tap to change',
            'الإتقان: اضغط للتغيير',
          ),
          child: Tag(
            stage.label(context.ui),
            key: Key('mastery-${l.code}'),
            icon: stageIcon(stage),
            color: stageColor(context, stage),
            filled: stage == Stage.mastered,
            onTap: () => ctl.cycleMastery(c.id, l.code),
          ),
        ),
      ],
    );

    if (line == null || line.text.isEmpty) {
      return Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 16),
            Text(
              context.tr(
                'No ${l.name} version of this concept yet.',
                'لا توجد نسخة ${l.nameAr} من هذا المفهوم بعد.',
              ),
              style: t.bodyMedium!.copyWith(color: mx.muted),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: Key('add-line-${l.code}'),
              onPressed: () => showEditLineDialog(context, ref, c, l),
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.tr('Add your translation', 'أضف ترجمتك')),
            ),
          ],
        ),
      );
    }

    final natural = line.natural.isNotEmpty && !context.isAr
        ? line.natural
        : c.meaning(context.ui);

    Widget targetText() {
      final text = Text(
        line.text,
        key: Key('line-${l.code}'),
        textDirection: dir,
        textAlign: dir == TextDirection.rtl ? TextAlign.right : TextAlign.left,
        style: t.headlineSmall!.copyWith(
          fontFamily: l.rtl ? 'NotoSansArabic' : kUiFont,
          fontWeight: FontWeight.w600,
          fontSize: l.rtl ? 22 : 20,
          height: l.rtl ? 1.9 : 1.55,
          letterSpacing: l.rtl ? 0 : 0.2,
        ),
      );
      if (!_hideText) {
        return SizedBox(width: double.infinity, child: text);
      }
      if (widget.mode == Aspect.writing) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.tr('Write it from memory:', 'اكتبه من الذاكرة:'),
              style: t.bodySmall,
            ),
            const SizedBox(height: 6),
            TextField(
              key: Key('recall-${l.code}'),
              controller: _answer,
              textDirection: dir,
              onSubmitted: (_) => _check(line.text),
              decoration: InputDecoration(
                hintText: c.meaning(context.ui),
                suffixIcon: IconButton(
                  tooltip: context.tr('Check', 'تحقق'),
                  onPressed: () => _check(line.text),
                  icon: const Icon(Icons.check),
                ),
              ),
            ),
            if (_correct == false) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.close,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.tr(
                        'Not quite. Try again or reveal.',
                        'ليس تمامًا. حاول مجددًا أو اكشف الإجابة.',
                      ),
                      style: t.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _revealed = true),
                    child: Text(context.tr('Reveal', 'اكشف')),
                  ),
                ],
              ),
            ],
          ],
        );
      }
      // Listening: hear it first, then reveal.
      return InkWell(
        key: Key('reveal-${l.code}'),
        onTap: () => setState(() => _revealed = true),
        borderRadius: BorderRadius.circular(6),
        child: Inset(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hearing, color: mx.primary, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  context.tr(
                    'Listen, then tap to reveal',
                    'استمع ثم اضغط للكشف',
                  ),
                  style: t.labelLarge!.copyWith(color: mx.primary),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Panel(
      borderColor: _correct == true ? mx.primary : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 14),
          targetText(),
          const SizedBox(height: 12),
          if (!_hideText || widget.mode == Aspect.writing)
            Inset(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (line.ipa.isNotEmpty &&
                      !(_hideText && widget.mode == Aspect.writing))
                    _MetaRow(
                      label: 'IPA',
                      child: Text(
                        line.ipa,
                        textDirection: TextDirection.ltr,
                        style: ipaStyle(context),
                      ),
                    ),
                  if (line.literal.isNotEmpty)
                    _MetaRow(
                      label: 'LIT',
                      child: Text(
                        '“${line.literal}”',
                        textDirection: TextDirection.ltr,
                        style: t.bodySmall!.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.g_translate, size: 16, color: mx.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${context.tr('Natural', 'المعنى')}: $natural',
                  style: t.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: mx.rule),
          Row(
            children: [
              IconButton(
                key: Key('play-${l.code}'),
                tooltip: context.tr('Play', 'تشغيل'),
                color: mx.primary,
                onPressed: () {
                  ctl.practised();
                  speak(context, ref, line.text, l);
                },
                icon: const Icon(Icons.volume_up_outlined),
              ),
              IconButton(
                tooltip: context.tr('Play slowly', 'تشغيل ببطء'),
                color: mx.primary,
                onPressed: () => speak(context, ref, line.text, l, slow: true),
                icon: const Icon(Icons.slow_motion_video),
              ),
              if (widget.mode == Aspect.speaking)
                IconButton(
                  key: Key('shadow-${l.code}'),
                  tooltip: context.tr(
                    'Shadow: slow, pause, normal',
                    'محاكاة: بطيء، توقف، عادي',
                  ),
                  color: mx.amber,
                  onPressed: () async {
                    ctl.practised();
                    await speak(context, ref, line.text, l, slow: true);
                    await Future<void>.delayed(const Duration(seconds: 3));
                    if (context.mounted) {
                      await speak(context, ref, line.text, l);
                    }
                  },
                  icon: const Icon(Icons.record_voice_over_outlined),
                ),
              const Spacer(),
              IconButton(
                key: Key('pin-${l.code}'),
                tooltip: context.tr('Pin to notebook', 'تثبيت في المذكرة'),
                onPressed: () {
                  ctl.pinConcept(c);
                  showSnack(
                    context,
                    context.tr(
                      'Pinned to your notebook',
                      'تم التثبيت في المذكرة',
                    ),
                  );
                },
                icon: const Icon(Icons.push_pin_outlined),
              ),
              IconButton(
                key: Key('save-${l.code}'),
                tooltip: saved
                    ? context.tr('In your dictionary', 'موجود في القاموس')
                    : context.tr('Save to dictionary', 'حفظ في القاموس'),
                color: saved ? mx.primary : null,
                onPressed: () {
                  final ok = ctl.saveLine(c, l.code);
                  showSnack(
                    context,
                    ok
                        ? context.tr(
                            'Saved to the dictionary',
                            'تم الحفظ في القاموس',
                          )
                        : context.tr(
                            'Already in your dictionary',
                            'موجود بالفعل في القاموس',
                          ),
                  );
                },
                icon: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_add_outlined,
                ),
              ),
              PopupMenuButton<String>(
                tooltip: context.tr('More', 'المزيد'),
                icon: const Icon(Icons.more_horiz),
                onSelected: (v) {
                  if (v == 'edit') showEditLineDialog(context, ref, c, l);
                  if (v == 'reveal') setState(() => _revealed = !_revealed);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      context.tr('Edit this line', 'تعديل هذا السطر'),
                    ),
                  ),
                  if (widget.mode == Aspect.listening ||
                      widget.mode == Aspect.writing)
                    PopupMenuItem(
                      value: 'reveal',
                      child: Text(
                        _revealed
                            ? context.tr('Hide text', 'إخفاء النص')
                            : context.tr('Reveal text', 'كشف النص'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              label,
              style: monoStyle(
                context,
                size: 10.5,
                color: context.mx.primary,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    ),
  );
}

/// "Polyglot skill matrix": what to do with this concept in each method.
class _PracticeStrip extends ConsumerWidget {
  const _PracticeStrip({
    required this.concept,
    required this.langs,
    required this.mode,
  });
  final Concept concept;
  final List<LanguageDef> langs;
  final Aspect? mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(polyglotProvider.notifier);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final current = mode ?? concept.aspect;
    final (title, body) = switch (current) {
      Aspect.vocabulary => (
        context.tr('Build the word web', 'ابنِ شبكة الكلمات'),
        context.tr(
          'Save each line to the dictionary, then open the dictionary to see the equivalents side by side and run a quick self-test.',
          'احفظ كل سطر في القاموس، ثم افتح القاموس لترى المقابلات جنبًا إلى جنب وأجرِ اختبارًا ذاتيًا سريعًا.',
        ),
      ),
      Aspect.grammar => (
        context.tr('Compare the structure', 'قارن البنية'),
        context.tr(
          'Read the literal (LIT) line of each card: where does the verb go? Which languages need a pronoun or an article? Pin your rule to the notebook.',
          'اقرأ السطر الحرفي (LIT) في كل بطاقة: أين يقع الفعل؟ أي اللغات تحتاج ضميرًا أو أداة تعريف؟ ثبّت قاعدتك في المذكرة.',
        ),
      ),
      Aspect.listening => (
        context.tr('Listen before you read', 'استمع قبل أن تقرأ'),
        context.tr(
          'Text is hidden. Play each card (normal, then slow), say what you heard, then tap to reveal and check the IPA.',
          'النص مخفي. شغّل كل بطاقة (عادي ثم بطيء)، قل ما سمعته، ثم اضغط للكشف وراجع النطق الصوتي.',
        ),
      ),
      Aspect.speaking => (
        context.tr('Shadowing', 'المحاكاة (Shadowing)'),
        context.tr(
          'Use the shadow button: it plays the line slowly, leaves you 3 seconds to repeat, then plays it at normal speed. Do three rounds per language.',
          'استعمل زر المحاكاة: يشغّل السطر ببطء، ويترك لك 3 ثوانٍ للتكرار، ثم يشغّله بالسرعة العادية. كرر ثلاث جولات لكل لغة.',
        ),
      ),
      Aspect.reading => (
        context.tr('Read for gist, then detail', 'اقرأ للفكرة ثم للتفاصيل'),
        context.tr(
          'Read every column once without help, then use the natural translation and IPA to fill the gaps. Mark each language as learning or mastered.',
          'اقرأ كل عمود مرة دون مساعدة، ثم استعن بالترجمة والنطق لسد الثغرات. علّم كل لغة بـ"قيد التعلم" أو "متقن".',
        ),
      ),
      Aspect.writing => (
        context.tr('Recall from memory', 'استرجع من الذاكرة'),
        context.tr(
          'Text is hidden. Type each line from memory and press check. Accents count; punctuation does not.',
          'النص مخفي. اكتب كل سطر من الذاكرة واضغط تحقق. علامات الحروف مهمة، وعلامات الترقيم لا.',
        ),
      ),
      Aspect.pragmatics => (
        context.tr('When and to whom', 'متى ولمن'),
        context.tr(
          'Decide who you would say this to in each language and how formal it is. Write one real situation per language in the notebook.',
          'حدد لمن تقول هذا في كل لغة ومدى رسميته. اكتب موقفًا حقيقيًا واحدًا لكل لغة في المذكرة.',
        ),
      ),
    };
    final skillsDone = langs
        .where((l) => ctl.mastery(concept.id, l.code) != Stage.fresh)
        .length;
    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(
            context.tr('Polyglot skill matrix', 'مصفوفة المهارات'),
            icon: Icons.hub_outlined,
            color: mx.ink,
            trailing: Text(
              context.tr(
                '$skillsDone/${langs.length} in progress',
                '$skillsDone/${langs.length} قيد التقدم',
              ),
              style: monoStyle(context, color: mx.amber),
            ),
          ),
          const SizedBox(height: 12),
          ChipRow(
            spacing: 6,
            children: [
              for (final a in Aspect.values)
                FilterPill(
                  key: Key('strip-${a.name}'),
                  label: a.short(context.ui),
                  icon: aspectIcon(a),
                  selected: current == a && mode != null,
                  onTap: () => ctl.setAspect(a),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: t.titleMedium),
          const SizedBox(height: 4),
          Text(body, style: t.bodyMedium!.copyWith(color: mx.muted)),
        ],
      ),
    );
  }
}

/// The comparative insight of the concept.
class _SynthesisPrompt extends StatelessWidget {
  const _SynthesisPrompt({required this.concept});
  final Concept concept;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    return Panel(
      color: Color.alphaBlend(mx.amber.withValues(alpha: 0.07), mx.surface),
      borderColor: mx.amber.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: mx.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.lightbulb_outline, color: mx.amber, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(
                  context.tr('Comparative synthesis prompt', 'ملاحظة المقارنة'),
                  color: mx.amber,
                ),
                const SizedBox(height: 6),
                Text(concept.note(context.ui), style: t.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the free resources drawer for the active languages.
class _ResourcesTrigger extends ConsumerWidget {
  const _ResourcesTrigger({required this.langs, required this.aspect});
  final List<LanguageDef> langs;
  final Aspect aspect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(polyglotProvider);
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final count = s.resources
        .where((r) => langs.any((l) => r.covers(l.code)))
        .length;
    return Panel(
      key: const Key('resources-drawer'),
      onTap: () => showResourcesDrawer(context, ref),
      color: mx.surface2,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mx.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.local_library_outlined, color: mx.surface),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Free resources drawer', 'درج المصادر المجانية'),
                  style: t.titleMedium,
                ),
                Text(
                  context.tr(
                    '$count free videos, open books, podcasts and tools for your ${langs.length} languages',
                    '$count فيديو وكتاب مفتوح وبودكاست وأداة مجانية للغاتك الـ${langs.length}',
                  ),
                  style: t.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            context.isAr ? Icons.arrow_back : Icons.arrow_forward,
            color: mx.primary,
          ),
        ],
      ),
    );
  }
}
