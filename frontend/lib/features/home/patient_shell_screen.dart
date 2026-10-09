import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/widgets/pulse_bottom_nav.dart';

class PatientShellScreen extends StatelessWidget {
  final Widget child;

  const PatientShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.pulseAi)) return 1;
    if (location.startsWith(AppRoutes.awareness)) return 2;
    if (location.startsWith(AppRoutes.care)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.pulseAi);
        break;
      case 2:
        context.go(AppRoutes.awareness);
        break;
      case 3:
        context.go(AppRoutes.care);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: PulseBottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
