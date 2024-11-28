class Family {
  final String id;
  final String name;
  final String joinCode;
  final List<String> memberIds;

  const Family({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.memberIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'joinCode': joinCode,
      'memberIds': memberIds,
    };
  }

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      joinCode: map['joinCode'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
    );
  }
}