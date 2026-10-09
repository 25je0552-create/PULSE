import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class GoalItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final int durationMinutes;
  final String frequency;
  final String preferredTime;
  final String difficulty;
  final bool isActive;

  GoalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    this.frequency = 'Every day',
    this.preferredTime = 'Afternoon',
    this.difficulty = 'Easy',
    this.isActive = false,
  });

  GoalItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? durationMinutes,
    String? frequency,
    String? preferredTime,
    String? difficulty,
    bool? isActive,
  }) {
    return GoalItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      frequency: frequency ?? this.frequency,
      preferredTime: preferredTime ?? this.preferredTime,
      difficulty: difficulty ?? this.difficulty,
      isActive: isActive ?? this.isActive,
    );
  }
}

class GoalsState {
  final bool isLoading;
  final GoalItem activeGoal;
  final List<GoalItem> alternatives;

  GoalsState({
    this.isLoading = false,
    required this.activeGoal,
    this.alternatives = const [],
  });

  GoalsState copyWith({
    bool? isLoading,
    GoalItem? activeGoal,
    List<GoalItem>? alternatives,
  }) {
    return GoalsState(
      isLoading: isLoading ?? this.isLoading,
      activeGoal: activeGoal ?? this.activeGoal,
      alternatives: alternatives ?? this.alternatives,
    );
  }
}

class GoalsNotifier extends StateNotifier<GoalsState> {
  final ApiClient _apiClient = ApiClient();

  GoalsNotifier()
      : super(
          GoalsState(
            activeGoal: GoalItem(
              id: 'g_1',
              title: 'Take 10 minutes away from your work screen today.',
              description: 'Step away from work notifications, rest your eyes, or take a gentle pause without any agenda.',
              category: 'Screen Pause',
              durationMinutes: 10,
              frequency: 'Every day',
              preferredTime: 'Afternoon',
              difficulty: 'Easy',
              isActive: true,
            ),
            alternatives: [
              GoalItem(
                id: 'g_2',
                title: 'Take a short walk',
                description: '5 min · Gentle movement',
                category: 'Movement',
                durationMinutes: 5,
              ),
              GoalItem(
                id: 'g_3',
                title: 'Go to bed 20 minutes earlier',
                description: '20 min · Sleep support',
                category: 'Sleep',
                durationMinutes: 20,
              ),
              GoalItem(
                id: 'g_4',
                title: 'Take a few minutes to breathe and reset',
                description: '2 min · Breathwork pause',
                category: 'Breathwork',
                durationMinutes: 2,
              ),
            ],
          ),
        );

  void updateFrequency(String freq) {
    state = state.copyWith(
      activeGoal: state.activeGoal.copyWith(frequency: freq),
    );
  }

  void updatePreferredTime(String time) {
    state = state.copyWith(
      activeGoal: state.activeGoal.copyWith(preferredTime: time),
    );
  }

  void updateDifficulty(String diff) {
    state = state.copyWith(
      activeGoal: state.activeGoal.copyWith(difficulty: diff),
    );
  }

  void reduceTo5Minutes() {
    state = state.copyWith(
      activeGoal: state.activeGoal.copyWith(
        durationMinutes: 5,
        title: 'Take 5 minutes away from your work screen today.',
        difficulty: 'Easy',
      ),
    );
  }

  void selectAlternative(GoalItem item) {
    state = state.copyWith(
      activeGoal: state.activeGoal.copyWith(
        id: item.id,
        title: item.title,
        description: item.description,
        category: item.category,
        durationMinutes: item.durationMinutes,
        isActive: true,
      ),
    );
  }

  Future<void> confirmGoal() async {
    try {
      await _apiClient.post(
        ApiEndpoints.goalsActive,
        data: {
          'title': state.activeGoal.title,
          'durationMinutes': state.activeGoal.durationMinutes,
          'frequency': state.activeGoal.frequency,
          'preferredTime': state.activeGoal.preferredTime,
          'difficulty': state.activeGoal.difficulty,
          'category': state.activeGoal.category,
        },
      );
    } catch (_) {}
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, GoalsState>((ref) {
  return GoalsNotifier();
});
