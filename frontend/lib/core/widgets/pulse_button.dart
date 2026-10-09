import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum PulseButtonVariant {
  primary,
  secondary,
  outlined,
  ghost,
}

class PulseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final PulseButtonVariant variant;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final int maxLines;
  final double? fontSize;

  const PulseButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = PulseButtonVariant.primary,
    this.icon,
    this.isFullWidth = true,
    this.isLoading = false,
    this.padding,
    this.maxLines = 2,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final textStyle = _getTextStyle();
    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 12);

    if (isLoading) {
      content = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (icon != null) {
      content = Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: maxLines,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 18, color: _getIconColor()),
        ],
      );
    } else {
      content = Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: maxLines,
      );
    }

    Widget buttonWidget;
    switch (variant) {
      case PulseButtonVariant.primary:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: content,
        );
        break;

      case PulseButtonVariant.secondary:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryFixed,
            foregroundColor: AppColors.secondary,
            elevation: 0,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: content,
        );
        break;

      case PulseButtonVariant.outlined:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: content,
        );
        break;

      case PulseButtonVariant.ghost:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }

  TextStyle _getTextStyle() {
    TextStyle base;
    switch (variant) {
      case PulseButtonVariant.primary:
        base = AppTypography.labelLarge.copyWith(color: AppColors.onPrimary);
        break;
      case PulseButtonVariant.secondary:
        base = AppTypography.labelLarge.copyWith(color: AppColors.secondary);
        break;
      case PulseButtonVariant.outlined:
        base = AppTypography.labelLarge.copyWith(color: AppColors.primary);
        break;
      case PulseButtonVariant.ghost:
        base = AppTypography.labelMedium.copyWith(color: AppColors.onSurfaceVariant);
        break;
    }
    if (fontSize != null) {
      return base.copyWith(fontSize: fontSize);
    }
    return base;
  }

  Color _getIconColor() {
    switch (variant) {
      case PulseButtonVariant.primary:
        return AppColors.onPrimary;
      case PulseButtonVariant.secondary:
        return AppColors.secondary;
      case PulseButtonVariant.outlined:
        return AppColors.primary;
      case PulseButtonVariant.ghost:
        return AppColors.onSurfaceVariant;
    }
  }
}
