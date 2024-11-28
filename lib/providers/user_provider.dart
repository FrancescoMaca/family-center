import 'package:family_center/models/family_user.dart';
import 'package:family_center/providers/auth_provider.dart';
import 'package:family_center/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());