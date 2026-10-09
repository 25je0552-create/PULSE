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
import 'progress_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressProvider);
    final range = progressState.selectedRangeDays;
    final trends = progressState.trendObservations;
    final goal = progressState.activeGoal;

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
          'Your Progress',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Stage 04 · Measure',
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
                'Longitudinal view',
                style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                'See how your patterns are changing over time.',
                style: AppTypography.titleMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Row(
                children: [7, 30, 90].map((days) {
                  final isSel = range == days;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PulseChip(
                      label: '$days days',
                      isSelected: isSel,
                      onTap: () => ref.read(progressProvider.notifier).fetchProgress(days),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '90 days provides the clearest picture for continuous care.',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildWellbeingSignalsCard(trends),
              const SizedBox(height: 20),
              _buildSignalsOverTimeCard(progressState.signalPoints, range),
              const SizedBox(height: 20),
              _buildPatternNoticedCard(),
              const SizedBox(height: 20),
              _buildGoalAdherenceCard(goal),
              const SizedBox(height: 28),
              PulseButton(
                text: 'View Care Continuity & Team',
                icon: Icons.healing,
                onPressed: () => context.push(AppRoutes.care),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWellbeingSignalsCard(Map<String, dynamic> trends) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your wellbeing',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Your recent check-ins show how you\'ve been feeling over time.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          _buildTrendRow('Mood', trends['mood'] ?? 'Mostly okay', Icons.sentiment_satisfied_alt_outlined, AppColors.primary),
          const Divider(height: 20, color: AppColors.cardBorder),
          _buildTrendRow('Stress', trends['stress'] ?? 'Higher this week', Icons.waves, AppColors.secondary),
          const Divider(height: 20, color: AppColors.cardBorder),
          _buildTrendRow('Energy', trends['energy'] ?? 'Improving', Icons.bolt_outlined, const Color(0xFFD97706)),
          const Divider(height: 20, color: AppColors.cardBorder),
          _buildTrendRow('Sleep', trends['sleep'] ?? 'Needs attention', Icons.bedtime_outlined, AppColors.error),
          const SizedBox(height: 14),
          Text(
            'Self-reported daily signals for your personal reflection, not clinical measurements.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendRow(String title, String status, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            status,
            textAlign: TextAlign.end,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSignalsOverTimeCard(List<dynamic> points, int range) {
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
                  'Your signals over time',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Last $range days',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _buildLegend('Stress', AppColors.secondary),
              _buildLegend('Sleep', AppColors.error),
              _buildLegend('Energy', const Color(0xFFD97706)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: points.map((p) {
                final day = p['day'] ?? '';
                final stress = (p['stress'] as num?)?.toDouble() ?? 3.0;
                final sleep = (p['sleep'] as num?)?.toDouble() ?? 6.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 8,
                          height: (stress / 5.0) * 80 + 10,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 8,
                          height: (sleep / 8.0) * 80 + 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCA5A5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      day,
                      style: AppTypography.labelSmall.copyWith(fontSize: 10),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildPatternNoticedCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF4),
      borderColor: const Color(0xFFBBF7D0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Color(0xFF16A34A), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Something to notice',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Pattern found', variant: PulseBadgeVariant.success),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your stress was higher on days when your sleep was lower.',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep checking in to see whether this rhythm continues. Observing the connection gives you practical context without judging difficult days.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalAdherenceCard(Map<String, dynamic> goal) {
    final completed = (goal['completedDays'] as num?)?.toInt() ?? 4;
    final target = (goal['targetDays'] as num?)?.toInt() ?? 6;
    final progressVal = target > 0 ? (completed / target).clamp(0.0, 1.0) : 0.6;

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
                  'Your adaptive goal',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: PulseBadge(
                  text: '$completed of $target days completed',
                  variant: PulseBadgeVariant.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal['title'] ?? 'Take 10 minutes away from your work screen',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            goal['category'] ?? 'Daily screen pause',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressVal,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerLow,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
