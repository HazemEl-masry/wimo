class UserEntity {
  final String id;
  final String phone;
  final String? name;
  final String? bio;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  UserEntity({
    required this.id,
    required this.phone,
    this.name,
    this.bio,
    this.avatar,
    this.isOnline = false,
    this.lastSeen,
  });
}
