import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

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
          'Your Care Professional',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurface),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.sync),
                        title: const Text('Manage connection'),
                        onTap: () => Navigator.pop(ctx),
                      ),
                      ListTile(
                        leading: const Icon(Icons.shield_outlined),
                        title: const Text('Sharing preferences'),
                        onTap: () => Navigator.pop(ctx),
                      ),
                      ListTile(
                        leading: const Icon(Icons.link_off, color: AppColors.error),
                        title: const Text('Disconnect partner', style: TextStyle(color: AppColors.error)),
                        onTap: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
              );
            },
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
              _buildDoctorHeaderCard(),
              const SizedBox(height: 20),
              _buildConnectionDetailsCard(),
              const SizedBox(height: 20),
              _buildNextAppointmentCard(context),
              const SizedBox(height: 20),
              _buildRecentCareContextCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorHeaderCard() {
    return PulseCard(
      padding: const EdgeInsets.all(20),
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
                'ID #SJH-4829',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.medical_services, color: AppColors.secondary, size: 30),
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
                            'Dr. Meera Sharma',
                            style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: AppColors.secondary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Primary Care Professional · Integrated Family Medicine',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'St. Jude Health Partner',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Connected since 12 Sep 2026',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionDetailsCard() {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your care connection',
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Pulse helps you and Dr. Sharma stay aligned between clinical visits by organizing everyday signals into longitudinal context.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          _buildCheckRow('Active care connection (St. Jude Health)'),
          const SizedBox(height: 8),
          _buildCheckRow('Patient-controlled sharing (You decide what is shared)'),
          const SizedBox(height: 8),
          _buildCheckRow('Longitudinal context available for consultations'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dr. Sharma does not monitor you 24/7 or receive unsolicited notifications. Data is organized for structured clinical review.',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextAppointmentCard(BuildContext context) {
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
                  'Next appointment',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Confirmed', variant: PulseBadgeVariant.success),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text('SEP', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
                    Text('24', style: AppTypography.titleLarge.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thursday, 24 Sep 2026',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '11:30 AM (45 min duration)',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    Text(
                      'St. Jude Health Center & Hybrid Video',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PulseButton(
                  text: 'View appointment',
                  variant: PulseButtonVariant.outlined,
                  onPressed: () => context.push(AppRoutes.appointments),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PulseButton(
                  text: 'Prepare summary',
                  onPressed: () => context.push(AppRoutes.preConsult),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCareContextCard(BuildContext context) {
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
                  'Recent care context',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const PulseBadge(text: 'Loop active', variant: PulseBadgeVariant.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Self-reported activity logged since your 12 Sep consultation with Dr. Sharma',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox('6', 'Check-ins logged'),
              const SizedBox(width: 10),
              _buildStatBox('2', 'Active goals'),
              const SizedBox(width: 10),
              _buildStatBox('1', 'New pattern'),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => context.push(AppRoutes.progress),
            child: Row(
              children: [
                Text(
                  'Progress timeline',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String num, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(num, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline),
            ),
          ],
        ),
      ),
    );
  }
}
