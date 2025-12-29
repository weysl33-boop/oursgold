import '../models/user.dart';
import '../services/api_client.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// Register a new user
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      '/api/v1/auth/register',
      data: request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save token
    await _apiClient.saveToken(authResponse.accessToken);

    return authResponse;
  }

  /// Login user
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      '/api/v1/auth/login',
      data: request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save token
    await _apiClient.saveToken(authResponse.accessToken);

    return authResponse;
  }

  /// Get current user
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get('/api/v1/auth/me');
    return User.fromJson(response.data);
  }

  /// Refresh token
  Future<AuthResponse> refreshToken() async {
    final response = await _apiClient.post('/api/v1/auth/refresh');

    final authResponse = AuthResponse.fromJson(response.data);

    // Save new token
    await _apiClient.saveToken(authResponse.accessToken);

    return authResponse;
  }

  /// Logout
  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _apiClient.hasToken();
  }
}
