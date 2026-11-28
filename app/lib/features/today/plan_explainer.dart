// "How your plan works": a card on the Today screen that explains how the
// study plan is built, in the same words as the SessionPlanner rules.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/bidi.dart';
import '../../core/providers.dart';
import '../../domain/scheduling/session_planner.dart';
import '../polyglot/ui.dart' show TrX;
import 'today_plan.dart';

class PlanExplainer extends ConsumerWidget {
  const PlanExplainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final ui = ref.watch(uiLanguageProvider);
    final goal = ref.watch(settingsProvider).value?.dailyGoalMinutes ?? 120;
    final now = DateTime.now();
    final plan = ref.watch(todayPlanProvider).value;
    final lessonLangs = [
      for (final b in plan?.blocks ?? const <SessionBlock>[])
        if (b.kind == BlockKind.newLesson && b.lang != null)
          b.lang!.displayName(ui),
    ];
    final todayLine = now.weekday == DateTime.sunday
        ? context.tr(
            'Today is Sunday: reviews only, no new lessons.',
            'النهاردة الحد: مراجعة بس، من غير دروس جديدة.',
          )
        : lessonLangs.isEmpty
        ? context.tr(
            'No new lesson today: reviews and practice.',
            'مفيش درس جديد النهاردة: مراجعة وتمارين.',
          )
        : context.tr(
            'Today\'s new lessons: ${lessonLangs.join(' and ')}.',
            'دروس النهاردة الجديدة: ${lessonLangs.join(' و')}.',
          );

    final points = <(IconData, String, String)>[
      (
        Icons.timer_outlined,
        context.tr('Your daily time', 'وقتك اليومي'),
        context.tr(
          'The plan fits into your daily goal ($goal minutes, change it in Settings) and shares it between your languages.',
          'الخطة بتتظبط على هدفك اليومي ($goal دقيقة، وتقدر تغيره من الإعدادات)، وبتتقسم بين لغاتك.',
        ),
      ),
      (
        Icons.style_outlined,
        context.tr('Reviews come first', 'المراجعة الأول'),
        context.tr(
          'Each day starts with the flashcards that are due (spaced repetition), the language with the most cards first. If reviews pile up for more than two days, new words for that language are halved until you catch up.',
          'كل يوم بيبدأ بالكروت اللي ميعاد مراجعتها جه (تكرار متباعد)، واللغة اللي عندها كروت أكتر الأول. لو المراجعة اتراكمت أكتر من يومين، الكلمات الجديدة في اللغة دي بتقل للنص لحد ما تلحق.',
        ),
      ),
      (
        Icons.school_outlined,
        context.tr('Two new lessons a day', 'درسين جداد كل يوم'),
        context.tr(
          'Monday to Saturday, two languages get a new lesson (${SessionPlanner.lessonMinutes} min each) and the third gets a skill practice (${SessionPlanner.skillMinutes} min: listening, reading, speaking or writing, rotating). Over six days each language gets four lessons. Learning one language? It gets a new lesson every day. Sunday is reviews only.',
          'كل يوم ما عدا الحد، لغتين بياخدوا درس جديد (${SessionPlanner.lessonMinutes} دقيقة لكل درس)، والتالتة بتاخد تمرين مهارة (${SessionPlanner.skillMinutes} دقيقة: استماع أو قراءة أو كلام أو كتابة بالتناوب). على 6 أيام كل لغة بتاخد 4 دروس. ولو بتدرس لغة واحدة، ليها درس جديد كل يوم. والحد مراجعة بس.',
        ),
      ),
      (
        Icons.compare_arrows,
        context.tr('Close languages kept apart', 'اللغات القريبة بعيد عن بعض'),
        context.tr(
          'German and Dutch look alike, so their new lessons never come back to back. If you mix up languages 3 times or more in a week, a ${SessionPlanner.contrastMinutes}-minute contrast drill is added.',
          'الألماني والهولندي شبه بعض، فدروسهم الجديدة مش بتيجي ورا بعض. ولو لخبطت بين اللغات 3 مرات أو أكتر في الأسبوع، بيتضاف تمرين مقارنة ${SessionPlanner.contrastMinutes} دقايق.',
        ),
      ),
      (
        Icons.stairs_outlined,
        context.tr('Levels A0 to C1', 'المستويات من A0 لـ C1'),
        context.tr(
          'Each level is a path of units (words, grammar, listening, reading, speaking, writing). At the end of a level there is an exam: 70% moves you up.',
          'كل مستوى عبارة عن وحدات (كلمات، قواعد، استماع، قراءة، كلام، كتابة). وفي آخر المستوى فيه امتحان، ولو جبت 70% بتطلع للمستوى اللي بعده.',
        ),
      ),
      (
        Icons.history,
        context.tr('Missed a day?', 'فاتك يوم؟'),
        context.tr(
          'Use "Previous day" on the plan to go back to the tasks of the last two weeks and finish what you missed.',
          'استخدم «اليوم اللي قبله» في الخطة عشان ترجع لمهام آخر أسبوعين وتكمل اللي فاتك.',
        ),
      ),
    ];

    return Card(
      key: const ValueKey('plan-explainer'),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Icon(Icons.help_outline, color: scheme.primary),
        title: BidiText(
          context.tr('How your plan works', 'إزاي خطتك بتتعمل؟'),
          style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: BidiText(todayLine, style: t.bodySmall),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          for (final (icon, title, body) in points)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    child: Icon(icon, size: 18, color: scheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BidiText(
                          title,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        BidiText(
                          body,
                          style: t.bodyMedium?.copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
