import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final String userId;
  final String contactPhone;
  final String? contactUserId;
  final String name;
  final bool isChatAppUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserParams? user;

  const ContactEntity({
    required this.id,
    required this.userId,
    required this.contactPhone,
    this.contactUserId,
    required this.name,
    required this.isChatAppUser,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    contactPhone,
    contactUserId,
    name,
    isChatAppUser,
    createdAt,
    updatedAt,
    user,
  ];
}

class UserParams extends Equatable {
  final String id;
  final String name;
  final String? bio;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  const UserParams({
    required this.id,
    required this.name,
    this.bio,
    this.avatar,
    required this.isOnline,
    this.lastSeen,
  });

  @override
  List<Object?> get props => [id, name, bio, avatar, isOnline, lastSeen];
}
