import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/consent_screen.dart';
import '../../features/onboarding/baseline_screen.dart';
import '../../features/onboarding/connect_doctor_screen.dart';
import '../../features/home/patient_shell_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/checkin/checkin_screen.dart';
import '../../features/pulse_ai/pulse_ai_screen.dart';
import '../../features/pulse_ai/ai_insight_screen.dart';
import '../../features/goals/adaptive_goal_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/care/care_screen.dart';
import '../../features/care/doctor_profile_screen.dart';
import '../../features/care/appointments_screen.dart';
import '../../features/care/pre_consult_summary_screen.dart';
import '../../features/wellbeing/wellbeing_screen.dart';
import '../../features/safety/safety_screen.dart';
import '../../features/awareness/awareness_screen.dart';
import '../../features/awareness/video_detail_screen.dart';
import '../../features/records/records_screen.dart';
import '../../features/family/family_circle_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/community/community_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.consent,
      builder: (context, state) => const ConsentScreen(),
    ),
    GoRoute(
      path: AppRoutes.baseline,
      builder: (context, state) => const BaselineScreen(),
    ),
    GoRoute(
      path: AppRoutes.connectDoctor,
      builder: (context, state) => const ConnectDoctorScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => PatientShellScreen(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.pulseAi,
          builder: (context, state) => const PulseAiScreen(),
        ),
        GoRoute(
          path: AppRoutes.community,
          builder: (context, state) => const CommunityScreen(),
        ),
        GoRoute(
          path: AppRoutes.care,
          builder: (context, state) => const CareScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.checkin,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CheckinScreen(),
    ),
    GoRoute(
      path: AppRoutes.aiInsight,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AiInsightScreen(),
    ),
    GoRoute(
      path: AppRoutes.adaptiveGoal,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AdaptiveGoalScreen(),
    ),
    GoRoute(
      path: AppRoutes.progress,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: AppRoutes.doctorProfile,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DoctorProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.appointments,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AppointmentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.preConsult,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PreConsultSummaryScreen(),
    ),
    GoRoute(
      path: AppRoutes.wellbeing,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WellbeingScreen(),
    ),
    GoRoute(
      path: AppRoutes.safety,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SafetyScreen(),
    ),
    GoRoute(
      path: AppRoutes.awareness,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AwarenessScreen(),
    ),
    GoRoute(
      path: '/patient/awareness/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'aware_1';
        return VideoDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: AppRoutes.records,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecordsScreen(),
    ),
    GoRoute(
      path: AppRoutes.family,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FamilyCircleScreen(),
    ),
  ],
);
