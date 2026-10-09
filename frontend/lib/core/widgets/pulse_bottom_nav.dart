import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PulseBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PulseBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(child: _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home')),
              Expanded(child: _buildNavItem(1, Icons.auto_awesome_outlined, Icons.auto_awesome, 'Pulse AI')),
              Expanded(child: _buildNavItem(2, Icons.school_outlined, Icons.school, 'Awareness')),
              Expanded(child: _buildNavItem(3, Icons.healing_outlined, Icons.healing, 'Care')),
              Expanded(child: _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.outline;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
