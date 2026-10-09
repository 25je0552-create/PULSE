import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/routing/app_routes.dart';
import 'package:pulse/core/network/api_endpoints.dart';
import 'package:pulse/core/network/api_client.dart';
import 'package:pulse/features/auth/auth_provider.dart';
import 'package:pulse/features/checkin/checkin_provider.dart';
import 'package:pulse/features/pulse_ai/ai_provider.dart';
import 'package:pulse/features/goals/goals_provider.dart';

void main() {
  group('Pulse Theme & Constants', () {
    test('AppColors are correctly configured', () {
      expect(AppColors.primary, equals(const Color(0xFF00685F)));
      expect(AppColors.secondary, equals(const Color(0xFF006398)));
      expect(AppColors.tertiary, equals(const Color(0xFF4648D4)));
      expect(AppColors.surface, equals(const Color(0xFFFAF8FF)));
    });

    test('AppRoutes defines patient screen paths', () {
      expect(AppRoutes.splash, equals('/'));
      expect(AppRoutes.login, equals('/login'));
      expect(AppRoutes.onboarding, equals('/patient/onboarding'));
      expect(AppRoutes.consent, equals('/patient/consent'));
      expect(AppRoutes.baseline, equals('/patient/baseline'));
      expect(AppRoutes.connectDoctor, equals('/patient/doctor/connect'));
      expect(AppRoutes.home, equals('/patient/home'));
      expect(AppRoutes.checkin, equals('/patient/check-in'));
      expect(AppRoutes.pulseAi, equals('/patient/ai'));
      expect(AppRoutes.aiInsight, equals('/patient/insights'));
      expect(AppRoutes.adaptiveGoal, equals('/patient/goals'));
      expect(AppRoutes.progress, equals('/patient/progress'));
      expect(AppRoutes.care, equals('/patient/care'));
      expect(AppRoutes.doctorProfile, equals('/patient/doctor'));
      expect(AppRoutes.appointments, equals('/patient/appointments'));
      expect(AppRoutes.preConsult, equals('/patient/pre-consult'));
      expect(AppRoutes.wellbeing, equals('/patient/wellbeing'));
      expect(AppRoutes.safety, equals('/patient/safety'));
      expect(AppRoutes.awareness, equals('/patient/awareness'));
      expect(AppRoutes.records, equals('/patient/records'));
      expect(AppRoutes.family, equals('/patient/family'));
      expect(AppRoutes.profile, equals('/patient/profile'));
    });

    test('ApiEndpoints defined correctly', () {
      expect(ApiEndpoints.login, equals('/auth/login'));
      expect(ApiEndpoints.checkins, equals('/checkins'));
      expect(ApiEndpoints.aiChat, equals('/ai/chat'));
      expect(ApiEndpoints.goals, equals('/goals'));
      expect(ApiEndpoints.safetyHelplines, equals('/safety/trusted-contact'));
    });
  });

  group('Pulse API Client & State Notifiers', () {
    test('ApiClient initializes cleanly without env crash', () {
      final client = ApiClient();
      expect(client.dio, isNotNull);
      expect(client.dio.options.headers['Content-Type'], equals('application/json'));
    });

    test('AuthState initial state defaults', () {
      final state = AuthState();
      expect(state.isLoading, isFalse);
      expect(state.isAuthenticated, isTrue);
      expect(state.name, equals('Ananya Sharma'));
      expect(state.role, equals('patient'));
    });

    test('CheckinState initial defaults', () {
      final state = CheckinState();
      expect(state.mood, equals('Okay'));
      expect(state.stress, equals('High'));
      expect(state.energy, equals('Low'));
      expect(state.isSubmitting, isFalse);
      expect(state.isCompleted, isFalse);
    });

    test('AiState default state', () {
      final state = AiState();
      expect(state.isLoading, isFalse);
      expect(state.isSending, isFalse);
      expect(state.hasSafetyEscalation, isFalse);
      expect(state.messages, isEmpty);
    });

    test('GoalsState active goal initialization', () {
      final goal = GoalItem(
        id: 'g1',
        title: 'Gentle Walk',
        description: 'Reduces cortisol without adrenal strain.',
        category: 'Movement',
        durationMinutes: 15,
        frequency: 'Daily',
        difficulty: 'Easy',
        isActive: true,
      );
      final state = GoalsState(activeGoal: goal);
      expect(state.isLoading, isFalse);
      expect(state.activeGoal.title, equals('Gentle Walk'));
      expect(state.alternatives, isEmpty);
    });
  });
}
