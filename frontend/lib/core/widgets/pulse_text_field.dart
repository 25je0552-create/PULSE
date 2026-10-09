import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PulseTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final int maxLines;

  const PulseTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
