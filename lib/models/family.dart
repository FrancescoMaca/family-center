
class Family {
  final String id;
  final String name;
  final String joinCode;
  final List<String> memberIds;
  final String ownerId;
  final List<String> moderatorsIds;

  Family({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.memberIds,
    required this.ownerId,
    required this.moderatorsIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'joinCode': joinCode,
      'memberIds': memberIds,
      'ownerId': ownerId,
      'moderatorsId': moderatorsIds,
    };
  }

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      joinCode: map['joinCode'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      ownerId: map['ownerId'] ?? "",
      moderatorsIds: List<String>.from(map['moderatorsIds'] ?? []),
    );
  }
}