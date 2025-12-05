class ChatEntity {
  final String id;
  final String type; // 'direct' or 'group'
  final List<String> participants;
  final String? lastMessageId;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ChatParticipantEntity? otherParticipant; // For direct chats
  final String? groupName;
  final String? groupAvatar;

  ChatEntity({
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
}

class ChatParticipantEntity {
  final String id;
  final String name;
  final String? avatar;
  final bool isOnline;

  ChatParticipantEntity({
    required this.id,
    required this.name,
    this.avatar,
    this.isOnline = false,
  });
}
