import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class LocalAuthUser {
  final String name;
  final String email;
  final String password;
  final String role;
  final String phone;

  LocalAuthUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
  });
}

class AuthState {
  final bool isAuthenticated;
  final String role;
  final String? token;
  final String name;
  final String email;
  final bool isLoading;
  final String? error;

  AuthState({
    this.isAuthenticated = true,
    this.role = 'patient',
    this.token,
    this.name = 'Ananya Sharma',
    this.email = 'patient@pulse.health',
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? role,
    String? token,
    String? name,
    String? email,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient = ApiClient();
  final List<LocalAuthUser> _localUsers = [
    LocalAuthUser(
      name: 'Ananya Sharma',
      email: 'patient@pulse.health',
      password: 'pulse123',
      role: 'patient',
      phone: '+91 98765 43210',
    ),
    LocalAuthUser(
      name: 'Dr. Meera Sharma',
      email: 'doctor@pulse.health',
      password: 'pulse123',
      role: 'doctor',
      phone: '+91 98765 12345',
    ),
  ];

  AuthNotifier() : super(AuthState());

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> login({
    required String identifier,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final cleanIdentifier = identifier.trim().toLowerCase();
    final cleanRole = role.trim().toLowerCase();

    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'identifier': identifier.trim(),
          'email': identifier.trim(),
          'password': password,
          'role': cleanRole,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final user = response.data['user'] as Map<String, dynamic>;
        _apiClient.setToken(token);

        state = state.copyWith(
          isAuthenticated: true,
          token: token,
          role: user['role'] ?? cleanRole,
          name: user['name'] ?? (cleanRole == 'doctor' ? 'Dr. Meera Sharma' : 'Ananya Sharma'),
          email: user['email'] ?? cleanIdentifier,
          isLoading: false,
          error: null,
        );
        return true;
      } else {
        final msg = response.data['message'] ?? 'Login failed';
        state = state.copyWith(isLoading: false, error: msg.toString());
        return false;
      }
    } on DioException catch (dioErr) {
      if (dioErr.response != null && dioErr.response?.data != null) {
        final data = dioErr.response!.data;
        String msg = 'Invalid credentials';
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        }
        state = state.copyWith(isLoading: false, error: msg);
        return false;
      }

      final matched = _localUsers.cast<LocalAuthUser?>().firstWhere(
        (u) =>
            u != null &&
            (u.email.toLowerCase() == cleanIdentifier || u.phone == identifier.trim()) &&
            u.role.toLowerCase() == cleanRole,
        orElse: () => null,
      );

      if (matched == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid credentials. User not found.',
        );
        return false;
      }

      if (matched.password != password) {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid credentials. Incorrect password.',
        );
        return false;
      }

      final mockToken = 'offline_jwt_${matched.role}_${DateTime.now().millisecondsSinceEpoch}';
      _apiClient.setToken(mockToken);
      state = state.copyWith(
        isAuthenticated: true,
        token: mockToken,
        role: matched.role,
        name: matched.name,
        email: matched.email,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred during sign in.',
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String role = 'patient',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final cleanEmail = email.trim().toLowerCase();
    final cleanRole = role.trim().toLowerCase();
    final cleanName = name.trim();
    final cleanPhone = (phone != null && phone.trim().isNotEmpty) ? phone.trim() : '+91 98765 00000';

    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': cleanName,
          'email': cleanEmail,
          'password': password,
          'phone': cleanPhone,
          'role': cleanRole,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final user = response.data['user'] as Map<String, dynamic>;
        _apiClient.setToken(token);

        state = state.copyWith(
          isAuthenticated: true,
          token: token,
          role: user['role'] ?? cleanRole,
          name: user['name'] ?? cleanName,
          email: user['email'] ?? cleanEmail,
          isLoading: false,
          error: null,
        );
        return true;
      } else {
        final msg = response.data['message'] ?? 'Registration failed';
        state = state.copyWith(isLoading: false, error: msg.toString());
        return false;
      }
    } on DioException catch (dioErr) {
      if (dioErr.response != null && dioErr.response?.data != null) {
        final data = dioErr.response!.data;
        String msg = 'Registration failed';
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        }
        state = state.copyWith(isLoading: false, error: msg);
        return false;
      }

      final existing = _localUsers.any((u) => u.email.toLowerCase() == cleanEmail);
      if (existing) {
        state = state.copyWith(
          isLoading: false,
          error: 'An account with this email already exists',
        );
        return false;
      }

      final newUser = LocalAuthUser(
        name: cleanName,
        email: cleanEmail,
        password: password,
        role: cleanRole,
        phone: cleanPhone,
      );
      _localUsers.add(newUser);

      final mockToken = 'offline_jwt_${cleanRole}_${DateTime.now().millisecondsSinceEpoch}';
      _apiClient.setToken(mockToken);
      state = state.copyWith(
        isAuthenticated: true,
        token: mockToken,
        role: cleanRole,
        name: cleanName,
        email: cleanEmail,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred during account creation.',
      );
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isLoading: false, error: null);
    return true;
  }

  void logout() {
    _apiClient.clearToken();
    state = AuthState(
      isAuthenticated: false,
      token: null,
      name: '',
      email: '',
      role: 'patient',
      isLoading: false,
      error: null,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
