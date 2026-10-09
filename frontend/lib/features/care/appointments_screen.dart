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

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _questionController = TextEditingController();
  final List<String> _questions = [
    'Ask about recent sleep fragmentation and 10 AM energy dips',
  ];
  bool _showLogistics = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    final text = _questionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _questions.add(text);
        _questionController.clear();
      });
      ApiClient().post(
        ApiEndpoints.appointmentQuestions,
        data: {'question': text},
      );
    }
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
          'Your Care Schedule',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: '5 days to go',
                variant: PulseBadgeVariant.primary,
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
                'Stay prepared for the conversations that matter.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              _buildUpcomingCard(),
              const SizedBox(height: 16),
              PulseButton(
                text: 'Find a doctor or therapist on DocTalk',
                icon: Icons.search,
                variant: PulseButtonVariant.outlined,
                onPressed: () => context.push(AppRoutes.docTalk),
              ),
              const SizedBox(height: 20),
              _buildUsefulConsultationCard(),
              const SizedBox(height: 20),
              _buildQuestionsCard(),
              const SizedBox(height: 20),
              _buildPastConsultationsCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard() {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: PulseBadge(text: 'UPCOMING · CONFIRMED', variant: PulseBadgeVariant.success)),
              const SizedBox(width: 8),
              Text('45 min', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Routine Consultation',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.event_available, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Thursday, 24 September 2026 • 11:30 AM',
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Dr. Meera Sharma, Partner · Integrated Family Medicine',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PulseButton(
                  text: 'Prepare for consultation',
                  onPressed: () => context.push(AppRoutes.preConsult),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => setState(() => _showLogistics = !_showLogistics),
            icon: Icon(_showLogistics ? Icons.expand_less : Icons.expand_more, size: 18),
            label: Text(
              _showLogistics ? 'Hide logistics' : 'View appointment logistics',
              style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
            ),
          ),
          if (_showLogistics) ...[
            const Divider(height: 16, color: AppColors.cardBorder),
            _buildLogisticsDetail('Provider:', 'Dr. Meera Sharma, MD'),
            _buildLogisticsDetail('Format:', 'Routine Review & Care Plan Check-in'),
            _buildLogisticsDetail('Venue:', 'St. Jude Health Center (Suite 304)'),
            _buildLogisticsDetail('Telehealth Link:', 'Ready 15m before visit'),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Reschedule', style: AppTypography.labelMedium.copyWith(color: AppColors.secondary)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Cancel visit', style: AppTypography.labelMedium.copyWith(color: AppColors.error)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogisticsDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
          ),
          Expanded(
            child: Text(value, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          ),
        ],
      ),
    );
  }

  Widget _buildUsefulConsultationCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF9),
      borderColor: const Color(0xFF99F6E4),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_alt_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Make your consultation more useful',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Synthesize your recent sleep logs, mood signals, and milestones into a 1-page clinical brief.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 14, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Private until approved: You review, annotate, and approve your 1-page digest before anything is shared with Dr. Sharma.',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PulseButton(
            text: 'Prepare my summary digest',
            icon: Icons.arrow_forward,
            onPressed: () => context.push(AppRoutes.preConsult),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsCard() {
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
                  'Questions for your consultation',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.edit_note, color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Keep track of topics or side effects so nothing is lost in the moment.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 12),
          ..._questions.map((q) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(q, style: AppTypography.bodySmall.copyWith(color: AppColors.onSurface)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: AppColors.outline),
                      onPressed: () => setState(() => _questions.remove(q)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: PulseTextField(
                  controller: _questionController,
                  hintText: 'Add a question for Dr. Sharma...',
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.add, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: _addQuestion,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Personal visit notes. Pulse does not route these to emergency responders.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildPastConsultationsCard() {
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
                  'Past consultations',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Archived (1)',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('12 SEPTEMBER 2026', style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Completed', variant: PulseBadgeVariant.neutral),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Follow-up · Dr. Meera Sharma',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Care Plan v2.4 adjustments & magnesium telemetry review',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
