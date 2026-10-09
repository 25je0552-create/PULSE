import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.go(AppRoutes.login),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Step 1 of 4',
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
                'Let’s make your care\nmore personal.',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pulse learns about your wellbeing, routines and care journey so you can get meaningful support between consultations.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'What Pulse can help you with',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureTile(
                icon: Icons.psychology_outlined,
                title: 'Understand your wellbeing patterns',
                desc: 'Reflect on daily patterns, mood, and stress shifts without judgment.',
              ),
              const SizedBox(height: 12),
              _buildFeatureTile(
                icon: Icons.spa_outlined,
                title: 'Build small, sustainable habits',
                desc: 'Gentle micro-actions designed for calm, realistic routines.',
              ),
              const SizedBox(height: 12),
              _buildFeatureTile(
                icon: Icons.connect_without_contact_outlined,
                title: 'Stay connected to your care',
                desc: 'Keep your health journey organized and shared with your provider.',
              ),
              const SizedBox(height: 12),
              _buildFeatureTile(
                icon: Icons.diversity_1_outlined,
                title: 'Know when it’s time to reach out for human support',
                desc: 'Recognize signs when a timely consultation or check-in helps most.',
              ),
              const SizedBox(height: 24),
              PulseCard(
                backgroundColor: const Color(0xFFF2FBF9),
                borderColor: const Color(0xFFBCEBE3),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.favorite_outline,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your wellbeing matters.',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your mental and emotional wellbeing are part of your overall health. Pulse helps you reflect on how you’re doing and supports you in taking the next small step.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PulseButton(
                text: 'Continue',
                onPressed: () => context.go(AppRoutes.consent),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Pulse works alongside your care team — not instead of them.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Next: Care Consent & Privacy',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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
