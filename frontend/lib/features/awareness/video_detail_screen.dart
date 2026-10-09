import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import 'awareness_provider.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const VideoDetailScreen({super.key, required this.id});

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  bool _isPlaying = false;
  bool _sharedWithCare = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(awarenessProvider);
    final item = state.items.firstWhere(
      (i) => i.id == widget.id,
      orElse: () => state.items.first,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Library',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones_outlined, color: AppColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              item.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: item.isSaved ? AppColors.primary : AppColors.onSurface,
            ),
            onPressed: () => ref.read(awarenessProvider.notifier).toggleSave(item.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVideoPlayerMockup(item),
              const SizedBox(height: 16),
              Text(
                '${item.category} • Educational guide',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppColors.outline),
                      const SizedBox(width: 4),
                      Text('${item.duration} video', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.graphic_eq, size: 14, color: AppColors.outline),
                      const SizedBox(width: 4),
                      Text('Audio available', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 14, color: Color(0xFF0D9488)),
                      const SizedBox(width: 4),
                      Text('Professionally reviewed', style: AppTypography.labelSmall.copyWith(color: const Color(0xFF0D9488))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.subtitle,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PulseButton(
                      text: item.isSaved ? 'Saved for later ✓' : 'Save for later',
                      variant: PulseButtonVariant.outlined,
                      icon: item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      fontSize: 12.5,
                      onPressed: () => ref.read(awarenessProvider.notifier).toggleSave(item.id),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PulseButton(
                      text: _sharedWithCare ? 'Shared ✓' : 'Share with care',
                      variant: _sharedWithCare ? PulseButtonVariant.secondary : PulseButtonVariant.primary,
                      icon: Icons.verified_user_outlined,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      fontSize: 12.5,
                      onPressed: () {
                        setState(() => _sharedWithCare = !_sharedWithCare);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_sharedWithCare
                                ? 'Resource will be discussed in your care review.'
                                : 'Resource unlinked from care review.'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.lock_outline, size: 12, color: AppColors.outline),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Optional and patient-controlled. Nothing is shared without your explicit confirmation.',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTrustworthyLearningCard(),
              const SizedBox(height: 20),
              _buildKeyTakeawaysCard(item),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayerMockup(AwarenessItem item) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: IconButton(
              iconSize: 56,
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.white,
              ),
              onPressed: () => setState(() => _isPlaying = !_isPlaying),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Text(
                  _isPlaying ? '1:24 / 4:12' : '0:00 / 4:12',
                  style: AppTypography.labelSmall.copyWith(color: Colors.white70),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _isPlaying ? 0.35 : 0.0,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryFixed),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.volume_up, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                const Icon(Icons.fullscreen, color: Colors.white70, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustworthyLearningCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF8FAFC),
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.health_and_safety_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Built for trustworthy learning',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pulse awareness content is designed to help you understand health topics and prepare for informed, confident conversations with your healthcare team.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  'Educational content • General reference',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyTakeawaysCard(AwarenessItem item) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Key takeaways',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Core points', variant: PulseBadgeVariant.primary),
            ],
          ),
          const SizedBox(height: 14),
          ...item.takeaways.map((t) {
            final title = t['title'] ?? '';
            final body = t['body'] ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(body, style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
