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
import '../../core/widgets/pulse_chip.dart';

class BaselineScreen extends StatefulWidget {
  const BaselineScreen({super.key});

  @override
  State<BaselineScreen> createState() => _BaselineScreenState();
}

class _BaselineScreenState extends State<BaselineScreen> {
  final Set<String> _selectedReasons = {
    'Mental wellbeing',
    'Stress & emotional balance',
    'Sleep',
    'Ongoing health condition',
  };

  String _selectedPriority = 'Manage stress better';
  String _professionalCare = 'Yes';
  String _providerType = 'Doctor';

  final Set<String> _supportModes = {
    'Daily check-ins',
    'Small habit suggestions',
    'Understand my patterns',
    'Prepare for appointments',
  };

  bool _isSaving = false;

  Future<void> _handleContinue() async {
    setState(() => _isSaving = true);
    try {
      await ApiClient().post(
        ApiEndpoints.patientBaseline,
        data: {
          'conditions': _selectedReasons.toList(),
          'supportGoals': [_selectedPriority],
          'receivingProfessionalCare': _professionalCare == 'Yes',
          'providers': [_providerType],
          'supportPreferences': _supportModes.toList(),
        },
      );
    } catch (_) {
    }

    if (mounted) {
      setState(() => _isSaving = false);
      context.go(AppRoutes.connectDoctor);
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
          onPressed: () => context.go(AppRoutes.consent),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Step 3 of 4',
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
                'Tell us what you’d like support with.',
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose what matters most to you right now. You can change this anytime.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                '1. What brings you to Pulse?',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select multiple',
                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Mental wellbeing',
                  'Stress & emotional balance',
                  'Sleep',
                  'Lifestyle & daily habits',
                  'Ongoing health condition',
                  'Support between consultations',
                  'Something else',
                ].map((reason) {
                  final isSelected = _selectedReasons.contains(reason);
                  return PulseChip(
                    label: reason,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedReasons.remove(reason);
                        } else {
                          _selectedReasons.add(reason);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              Text(
                '2. What would you most like to improve?',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose 1',
                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Feel more emotionally balanced',
                  'Manage stress better',
                  'Improve my sleep',
                  'Build healthier routines',
                  'Stay consistent with my care',
                  'Understand my health patterns',
                ].map((priority) {
                  final isSelected = _selectedPriority == priority;
                  return PulseChip(
                    label: priority,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              Text(
                '3. Are you currently receiving professional care?',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Yes', 'Not currently', 'Prefer not to say'].map((opt) {
                  final isSelected = _professionalCare == opt;
                  return PulseChip(
                    label: opt,
                    isSelected: isSelected,
                    onTap: () => setState(() => _professionalCare = opt),
                  );
                }).toList(),
              ),
              if (_professionalCare == 'Yes') ...[
                const SizedBox(height: 16),
                Text(
                  'Who supports your care? (Optional)',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Doctor',
                    'Psychologist / therapist',
                    'Psychiatrist',
                    'Other healthcare professional',
                  ].map((p) {
                    final isSelected = _providerType == p;
                    return PulseChip(
                      label: p,
                      isSelected: isSelected,
                      onTap: () => setState(() => _providerType = p),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 28),
              Text(
                '4. How would you like Pulse to support you?',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select multiple',
                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Daily check-ins',
                  'Small habit suggestions',
                  'Understand my patterns',
                  'Educational content',
                  'Prepare for appointments',
                  'Stay connected with care',
                ].map((mode) {
                  final isSelected = _supportModes.contains(mode);
                  return PulseChip(
                    label: mode,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _supportModes.remove(mode);
                        } else {
                          _supportModes.add(mode);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              PulseCard(
                backgroundColor: const Color(0xFFFFFBEB),
                borderColor: const Color(0xFFFDE68A),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pulse is here for ongoing support.',
                            style: AppTypography.titleMedium.copyWith(
                              color: const Color(0xFF92400E),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'If you\'re experiencing an urgent mental or physical health situation, please contact an appropriate healthcare professional or emergency service.',
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF78350F),
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
                isLoading: _isSaving,
                onPressed: _handleContinue,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'You can update these preferences later.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
