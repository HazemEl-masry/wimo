class ChatModel {
  final String id;
  final String type; // 'direct' or 'group'
  final List<String> participants;
  final String? lastMessageId;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatParticipantInfo? otherParticipant; // For direct chats
  final String? groupName;
  final String? groupAvatar;

  ChatModel({
    required this.id,
    required this.type,
    required this.participants,
    this.lastMessageId,
    this.lastMessageTime,
    this.unreadCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.otherParticipant,
    this.groupName,
    this.groupAvatar,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'direct',
      participants: List<String>.from(json['participants'] ?? []),
      lastMessageId: json['lastMessageId'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      otherParticipant: json['otherParticipant'] != null
          ? ChatParticipantInfo.fromJson(json['otherParticipant'])
          : null,
      groupName: json['groupName'],
      groupAvatar: json['groupAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'participants': participants,
      'lastMessageId': lastMessageId,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'groupName': groupName,
      'groupAvatar': groupAvatar,
    };
  }
}

class ChatParticipantInfo {
  final String id;
  final String name;
  final String? avatar;
  final bool isOnline;

  ChatParticipantInfo({
    required this.id,
    required this.name,
    this.avatar,
    this.isOnline = false,
  });

  factory ChatParticipantInfo.fromJson(Map<String, dynamic> json) {
    return ChatParticipantInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      isOnline: json['isOnline'] ?? false,
    );
  }
}
