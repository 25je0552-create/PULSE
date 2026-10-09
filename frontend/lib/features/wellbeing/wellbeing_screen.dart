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
import '../../core/widgets/pulse_text_field.dart';

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({super.key});

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  final _reflectionController = TextEditingController(
    text: 'I\'ve been feeling overwhelmed with work lately.',
  );
  bool _saved = false;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _saveReflection() {
    setState(() => _saved = true);
    ApiClient().post(
      ApiEndpoints.wellbeingReflection,
      data: {'text': _reflectionController.text.trim()},
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved locally and kept private.')),
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
          'Wellbeing',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.health_and_safety_outlined, color: AppColors.error),
            onPressed: () => context.push(AppRoutes.safety),
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
              Text(
                'SIGNAL · REFLECTION · SUPPORT',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Take a moment to check in with yourself.',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _buildHeroBreathingCard(context),
              const SizedBox(height: 20),
              _buildRecentWellbeingCard(),
              const SizedBox(height: 20),
              _buildReflectionCard(),
              const SizedBox(height: 20),
              _buildNoticingCard(context),
              const SizedBox(height: 20),
              _buildAdaptiveStepCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBreathingCard(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF9),
      borderColor: const Color(0xFF99F6E4),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.spa, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Calm breathing space',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'How are you really doing?',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Your wellbeing can change from day to day. There’s no right answer here.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PulseButton(
                  text: 'Check in (~30 sec)',
                  icon: Icons.arrow_forward,
                  onPressed: () => context.push(AppRoutes.checkin),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentWellbeingCard() {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your recent wellbeing',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on your recent self-reported check-ins. No clinical scores calculated.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetricItem('Mood', 'Okay', 'Gentle baseline', Icons.sentiment_satisfied_alt_outlined, AppColors.primary),
              _buildMetricItem('Stress', 'Moderate', 'Evening indicator', Icons.waves, AppColors.secondary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricItem('Energy', 'Low', 'Resting phase', Icons.bolt_outlined, const Color(0xFFD97706)),
              _buildMetricItem('Sleep', 'Needs attention', 'Interrupted rhythm', Icons.bedtime_outlined, AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
            Text(value, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            Text(sub, style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionCard() {
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
                  'Take a moment',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Private', variant: PulseBadgeVariant.neutral),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Is there something on your mind today?',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 12),
          PulseTextField(
            controller: _reflectionController,
            maxLines: 3,
            hintText: 'Record a private reflection...',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 14, color: AppColors.outline),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Only share what you\'re comfortable sharing. Reflections stay private and unshared by default.',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PulseButton(
            text: _saved ? 'Reflection saved locally ✓' : 'Save reflection',
            variant: _saved ? PulseButtonVariant.secondary : PulseButtonVariant.primary,
            onPressed: _saveReflection,
          ),
        ],
      ),
    );
  }

  Widget _buildNoticingCard(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF4),
      borderColor: const Color(0xFFBBF7D0),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: Color(0xFF16A34A), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'What you\'ve been noticing',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF166534)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your recent check-ins show higher stress on days when your sleep was lower.',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Patterns can take time to become clear. Observing connections helps you explore rhythms without self-judgment.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => context.push(AppRoutes.progress),
            child: Row(
              children: [
                Text(
                  'View my progress',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptiveStepCard(BuildContext context) {
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
                  'Adaptive Micro-Step',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: '10 min', variant: PulseBadgeVariant.primary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Take 10 quiet minutes away from your screen today.',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose something that feels realistic, not perfect. No streak pressure.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PulseButton(
                  text: 'Try this',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Scheduled 10-minute quiet pause.')),
                    );
                  },
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
      ),
    );
  }
}
