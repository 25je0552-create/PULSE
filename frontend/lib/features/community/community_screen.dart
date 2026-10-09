import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/pulse_badge.dart';
import '../../core/widgets/pulse_card.dart';
import '../../core/widgets/pulse_chip.dart';
import '../../core/widgets/pulse_premium_modal.dart';
import 'community_provider.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  void _showCreatePostDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Pacing & Stress';

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
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Share with Community',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Your post will appear anonymously. Do not share sensitive personal identifiers.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Discussion title',
                  labelStyle: AppTypography.bodySmall,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'What would you like to share or ask?',
                  labelStyle: AppTypography.bodySmall,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onPressed: () {
                      final title = titleController.text.trim();
                      final content = contentController.text.trim();
                      if (title.isNotEmpty && content.isNotEmpty) {
                        ref.read(communityProvider.notifier).addPost(
                          title: title,
                          content: content,
                          category: selectedCategory,
                        );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Discussion posted anonymously.')),
                        );
                      }
                    },
                    child: const Text('Post', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityProvider);
    final posts = state.selectedCategory == 'All'
        ? state.posts
        : state.posts.where((p) => p.category == state.selectedCategory).toList();

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
              'Community',
              style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Anonymous peer support & lived experience',
              style: AppTypography.bodySmall.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clinician Education',
            icon: const Icon(Icons.school_outlined, color: AppColors.primary),
            onPressed: () => context.push(AppRoutes.awareness),
          ),
          IconButton(
            tooltip: 'Safety Helplines',
            icon: const Icon(Icons.health_and_safety_outlined, color: AppColors.error),
            onPressed: () => context.push(AppRoutes.safety),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGuidelinesNotice(),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.categories.map((cat) {
                    final isSelected = state.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PulseChip(
                        label: cat,
                        isSelected: isSelected,
                        onTap: () => ref.read(communityProvider.notifier).setCategory(cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _buildAwarenessBanner(context),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discussions',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                  InkWell(
                    onTap: () {
                      if (!state.isPremiumUnlocked) {
                        showPulsePremiumModal(
                          context,
                          featureName: 'Starting Community Discussions',
                          onUnlocked: () => ref.read(communityProvider.notifier).unlockPremium(),
                        );
                      } else {
                        _showCreatePostDialog(context, ref);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            state.isPremiumUnlocked ? Icons.add_circle_outline : Icons.lock_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'New topic',
                            style: AppTypography.labelMedium.copyWith(
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
              const SizedBox(height: 12),
              ...posts.map((post) => _buildPostCard(context, ref, post, state.isPremiumUnlocked)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelinesNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF99F6E4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safe, Moderated Space',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  'All members post anonymously. Community is peer encouragement, not clinical advice.',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwarenessBanner(BuildContext context) {
    return PulseCard(
      onTap: () => context.push(AppRoutes.awareness),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      backgroundColor: const Color(0xFFF2F3FF),
      borderColor: const Color(0xFFE2E7FF),
      child: Row(
        children: [
          const Icon(Icons.school_outlined, color: AppColors.secondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinician-Reviewed Resources',
                  style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Explore educational videos and pacing guides in Awareness',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, size: 16, color: AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, WidgetRef ref, CommunityPost post, bool isPremium) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PulseCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: post.isPinned ? AppColors.primary : AppColors.surfaceContainerLow,
                  child: Icon(
                    post.isPinned ? Icons.push_pin : Icons.person_outline,
                    size: 14,
                    color: post.isPinned ? Colors.white : AppColors.outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorHandle,
                        style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${post.category} · ${post.timeAgo}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                if (post.isPinned)
                  const PulseBadge(text: 'Moderator', variant: PulseBadgeVariant.primary),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              post.content,
              style: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => ref.read(communityProvider.notifier).toggleLike(post.id),
                      child: Row(
                        children: [
                          Icon(
                            post.isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: post.isLiked ? AppColors.error : AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Text('${post.likes}', style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        if (!isPremium) {
                          showPulsePremiumModal(
                            context,
                            featureName: 'Peer Replies',
                            onUnlocked: () => ref.read(communityProvider.notifier).unlockPremium(),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Discussion thread opened.')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.outline),
                          const SizedBox(width: 4),
                          Text('${post.repliesCount} replies', style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 18,
                    color: post.isBookmarked ? AppColors.primary : AppColors.outline,
                  ),
                  onPressed: () => ref.read(communityProvider.notifier).toggleBookmark(post.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
