// Easy German and CyberGerman on YouTube, placed where they help: a
// playlist for the learner's level on the course and roadmap pages, and
// channel searches for the topic on each German grammar page. We only link;
// the videos play in the YouTube player (in-app browser or YouTube app).

import 'package:material_ui/material_ui.dart';

import '../../core/bidi.dart';
import '../../core/theme.dart';
import '../polyglot/ui.dart' show TrX;
import 'german_roadmap.dart' show openPog;

/// Easy German's own "Where to begin" playlists (easygerman.org, 2026-11-25).
const _easyGermanLevels = {
  'A1': 'PLk1fjOl39-50kWobutO8NVFzbw9PHtbbg',
  'A2': 'PLk1fjOl39-5201BUdhtOM_x23poNvLouT',
  'B1': 'PLk1fjOl39-53yooogv6RaJAK29mx7nz1d',
  'B2': 'PLk1fjOl39-51lvdiuQYsLW-0aGIdNNknA',
  'C1': 'PLk1fjOl39-53pjPz2VLCeu5vjOUMKZ22O',
};
const superEasyGermanList = 'PLk1fjOl39-53GxQIn1Hxdouokf0J0SDpl';
const streetInterviewsList = 'PL3936178A38BB5F87';

Uri playlistUrl(String id) =>
    Uri.https('www.youtube.com', '/playlist', {'list': id});

/// Easy German's playlist for a course level (A0 uses the A1 one).
Uri easyGermanLevelUrl(String cefr) => playlistUrl(
  _easyGermanLevels[cefr == 'A0' ? 'A1' : cefr] ?? _easyGermanLevels['A1']!,
);

/// A search inside one channel, e.g. `@CyberGerman` for "Perfekt".
Uri channelSearchUrl(String handle, String topic) {
  final clean = topic
      .replaceAll(RegExp(r'[()]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return Uri.https('www.youtube.com', '/$handle/search', {'query': clean});
}

final easyGermanChannel = Uri.https('www.youtube.com', '/@EasyGerman');
final cyberGermanChannel = Uri.https('www.youtube.com', '/@CyberGerman');

/// Video picks from Easy German and CyberGerman for a [level], and for a
/// grammar [topic] when there is one.
class GermanChannelsCard extends StatelessWidget {
  const GermanChannelsCard({super.key, required this.level, this.topic});
  final String level;
  final String? topic;

  @override
  Widget build(BuildContext context) {
    final mx = context.mx;
    final t = Theme.of(context).textTheme;
    final low = level == 'A0' || level == 'A1' || level == 'A2';
    final lv = level == 'A0' ? 'A1' : level;
    final links = <(Key, IconData, String, Uri)>[
      if (topic case final topic?) ...[
        (
          const Key('eg-topic'),
          Icons.search,
          context.tr('Easy German on this topic', 'Easy German عن الموضوع ده'),
          channelSearchUrl('@EasyGerman', topic),
        ),
        (
          const Key('cg-topic'),
          Icons.search,
          context.tr('CyberGerman on this topic', 'CyberGerman عن الموضوع ده'),
          channelSearchUrl('@CyberGerman', topic),
        ),
      ],
      (
        const Key('eg-level'),
        Icons.playlist_play,
        context.tr('Easy German · $lv playlist', 'قائمة Easy German · $lv'),
        easyGermanLevelUrl(level),
      ),
      low
          ? (
              const Key('eg-super'),
              Icons.slow_motion_video,
              context.tr('Super Easy German', 'Super Easy German'),
              playlistUrl(superEasyGermanList),
            )
          : (
              const Key('eg-street'),
              Icons.record_voice_over_outlined,
              context.tr(
                'Easy German street interviews',
                'مقابلات Easy German في الشارع',
              ),
              playlistUrl(streetInterviewsList),
            ),
      if (topic == null)
        (
          const Key('cg-channel'),
          Icons.smart_display_outlined,
          context.tr('CyberGerman channel', 'قناة CyberGerman'),
          cyberGermanChannel,
        ),
    ];

    return Container(
      key: const Key('german-channels'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mx.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mx.rule),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BidiText('Easy German · CyberGerman', style: t.titleMedium),
                    BidiText(
                      topic == null
                          ? context.tr(
                              'Real German videos for your level.',
                              'فيديوهات ألماني حقيقية على مستواك.',
                            )
                          : context.tr(
                              'Watch this topic explained by native speakers.',
                              'اتفرج على الموضوع ده بشرح متحدثين أصليين.',
                            ),
                      style: t.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (key, icon, label, url) in links)
                ActionChip(
                  key: key,
                  avatar: Icon(icon, size: 18),
                  label: BidiText(label),
                  onPressed: () => openPog(url),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
