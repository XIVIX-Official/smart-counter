import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../models/user.dart';
import '../utils/logger.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Dependencies
  final _auth = firebase.FirebaseAuth.instance;
  final _apiService = ApiService();
  final _storageService = StorageService();
  final _logger = AppLogger();


  // Stream controllers
  final _authStateController = StreamController<AuthState>.broadcast();

  // Getters
  Stream<AuthState> get authStateStream => _authStateController.stream;
  bool get isAuthenticated => _auth.currentUser != null;
  String? get currentUserId => _auth.currentUser?.uid;

  // Initialize the service
  Future<void> init() async {
    // Listen to Firebase auth state changes
    _auth.authStateChanges().listen(_handleAuthStateChange);
  }

  // Handle auth state changes
  void _handleAuthStateChange(firebase.User? firebaseUser) async {
    if (firebaseUser == null) {
      _authStateController.add(AuthState.unauthenticated());
      return;
    }

    try {
      // Get user profile from API
      final user = await _getUserProfile(firebaseUser.uid);
      _authStateController.add(AuthState.authenticated(user));
    } catch (e) {
      _logger.error('Error getting user profile', e);
      _authStateController.add(AuthState.error('Failed to get user profile'));
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed - no user returned');
      }

      // Get user profile and token
      await _handleSuccessfulAuth(credential.user!);
    } catch (e) {
      _logger.error('Sign in failed', e);
      rethrow;
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Registration failed - no user created');
      }

      // Create user profile
      await _createUserProfile(credential.user!, name);

      // Handle successful auth
      await _handleSuccessfulAuth(credential.user!);
    } catch (e) {
      _logger.error('Registration failed', e);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storageService.clearAuthData();
      _apiService.clearAuthToken();
      _authStateController.add(AuthState.unauthenticated());
    } catch (e) {
      _logger.error('Sign out failed', e);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _logger.error('Password reset failed', e);
      rethrow;
    }
  }

  // Handle successful authentication
  Future<void> _handleSuccessfulAuth(firebase.User firebaseUser) async {
    try {
      // Get ID token
      final token = await firebaseUser.getIdToken();

      // Save token (add null check assertion)
      await _storageService.saveAuthToken(token!);

      // Set token in API service
      _apiService.setAuthToken(token);

      // Get user profile
      final user = await _getUserProfile(firebaseUser.uid);

      // Update auth state
      _authStateController.add(AuthState.authenticated(user));
    } catch (e) {
      _logger.error('Error handling successful auth', e);
      rethrow;
    }
  }

  // Get user profile from API
  Future<User> _getUserProfile(String userId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/users/$userId',
      );
      return User.fromJson(response);
    } catch (e) {
      _logger.error('Error getting user profile', e);
      rethrow;
    }
  }

  // Create user profile in API
  Future<User> _createUserProfile(firebase.User firebaseUser, String name) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/users',
        data: {
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'name': name,
          'role': 'employee', // Default role
        },
      );
      return User.fromJson(response);
    } catch (e) {
      _logger.error('Error creating user profile', e);
      rethrow;
    }
  }

  // Clean up resources
  void dispose() {
    _authStateController.close();
  }
}

// Auth state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  AuthState({
    required this.status,
    this.user,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(status: AuthStatus.initial);
  }

  factory AuthState.authenticated(User user) {
    return AuthState(status: AuthStatus.authenticated, user: user);
  }

  factory AuthState.unauthenticated() {
    return AuthState(status: AuthStatus.unauthenticated);
  }

  factory AuthState.error(String error) {
    return AuthState(status: AuthStatus.error, error: error);
  }
}

// Auth status enum
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  error,
}