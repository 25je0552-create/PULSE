import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class RecordModel {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final String category;
  final String date;
  final String actionLabel;
  final String details;
  final List<String> recommendations;

  RecordModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.category,
    required this.date,
    required this.actionLabel,
    required this.details,
    this.recommendations = const [],
  });

  RecordModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? badge,
    String? category,
    String? date,
    String? actionLabel,
    String? details,
    List<String>? recommendations,
  }) {
    return RecordModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      badge: badge ?? this.badge,
      category: category ?? this.category,
      date: date ?? this.date,
      actionLabel: actionLabel ?? this.actionLabel,
      details: details ?? this.details,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

class RecordsState {
  final bool isLoading;
  final String selectedCategory;
  final String searchQuery;
  final List<RecordModel> records;

  RecordsState({
    this.isLoading = false,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.records = const [],
  });

  RecordsState copyWith({
    bool? isLoading,
    String? selectedCategory,
    String? searchQuery,
    List<RecordModel>? records,
  }) {
    return RecordsState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      records: records ?? this.records,
    );
  }
}

class RecordsNotifier extends StateNotifier<RecordsState> {
  final ApiClient _apiClient = ApiClient();

  RecordsNotifier()
      : super(
          RecordsState(
            records: [
              RecordModel(
                id: 'rec_1',
                title: 'Consultation summary',
                subtitle: 'Dr. Meera Sharma · Primary Care',
                badge: 'Clinician note',
                category: 'Care documents',
                date: '18 Sep 2026',
                actionLabel: 'View summary',
                details:
                    'Discussed daily stress pacing, sleep routine adjustments, and scheduled follow-up check-in for 24 September. Patient agreed to log weekly energy levels.',
                recommendations: [
                  'Limit screen time 45 min before resting',
                  'Maintain regular hydration schedule',
                  'Follow up during next cycle consult',
                ],
              ),
              RecordModel(
                id: 'rec_2',
                title: 'Wellbeing review',
                subtitle: 'Pulse check-in summary · 30-day rhythm',
                badge: 'Self-reported',
                category: 'Wellbeing history',
                date: '16 Sep 2026',
                actionLabel: 'Recorded',
                details:
                    'Self-reported 30-day rhythm review shows stable evening recovery patterns and lower morning friction.',
                recommendations: [
                  'Continue 10-minute morning pacing',
                  'Maintain steady bedtime hours',
                ],
              ),
              RecordModel(
                id: 'rec_3',
                title: 'Care plan',
                subtitle: 'Updated care plan & lifestyle guidance',
                badge: 'Care team',
                category: 'Care documents',
                date: '12 Sep 2026',
                actionLabel: 'Read plan',
                details:
                    'Prescribed and confirmed during your 12 Sep consultation with Dr. Meera Sharma. Focus on sleep routine regularity.',
                recommendations: [
                  'Regular sleep hygiene schedule',
                  'Hydration routine reinforcement',
                ],
              ),
              RecordModel(
                id: 'rec_4',
                title: 'Sleep & wellbeing report',
                subtitle: 'Pulse generated summary (Patient draft)',
                badge: 'Personal draft',
                category: 'Reports & results',
                date: '08 Sep 2026',
                actionLabel: 'Review draft',
                details:
                    'Patient draft summarizing sleep patterns and evening rest intervals over the previous fortnightly cycle.',
                recommendations: [
                  'Review draft prior to next clinical visit',
                ],
              ),
            ],
          ),
        );

  void setCategory(String category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(selectedCategory: 'All');
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void deleteRecord(String id) {
    state = state.copyWith(
      records: state.records.where((r) => r.id != id).toList(),
    );
  }

  void addRecord({
    required String title,
    required String subtitle,
    required String category,
    required String badge,
    required String details,
  }) {
    final newRec = RecordModel(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      badge: badge,
      category: category,
      date: 'Today',
      actionLabel: 'View summary',
      details: details,
      recommendations: [
        'Stored securely in local device vault',
      ],
    );
    state = state.copyWith(records: [newRec, ...state.records]);
    try {
      _apiClient.post(
        ApiEndpoints.records,
        data: {
          'title': title,
          'category': category,
        },
      );
    } catch (_) {}
  }
}

final recordsProvider =
    StateNotifierProvider<RecordsNotifier, RecordsState>((ref) {
  return RecordsNotifier();
});
