import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class HomeState {
  final bool isLoading;
  final String greeting;
  final String subgreeting;
  final Map<String, dynamic> pulseToday;
  final Map<String, dynamic> nextSmallStep;
  final Map<String, dynamic> progressSummary;
  final Map<String, dynamic> careTeamStatus;
  final Map<String, dynamic> recommendedAwareness;

  HomeState({
    this.isLoading = false,
    this.greeting = 'Good morning, Ananya',
    this.subgreeting = 'How are you feeling today?',
    this.pulseToday = const {
      'mood': 'Okay',
      'moodDetail': 'Logged 8:30 AM',
      'stress': 'Moderate',
      'stressDetail': 'Steady',
      'energy': 'Low',
      'energyDetail': 'Needs rest',
    },
    this.nextSmallStep = const {
      'title': 'Take a 10-minute walk today.',
      'description': 'Small actions are easier to sustain without pressure.',
      'category': 'General wellbeing routine',
      'duration': '10 min',
    },
    this.progressSummary = const {
      'checkinsThisWeek': 4,
      'message': 'Keep building your pattern.',
      'weekDays': [
        {'day': 'Mon', 'completed': true},
        {'day': 'Tue', 'completed': true},
        {'day': 'Wed', 'completed': true},
        {'day': 'Thu', 'completed': true},
        {'day': 'Fri', 'completed': false},
        {'day': 'Sat', 'completed': false},
        {'day': 'Sun', 'completed': false},
      ],
    },
    this.careTeamStatus = const {
      'connected': true,
      'doctorName': 'Dr. Meera Sharma',
      'nextAppointment': '24 Sep 2026',
    },
    this.recommendedAwareness = const {
      'id': 'aware_1',
      'title': 'Understanding stress and your body',
      'category': 'Mental wellbeing',
      'duration': '4 min read',
    },
  });

  HomeState copyWith({
    bool? isLoading,
    String? greeting,
    String? subgreeting,
    Map<String, dynamic>? pulseToday,
    Map<String, dynamic>? nextSmallStep,
    Map<String, dynamic>? progressSummary,
    Map<String, dynamic>? careTeamStatus,
    Map<String, dynamic>? recommendedAwareness,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      greeting: greeting ?? this.greeting,
      subgreeting: subgreeting ?? this.subgreeting,
      pulseToday: pulseToday ?? this.pulseToday,
      nextSmallStep: nextSmallStep ?? this.nextSmallStep,
      progressSummary: progressSummary ?? this.progressSummary,
      careTeamStatus: careTeamStatus ?? this.careTeamStatus,
      recommendedAwareness: recommendedAwareness ?? this.recommendedAwareness,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final ApiClient _apiClient = ApiClient();

  HomeNotifier() : super(HomeState()) {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    state = state.copyWith(isLoading: true);
    try {
      final res = await _apiClient.get(ApiEndpoints.patientHome);
      if (res.statusCode == 200 && res.data['success'] == true) {
        state = state.copyWith(
          greeting: res.data['greeting'],
          subgreeting: res.data['subgreeting'],
          pulseToday: res.data['pulseToday'],
          nextSmallStep: res.data['nextSmallStep'],
          progressSummary: res.data['progressSummary'],
          careTeamStatus: res.data['careTeamStatus'],
          recommendedAwareness: res.data['recommendedAwareness'],
          isLoading: false,
        );
        return;
      }
    } catch (_) {}
    state = state.copyWith(isLoading: false);
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
