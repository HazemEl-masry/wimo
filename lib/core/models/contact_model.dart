class ContactModel {
  final String id;
  final String userId;
  final String contactPhone;
  final String? contactUserId;
  final String name;
  final bool isChatAppUser;
  final UserInfo? userInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContactModel({
    required this.id,
    required this.userId,
    required this.contactPhone,
    this.contactUserId,
    required this.name,
    required this.isChatAppUser,
    this.userInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      contactUserId: json['contactUserId'] is String
          ? json['contactUserId']
          : json['contactUserId']?['_id'],
      name: json['name'] ?? '',
      isChatAppUser: json['isChatAppUser'] ?? false,
      userInfo: json['contactUserId'] is Map
          ? UserInfo.fromJson(json['contactUserId'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'contactPhone': contactPhone,
      'contactUserId': contactUserId,
      'name': name,
      'isChatAppUser': isChatAppUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String? bio;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;

  UserInfo({
    required this.id,
    required this.name,
    this.bio,
    this.avatar,
    required this.isOnline,
    this.lastSeen,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'],
      avatar: json['avatar'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'])
          : null,
    );
  }
}
