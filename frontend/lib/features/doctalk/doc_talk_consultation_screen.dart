import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_card.dart';
import 'doctalk_provider.dart';

class DocTalkConsultationScreen extends ConsumerWidget {
  final String? appointmentId;

  const DocTalkConsultationScreen({super.key, this.appointmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(docTalkProvider);
    final notifier = ref.read(docTalkProvider.notifier);

    DocTalkAppointment? appt = state.lastBookedAppointment;
    if (appointmentId != null) {
      appt = state.appointments.cast<DocTalkAppointment?>().firstWhere(
            (a) => a?.id == appointmentId,
            orElse: () => state.appointments.isNotEmpty ? state.appointments.first : null,
          );
    }
    appt ??= (state.appointments.isNotEmpty ? state.appointments.first : state.lastBookedAppointment);

    if (appt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Consultation Details')),
        body: const Center(child: Text('Appointment not found.')),
      );
    }

    final isCancelled = appt.status == 'Cancelled';

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
          'Consultation Session',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(appt),
              const SizedBox(height: 16),
              _buildDoctorCard(appt),
              const SizedBox(height: 16),
              _buildLogisticsCard(appt),
              const SizedBox(height: 16),
              _buildVirtualRoomPlaceholder(appt, isCancelled),
              const SizedBox(height: 16),
              if (appt.questions.isNotEmpty) _buildQuestionsCard(appt),
              const SizedBox(height: 20),
              if (!isCancelled) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showRescheduleDialog(context, appt!, notifier),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.secondary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Reschedule',
                          style: AppTypography.labelLarge.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showCancelDialog(context, appt!, notifier),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Cancel Session',
                          style: AppTypography.labelLarge.copyWith(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(DocTalkAppointment appt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appt.title,
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              'DocTalk Verified Session',
              style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        PulseBadge(
          text: appt.status,
          variant: appt.status == 'Cancelled'
              ? PulseBadgeVariant.error
              : PulseBadgeVariant.success,
        ),
      ],
    );
  }

  Widget _buildDoctorCard(DocTalkAppointment appt) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              appt.doctorName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt.doctorName,
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  appt.organization,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogisticsCard(DocTalkAppointment appt) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_today_outlined, 'Date', appt.date),
          const Divider(height: 16),
          _buildInfoRow(Icons.access_time_outlined, 'Time', '${appt.time} (${appt.duration})'),
          const Divider(height: 16),
          _buildInfoRow(Icons.videocam_outlined, 'Format', appt.format),
          const Divider(height: 16),
          _buildInfoRow(
            Icons.receipt_long_outlined,
            'Consultation Fee',
            appt.finalFee == 0 ? '₹0 (Introductory Offer Applied)' : '₹${appt.finalFee.toInt()}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.outline),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildVirtualRoomPlaceholder(DocTalkAppointment appt, bool isCancelled) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCancelled ? AppColors.surfaceContainerLow : const Color(0xFFF0FAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCancelled ? AppColors.cardBorder : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sensors_rounded,
                color: isCancelled ? AppColors.outline : AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Telehealth Virtual Room',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isCancelled ? AppColors.outline : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isCancelled
                ? 'This session has been cancelled. No room will be generated.'
                : 'Session placeholder: The encrypted room link unlocks 10 minutes prior to ${appt.time} on ${appt.date}. No simulated connection is active until the appointed consultation.',
            style: AppTypography.bodySmall.copyWith(
              color: isCancelled ? AppColors.outline : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: isCancelled ? null : () {},
            icon: const Icon(Icons.meeting_room_outlined, size: 18),
            label: const Text('Join Room (Opens 10m Prior)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCancelled ? Colors.grey : AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsCard(DocTalkAppointment appt) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Notes Shared with Doctor',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...appt.questions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.w700)),
                    Expanded(
                      child: Text(
                        q,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    DocTalkAppointment appt,
    DocTalkNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Cancel Consultation?'),
        content: Text('Are you sure you want to cancel your session with ${appt.doctorName}? The reserved slot will be freed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Session'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.cancelAppointment(appt.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Confirm Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    DocTalkAppointment appt,
    DocTalkNotifier notifier,
  ) {
    final dateCtrl = TextEditingController(text: '2026-10-12');
    final timeCtrl = TextEditingController(text: '03:00 PM');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Reschedule Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(labelText: 'New Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: 'New Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              notifier.rescheduleAppointment(appt.id, dateCtrl.text.trim(), timeCtrl.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: Colors.white),
            child: const Text('Save New Time'),
          ),
        ],
      ),
    );
  }
}
