import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class CareState {
  final bool isLoading;
  final Map<String, dynamic> careTeam;
  final Map<String, dynamic> upcomingAppointment;
  final Map<String, dynamic> preConsultSummary;

  CareState({
    this.isLoading = false,
    this.careTeam = const {
      'partner': {
        'name': 'Dr. Meera Sharma',
        'title': 'Primary Care Professional',
        'specialty': 'Integrated Family Medicine · St. Jude Health',
        'partnerCode': 'SJH-4829',
        'connectedSince': '12 Sep 2026',
        'lastConsultation': '12 Sep 2026',
        'nextAppointment': '24 Sep 2026',
      },
      'disciplines': [
        {'name': 'Primary Care', 'connected': true, 'doctor': 'Dr. Meera Sharma'},
        {'name': 'Therapist', 'connected': false, 'doctor': null},
        {'name': 'Psychologist', 'connected': false, 'doctor': null},
        {'name': 'Psychiatrist', 'connected': false, 'doctor': null},
      ],
    },
    this.upcomingAppointment = const {
      'id': 'apt_1',
      'title': 'Routine Consultation',
      'doctorName': 'Dr. Meera Sharma, MD',
      'date': 'Thursday, 24 Sep 2026',
      'time': '11:30 AM',
      'duration': '45 min',
      'venue': 'St. Jude Health & Virtual Hybrid Option',
      'status': 'Confirmed',
    },
    this.preConsultSummary = const {
      'isApproved': false,
      'isDraft': true,
      'checkinsCount': 6,
      'activeGoalsCount': 2,
      'patternsCount': 1,
    },
  });

  CareState copyWith({
    bool? isLoading,
    Map<String, dynamic>? careTeam,
    Map<String, dynamic>? upcomingAppointment,
    Map<String, dynamic>? preConsultSummary,
  }) {
    return CareState(
      isLoading: isLoading ?? this.isLoading,
      careTeam: careTeam ?? this.careTeam,
      upcomingAppointment: upcomingAppointment ?? this.upcomingAppointment,
      preConsultSummary: preConsultSummary ?? this.preConsultSummary,
    );
  }
}

class CareNotifier extends StateNotifier<CareState> {
  final ApiClient _apiClient = ApiClient();

  CareNotifier() : super(CareState()) {
    fetchCareOverview();
  }

  Future<void> fetchCareOverview() async {
    state = state.copyWith(isLoading: true);
    try {
      final res = await _apiClient.get(ApiEndpoints.careOverview);
      if (res.statusCode == 200 && res.data['success'] == true) {
        state = state.copyWith(
          careTeam: res.data['careTeam'],
          upcomingAppointment: res.data['upcomingAppointment'],
          isLoading: false,
        );
        return;
      }
    } catch (_) {}
    state = state.copyWith(isLoading: false);
  }

  Future<void> approveSummary() async {
    try {
      await _apiClient.post(ApiEndpoints.preConsultApprove);
      state = state.copyWith(
        preConsultSummary: {
          ...state.preConsultSummary,
          'isApproved': true,
          'isDraft': false,
        },
      );
    } catch (_) {}
  }
}

final careProvider = StateNotifierProvider<CareNotifier, CareState>((ref) {
  return CareNotifier();
});
