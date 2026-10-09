import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum PulseBadgeVariant {
  primary,
  secondary,
  tertiary,
  neutral,
  success,
  warning,
  error,
}

class PulseBadge extends StatelessWidget {
  final String text;
  final PulseBadgeVariant variant;
  final IconData? icon;

  const PulseBadge({
    super.key,
    required this.text,
    this.variant = PulseBadgeVariant.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (variant) {
      case PulseBadgeVariant.primary:
        bg = const Color(0xFFE6F4F1);
        fg = AppColors.primary;
        break;
      case PulseBadgeVariant.secondary:
        bg = const Color(0xFFE0F2FE);
        fg = AppColors.secondary;
        break;
      case PulseBadgeVariant.tertiary:
        bg = const Color(0xFFEEF0FF);
        fg = AppColors.tertiary;
        break;
      case PulseBadgeVariant.neutral:
        bg = AppColors.surfaceContainerLow;
        fg = AppColors.onSurfaceVariant;
        break;
      case PulseBadgeVariant.success:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        break;
      case PulseBadgeVariant.warning:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        break;
      case PulseBadgeVariant.error:
        bg = AppColors.errorContainer;
        fg = AppColors.onErrorContainer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              style: AppTypography.labelSmall.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
