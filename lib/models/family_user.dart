
class FamilyUser {
  final String id;
  final String name;
  final int age;
  final List<String> familyIds;

  FamilyUser({
    required this.id,
    required this.name,
    required this.age,
    required this.familyIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'familyIds': familyIds,
    };
  }

  factory FamilyUser.fromMap(Map<String, dynamic> map) {
    return FamilyUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      familyIds: List<String>.from(map['familyIds'] ?? []),
    );
  }
}