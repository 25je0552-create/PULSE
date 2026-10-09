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
import 'family_provider.dart';

class FamilyCircleScreen extends ConsumerWidget {
  const FamilyCircleScreen({super.key});

  void _showEditPermissionsSheet(BuildContext context, WidgetRef ref, FamilyMemberModel member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final currentMember = ref.watch(familyProvider).members.firstWhere(
                (m) => m.id == member.id,
                orElse: () => member,
              );

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Access for ${currentMember.name}',
                        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Text(
                  'Select what information this person can see:',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                ),
                const SizedBox(height: 16),
                ...currentMember.sharedPermissions.entries.map((entry) {
                  return SwitchListTile(
                    activeThumbColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.key, style: AppTypography.labelLarge),
                    value: entry.value,
                    onChanged: (_) {
                      ref.read(familyProvider.notifier).togglePermission(member.id, entry.key);
                    },
                  );
                }),
                const SizedBox(height: 20),
                PulseButton(
                  text: 'Save Permissions',
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddMemberSheet(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String relation = 'Sister';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Trusted Person',
                style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              PulseTextField(
                controller: nameController,
                label: 'Full Name',
                hintText: 'e.g. Priya Sharma',
              ),
              const SizedBox(height: 12),
              PulseTextField(
                controller: phoneController,
                label: 'Phone Number',
                hintText: '+91 98765 43210',
              ),
              const SizedBox(height: 12),
              Text('Relationship', style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Parent', 'Partner', 'Sister', 'Friend', 'Caregiver'].map((r) {
                  return PulseChip(
                    label: r,
                    isSelected: relation == r,
                    onTap: () => setSheetState(() => relation = r),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              PulseButton(
                text: 'Send Invitation & Set Access',
                icon: Icons.person_add,
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    ref.read(familyProvider.notifier).addMember(
                          nameController.text.trim(),
                          relation,
                          phoneController.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invitation sent. Permissions default to minimal.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyProvider);
    final members = state.members;

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
          'Family Circle',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: PulseBadge(
                text: 'Secured',
                icon: Icons.lock,
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
                'Choose who you want beside you.',
                style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Your health stays yours.',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'You decide exactly what your trusted circle can see, whenever you want.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _buildSupportContextCard(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Your trusted people',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PulseBadge(
                    text: '${members.length} connected',
                    variant: PulseBadgeVariant.neutral,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...members.map((m) => _buildMemberCard(context, ref, m)),
              const SizedBox(height: 16),
              PulseButton(
                text: 'Add trusted person',
                variant: PulseButtonVariant.outlined,
                icon: Icons.person_add_outlined,
                onPressed: () => _showAddMemberSheet(context, ref),
              ),
              const SizedBox(height: 24),
              _buildSecurityPrivacyNotice(context),
              const SizedBox(height: 20),
              _buildSupportLinks(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportContextCard() {
    return PulseCard(
      backgroundColor: const Color(0xFFF0FDF9),
      borderColor: const Color(0xFF99F6E4),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Support can make care easier.',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Invite someone you trust to walk your wellbeing journey alongside you. Family members never automatically receive clinical telemetry or doctor notes.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.lock_clock, size: 14, color: AppColors.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Zero automatic sharing by default',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, WidgetRef ref, FamilyMemberModel member) {
    final activePerms = member.sharedPermissions.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .join(', ');

    return PulseCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE0F2FE),
                child: Text(
                  member.name.isNotEmpty ? member.name[0] : 'P',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            member.name,
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const PulseBadge(text: 'Connected', variant: PulseBadgeVariant.success),
                      ],
                    ),
                    Text(
                      'Family · ${member.relation}',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.primary, size: 20),
                onPressed: () => _showEditPermissionsSheet(context, ref, member),
              ),
            ],
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
                const Icon(Icons.rule_folder_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activePerms.isNotEmpty ? 'Shared: $activePerms' : 'No categories shared',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                TextButton(
                  onPressed: () => _showEditPermissionsSheet(context, ref, member),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 24)),
                  child: Text('Edit access', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityPrivacyNotice(BuildContext context) {
    return PulseCard(
      backgroundColor: const Color(0xFFF8FAFC),
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.admin_panel_settings_outlined, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You’re always in control',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Family Circle never provides root access to your Pulse health chart. Clinical telemetry, therapy journals, and confidential doctor summaries remain locked unless intentionally granted.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => context.push(AppRoutes.profile),
            child: Row(
              children: [
                Text(
                  'Manage privacy settings',
                  style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
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

  Widget _buildSupportLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Need more support?',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: PulseButton(
                text: 'Care team',
                variant: PulseButtonVariant.outlined,
                icon: Icons.medical_services_outlined,
                onPressed: () => context.push(AppRoutes.care),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PulseButton(
                text: 'Human support',
                variant: PulseButtonVariant.outlined,
                icon: Icons.support_agent,
                onPressed: () => context.push(AppRoutes.safety),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
