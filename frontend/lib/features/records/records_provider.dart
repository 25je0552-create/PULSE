import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class RecordModel {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String category;
  final String date;
  final String facility;
  final String details;
  final bool sharedWithDoctor;
  final bool sharedWithFamily;

  RecordModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.category,
    required this.date,
    required this.facility,
    required this.details,
    this.sharedWithDoctor = true,
    this.sharedWithFamily = false,
  });

  RecordModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? type,
    String? category,
    String? date,
    String? facility,
    String? details,
    bool? sharedWithDoctor,
    bool? sharedWithFamily,
  }) {
    return RecordModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      facility: facility ?? this.facility,
      details: details ?? this.details,
      sharedWithDoctor: sharedWithDoctor ?? this.sharedWithDoctor,
      sharedWithFamily: sharedWithFamily ?? this.sharedWithFamily,
    );
  }
}

class RecordsState {
  final bool isLoading;
  final String selectedCategory;
  final List<RecordModel> records;

  RecordsState({
    this.isLoading = false,
    this.selectedCategory = 'All',
    this.records = const [],
  });

  RecordsState copyWith({
    bool? isLoading,
    String? selectedCategory,
    List<RecordModel>? records,
  }) {
    return RecordsState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
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
                type: 'Clinician note',
                category: 'Care documents',
                date: '18 Sep 2026',
                facility: 'St. Jude Health Center',
                details: 'Follow-up regarding lifestyle pacing, sleep hygiene advice, and baseline metabolic monitoring.',
                sharedWithDoctor: true,
                sharedWithFamily: false,
              ),
              RecordModel(
                id: 'rec_2',
                title: 'Comprehensive Metabolic Panel & Hormonal Baseline',
                subtitle: 'Bengaluru Diagnostic Laboratories',
                type: 'Lab report',
                category: 'Reports & results',
                date: '10 Sep 2026',
                facility: 'BDL Labs, Indiranagar',
                details: 'Insulin, lipid profile, thyroid function, and androgen indices reviewed with primary care doctor.',
                sharedWithDoctor: true,
                sharedWithFamily: false,
              ),
              RecordModel(
                id: 'rec_3',
                title: 'Current Nutritional Care Guidelines',
                subtitle: 'Dr. Meera Sharma, MD',
                type: 'Care plan',
                category: 'Prescriptions',
                date: '12 Sep 2026',
                facility: 'St. Jude Health',
                details: 'Magnesium glycinate supplement guidance, balanced glycemic meals recommendation.',
                sharedWithDoctor: true,
                sharedWithFamily: false,
              ),
              RecordModel(
                id: 'rec_4',
                title: 'Pulse 30-Day Check-in Synthesis',
                subtitle: 'Self-reported telemetry archive',
                type: 'Wellbeing history',
                category: 'Wellbeing history',
                date: '22 Sep 2026',
                facility: 'Pulse Encrypted Vault',
                details: 'Archive of self-reported mood, energy, and stress daily signals.',
                sharedWithDoctor: true,
                sharedWithFamily: true,
              ),
            ],
          ),
        );

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleDoctorSharing(String id) {
    state = state.copyWith(
      records: state.records.map((r) {
        if (r.id == id) {
          final updated = r.copyWith(sharedWithDoctor: !r.sharedWithDoctor);
          _syncPermissions(updated);
          return updated;
        }
        return r;
      }).toList(),
    );
  }

  void toggleFamilySharing(String id) {
    state = state.copyWith(
      records: state.records.map((r) {
        if (r.id == id) {
          final updated = r.copyWith(sharedWithFamily: !r.sharedWithFamily);
          _syncPermissions(updated);
          return updated;
        }
        return r;
      }).toList(),
    );
  }

  void addRecord(String title, String category, String facility) {
    final newRec = RecordModel(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: 'Uploaded by patient',
      type: 'Personal Record',
      category: category,
      date: 'Today',
      facility: facility,
      details: 'Patient document stored securely in Pulse Personal Vault.',
      sharedWithDoctor: false,
      sharedWithFamily: false,
    );

    state = state.copyWith(records: [newRec, ...state.records]);
    try {
      _apiClient.post(
        ApiEndpoints.records,
        data: {
          'title': title,
          'category': category,
          'facility': facility,
        },
      );
    } catch (_) {}
  }

  void _syncPermissions(RecordModel record) {
    try {
      _apiClient.patch(
        '${ApiEndpoints.records}/${record.id}/permissions',
        data: {
          'sharedWithDoctor': record.sharedWithDoctor,
          'sharedWithFamily': record.sharedWithFamily,
        },
      );
    } catch (_) {}
  }
}

final recordsProvider = StateNotifierProvider<RecordsNotifier, RecordsState>((ref) {
  return RecordsNotifier();
});
