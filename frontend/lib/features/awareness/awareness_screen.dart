import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_chip.dart';
import 'awareness_provider.dart';

class AwarenessScreen extends ConsumerWidget {
  const AwarenessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(awarenessProvider);
    final items = state.items;
    final featured = items.firstWhere((i) => i.isFeatured, orElse: () => items.first);

    final categories = [
      'All',
      'Mental wellbeing',
      'Stress',
      'Sleep',
      'Emotional health',
      'Movement',
      'Nutrition',
      'Healthy routines',
      'Care & consultations',
    ];

    final filteredItems = state.selectedCategory == 'All'
        ? items
        : items.where((i) => i.category.toLowerCase() == state.selectedCategory.toLowerCase()).toList();

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
              'Awareness',
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Understand your health. Make informed choices.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: AppColors.onSurface),
            onPressed: () {},
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
              const Row(
                children: [
                  PulseBadge(
                    text: 'Stage 02 · Understand & Educate',
                    variant: PulseBadgeVariant.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFeaturedCard(context, ref, featured),
              const SizedBox(height: 24),
              Text(
                'Explore Themes',
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
                        onTap: () => ref.read(awarenessProvider.notifier).setCategory(cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Curated Guides',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: PulseBadge(
                      text: 'Clinical evidence grade',
                      variant: PulseBadgeVariant.neutral,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...filteredItems.map((item) => _buildGuideItem(context, ref, item)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, WidgetRef ref, AwarenessItem item) {
    return PulseCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/patient/awareness/${item.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFF131B2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: PulseBadge(
                    text: 'Featured · ${item.duration}',
                    variant: PulseBadgeVariant.primary,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: Icon(
                      item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () => ref.read(awarenessProvider.notifier).toggleSave(item.id),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Row(
                    children: [
                      const Icon(Icons.verified, size: 14, color: Color(0xFF5EEAD4)),
                      const SizedBox(width: 4),
                      Text(
                        'Professionally reviewed',
                        style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.play_circle_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Watch',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.headset, size: 16, color: AppColors.outline),
                    const SizedBox(width: 4),
                    Text(
                      'Audio available',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
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

  Widget _buildGuideItem(BuildContext context, WidgetRef ref, AwarenessItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PulseCard(
        padding: const EdgeInsets.all(14),
        onTap: () => context.push('/patient/awareness/${item.id}'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_circle_outline, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.category,
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.duration,
                        style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title,
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
