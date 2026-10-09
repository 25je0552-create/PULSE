import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_chip.dart';
import '../../core/widgets/pulse_text_field.dart';
import 'checkin_provider.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  late final TextEditingController _reflectionController;

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController(
      text: ref.read(checkinProvider).reflection,
    );
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    ref.read(checkinProvider.notifier).setReflection(_reflectionController.text.trim());
    final success = await ref.read(checkinProvider.notifier).submitCheckin();
    if (success && mounted) {
      context.go(AppRoutes.pulseAi);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkinState = ref.watch(checkinProvider);

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
          'Daily Check-in',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: '~30 sec',
                icon: Icons.timer_outlined,
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
              PulseCard(
                backgroundColor: const Color(0xFFF0FDF9),
                borderColor: const Color(0xFF99F6E4),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.spa, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Signals • Daily Pulse',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How are you doing today?',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A quick check-in helps Pulse understand your natural rhythms and patterns over time.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCCFBF1)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.history_toggle_off, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Last time, you noted lower energy. Take whatever time you need—there are no right or wrong answers.',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildQuestionSection(
                step: 'Signal 01 · Step 1 of 4',
                title: 'How would you describe your mood right now?',
                subtitle: 'Your current self-reported emotional baseline.',
                options: ['Very low', 'Low', 'Okay', 'Good', 'Great'],
                selectedValue: checkinState.mood,
                onSelect: (val) => ref.read(checkinProvider.notifier).setMood(val),
              ),
              const SizedBox(height: 24),
              _buildQuestionSection(
                step: 'Signal 02 · Step 2 of 4',
                title: 'How stressed do you feel today?',
                subtitle: 'Perceived pressure or strain in this moment.',
                options: ['Very low', 'Low', 'Mid', 'High', 'Intense'],
                selectedValue: checkinState.stress,
                onSelect: (val) => ref.read(checkinProvider.notifier).setStress(val),
              ),
              const SizedBox(height: 24),
              _buildQuestionSection(
                step: 'Signal 03 · Step 3 of 4',
                title: 'How is your energy today?',
                subtitle: 'Your general physical and mental stamina right now.',
                options: ['Depleted', 'Low', 'Okay', 'Good', 'High'],
                selectedValue: checkinState.energy,
                onSelect: (val) => ref.read(checkinProvider.notifier).setEnergy(val),
              ),
              const SizedBox(height: 24),
              _buildQuestionSection(
                step: 'Signal 04 · Step 4 of 4',
                title: 'How did you sleep last night?',
                subtitle: 'Your restfulness and perceived recovery quality.',
                options: ['Poorly', 'Fair', 'Good', 'Very good'],
                selectedValue: checkinState.sleep,
                onSelect: (val) => ref.read(checkinProvider.notifier).setSleep(val),
              ),
              const SizedBox(height: 24),
              PulseCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Any notes or reflections today?',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optional context to help you remember what happened today.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                    ),
                    const SizedBox(height: 12),
                    PulseTextField(
                      controller: _reflectionController,
                      hintText: 'e.g. Work has been overwhelming this week.',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PulseButton(
                text: 'Save & View Pulse AI Synthesis',
                icon: Icons.auto_awesome,
                isLoading: checkinState.isSubmitting,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: 10),
              PulseButton(
                text: 'Go to Wellbeing Space',
                variant: PulseButtonVariant.outlined,
                icon: Icons.spa_outlined,
                onPressed: () => context.push(AppRoutes.wellbeing),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection({
    required String step,
    required String title,
    required String subtitle,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelect,
  }) {
    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PulseBadge(
            text: step,
            variant: PulseBadgeVariant.neutral,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final isSelected = selectedValue == opt;
              return PulseChip(
                label: opt,
                isSelected: isSelected,
                onTap: () => onSelect(opt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
