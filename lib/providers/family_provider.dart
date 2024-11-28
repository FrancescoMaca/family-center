import 'package:family_center/models/family.dart' as models;
import 'package:family_center/providers/auth_provider.dart';
import 'package:family_center/services/family_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final familyServiceProvider = Provider<FamilyService>((ref) => FamilyService());

final userFamiliesProvider = StreamProvider.autoDispose<List<models.Family>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return Stream.value(<models.Family>[]);
  
  final familyService = ref.watch(familyServiceProvider);
  return familyService.getUserFamilies(user.uid);
});