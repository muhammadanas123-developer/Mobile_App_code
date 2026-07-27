import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/domain/user_model.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../data/auth_repository.dart';

/// Class representing the state of Authentication.
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String role; // 'customer' or 'owner'
  final String? errorMessage;

  const AuthState({
    this.isLoading = true,
    this.isAuthenticated = false,
    this.user,
    this.role = 'customer',
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? role,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      role: role ?? this.role,
      errorMessage: errorMessage,
    );
  }
}

/// StateNotifier that coordinates authentication.
class AuthNotifier extends StateNotifier<AuthState> {
  final PreferencesService _prefs;
  final SecureStorageService _secureStorage;
  final AuthRepository _authRepository;

  AuthNotifier(this._prefs, this._secureStorage, this._authRepository) : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final token = await _secureStorage.getAccessToken();
    final savedRole = _prefs.getUserRole();

    if (token != null && token.isNotEmpty) {
      try {
        final user = await _authRepository.getProfile();
        await _prefs.setUserRole(user.role);
        state = AuthState(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          role: user.role,
        );
      } catch (e) {
        // Clear tokens if getting profile fails to enforce fresh login
        await _secureStorage.clearTokens();
        await _prefs.clearPreferences();
        state = AuthState(
          isLoading: false,
          isAuthenticated: false,
          role: savedRole,
        );
      }
    } else {
      state = AuthState(
        isLoading: false,
        isAuthenticated: false,
        role: savedRole,
      );
    }
  }

  /// Real backend Login with Email and Password
  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _authRepository.login(email: email, password: password);
      final token = res['access_token'] as String;
      final user = res['user'] as UserModel;

      await _secureStorage.saveTokens(accessToken: token, refreshToken: token);
      await _prefs.setUserRole(user.role);

      state = AuthState(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        role: user.role,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('CustomException:', '').replaceAll('ValidationException:', '').trim(),
      );
      return false;
    }
  }

  /// Real backend Signup
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String role,
    String? businessName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authRepository.signup(
        email: email,
        password: password,
        name: name,
        role: role,
        businessName: businessName,
      );
      // Attempt login right after signup
      return await login(email: email, password: password);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('CustomException:', '').replaceAll('ValidationException:', '').trim(),
      );
      return false;
    }
  }



  Future<void> updateProfileName(String newName) async {
    if (state.user != null) {
      try {
        final updatedUser = await _authRepository.updateProfile(name: newName);
        state = state.copyWith(user: updatedUser);
      } catch (_) {
        state = state.copyWith(user: state.user!.copyWith(name: newName));
      }
    }
  }

  /// Cleans up auth and secure storage
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _secureStorage.clearTokens();
    await _prefs.clearPreferences();
    state = const AuthState(
      isLoading: false,
      isAuthenticated: false,
      role: 'customer',
    );
  }
}

/// Provider to watch and interact with authentication state.
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return AuthNotifier(prefs, secureStorage, authRepo);
});

