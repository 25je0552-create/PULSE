import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PulseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasShadow;

  const PulseCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: borderColor ?? AppColors.cardBorder,
      width: 1,
    );

    final boxDecoration = BoxDecoration(
      color: backgroundColor ?? AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.fromBorderSide(border),
      boxShadow: hasShadow
          ? [
              BoxStyle.ambientShadow,
            ]
          : null,
    );

    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    if (onTap != null) {
      return Container(
        decoration: boxDecoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onTap,
            child: content,
          ),
        ),
      );
    }

    return Container(
      decoration: boxDecoration,
      child: content,
    );
  }
}

class BoxStyle {
  static const BoxShadow ambientShadow = BoxShadow(
    color: Color.fromRGBO(15, 23, 42, 0.04),
    offset: Offset(0, 4),
    blurRadius: 16,
    spreadRadius: -2,
  );
}
