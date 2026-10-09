import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class FamilyMemberModel {
  final String id;
  final String name;
  final String relation;
  final String contact;
  final String status;
  final Map<String, bool> sharedPermissions;

  FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.contact,
    this.status = 'Connected',
    required this.sharedPermissions,
  });

  FamilyMemberModel copyWith({
    String? id,
    String? name,
    String? relation,
    String? contact,
    String? status,
    Map<String, bool>? sharedPermissions,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      contact: contact ?? this.contact,
      status: status ?? this.status,
      sharedPermissions: sharedPermissions ?? this.sharedPermissions,
    );
  }
}

class FamilyState {
  final bool isLoading;
  final List<FamilyMemberModel> members;

  FamilyState({
    this.isLoading = false,
    this.members = const [],
  });

  FamilyState copyWith({
    bool? isLoading,
    List<FamilyMemberModel>? members,
  }) {
    return FamilyState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
    );
  }
}

class FamilyNotifier extends StateNotifier<FamilyState> {
  final ApiClient _apiClient = ApiClient();

  FamilyNotifier()
      : super(
          FamilyState(
            members: [
              FamilyMemberModel(
                id: 'fam_1',
                name: 'Priya',
                relation: 'Sister',
                contact: 'priya@family.pulse',
                status: 'Connected',
                sharedPermissions: {
                  'Wellbeing check-ins': true,
                  'Goals & progress': true,
                  'Care schedule': false,
                  'Care summaries': false,
                  'Health records': false,
                },
              ),
            ],
          ),
        );

  void togglePermission(String memberId, String permissionKey) {
    state = state.copyWith(
      members: state.members.map((m) {
        if (m.id == memberId) {
          final newPerms = Map<String, bool>.from(m.sharedPermissions);
          newPerms[permissionKey] = !(newPerms[permissionKey] ?? false);
          final updated = m.copyWith(sharedPermissions: newPerms);
          _syncPermissions(updated);
          return updated;
        }
        return m;
      }).toList(),
    );
  }

  void updateAllPermissions(
      String memberId, Map<String, bool> updatedPermissions) {
    state = state.copyWith(
      members: state.members.map((m) {
        if (m.id == memberId) {
          final updated = m.copyWith(sharedPermissions: updatedPermissions);
          _syncPermissions(updated);
          return updated;
        }
        return m;
      }).toList(),
    );
  }

  void removeMember(String memberId) {
    state = state.copyWith(
      members: state.members.where((m) => m.id != memberId).toList(),
    );
  }

  void addMember({
    required String name,
    required String relation,
    required String contact,
    required Map<String, bool> permissions,
  }) {
    final newMember = FamilyMemberModel(
      id: 'fam_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      relation: relation,
      contact: contact,
      status: 'Connected',
      sharedPermissions: permissions,
    );

    state = state.copyWith(members: [...state.members, newMember]);
    try {
      _apiClient.post(
        ApiEndpoints.familyInvite,
        data: {
          'name': name,
          'relation': relation,
          'contact': contact,
        },
      );
    } catch (_) {}
  }

  void _syncPermissions(FamilyMemberModel member) {
    try {
      _apiClient.patch(
        ApiEndpoints.familyPermissions,
        data: {
          'memberId': member.id,
          'permissions': member.sharedPermissions,
        },
      );
    } catch (_) {}
  }
}

final familyProvider =
    StateNotifierProvider<FamilyNotifier, FamilyState>((ref) {
  return FamilyNotifier();
});
