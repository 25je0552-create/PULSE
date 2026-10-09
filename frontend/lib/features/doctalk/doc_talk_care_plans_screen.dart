import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../goals/goals_provider.dart';
import 'doctalk_provider.dart';

class DocTalkCarePlansScreen extends ConsumerWidget {
  const DocTalkCarePlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(docTalkProvider);
    final notifier = ref.read(docTalkProvider.notifier);
    final plans = state.carePlans;

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
          'Care Plans & Advice',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: AppColors.primary),
            tooltip: 'View Adaptive Goals',
            onPressed: () => context.push(AppRoutes.adaptiveGoal),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProvenanceCard(),
              const SizedBox(height: 20),
              Text(
                'Professional Care Guidance',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Personalized recommendations documented by your consulting healthcare professionals.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              if (plans.isEmpty)
                _buildEmptyPlansCard(context)
              else
                ...plans.map((plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildCarePlanCard(context, ref, plan, notifier),
                    )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProvenanceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined, color: AppColors.tertiary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Clinical Authorship Standards',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '• Advice below is written and approved directly by verified doctors/therapists.\n• AI acts only to summarize or explain in everyday terms — AI never modifies clinical prescriptions.\n• Adopted recommendations automatically populate your daily Pulse Adaptive Goals.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarePlanCard(
    BuildContext context,
    WidgetRef ref,
    DocTalkCarePlan plan,
    DocTalkNotifier notifier,
  ) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.medical_services_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.professionalName,
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${plan.professionalRole} • Documented ${plan.date}',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
              const PulseBadge(
                text: 'Doctor Authored',
                variant: PulseBadgeVariant.primary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              plan.summary,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Prescribed Wellbeing Recommendations',
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...plan.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRecommendationItem(context, ref, plan, rec, notifier),
              )),
          if (plan.followUpNote.isNotEmpty) ...[
            const Divider(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_repeat_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Follow-up Instruction:',
                        style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        plan.followUpNote,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context,
    WidgetRef ref,
    DocTalkCarePlan plan,
    CareRecommendation rec,
    DocTalkNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rec.adoptedAsGoal ? const Color(0xFFE8F7F4) : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: rec.adoptedAsGoal ? AppColors.primary : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PulseBadge(
                text: rec.category,
                variant: rec.adoptedAsGoal ? PulseBadgeVariant.success : PulseBadgeVariant.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.title,
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            rec.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                '${rec.durationMinutes} min • ${rec.frequency}',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
              if (rec.adoptedAsGoal)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Active Pulse Goal',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(goalsProvider.notifier).selectAlternative(
                          GoalItem(
                            id: rec.id,
                            title: rec.title,
                            description: '${rec.description} (Advised by ${plan.professionalName})',
                            category: rec.category,
                            durationMinutes: rec.durationMinutes,
                            frequency: rec.frequency,
                            isActive: true,
                          ),
                        );
                    notifier.adoptRecommendationAsGoal(plan.id, rec.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Adopted "${rec.title}" as an active Pulse Goal.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_task_outlined, size: 14),
                  label: const Text('Adopt as Goal'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlansCard(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.note_alt_outlined, size: 48, color: AppColors.outline),
            const SizedBox(height: 12),
            Text(
              'No Care Plans Available Yet',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'After your consultation, your doctor will document tailored recommendations here.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
            const SizedBox(height: 16),
            PulseButton(
              text: 'Book a Consultation on DocTalk',
              isFullWidth: false,
              onPressed: () => context.push(AppRoutes.docTalk),
            ),
          ],
        ),
      ),
    );
  }
}
