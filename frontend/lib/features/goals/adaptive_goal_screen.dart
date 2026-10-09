import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_chip.dart';
import 'goals_provider.dart';

class AdaptiveGoalScreen extends ConsumerWidget {
  const AdaptiveGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(goalsProvider);
    final activeGoal = goalsState.activeGoal;

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
          'Pulse Ai',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Act & Adapt',
                variant: PulseBadgeVariant.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let’s make it doable.',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Small actions are easier to build into your day. You can always adjust or resize this goal whenever life shifts.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              PulseCard(
                backgroundColor: const Color(0xFFF0FDF9),
                borderColor: const Color(0xFF99F6E4),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Based on your recent check-ins',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your stress has been higher while your sleep and energy have been lower. Rather than changing everything at once, let’s start with one calm, low-friction pause.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PulseCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.spa, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your goal',
                                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        PulseBadge(
                          text: '${activeGoal.durationMinutes} min',
                          variant: PulseBadgeVariant.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activeGoal.title,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activeGoal.description,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: AppColors.outline),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Estimated time: ${activeGoal.durationMinutes} minutes',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Make it work for you',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Tune this to match your real day, without guilt or pressure.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 16),
              _buildTuningOption(
                title: 'How often?',
                options: ['Today', '3 days', 'Every day'],
                selected: activeGoal.frequency,
                onSelected: (val) => ref.read(goalsProvider.notifier).updateFrequency(val),
              ),
              const SizedBox(height: 16),
              _buildTuningOption(
                title: 'When?',
                options: ['Morning', 'Afternoon', 'Evening', 'Whenever works'],
                selected: activeGoal.preferredTime,
                onSelected: (val) => ref.read(goalsProvider.notifier).updatePreferredTime(val),
              ),
              const SizedBox(height: 16),
              _buildTuningOption(
                title: 'How doable does this feel?',
                options: ['Easy', 'Manageable', 'Hard'],
                selected: activeGoal.difficulty,
                onSelected: (val) => ref.read(goalsProvider.notifier).updateDifficulty(val),
              ),
              const SizedBox(height: 20),
              PulseCard(
                backgroundColor: const Color(0xFFFEF3C7),
                borderColor: const Color(0xFFFDE68A),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tips_and_updates_outlined, color: Color(0xFFB45309), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'If this feels like a lot today:',
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: PulseButton(
                            text: 'Make it 5 minutes',
                            icon: Icons.compress,
                            variant: PulseButtonVariant.secondary,
                            onPressed: () {
                              ref.read(goalsProvider.notifier).reduceTo5Minutes();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Goal adapted to a gentle 5-minute pause.')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Not the right goal? Choose another',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...goalsState.alternatives.map((alt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PulseCard(
                    onTap: () {
                      ref.read(goalsProvider.notifier).selectAlternative(alt);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: ${alt.title}')),
                      );
                    },
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horiz, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alt.title,
                                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                alt.description,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.outline),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 28),
              PulseButton(
                text: 'Confirm Goal & View Progress',
                icon: Icons.arrow_forward,
                onPressed: () async {
                  await ref.read(goalsProvider.notifier).confirmGoal();
                  if (context.mounted) {
                    context.push(AppRoutes.progress);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTuningOption({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSel = selected == opt;
            return PulseChip(
              label: opt,
              isSelected: isSel,
              icon: isSel ? Icons.check : null,
              onTap: () => onSelected(opt),
            );
          }).toList(),
        ),
      ],
    );
  }
}
