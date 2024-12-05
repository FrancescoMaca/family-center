import 'dart:async';

import 'package:family_center/models/family_user.dart';
import 'package:family_center/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<FamilyUser?>>((ref) {
  final userService = ref.watch(userServiceProvider);

  return UserNotifier(userService);
});

class UserNotifier extends StateNotifier<AsyncValue<FamilyUser?>> {
  
  final UserService _userService;
  StreamSubscription<FamilyUser?>? _userSubscriptions;

  UserNotifier(this._userService) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    await _userSubscriptions?.cancel();

    _userSubscriptions = _userService.getUserStream().listen(
      (user) {
        if (user != null) {
          state = AsyncValue.data(user);
        } else {
          state = const AsyncValue.data(null);
        }
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      }
    );
  }

  Future<void> updateNameAndAge(String name, String age) async {
    try {
      state = const AsyncValue.loading();
      
      await _userService.changeNameAndAge(name, age);
    } catch (error, stack) {

      state = AsyncValue.error(error, stack);
      rethrow;
    }
  }

  Future<String> getName() async {
    try {
      state = const AsyncValue.loading();
      
      return await _userService.getName();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      rethrow;
    }
  }


  Future<String> getAge() async {
    try {
      state = const AsyncValue.loading();
      
      return await _userService.getAge();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      rethrow;
    }
  }

  @override
  void dispose() {
    _userSubscriptions?.cancel();
    super.dispose();
  }

  Future<void> refreshUser() async {
    await _loadUser();
  }
}