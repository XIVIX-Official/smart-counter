import 'package:get/get.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

class AuthController extends GetxController {
  // Dependencies
  final _authService = AuthService();
  final _logger = AppLogger();

  // Observable values
  final Rx<User?> _user = Rx<User?>(null);
  final _isLoading = false.obs;
  final _error = Rx<String?>(null);

  // Getters
  User? get user => _user.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  bool get isAuthenticated => user != null;

  @override
  void onInit() {
    super.onInit();
    _initAuthState();
  }

  // Initialize auth state
  void _initAuthState() {
    _authService.authStateStream.listen(
      (state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            _user.value = state.user;
            _error.value = null;
            break;
          case AuthStatus.unauthenticated:
            _user.value = null;
            _error.value = null;
            break;
          case AuthStatus.error:
            _user.value = null;
            _error.value = state.error;
            break;
          case AuthStatus.initial:
            // Do nothing
            break;
        }
      },
      onError: (error) {
        _logger.error('Auth state stream error', error);
        _error.value = 'Authentication error occurred';
      },
    );
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      _logger.error('Sign in failed', e);
      _error.value = 'Failed to sign in: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _authService.registerWithEmailAndPassword(
        email,
        password,
        name,
      );
    } catch (e) {
      _logger.error('Registration failed', e);
      _error.value = 'Failed to register: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _authService.signOut();
    } catch (e) {
      _logger.error('Sign out failed', e);
      _error.value = 'Failed to sign out: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _authService.resetPassword(email);
    } catch (e) {
      _logger.error('Password reset failed', e);
      _error.value = 'Failed to reset password: ${e.toString()}';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  // Clear error
  void clearError() {
    _error.value = null;
  }
}