import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import 'care_provider.dart';

class PreConsultSummaryScreen extends ConsumerStatefulWidget {
  const PreConsultSummaryScreen({super.key});

  @override
  ConsumerState<PreConsultSummaryScreen> createState() => _PreConsultSummaryScreenState();
}

class _PreConsultSummaryScreenState extends ConsumerState<PreConsultSummaryScreen> {
  bool _isApproved = false;

  void _handleApprove() {
    setState(() => _isApproved = true);
    ref.read(careProvider.notifier).approveSummary();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary approved and ready for Dr. Sharma.')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Pre-consult Summary',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: _isApproved ? 'Approved ✓' : 'Private draft',
                variant: _isApproved ? PulseBadgeVariant.success : PulseBadgeVariant.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STAGE 05 · HUMAN REVIEW PREP',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Your recent story',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Pulse organized your recent check-ins, goals, and rhythms into a clear briefing for your clinician. You hold complete ownership of what is included.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildUpcomingDigestHeaderCard(),
              const SizedBox(height: 20),
              _buildWellbeingAtAGlanceCard(),
              const SizedBox(height: 20),
              _buildWhatYouveNoticedCard(),
              const SizedBox(height: 20),
              _buildRecentSignalsCard(),
              const SizedBox(height: 20),
              _buildQuestionsForConsultationCard(),
              const SizedBox(height: 24),
              if (_isApproved) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Summary approved! This 1-page digest will be accessible to Dr. Meera Sharma during your 24 Sep consultation.',
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFF166534),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PulseButton(
                  text: 'Return to Care',
                  variant: PulseButtonVariant.outlined,
                  onPressed: () => context.go(AppRoutes.care),
                ),
              ] else ...[
                PulseButton(
                  text: 'Approve & Share with Dr. Sharma',
                  icon: Icons.check_circle_outline,
                  onPressed: _handleApprove,
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingDigestHeaderCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF6F8FF),
      borderColor: const Color(0xFFD4DCFD),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: PulseBadge(text: '1-Page Digest', variant: PulseBadgeVariant.tertiary)),
              const SizedBox(width: 8),
              Flexible(child: Text('UPCOMING CONSULTATION', style: AppTypography.labelSmall.copyWith(color: AppColors.outline), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Dr. Meera Sharma',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            'Primary Care · Integrated Family Medicine',
            style: AppTypography.bodySmall.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Thursday, 24 Sep 2026 · 11:30 AM (45 min)',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWellbeingAtAGlanceCard() {
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
                  'Your wellbeing at a glance',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text('30d review', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Self-reported over the last 30 days',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetricTile('6', 'Check-ins logged'),
              const SizedBox(width: 8),
              _buildMetricTile('2', 'Active goals'),
              const SizedBox(width: 8),
              _buildMetricTile('1', 'Pattern noticed'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Synthesized strictly from your personal check-ins. No clinical scores calculated.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(count, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline)),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatYouveNoticedCard() {
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
                  'What you\'ve noticed',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Self-reported', variant: PulseBadgeVariant.neutral),
            ],
          ),
          const SizedBox(height: 14),
          _buildNoticeItem(
            icon: Icons.sync_alt,
            title: 'Stress & sleep cadence',
            desc: 'You reported higher stress on days when sleep duration was lower. Reflects self-logged entries between 12 Sep and 22 Sep. Highlights personal rhythm without asserting clinical cause.',
          ),
          const SizedBox(height: 12),
          _buildNoticeItem(
            icon: Icons.nature_people_outlined,
            title: 'Screen rest habit',
            desc: 'Your energy was reported higher on days you took your 10-minute work screen pause. Correlates with your afternoon recharge moments.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(desc, style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSignalsCard() {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent signals',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            'Self-reported baseline trends • No composite score',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 14),
          _buildSignalItem('Mood', 'Mostly okay', 'Steady baseline', Icons.sentiment_satisfied_alt_outlined, AppColors.primary),
          const SizedBox(height: 8),
          _buildSignalItem('Stress', 'Higher than usual', 'Evening peaks noted', Icons.waves, AppColors.secondary),
          const SizedBox(height: 8),
          _buildSignalItem('Energy', 'Improving', 'Morning rebound', Icons.bolt_outlined, const Color(0xFFD97706)),
          const SizedBox(height: 8),
          _buildSignalItem('Sleep', 'Needs attention', 'Interrupted rest', Icons.bedtime_outlined, AppColors.error),
        ],
      ),
    );
  }

  Widget _buildSignalItem(String label, String value, String note, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        SizedBox(
          width: 55,
          child: Text(label, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            note,
            textAlign: TextAlign.end,
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsForConsultationCard() {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions for your consultation',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _buildQuestionBullet('Ask about recent sleep fragmentation and 10 AM energy dips'),
          const SizedBox(height: 8),
          _buildQuestionBullet('Should we adjust afternoon meal timing?'),
        ],
      ),
    );
  }

  Widget _buildQuestionBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.circle, size: 6, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.onSurface)),
        ),
      ],
    );
  }
}
