import 'package:family_center/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(null) {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _authService.signUpWithEmail(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}