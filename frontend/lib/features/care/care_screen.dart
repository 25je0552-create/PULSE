import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import 'care_provider.dart';

class CareScreen extends ConsumerWidget {
  const CareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careState = ref.watch(careProvider);
    final partner = careState.careTeam['partner'] as Map<String, dynamic>? ?? {};
    final appt = careState.upcomingAppointment;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Care',
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Stay connected to the people supporting your health.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: AppColors.onSurface),
            onPressed: () => context.push(AppRoutes.appointments),
          ),
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: AppColors.primary),
            onPressed: () => context.push(AppRoutes.records),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  PulseBadge(
                    text: 'Human Review',
                    variant: PulseBadgeVariant.primary,
                  ),
                  PulseBadge(
                    text: 'Loop Active',
                    variant: PulseBadgeVariant.success,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Your care continuity',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Pulse keeps you and your healthcare team aligned between clinical visits.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildPrimaryPartnerCard(context, partner),
              const SizedBox(height: 20),
              _buildMultiDisciplineCard(careState.careTeam['disciplines'] as List<dynamic>? ?? []),
              const SizedBox(height: 20),
              _buildUpcomingReviewCard(context, appt),
              const SizedBox(height: 20),
              _buildPreConsultDigestTeaserCard(context),
              const SizedBox(height: 20),
              _buildHealthRecordsVaultCard(context),
              const SizedBox(height: 20),
              _buildFamilyCircleTeaserCard(context),
              const SizedBox(height: 20),
              _buildWellbeingSpaceTeaserCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryPartnerCard(BuildContext context, Map<String, dynamic> partner) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: PulseBadge(
                  text: 'Connected Care Partner',
                  variant: PulseBadgeVariant.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Primary Link',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: AppColors.secondary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            partner['name'] ?? 'Dr. Meera Sharma',
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 16, color: AppColors.secondary),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      partner['title'] ?? 'Primary Care Professional',
                      style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.secondary),
                    ),
                    Text(
                      partner['specialty'] ?? 'Integrated Family Medicine · St. Jude Health',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last Consultation', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                      Text(partner['lastConsultation'] ?? '12 Sep 2026', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700)),
                      Text('Comprehensive check', style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10)),
                    ],
                  ),
                ),
                Container(width: 1, height: 36, color: AppColors.outlineVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Next Appointment', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                      Text(partner['nextAppointment'] ?? '24 Sep 2026', style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700)),
                      Text('In 9 days · Confirmed', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => context.push(AppRoutes.doctorProfile),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'View care team details',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
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

  Widget _buildMultiDisciplineCard(List<dynamic> disciplines) {
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
                  'Multi-Discipline Network',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: '1 connected', variant: PulseBadgeVariant.neutral),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: disciplines.map((d) {
              final isConnected = d['connected'] == true;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isConnected ? const Color(0xFFE6F4F1) : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isConnected ? AppColors.primary : AppColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle : Icons.add_circle_outline,
                      size: 14,
                      color: isConnected ? AppColors.primary : AppColors.outline,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      d['name'] ?? '',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isConnected ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'Pulse coordinates whole-person health. You choose who you link to your timeline.',
            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingReviewCard(BuildContext context, Map<String, dynamic> appt) {
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
                  'Upcoming review',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Confirmed', variant: PulseBadgeVariant.success),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Consultation with ${appt['doctorName'] ?? 'Dr. Meera Sharma, MD'}',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${appt['date'] ?? 'Thursday, 24 Sep 2026'} · ${appt['time'] ?? '11:30 AM'}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  appt['venue'] ?? 'St. Jude Health & Virtual Hybrid Option',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PulseButton(
                  text: 'View details',
                  variant: PulseButtonVariant.outlined,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  fontSize: 13,
                  onPressed: () => context.push(AppRoutes.appointments),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PulseButton(
                  text: 'Prepare notes',
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  fontSize: 13,
                  onPressed: () => context.push(AppRoutes.preConsult),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreConsultDigestTeaserCard(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF9),
      borderColor: const Color(0xFF99F6E4),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_turned_in, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pre-Consult Tool',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Make your next consultation more useful',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Pulse synthesizes your daily signals, micro-habits, and sleep trends into a clinician-friendly 1-page digest so you don\'t forget important context.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 14, color: AppColors.outline),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'You review, edit, and approve everything before Dr. Sharma sees it.',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PulseButton(
            text: 'Prepare my summary for 24 Sep',
            icon: Icons.arrow_forward,
            onPressed: () => context.push(AppRoutes.preConsult),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRecordsVaultCard(BuildContext context) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: PulseBadge(
                  text: 'Secure Archive',
                  variant: PulseBadgeVariant.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Personal Vault',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your health information',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep consultation summaries, care plans, reports, and medication history in your private encrypted vault.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '6',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Total records',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 28, color: AppColors.outlineVariant),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '2',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        'Care notes',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 28, color: AppColors.outlineVariant),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Encrypted',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Private archive',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PulseButton(
            text: 'Open Health Records & Vault',
            icon: Icons.shield_outlined,
            onPressed: () => context.push(AppRoutes.records),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyCircleTeaserCard(BuildContext context) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: PulseBadge(
                  text: 'Trusted Companions',
                  variant: PulseBadgeVariant.neutral,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '1 connected',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Family Circle & Support Network',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Invite someone you trust to walk your wellbeing journey alongside you. Zero automatic sharing by default.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCCFBF1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'P',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Priya · Sister',
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Shared: Wellbeing updates & goals',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const PulseBadge(text: 'Active', variant: PulseBadgeVariant.success),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PulseButton(
            text: 'Manage Family Circle',
            variant: PulseButtonVariant.outlined,
            icon: Icons.people_outline,
            onPressed: () => context.push(AppRoutes.family),
          ),
        ],
      ),
    );
  }

  Widget _buildWellbeingSpaceTeaserCard(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFF2F3FF),
      borderColor: const Color(0xFFE2E7FF),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: PulseBadge(
                  text: 'Signal · Reflection · Support',
                  variant: PulseBadgeVariant.primary,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.spa, color: Color(0xFF00685F), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Personal Wellbeing Space',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Check in with yourself between appointments. Track your personal rhythm, log private reflections, and prepare your wellbeing summary for your care team.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          PulseButton(
            text: 'Open Wellbeing Space',
            icon: Icons.spa_outlined,
            onPressed: () => context.push(AppRoutes.wellbeing),
          ),
        ],
      ),
    );
  }
}

