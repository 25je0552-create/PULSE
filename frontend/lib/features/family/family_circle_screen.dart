import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_bottom_nav.dart';
import 'family_provider.dart';

class FamilyCircleScreen extends ConsumerStatefulWidget {
  const FamilyCircleScreen({super.key});

  @override
  ConsumerState<FamilyCircleScreen> createState() => _FamilyCircleScreenState();
}

class _FamilyCircleScreenState extends ConsumerState<FamilyCircleScreen> {
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF89F5E7), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF283044),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(milliseconds: 3200),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.pulseAi);
        break;
      case 2:
        context.go(AppRoutes.awareness);
        break;
      case 3:
        context.go(AppRoutes.care);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  void _showInviteModal() {
    int currentStep = 1;
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    String selectedRelation = 'Sibling';
    final Map<String, bool> draftPermissions = {
      'Wellbeing check-ins': false,
      'Goals & progress': false,
      'Care schedule': false,
      'Care summaries': false,
      'Health records': false,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (currentStep == 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Who would you like to invite?',
                            style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Enter their details to send an invitation.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAEDFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF3D4947)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Full name', style: AppTypography.labelMedium),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Rahul Sharma',
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Relationship', style: AppTypography.labelMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildRelChip('Parent', selectedRelation, () {
                      setModalState(() => selectedRelation = 'Parent');
                    }),
                    const SizedBox(width: 8),
                    _buildRelChip('Partner', selectedRelation, () {
                      setModalState(() => selectedRelation = 'Partner');
                    }),
                    const SizedBox(width: 8),
                    _buildRelChip('Sibling', selectedRelation, () {
                      setModalState(() => selectedRelation = 'Sibling');
                    }),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRelChip('Friend', selectedRelation, () {
                      setModalState(() => selectedRelation = 'Friend');
                    }),
                    const SizedBox(width: 8),
                    _buildRelChip('Caregiver', selectedRelation, () {
                      setModalState(() => selectedRelation = 'Caregiver');
                    }),
                    const SizedBox(width: 8),
                    _buildRelChip('Other', selectedRelation, () {
                      setModalState(() => selectedRelation = 'Other');
                    }),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Phone number or email', style: AppTypography.labelMedium),
                const SizedBox(height: 6),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    hintText: 'rahul@example.com or mobile',
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 1,
                    shadowColor: Colors.black.withValues(alpha: 0.1),
                    child: InkWell(
                      onTap: () {
                        if (nameController.text.trim().isNotEmpty) {
                          setModalState(() => currentStep = 2);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue to permissions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if (currentStep == 2) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.tune, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'STEP 2 OF 2',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Choose their access',
                            style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'You decide exactly what this person can see.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAEDFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 18, color: Color(0xFF3D4947)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'All access permissions start strictly disabled.',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...draftPermissions.keys.map((permKey) {
                  final isEnabled = draftPermissions[permKey] ?? false;
                  String subText;
                  if (permKey == 'Wellbeing check-ins') {
                    subText = 'Share mood, stress, energy, and sleep logs.';
                  } else if (permKey == 'Goals & progress') {
                    subText = 'Share milestones and self-care targets.';
                  } else if (permKey == 'Care schedule') {
                    subText = 'Share upcoming doctor appointment dates.';
                  } else if (permKey == 'Care summaries') {
                    subText = 'Only clinic notes you explicitly choose to share.';
                  } else {
                    subText = 'Share lab and telemetry files manually.';
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                Text(
                                  permKey,
                                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  subText,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isEnabled,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) {
                              setModalState(() {
                                draftPermissions[permKey] = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Nothing is shared until you confirm.',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Material(
                      color: const Color(0xFFEAEDFF),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => setModalState(() => currentStep = 1),
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF131B2E),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Material(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        elevation: 1,
                        shadowColor: Colors.black.withValues(alpha: 0.1),
                        child: InkWell(
                          onTap: () {
                            ref.read(familyProvider.notifier).addMember(
                                  name: nameController.text.trim(),
                                  relation: selectedRelation,
                                  contact: contactController.text.trim(),
                                  permissions: draftPermissions,
                                );
                            setModalState(() => currentStep = 3);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Send invitation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCCFBF1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mark_email_read, color: AppColors.primary, size: 36),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCE5FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Pending acceptance',
                          style: AppTypography.labelSmall.copyWith(
                            color: const Color(0xFF001D31),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Invitation on its way',
                        style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "They will need to accept your invitation before they can access anything you've chosen to share.",
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => Navigator.pop(ctx),
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                              child: Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelChip(String title, String selected, VoidCallback onTap) {
    final isSelected = title == selected;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : const Color(0xFFEAEDFF),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF131B2E),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showPriyaModal(FamilyMemberModel member) {
    final Map<String, bool> localPerms = Map<String, bool>.from(member.sharedPermissions);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPriyaState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFCCFBF1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              member.name.isNotEmpty ? member.name[0] : 'P',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
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
                                      style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6F4F1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Connected',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Family · ${member.relation}',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAEDFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: Color(0xFF3D4947)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...localPerms.keys.map((permKey) {
                final isEnabled = localPerms[permKey] ?? false;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          permKey,
                          style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Switch(
                          value: isEnabled,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            setPriyaState(() {
                              localPerms[permKey] = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 1,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  child: InkWell(
                    onTap: () {
                      ref.read(familyProvider.notifier).updateAllPermissions(member.id, localPerms);
                      Navigator.pop(ctx);
                      _showToast("${member.name}'s permissions updated.");
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      child: Center(
                        child: Text(
                          'Save access changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: const Color(0xFFFFDAD6).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showRemoveConfirmationDialog(member);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_remove, size: 18, color: Color(0xFFBA1A1A)),
                          SizedBox(width: 6),
                          Text(
                            'Remove from Family Circle',
                            style: TextStyle(
                              color: Color(0xFFBA1A1A),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmationDialog(FamilyMemberModel member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFDAD6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning, color: Color(0xFFBA1A1A), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              'Remove ${member.name}?',
              style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "They will no longer have access to information you've shared through Pulse. You can invite them back at any time.",
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: const Color(0xFFEAEDFF),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => Navigator.pop(ctx),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 11),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF131B2E),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Material(
                    color: const Color(0xFFBA1A1A),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        ref.read(familyProvider.notifier).removeMember(member.id);
                        Navigator.pop(ctx);
                        _showToast('${member.name} removed from your Family Circle.');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 11),
                        child: Center(
                          child: Text(
                            'Confirm remove',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(familyProvider);
    final members = state.members;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: InkWell(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.profile);
              }
            },
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back, color: Color(0xFF131B2E), size: 24),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Family Circle',
              style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Shared care circles and trusted proxies',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEDFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'SECURED',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PulseBottomNav(
        currentIndex: 4,
        onTap: _onBottomNavTapped,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose who you want beside you.',
                style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified_user, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Your health stays yours. ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'You decide exactly what your trusted circle can see, whenever you want.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildIntroCard(),
              const SizedBox(height: 20),
              _buildCircleSection(members),
              const SizedBox(height: 20),
              _buildPrivacyOwnershipCard(),
              const SizedBox(height: 20),
              _buildHumanSupportSection(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF89F5E7), Color(0xFF6063EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.diversity_1, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Support can make care easier.',
            style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Invite someone you trust to walk your wellbeing journey alongside you. Family members never automatically receive clinical telemetry or doctor notes.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.lock_clock, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Zero automatic sharing by default',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleSection(List<FamilyMemberModel> members) {
    final count = members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Your trusted people',
                      style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: count > 0 ? const Color(0xFF89F5E7) : const Color(0xFFEAEDFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count connected',
                      style: AppTypography.labelSmall.copyWith(
                        color: count > 0 ? const Color(0xFF00201D) : AppColors.outline,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Active access',
              style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (members.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.group_off, size: 36, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    'No trusted people connected',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You are navigating Pulse independently. You can add a companion whenever you are ready.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...members.map((m) => _buildMemberCard(m)),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            child: InkWell(
              onTap: _showInviteModal,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add trusted person',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(FamilyMemberModel member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCCFBF1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        member.name.isNotEmpty ? member.name[0] : 'P',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4F1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Connected',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Family · ${member.relation}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showPriyaModal(member),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAEDFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune, size: 20, color: Color(0xFF3D4947)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _showPriyaModal(member),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.rule_folder, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Shared: Wellbeing updates & goals',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    'Edit access',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOwnershipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFCCFBF1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'You’re always in control',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Family Circle never provides root access to your Pulse health chart. Clinical telemetry, therapy journals, and confidential doctor summaries remain locked unless intentionally granted.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: const Color(0xFFE2E7FF),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  _showToast('Global privacy settings synchronized.');
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security, size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Manage privacy settings',
                          style: TextStyle(
                            color: Color(0xFF131B2E),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumanSupportSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.handshake, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Need more support?',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'If you are feeling overwhelmed, navigate straight to clinical care or activate safety pathways for dedicated human guidance.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 1,
                  shadowColor: Colors.black.withValues(alpha: 0.04),
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.care),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services_outlined, size: 16, color: Color(0xFF006398)),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Care team',
                              style: TextStyle(
                                color: Color(0xFF131B2E),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 1,
                  shadowColor: Colors.black.withValues(alpha: 0.04),
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.safety),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.support_agent, size: 16, color: Color(0xFF4648D4)),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Human support',
                              style: TextStyle(
                                color: Color(0xFF131B2E),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
