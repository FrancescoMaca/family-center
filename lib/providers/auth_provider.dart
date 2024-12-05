import 'dart:async';

import 'package:family_center/providers/user_provider.dart';
import 'package:family_center/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService;
  final Ref _ref;
  StreamSubscription<User?>? _authSubscription;

  AuthNotifier(this._authService, this._ref) : super(null) {
    _init();
  }

  void _init() {
    _authSubscription = _authService.authStateChanges.listen((user) {
      state = user;

      if (user != null) {
        _ref.read(userProvider.notifier).refreshUser();
      }
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}