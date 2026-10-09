import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _consentPersonalize = true;
  bool _consentNotReplacement = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.go(AppRoutes.onboarding),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Step 2 of 4',
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
                'Consent & Privacy',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your health information stays in your control.',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pulse uses the information you choose to share to personalize your care experience and help you stay connected between consultations.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'What Pulse may use',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildUsageRow(Icons.spa_outlined, 'Your wellbeing check-ins', 'Daily reflections, mood & pacing'),
              _buildUsageRow(Icons.description_outlined, 'Health and care information you choose to share', 'Consult summaries, notes & symptoms you log'),
              _buildUsageRow(Icons.track_changes_outlined, 'Your goals and daily routines', 'Gentle pacing micro-habits & milestones'),
              _buildUsageRow(Icons.chat_bubble_outline, 'Your interactions with Pulse', 'Reflections and educational queries'),
              const SizedBox(height: 20),
              PulseCard(
                backgroundColor: const Color(0xFFF6F8FF),
                borderColor: const Color(0xFFD4DCFD),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You’re in control',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You choose what information you share. You can review your privacy choices and manage access anytime from your profile.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.outline, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pulse does not replace your doctor, therapist, or emergency services.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Required Patient Consents',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                value: _consentPersonalize,
                onChanged: (val) {
                  setState(() {
                    _consentPersonalize = val ?? false;
                  });
                },
                title: Text(
                  'I agree to Pulse using the information I provide to personalize my care experience.',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                value: _consentNotReplacement,
                onChanged: (val) {
                  setState(() {
                    _consentNotReplacement = val ?? false;
                  });
                },
                title: Text(
                  'I understand that Pulse is not a replacement for professional medical or mental-health care.',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PulseButton(
                text: 'Agree & Continue',
                onPressed: (_consentPersonalize && _consentNotReplacement)
                    ? () => context.go(AppRoutes.baseline)
                    : null,
              ),
              const SizedBox(height: 24),
              _buildPrivacyCommitments(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCommitments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Commitments',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _buildCommitmentItem(
          'We Never Sell Your Health Data',
          'Your wellbeing logs, reflections, and routine records are never sold to advertisers or third-party data brokers.',
        ),
        _buildCommitmentItem(
          'Patient Deletion Rights',
          'You can export or request full deletion of your recorded information directly in your profile settings.',
        ),
        _buildCommitmentItem(
          'Secure Transmission & Storage',
          'All data is safeguarded in transit and storage using industry-standard health-grade cryptographic protocols.',
        ),
      ],
    );
  }

  Widget _buildCommitmentItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
