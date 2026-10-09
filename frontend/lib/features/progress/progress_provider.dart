import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class ProgressState {
  final int selectedRangeDays;
  final bool isLoading;
  final Map<String, dynamic> trendObservations;
  final List<dynamic> signalPoints;
  final Map<String, dynamic> activeGoal;

  ProgressState({
    this.selectedRangeDays = 7,
    this.isLoading = false,
    this.trendObservations = const {
      'mood': 'Mostly okay (Steady baseline)',
      'stress': 'Higher this week (Evening spikes noted)',
      'energy': 'Improving (Morning rebound ↑)',
      'sleep': 'Needs attention (Interrupted rhythm)',
    },
    this.signalPoints = const [
      {'day': 'Mon', 'stress': 2.0, 'sleep': 7.0, 'energy': 3.0, 'mood': 3.0},
      {'day': 'Tue', 'stress': 2.5, 'sleep': 6.5, 'energy': 3.0, 'mood': 3.5},
      {'day': 'Wed', 'stress': 4.0, 'sleep': 5.0, 'energy': 2.0, 'mood': 2.5},
      {'day': 'Thu', 'stress': 4.5, 'sleep': 4.5, 'energy': 1.5, 'mood': 2.0},
      {'day': 'Fri', 'stress': 4.0, 'sleep': 5.5, 'energy': 2.5, 'mood': 2.5},
      {'day': 'Sat', 'stress': 2.0, 'sleep': 7.5, 'energy': 3.5, 'mood': 4.0},
      {'day': 'Sun', 'stress': 2.0, 'sleep': 8.0, 'energy': 4.0, 'mood': 4.0},
    ],
    this.activeGoal = const {
      'title': 'Take 10 minutes away from your work screen',
      'category': 'Daily screen pause',
      'completedDays': 4,
      'targetDays': 6,
    },
  });

  ProgressState copyWith({
    int? selectedRangeDays,
    bool? isLoading,
    Map<String, dynamic>? trendObservations,
    List<dynamic>? signalPoints,
    Map<String, dynamic>? activeGoal,
  }) {
    return ProgressState(
      selectedRangeDays: selectedRangeDays ?? this.selectedRangeDays,
      isLoading: isLoading ?? this.isLoading,
      trendObservations: trendObservations ?? this.trendObservations,
      signalPoints: signalPoints ?? this.signalPoints,
      activeGoal: activeGoal ?? this.activeGoal,
    );
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  final ApiClient _apiClient = ApiClient();

  ProgressNotifier() : super(ProgressState()) {
    fetchProgress(7);
  }

  Future<void> fetchProgress(int days) async {
    state = state.copyWith(selectedRangeDays: days, isLoading: true);
    try {
      final res = await _apiClient.get(
        ApiEndpoints.progress,
        queryParameters: {'range': days},
      );
      if (res.statusCode == 200 && res.data['success'] == true) {
        final summary = res.data['summary'] as Map<String, dynamic>;
        state = state.copyWith(
          trendObservations: summary['trendObservations'],
          activeGoal: res.data['activeGoal'],
          isLoading: false,
        );
        return;
      }
    } catch (_) {}
    state = state.copyWith(isLoading: false);
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
