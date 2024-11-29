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
  
  UserNotifier(this._userService) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _userService.getUserStream().listen(
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
}