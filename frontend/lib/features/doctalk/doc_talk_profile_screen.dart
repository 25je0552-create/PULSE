import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_card.dart';
import 'doctalk_provider.dart';

class DocTalkProfileScreen extends ConsumerWidget {
  final String? professionalId;

  const DocTalkProfileScreen({super.key, this.professionalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(docTalkProvider);
    final notifier = ref.read(docTalkProvider.notifier);

    HealthcareProfessional? pro = state.selectedProfessional;
    if (pro == null && professionalId != null) {
      pro = state.professionals.cast<HealthcareProfessional?>().firstWhere(
            (p) => p?.id == professionalId,
            orElse: () => state.professionals.isNotEmpty ? state.professionals.first : null,
          );
    }
    pro ??= state.professionals.first;

    final isOfferEligible = state.offerEligible;

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
          'Professional Profile',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context, pro),
              const SizedBox(height: 20),
              _buildCredentialsSection(pro),
              const SizedBox(height: 20),
              _buildBiographySection(pro),
              const SizedBox(height: 20),
              _buildConsultationModesCard(pro),
              const SizedBox(height: 20),
              _buildFeeAndOfferSummary(pro, isOfferEligible),
              const SizedBox(height: 20),
              _buildAvailabilityPreviewCard(context, pro, notifier),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        notifier.selectProfessional(pro!);
                        context.push('${AppRoutes.docTalkBooking}/${pro.id}');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'View availability',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        notifier.selectProfessional(pro!);
                        context.push('${AppRoutes.docTalkBooking}/${pro.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Book consultation',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, HealthcareProfessional pro) {
    return PulseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              pro.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  pro.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              if (pro.isVerified) ...[
                const SizedBox(width: 6),
                const Icon(Icons.verified, color: AppColors.primary, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            pro.role,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            pro.clinicOrOrg,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Experience', '${pro.experienceYears} Years'),
              Container(width: 1, height: 32, color: AppColors.divider),
              _buildStatItem('Languages', pro.languages.take(2).join(', ')),
              Container(width: 1, height: 32, color: AppColors.divider),
              _buildStatItem('Format', '${pro.modes.length} Modes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
        ),
      ],
    );
  }

  Widget _buildCredentialsSection(HealthcareProfessional pro) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Qualifications & Credentials',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.school_outlined, size: 20, color: AppColors.outline),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pro.qualification,
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pro.verificationNote,
                        style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Specialties',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: pro.specialties
                .map((s) => PulseBadge(text: s, variant: PulseBadgeVariant.secondary))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBiographySection(HealthcareProfessional pro) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Biography',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            pro.bio,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationModesCard(HealthcareProfessional pro) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Consultation Formats',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...pro.modes.map((m) {
            IconData icon = Icons.videocam_outlined;
            if (m.toLowerCase().contains('audio')) icon = Icons.phone_in_talk_outlined;
            if (m.toLowerCase().contains('clinic')) icon = Icons.local_hospital_outlined;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 18, color: AppColors.secondary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    m,
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Text(
                    'Supported',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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

  Widget _buildFeeAndOfferSummary(HealthcareProfessional pro, bool isOfferEligible) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Standard Consultation Fee',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '₹${pro.fee.toInt()}',
                style: TextStyle(
                  decoration: isOfferEligible ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w600,
                  color: isOfferEligible ? AppColors.outline : AppColors.onSurface,
                ),
              ),
            ],
          ),
          if (isOfferEligible) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'First Consultation Offer',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '- ₹${pro.fee.toInt()} (100% OFF)',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payable Amount',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '₹0 (Complimentary)',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvailabilityPreviewCard(
    BuildContext context,
    HealthcareProfessional pro,
    DocTalkNotifier notifier,
  ) {
    final slots = pro.availableSlots.where((s) => !s.isBooked).toList();

    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Available Slots',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${slots.length} open',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (slots.isEmpty)
            Text(
              'No upcoming slots available this week.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppColors.outline),
                      const SizedBox(width: 6),
                      Text(
                        '${s.date} • ${s.time}',
                        style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
