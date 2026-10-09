import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../auth/auth_provider.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Request Data Deletion', style: AppTypography.headlineSmall),
        content: Text(
          'Under Pulse transparent privacy principles, you have full ownership of your data. Deleting your data will remove all check-ins, reflections, and care links. This cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data deletion request submitted securely.')),
              );
            },
            child: const Text('Confirm Deletion', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

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
              'Profile',
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Account, privacy & preferences',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Secured',
                icon: Icons.verified_user,
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
              _buildUserCard(profile),
              const SizedBox(height: 20),
              _buildSnapshotCard(context, profile),
              const SizedBox(height: 20),
              _buildPrivacySharingSection(context),
              const SizedBox(height: 20),
              _buildAiPersonalizationSection(ref, profile),
              const SizedBox(height: 20),
              _buildNotificationsSection(ref, profile),
              const SizedBox(height: 20),
              _buildDataControlsSection(context),
              const SizedBox(height: 24),
              PulseButton(
                text: 'Sign Out',
                variant: PulseButtonVariant.outlined,
                icon: Icons.logout,
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go(AppRoutes.login);
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(ProfileState profile) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Text(
              'AS',
              style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
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
                        profile.name,
                        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const PulseBadge(text: 'Patient', variant: PulseBadgeVariant.neutral),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Your health journey, your choices.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.lock_clock, size: 12, color: AppColors.outline),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Diagnostics protected · Non-public view',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotCard(BuildContext context, ProfileState profile) {
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
                  'Your Pulse Snapshot',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ID: ${profile.patientCode}',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSnapshotItem(
            Icons.calendar_today_outlined,
            'Member since',
            profile.memberSince,
          ),
          const SizedBox(height: 8),
          _buildSnapshotItem(
            Icons.medical_services_outlined,
            'Care team',
            '1 connected · Dr. Meera Sharma',
            onTap: () => context.push(AppRoutes.doctorProfile),
          ),
          const SizedBox(height: 8),
          _buildSnapshotItem(
            Icons.family_restroom_outlined,
            'Family Circle',
            '1 trusted person · Priya (Sister)',
            onTap: () => context.push(AppRoutes.family),
          ),
          const SizedBox(height: 8),
          _buildSnapshotItem(
            Icons.shield_outlined,
            'Health records',
            '6 records · Encrypted vault',
            onTap: () => context.push(AppRoutes.records),
          ),
          const SizedBox(height: 8),
          _buildSnapshotItem(
            Icons.bookmark_outline,
            'Saved awareness',
            '4 resources saved',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, size: 14, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Personal continuous-care account · Real-time verified consent',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotItem(IconData icon, String label, String value, {VoidCallback? onTap}) {
    final row = Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Text('$label: ', style: AppTypography.bodySmall.copyWith(color: AppColors.outline)),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: onTap != null ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ),
        if (onTap != null)
          const Icon(Icons.chevron_right, size: 16, color: AppColors.outline),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: row,
        ),
      );
    }
    return row;
  }

  Widget _buildPrivacySharingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy & sharing',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'You decide what information Pulse can use and who you share it with.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 12),
        _buildNavTile(
          context,
          icon: Icons.shield_outlined,
          title: 'Privacy settings',
          subtitle: 'Manage how your information is stored and protected',
          onTap: () => context.push(AppRoutes.consent),
        ),
        const SizedBox(height: 8),
        _buildNavTile(
          context,
          icon: Icons.folder_shared_outlined,
          title: 'Care team sharing & records',
          subtitle: 'Choose what your connected clinician can access from your vault',
          onTap: () => context.push(AppRoutes.records),
        ),
        const SizedBox(height: 8),
        _buildNavTile(
          context,
          icon: Icons.favorite_outline,
          title: 'Family Circle',
          subtitle: 'Manage trusted people and individual permissions',
          onTap: () => context.push(AppRoutes.family),
        ),
      ],
    );
  }

  Widget _buildNavTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return PulseCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700)),
                Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }

  Widget _buildAiPersonalizationSection(WidgetRef ref, ProfileState profile) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: AppColors.tertiary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI & Personalization',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Tune how Pulse AI tailors reflections and guides your everyday pacing.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: Text('Use my check-ins to personalize Pulse', style: AppTypography.labelLarge),
            subtitle: Text(
              'Allows Pulse to use your recent wellbeing signals to provide more relevant suggestions.',
              style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
            ),
            value: profile.useCheckinsForAi,
            onChanged: (val) => ref.read(profileProvider.notifier).toggleCheckinsAi(val),
          ),
          SwitchListTile(
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: Text('Use my goals and routines', style: AppTypography.labelLarge),
            subtitle: Text(
              'Allows Pulse to incorporate selected gentle routines into personalized pacing prompts.',
              style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
            ),
            value: profile.useGoalsForAi,
            onChanged: (val) => ref.read(profileProvider.notifier).toggleGoalsAi(val),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(WidgetRef ref, ProfileState profile) {
    return PulseCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notifications', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          SwitchListTile(
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: Text('Check-in reminders', style: AppTypography.labelLarge),
            value: profile.checkinReminders,
            onChanged: (val) => ref.read(profileProvider.notifier).toggleReminders(val),
          ),
          SwitchListTile(
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            title: Text('Care team schedule updates', style: AppTypography.labelLarge),
            value: profile.careUpdates,
            onChanged: (val) => ref.read(profileProvider.notifier).toggleCareUpdates(val),
          ),
        ],
      ),
    );
  }

  Widget _buildDataControlsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data controls', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        PulseCard(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preparing secure data archive download...')),
            );
          },
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.download_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Download my data archive', style: AppTypography.labelLarge),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
        const SizedBox(height: 8),
        PulseCard(
          onTap: () => _showDeleteConfirmation(context),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Request full data deletion',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.error),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ],
    );
  }
}
