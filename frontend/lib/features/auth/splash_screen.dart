import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFD),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF03A1C6).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF03A1C6).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              width: 140,
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF03A1C6).withValues(alpha: 0.18),
                                    blurRadius: 36,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/pulse_icon_transparent.png',
                                width: 130,
                                height: 130,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              'PULSE',
                              textAlign: TextAlign.center,
                              style: AppTypography.displayLarge.copyWith(
                                color: const Color(0xFF03A1C6),
                                letterSpacing: 6.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 240),
                            child: Text(
                              'Continuous care between consultations',
                              textAlign: TextAlign.center,
                              style: AppTypography.titleMedium.copyWith(
                                color: const Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF03A1C6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF03A1C6).withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF03A1C6).withValues(alpha: 0.35),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Preparing your care experience',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 120,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 56,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF03A1C6),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                size: 14,
                                color: Color(0xFF03A1C6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Doctor-led • India Healthcare Platform',
                                textAlign: TextAlign.center,
                                style: AppTypography.labelSmall.copyWith(
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
