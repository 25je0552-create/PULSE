import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class CheckinState {
  final String mood;
  final String stress;
  final String energy;
  final String sleep;
  final String reflection;
  final bool isSubmitting;
  final bool isCompleted;

  CheckinState({
    this.mood = 'Okay',
    this.stress = 'High',
    this.energy = 'Low',
    this.sleep = 'Poorly',
    this.reflection = 'Work has been overwhelming this week.',
    this.isSubmitting = false,
    this.isCompleted = false,
  });

  CheckinState copyWith({
    String? mood,
    String? stress,
    String? energy,
    String? sleep,
    String? reflection,
    bool? isSubmitting,
    bool? isCompleted,
  }) {
    return CheckinState(
      mood: mood ?? this.mood,
      stress: stress ?? this.stress,
      energy: energy ?? this.energy,
      sleep: sleep ?? this.sleep,
      reflection: reflection ?? this.reflection,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class CheckinNotifier extends StateNotifier<CheckinState> {
  final ApiClient _apiClient = ApiClient();

  CheckinNotifier() : super(CheckinState());

  void setMood(String mood) => state = state.copyWith(mood: mood);
  void setStress(String stress) => state = state.copyWith(stress: stress);
  void setEnergy(String energy) => state = state.copyWith(energy: energy);
  void setSleep(String sleep) => state = state.copyWith(sleep: sleep);
  void setReflection(String ref) => state = state.copyWith(reflection: ref);

  Future<bool> submitCheckin() async {
    state = state.copyWith(isSubmitting: true);
    try {
      final res = await _apiClient.post(
        ApiEndpoints.checkins,
        data: {
          'mood': state.mood,
          'stress': state.stress,
          'energy': state.energy,
          'sleep': state.sleep,
          'reflection': state.reflection,
          'sleepHours': state.sleep == 'Poorly' ? 5.5 : 7.0,
          'goalCompleted': true,
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        state = state.copyWith(isSubmitting: false, isCompleted: true);
        return true;
      }
    } catch (_) {}

    state = state.copyWith(isSubmitting: false, isCompleted: true);
    return true;
  }
}

final checkinProvider = StateNotifierProvider<CheckinNotifier, CheckinState>((ref) {
  return CheckinNotifier();
});
