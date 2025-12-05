class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String? bio;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastSeen;
  final PrivacySettings? privacy;

  UserModel({
    required this.id,
    required this.phone,
    this.name,
    this.bio,
    this.avatar,
    this.isOnline = false,
    this.lastSeen,
    this.privacy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      bio: json['bio'],
      avatar: json['avatar'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'])
          : null,
      privacy: json['privacy'] != null
          ? PrivacySettings.fromJson(json['privacy'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'privacy': privacy?.toJson(),
    };
  }
}

class PrivacySettings {
  final String profilePhoto;
  final String about;
  final String lastSeen;

  PrivacySettings({
    this.profilePhoto = 'everyone',
    this.about = 'everyone',
    this.lastSeen = 'everyone',
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profilePhoto: json['profilePhoto'] ?? 'everyone',
      about: json['about'] ?? 'everyone',
      lastSeen: json['lastSeen'] ?? 'everyone',
    );
  }

  Map<String, dynamic> toJson() {
    return {'profilePhoto': profilePhoto, 'about': about, 'lastSeen': lastSeen};
  }
}
