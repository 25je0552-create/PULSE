import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

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
          'Get Support',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Active Safety Net',
                variant: PulseBadgeVariant.error,
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
              _buildCrisisEscalationBanner(),
              const SizedBox(height: 20),
              Text(
                'You don\'t have to handle everything alone.',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'If something feels overwhelming or you don\'t feel safe, reaching out to a trusted person or qualified professional can be an important next step.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildImmediateHelplinesCard(context),
              const SizedBox(height: 20),
              _buildTrustedPersonCard(context),
              const SizedBox(height: 20),
              _buildProfessionalCareCard(context),
              const SizedBox(height: 20),
              _buildAiLimitationsCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrisisEscalationBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pause_circle_outline, color: AppColors.error, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Coaching Paused · Normal Chat Stopped',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re concerned about your safety. If you are experiencing distress, normal AI conversation steps back so you can connect directly with human and clinical resources.',
            style: AppTypography.bodySmall.copyWith(color: const Color(0xFF991B1B)),
          ),
        ],
      ),
    );
  }

  Widget _buildImmediateHelplinesCard(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFFFF7ED),
      borderColor: const Color(0xFFFED7AA),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone_in_talk, color: Color(0xFFEA580C), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Need someone right now?',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9A3412),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pulse is not an emergency service. If you may be in immediate danger, please connect with these verified resources or call emergency responders directly.',
            style: AppTypography.bodySmall.copyWith(color: const Color(0xFF7C2D12)),
          ),
          const SizedBox(height: 14),
          _buildHelplineRow('Tele-MANAS (Mental Health)', '14416', '24/7 Toll-free Govt. of India'),
          const Divider(height: 16, color: Color(0xFFFED7AA)),
          _buildHelplineRow('KIRAN Helpline', '1800-599-0019', '24/7 Multilingual Support'),
          const Divider(height: 16, color: Color(0xFFFED7AA)),
          _buildHelplineRow('National Emergency', '112', 'Immediate First Responders'),
        ],
      ),
    );
  }

  Widget _buildHelplineRow(String name, String number, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF7C2D12))),
              Text(subtitle, style: AppTypography.labelSmall.copyWith(color: const Color(0xFF9A3412), fontSize: 10)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEA580C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: AppTypography.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustedPersonCard(BuildContext context) {
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
                  'Reach someone you trust',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Trusted Circle', variant: PulseBadgeVariant.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'A friend, family member, or roommate can help you feel grounded and assist you in accessing professional care.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE0F2FE),
                child: Text('SJ', style: AppTypography.titleMedium.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sarah Jenkins',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Designated Trusted Contact · Close Friend',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                icon: const Icon(Icons.call, size: 18),
                style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling Sarah Jenkins...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Pulse will never notify contacts without your explicit tap.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCareCard(BuildContext context) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Talk to a professional',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'A qualified mental-health or healthcare professional can help you navigate what you are feeling and structure appropriate care.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.medical_services_outlined, color: AppColors.secondary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dr. Meera Sharma, MD', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                    Text('Assigned Primary Care Lead', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
              PulseButton(
                text: 'Message',
                isFullWidth: false,
                variant: PulseButtonVariant.secondary,
                onPressed: () => context.push(AppRoutes.appointments),
              ),
            ],
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () => context.push(AppRoutes.preConsult),
            child: Row(
              children: [
                const Icon(Icons.edit_note, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Prepare what I want to say',
                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiLimitationsCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF8FAFC),
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.smart_toy_outlined, color: AppColors.outline, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pulse AI has limits',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pulse AI can help you reflect and find information, but it cannot provide emergency care, diagnose, or replace a qualified professional.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
