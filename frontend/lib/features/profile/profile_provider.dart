import 'package:flutter_riverpod/legacy.dart';

class ProfileState {
  final String name;
  final String patientCode;
  final String memberSince;
  final bool useCheckinsForAi;
  final bool useGoalsForAi;
  final bool checkinReminders;
  final bool careUpdates;

  ProfileState({
    this.name = 'Ananya Sharma',
    this.patientCode = 'PLS-84920',
    this.memberSince = 'August 2026',
    this.useCheckinsForAi = true,
    this.useGoalsForAi = true,
    this.checkinReminders = true,
    this.careUpdates = true,
  });

  ProfileState copyWith({
    String? name,
    String? patientCode,
    String? memberSince,
    bool? useCheckinsForAi,
    bool? useGoalsForAi,
    bool? checkinReminders,
    bool? careUpdates,
  }) {
    return ProfileState(
      name: name ?? this.name,
      patientCode: patientCode ?? this.patientCode,
      memberSince: memberSince ?? this.memberSince,
      useCheckinsForAi: useCheckinsForAi ?? this.useCheckinsForAi,
      useGoalsForAi: useGoalsForAi ?? this.useGoalsForAi,
      checkinReminders: checkinReminders ?? this.checkinReminders,
      careUpdates: careUpdates ?? this.careUpdates,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState());

  void toggleCheckinsAi(bool val) => state = state.copyWith(useCheckinsForAi: val);
  void toggleGoalsAi(bool val) => state = state.copyWith(useGoalsForAi: val);
  void toggleReminders(bool val) => state = state.copyWith(checkinReminders: val);
  void toggleCareUpdates(bool val) => state = state.copyWith(careUpdates: val);
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
