import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset(
            'assets/images/pulse_icon_transparent.png',
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Patient Home',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Pulse Health',
              style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.health_and_safety_outlined, color: AppColors.error),
            onPressed: () => context.push(AppRoutes.safety),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).fetchHomeData(),
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeState.greeting,
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                homeState.subgreeting,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildCheckInPromptCard(context),
              const SizedBox(height: 20),
              _buildPulseTodayCard(homeState.pulseToday),
              const SizedBox(height: 20),
              _buildNextSmallStepCard(context, homeState.nextSmallStep),
              const SizedBox(height: 20),
              _buildProgressCard(context, homeState.progressSummary),
              const SizedBox(height: 20),
              _buildCareTeamCard(context, homeState.careTeamStatus),
              const SizedBox(height: 20),
              _buildAwarenessCard(context, homeState.recommendedAwareness),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInPromptCard(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF9),
      borderColor: const Color(0xFF99F6E4),
      padding: const EdgeInsets.all(20),
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.spa, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              const PulseBadge(
                text: '30-second daily check-in',
                variant: PulseBadgeVariant.primary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'How are you doing today?',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Take a moment to check in with yourself. Reflecting helps build understanding between visits.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          PulseButton(
            text: 'Check in',
            icon: Icons.arrow_forward,
            onPressed: () => context.push(AppRoutes.checkin),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseTodayCard(Map<String, dynamic> pulse) {
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
                  'Your Pulse today',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'User-reported signals',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.info_outline, size: 14, color: AppColors.outline),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSignalTile(
                  icon: Icons.sentiment_satisfied_alt_outlined,
                  label: 'Mood',
                  value: pulse['mood'] ?? 'Okay',
                  detail: pulse['moodDetail'] ?? 'Logged 8:30 AM',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSignalTile(
                  icon: Icons.waves,
                  label: 'Stress',
                  value: pulse['stress'] ?? 'Moderate',
                  detail: pulse['stressDetail'] ?? 'Steady',
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSignalTile(
                  icon: Icons.bolt_outlined,
                  label: 'Energy',
                  value: pulse['energy'] ?? 'Low',
                  detail: pulse['energyDetail'] ?? 'Needs rest',
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Self-reported daily signals for your personal reflection — not clinical assessments.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalTile({
    required IconData icon,
    required String label,
    required String value,
    required String detail,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSmallStepCard(BuildContext context, Map<String, dynamic> step) {
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
                  'Your next small step',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: PulseBadge(
                  text: step['category'] ?? 'General wellbeing routine',
                  variant: PulseBadgeVariant.neutral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            step['title'] ?? 'Take a 10-minute walk today.',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            step['description'] ?? 'Small actions are easier to sustain without pressure.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => context.push(AppRoutes.adaptiveGoal),
            child: Row(
              children: [
                Text(
                  'View plan',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, Map<String, dynamic> prog) {
    final weekDays = (prog['weekDays'] as List<dynamic>?) ?? [];

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
                  'Your progress',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => context.push(AppRoutes.progress),
                child: Text(
                  'View progress →',
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
            '${prog['checkinsThisWeek'] ?? 4} check-ins this week',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            prog['message'] ?? 'Keep building your pattern.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((d) {
              final day = d['day'] ?? '';
              final done = d['completed'] == true;
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? AppColors.primary : AppColors.surfaceContainerLow,
                    ),
                    child: Center(
                      child: Icon(
                        done ? Icons.check : Icons.circle,
                        size: done ? 18 : 6,
                        color: done ? Colors.white : AppColors.outlineVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    day,
                    style: AppTypography.labelSmall.copyWith(
                      color: done ? AppColors.primary : AppColors.outline,
                      fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTeamCard(BuildContext context, Map<String, dynamic> care) {
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
                  'Your care team',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(
                text: 'Connected ✓',
                variant: PulseBadgeVariant.success,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${care['doctorName'] ?? 'Dr. Meera Sharma'}',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Your progress can help make your next conversation more useful.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              InkWell(
                onTap: () => context.push(AppRoutes.care),
                child: Text(
                  'View care →',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              InkWell(
                onTap: () => context.push(AppRoutes.records),
                child: Text(
                  'Health records →',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              InkWell(
                onTap: () => context.push(AppRoutes.family),
                child: Text(
                  'Family Circle →',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAwarenessCard(BuildContext context, Map<String, dynamic> awareness) {
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
                  'Learn something useful',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(
                text: 'Recommended',
                variant: PulseBadgeVariant.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Text(
                  awareness['category'] ?? 'Mental wellbeing',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text('•', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
              const SizedBox(width: 8),
              Text(
                awareness['duration'] ?? '4 min read',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            awareness['title'] ?? 'Understanding stress and your body',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () => context.push('/patient/awareness/${awareness['id'] ?? 'aware_1'}'),
            child: Row(
              children: [
                Text(
                  'Explore awareness',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
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
}
