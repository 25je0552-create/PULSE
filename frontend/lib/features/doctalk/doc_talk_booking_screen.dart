import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_text_field.dart';
import 'doctalk_provider.dart';

class DocTalkBookingScreen extends ConsumerStatefulWidget {
  final String? professionalId;

  const DocTalkBookingScreen({super.key, this.professionalId});

  @override
  ConsumerState<DocTalkBookingScreen> createState() => _DocTalkBookingScreenState();
}

class _DocTalkBookingScreenState extends ConsumerState<DocTalkBookingScreen> {
  final _reasonController = TextEditingController();
  bool _sharePreConsultSummary = true;
  bool _shareHealthRecords = false;
  bool _applyOffer = true;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmBooking(HealthcareProfessional pro) async {
    final notifier = ref.read(docTalkProvider.notifier);

    final success = await notifier.bookAppointment(
      reason: _reasonController.text.trim(),
      sharePreConsultSummary: _sharePreConsultSummary,
      applyIntroductoryOffer: _applyOffer,
    );

    if (success && mounted) {
      final lastAppt = ref.read(docTalkProvider).lastBookedAppointment;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Consultation Confirmed',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your session with ${pro.name} has been booked.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time: ${ref.read(docTalkProvider).selectedSlot?.date ?? ''} at ${ref.read(docTalkProvider).selectedSlot?.time ?? ''}',
                      style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mode: ${ref.read(docTalkProvider).selectedBookingMode}',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Demo payment status: Simulated 0-cost onboarding voucher applied.',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (lastAppt != null) {
                  context.push('${AppRoutes.docTalkConsultation}/${lastAppt.id}');
                } else {
                  context.push(AppRoutes.appointments);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View Appointment Details'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(docTalkProvider);
    final notifier = ref.read(docTalkProvider.notifier);

    HealthcareProfessional? pro = state.selectedProfessional;
    if (pro == null && widget.professionalId != null) {
      pro = state.professionals.cast<HealthcareProfessional?>().firstWhere(
            (p) => p?.id == widget.professionalId,
            orElse: () => state.professionals.isNotEmpty ? state.professionals.first : null,
          );
    }
    pro ??= state.professionals.first;

    final openSlots = pro.availableSlots.where((s) => !s.isBooked).toList();
    final isOfferEligible = state.offerEligible;
    final totalPayable = (_applyOffer && isOfferEligible) ? 0.0 : pro.fee;

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
          'Book Consultation',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProSummaryCard(pro),
              const SizedBox(height: 20),
              Text(
                '1. Select Appointment Slot',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              if (openSlots.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('No appointment slots currently available for this professional.'),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: openSlots.map((slot) {
                    final isSelected = state.selectedSlot?.id == slot.id;
                    return InkWell(
                      onTap: () => notifier.selectSlot(slot),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.cardBorder,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.date,
                              style: AppTypography.labelSmall.copyWith(
                                color: isSelected ? Colors.white70 : AppColors.outline,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              slot.time,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24),
              Text(
                '2. Consultation Mode',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: pro.modes.map((mode) {
                  final isSelected = state.selectedBookingMode == mode;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => notifier.selectBookingMode(mode),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFEBF5FC) : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.secondary : AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                mode.toLowerCase().contains('audio')
                                    ? Icons.phone_in_talk_outlined
                                    : (mode.toLowerCase().contains('clinic')
                                        ? Icons.local_hospital_outlined
                                        : Icons.videocam_outlined),
                                color: isSelected ? AppColors.secondary : AppColors.outline,
                                size: 20,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                mode.replaceAll(' Consultation', ''),
                                textAlign: TextAlign.center,
                                style: AppTypography.labelSmall.copyWith(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? AppColors.secondary : AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                '3. Reason for Consultation (Optional)',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              PulseTextField(
                controller: _reasonController,
                hintText: 'e.g. Discuss recent sleep fragmentation, stress levels, or routine adjustments',
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Text(
                '4. Patient Data Sharing Consent',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Pulse never shares your clinical information automatically. You choose what context to provide.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 10),
              PulseCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _sharePreConsultSummary,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _sharePreConsultSummary = val ?? true),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Share Pre-Consult Summary',
                                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Includes recent check-in patterns and questions for Dr/Therapist review.',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _shareHealthRecords,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _shareHealthRecords = val ?? false),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Share Uploaded Lab Reports',
                                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Attaches verified PDF reports from your Health Records vault.',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline, size: 16, color: AppColors.outline),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Private by default: Family Circle members do not gain access to this consultation.',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '5. Pricing & Offer Summary',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Consultation Fee (45 min)'),
                        Text(
                          '₹${pro.fee.toInt()}',
                          style: TextStyle(
                            decoration: (isOfferEligible && _applyOffer) ? TextDecoration.lineThrough : null,
                            color: (isOfferEligible && _applyOffer) ? AppColors.outline : AppColors.onSurface,
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
                              Checkbox(
                                value: _applyOffer,
                                activeColor: AppColors.primary,
                                onChanged: (val) => setState(() => _applyOffer = val ?? true),
                              ),
                              Text(
                                'First Consult Voucher (100% OFF)',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '- ₹${pro.fee.toInt()}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Final Payable Total',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '₹${totalPayable.toInt()} (Simulated)',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: totalPayable == 0 ? AppColors.primary : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state.error != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              PulseButton(
                text: 'Confirm & Book Consultation',
                isLoading: state.isBooking,
                onPressed: state.selectedSlot != null ? () => _handleConfirmBooking(pro!) : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProSummaryCard(HealthcareProfessional pro) {
    return PulseCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              pro.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pro.name,
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  pro.role,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  pro.clinicOrOrg,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
