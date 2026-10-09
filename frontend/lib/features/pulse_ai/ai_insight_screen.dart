import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';

class AiInsightScreen extends StatefulWidget {
  const AiInsightScreen({super.key});

  @override
  State<AiInsightScreen> createState() => _AiInsightScreenState();
}

class _AiInsightScreenState extends State<AiInsightScreen> {
  bool _goalAdded = false;

  void _handleSetGoal() {
    setState(() => _goalAdded = true);
    ApiClient().post(
      ApiEndpoints.goalsActive,
      data: {
        'title': 'Protect 10 minutes of uninterrupted time for yourself today',
        'durationMinutes': 10,
        'category': 'Pacing',
        'frequency': 'Every day',
        'difficulty': 'Easy',
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal added — We’ll check in tonight')),
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
          'AI Insight',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'This Week',
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
                'Your wellbeing pattern',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Here’s what your recent self-reported check-ins may be gently highlighting.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildPatternCard(),
              const SizedBox(height: 20),
              _buildSignalsSummary(),
              const SizedBox(height: 20),
              _buildMeaningCard(),
              const SizedBox(height: 20),
              _buildNextSmallStepCard(),
              const SizedBox(height: 20),
              _buildWhyCard(),
              const SizedBox(height: 20),
              _buildDiscussWithDoctorCard(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatternCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF4),
      borderColor: const Color(0xFFBBF7D0),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Color(0xFF16A34A), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'We noticed a pattern',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Your stress has been higher on days when your sleep and energy were lower.',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This pattern appeared across several of your recent check-ins. When multiple routines shift together, observing the broader rhythm can help illuminate small points of balance.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalsSummary() {
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
                  'Your signals',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Past 7 days',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSignalCol('Mood', 'Okay', 'Steady', null, AppColors.primary),
              _buildSignalCol('Stress', 'High', 'Higher than usual', Icons.north, AppColors.secondary),
              _buildSignalCol('Energy', 'Low', 'Lower than usual', Icons.south, const Color(0xFFD97706)),
              _buildSignalCol('Sleep', 'Poor', 'Interrupted', Icons.south, AppColors.error),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Based on your self-reported check-ins. Daily signals for your reflection, not clinical measurements.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCol(String label, String val, String subtitle, IconData? arrow, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  val,
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (arrow != null) ...[
                const SizedBox(width: 2),
                Icon(arrow, size: 14, color: color),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildMeaningCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFFAF5FF),
      borderColor: const Color(0xFFE9D5FF),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_outlined, color: AppColors.tertiary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'What this could mean',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'When several parts of your routine change together, it can be useful to slow down and look at the pattern rather than focusing on one difficult day. Sleep and energy often act as anchors for how we perceive daily stress.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSmallStepCard() {
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
                  'Your Next Small Step',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: '10 min', variant: PulseBadgeVariant.primary),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Protect 10 minutes of uninterrupted time for yourself today.',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose something realistic rather than trying to change everything at once. Step away from work screens or pause between tasks.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          if (_goalAdded) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Goal added — We’ll check in tonight',
                      style: AppTypography.labelMedium.copyWith(color: const Color(0xFF15803D)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PulseButton(
              text: 'View Progress',
              variant: PulseButtonVariant.outlined,
              onPressed: () => context.push(AppRoutes.progress),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: PulseButton(
                    text: 'Set this as my goal',
                    onPressed: _handleSetGoal,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PulseButton(
                    text: 'Choose another',
                    variant: PulseButtonVariant.outlined,
                    onPressed: () => context.push(AppRoutes.adaptiveGoal),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWhyCard() {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.timeline_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why we’re showing you this',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Individual check-ins can be useful, but patterns over time can help you understand what affects your wellbeing and give you something meaningful to discuss with your care team.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussWithDoctorCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF8FAFC),
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.medical_services, color: AppColors.secondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Want to discuss this with care?',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Prepare notes for your next doctor check-in',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                ),
              ],
            ),
          ),
          PulseButton(
            text: 'Prepare',
            isFullWidth: false,
            variant: PulseButtonVariant.secondary,
            onPressed: () => context.push(AppRoutes.preConsult),
          ),
        ],
      ),
    );
  }
}
