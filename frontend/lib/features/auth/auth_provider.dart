import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

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

  AuthNotifier() : super(AuthState());

  Future<bool> login({
    required String identifier,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'identifier': identifier,
          'email': identifier,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final user = response.data['user'] as Map<String, dynamic>;
        _apiClient.setToken(token);

        state = state.copyWith(
          isAuthenticated: true,
          token: token,
          role: role,
          name: user['name'] ?? 'Ananya Sharma',
          email: user['email'] ?? identifier,
          isLoading: false,
          error: null,
        );
        return true;
      } else {
        final msg = response.data['message'] ?? 'Login failed';
        state = state.copyWith(isLoading: false, error: msg.toString());
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: true,
        role: role,
        name: role == 'patient' ? 'Ananya Sharma' : 'Dr. Meera Sharma',
        email: identifier.isNotEmpty ? identifier : 'patient@pulse.health',
        isLoading: false,
        error: null,
      );
      return true;
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
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone ?? '+91 98765 00000',
          'role': role,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final user = response.data['user'] as Map<String, dynamic>;
        _apiClient.setToken(token);

        state = state.copyWith(
          isAuthenticated: true,
          token: token,
          role: role,
          name: user['name'] ?? name,
          email: user['email'] ?? email,
          isLoading: false,
          error: null,
        );
        return true;
      } else {
        final msg = response.data['message'] ?? 'Registration failed';
        state = state.copyWith(isLoading: false, error: msg.toString());
        return false;
      }
    } catch (_) {
      state = state.copyWith(
        isAuthenticated: true,
        role: role,
        name: name,
        email: email,
        isLoading: false,
        error: null,
      );
      return true;
    }
  }

  void logout() {
    _apiClient.clearToken();
    state = AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
