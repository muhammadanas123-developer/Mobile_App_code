import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/domain/user_model.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../data/auth_service.dart';

/// Class representing the state of Authentication.
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String role; // 'customer' or 'owner'

  const AuthState({
    this.isLoading = true,
    this.isAuthenticated = false,
    this.user,
    this.role = 'customer',
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? role,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      role: role ?? this.role,
    );
  }
}

/// StateNotifier that coordinates authentication.
class AuthNotifier extends StateNotifier<AuthState> {
  final PreferencesService _prefs;
  final SecureStorageService _secureStorage;
  final AuthService _authService = AuthService();

  AuthNotifier(this._prefs, this._secureStorage) : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    final token = await _secureStorage.getAccessToken();
    final role = _prefs.getUserRole();

    if (token != null) {
      // Mocked authenticated user profile loading
      final user = UserModel(
        id: '1',
        name: role == 'owner' ? 'Maison de Beauté' : 'Charlotte Dubois',
        email: role == 'owner' ? 'contact@maison.paris' : 'charlotte@lumiere.com',
        role: role,
        avatarUrl: role == 'owner' ? 'assets/images/avatar_sarah.png' : 'assets/images/avatar_user.png',
        salonName: role == 'owner' ? 'Maison de Beauté' : null,
      );
      state = AuthState(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        role: role,
      );
    } else {
      state = AuthState(
        isLoading: false,
        isAuthenticated: false,
        role: role,
      );
    }
  }

  /// Real login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _authService.login(
        email: email,
        password: password,
      );

      final token = response['access_token'];

      final userJson = response['user'];

      final user = UserModel(
        id: userJson['id'],
        name: userJson['user_metadata']?['name'] ?? '',
        email: userJson['email'],
        role: userJson['user_metadata']?['role'] ?? 'customer',
      );

      await _secureStorage.saveTokens(
        accessToken: token,
        refreshToken: '',
      );

      await _prefs.setUserRole(user.role);

      state = AuthState(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        role: user.role,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Logs in as Customer (Mock)
  Future<void> loginAsCustomer() async {
    state = state.copyWith(isLoading: true);
    await _secureStorage.saveTokens(accessToken: 'mock_customer_jwt', refreshToken: 'mock_refresh_token');
    await _prefs.setUserRole('customer');

    const user = UserModel(
      id: '1',
      name: 'Charlotte Dubois',
      email: 'charlotte@lumiere.com',
      role: 'customer',
      avatarUrl: 'assets/images/avatar_user.png',
    );

    state = const AuthState(
      isLoading: false,
      isAuthenticated: true,
      user: user,
      role: 'customer',
    );
  }

  /// Logs in as Salon Owner (Mock)
  Future<void> loginAsOwner() async {
    state = state.copyWith(isLoading: true);
    await _secureStorage.saveTokens(accessToken: 'mock_owner_jwt', refreshToken: 'mock_refresh_token');
    await _prefs.setUserRole('owner');

    const user = UserModel(
      id: '2',
      name: 'Sarah Jenkins',
      email: 'contact@maison.paris',
      role: 'owner',
      avatarUrl: 'assets/images/avatar_sarah.png',
      salonName: 'Maison de Beauté',
    );

    state = const AuthState(
      isLoading: false,
      isAuthenticated: true,
      user: user,
      role: 'owner',
    );
  }

  /// Switch roles on-the-fly for demo purposes
  Future<void> switchRole() async {
    final nextRole = state.role == 'customer' ? 'owner' : 'customer';
    state = state.copyWith(isLoading: true);
    await _prefs.setUserRole(nextRole);

    if (nextRole == 'owner') {
      await loginAsOwner();
    } else {
      await loginAsCustomer();
    }
  }

  void updateProfileName(String newName) {
    if (state.user != null) {
      state = state.copyWith(user: state.user!.copyWith(name: newName));
    }
  }

  /// Cleans up auth and secure storage
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
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
  return AuthNotifier(prefs, secureStorage);
});

/// Helper class to refresh GoRouter when authentication state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();

    _subscription = stream.asBroadcastStream().listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
