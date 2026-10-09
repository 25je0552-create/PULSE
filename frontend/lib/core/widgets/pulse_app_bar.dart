import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PulseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const PulseAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      actions: actions,
    );
  }
}
