import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class FamilyMemberModel {
  final String id;
  final String name;
  final String relation;
  final String phone;
  final String status;
  final Map<String, bool> sharedPermissions;

  FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.status = 'Connected',
    required this.sharedPermissions,
  });

  FamilyMemberModel copyWith({
    String? id,
    String? name,
    String? relation,
    String? phone,
    String? status,
    Map<String, bool>? sharedPermissions,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      phone: phone ?? this.phone,
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
                phone: '+91 98111 22334',
                status: 'Connected',
                sharedPermissions: {
                  'Wellbeing updates': true,
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

  void addMember(String name, String relation, String phone) {
    final newMember = FamilyMemberModel(
      id: 'fam_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      relation: relation,
      phone: phone,
      status: 'Connected',
      sharedPermissions: {
        'Wellbeing updates': false,
        'Goals & progress': true,
        'Care schedule': false,
        'Care summaries': false,
        'Health records': false,
      },
    );

    state = state.copyWith(members: [...state.members, newMember]);
    try {
      _apiClient.post(
        ApiEndpoints.familyInvite,
        data: {
          'name': name,
          'relation': relation,
          'phone': phone,
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

final familyProvider = StateNotifierProvider<FamilyNotifier, FamilyState>((ref) {
  return FamilyNotifier();
});
