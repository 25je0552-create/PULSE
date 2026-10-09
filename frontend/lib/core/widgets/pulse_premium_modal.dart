import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'pulse_button.dart';

void showPulsePremiumModal(BuildContext context, {required String featureName, VoidCallback? onUnlocked}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium, color: Color(0xFFD97706), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pulse Community Plus',
                      style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Peer Discussions & Moderated Circles',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'To participate in $featureName, upgrade to Pulse Community Plus for verified safe spaces, anonymous discussion groups, and clinical moderator support.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 16),
          _buildPerkItem(Icons.verified_user_outlined, '100% Anonymous & secure handles'),
          const SizedBox(height: 10),
          _buildPerkItem(Icons.health_and_safety_outlined, 'Clinically moderated discussion circles'),
          const SizedBox(height: 10),
          _buildPerkItem(Icons.lock_outline, 'Zero data shared with third parties or insurers'),
          const SizedBox(height: 24),
          PulseButton(
            text: 'Activate Community Access',
            icon: Icons.check,
            onPressed: () {
              Navigator.pop(ctx);
              if (onUnlocked != null) {
                onUnlocked();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pulse Community Plus enabled for your session.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Explore Free Previews',
                style: AppTypography.labelMedium.copyWith(color: AppColors.outline),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _buildPerkItem(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
