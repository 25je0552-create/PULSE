import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_button.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_chip.dart';
import '../../core/widgets/pulse_text_field.dart';
import 'records_provider.dart';

class RecordsScreen extends ConsumerWidget {
  const RecordsScreen({super.key});

  void _showAddRecordSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final facilityController = TextEditingController();
    String selectedCategory = 'Care documents';

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
                'Upload or Add Record',
                style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              PulseTextField(
                controller: titleController,
                label: 'Document Title',
                hintText: 'e.g. Blood Test Report, Prescription',
              ),
              const SizedBox(height: 14),
              PulseTextField(
                controller: facilityController,
                label: 'Clinic / Laboratory',
                hintText: 'e.g. Apollo Diagnostics, St. Jude Health',
              ),
              const SizedBox(height: 14),
              Text('Category', style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  'Care documents',
                  'Reports & results',
                  'Prescriptions',
                  'Wellbeing history',
                ].map((cat) {
                  return PulseChip(
                    label: cat,
                    isSelected: selectedCategory == cat,
                    onTap: () => setSheetState(() => selectedCategory = cat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              PulseButton(
                text: 'Save to Vault',
                icon: Icons.lock,
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    ref.read(recordsProvider.notifier).addRecord(
                          titleController.text.trim(),
                          selectedCategory,
                          facilityController.text.trim().isEmpty
                              ? 'Personal Record'
                              : facilityController.text.trim(),
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document encrypted and stored in vault.')),
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
    final state = ref.watch(recordsProvider);
    final records = state.records;

    final categories = [
      'All',
      'Care documents',
      'Reports & results',
      'Prescriptions',
      'Wellbeing history',
      'Appointments',
    ];

    final filteredRecords = state.selectedCategory == 'All'
        ? records
        : records.where((r) => r.category == state.selectedCategory).toList();

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
          'Personal Vault',
          style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddRecordSheet(context, ref),
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
                    text: 'STAGE 05 · SECURE PERSONAL ARCHIVE',
                    variant: PulseBadgeVariant.primary,
                  ),
                  PulseBadge(
                    text: 'Encrypted',
                    icon: Icons.lock,
                    variant: PulseBadgeVariant.success,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Your health information',
                style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Your records are private and controlled by you. Pulse never shares records automatically with hospitals or insurers.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              _buildVaultStatsRow(records.length),
              const SizedBox(height: 20),
              Text(
                'Browse by category',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSel = state.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PulseChip(
                        label: cat,
                        isSelected: isSel,
                        onTap: () => ref.read(recordsProvider.notifier).setCategory(cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Recent records',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sort: Most recent',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...filteredRecords.map((rec) => _buildRecordCard(context, ref, rec)),
              const SizedBox(height: 20),
              PulseButton(
                text: 'Upload or Add Record',
                icon: Icons.upload_file,
                onPressed: () => _showAddRecordSheet(context, ref),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVaultStatsRow(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('$count', 'Total records'),
          _buildDivider(),
          _buildStat('2', 'Care notes'),
          _buildDivider(),
          _buildStat('18 Sep', 'Last updated'),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.outline)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: AppColors.outlineVariant);
  }

  Widget _buildRecordCard(BuildContext context, WidgetRef ref, RecordModel rec) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PulseCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec.title,
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${rec.subtitle} • ${rec.facility}',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.outline),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              rec.date,
                              style: AppTypography.labelSmall.copyWith(fontSize: 11, color: AppColors.outline),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: PulseBadge(text: rec.type, variant: PulseBadgeVariant.neutral),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.security, size: 14, color: AppColors.outline),
                      const SizedBox(width: 6),
                      Text('Sharing Permissions:', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPermissionChip(
                        label: 'Doctor',
                        isActive: rec.sharedWithDoctor,
                        onTap: () => ref.read(recordsProvider.notifier).toggleDoctorSharing(rec.id),
                      ),
                      const SizedBox(width: 6),
                      _buildPermissionChip(
                        label: 'Family',
                        isActive: rec.sharedWithFamily,
                        onTap: () => ref.read(recordsProvider.notifier).toggleFamilySharing(rec.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE6F4F1) : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isActive ? AppColors.primary : AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? Icons.check : Icons.lock_outline, size: 12, color: isActive ? AppColors.primary : AppColors.outline),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.outline,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
