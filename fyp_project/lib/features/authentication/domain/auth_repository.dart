import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../domain/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient);
});

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final accessToken = data['access_token'] as String;
    
    // Fetch user profile using the access token
    final profileResponse = await getProfile(tokenOverride: accessToken);

    return {
      'access_token': accessToken,
      'user': profileResponse,
    };
  }

  /// Signup new user
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
    required String role,
    String? businessName,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.signup,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        if (businessName != null && businessName.isNotEmpty) 'business_name': businessName,
      },
    );

    return response.data as Map<String, dynamic>;
  }

  /// Fetch authenticated user profile
  Future<UserModel> getProfile({String? tokenOverride}) async {
    final response = await _dioClient.get(
      ApiConstants.profile,
    );

    final data = response.data as Map<String, dynamic>;
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'customer',
      avatarUrl: data['avatar_url'] ?? (data['role'] == 'owner' ? 'assets/images/avatar_sarah.png' : 'assets/images/avatar_user.png'),
      salonName: data['business_name'] ?? data['salon_name'],
    );
  }

  /// Update profile info
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    final response = await _dioClient.put(
      ApiConstants.profile,
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
    );

    final data = (response.data['profile'] ?? response.data) as Map<String, dynamic>;
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'customer',
      avatarUrl: data['avatar_url'],
      salonName: data['business_name'] ?? data['salon_name'],
    );
  }
}
