class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String type; // 'text', 'image', 'video', 'audio', 'document'
  final String? mediaUrl;
  final bool isRead;
  final List<String> readBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEdited;
  final bool isDeleted;
  final SenderInfo? senderInfo;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.type = 'text',
    this.mediaUrl,
    this.isRead = false,
    this.readBy = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isEdited = false,
    this.isDeleted = false,
    this.senderInfo,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] is String
          ? json['senderId']
          : json['senderId']?['_id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      mediaUrl: json['mediaUrl'],
      isRead: json['isRead'] ?? false,
      readBy: List<String>.from(json['readBy'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      senderInfo: json['senderId'] is Map
          ? SenderInfo.fromJson(json['senderId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'mediaUrl': mediaUrl,
      'isRead': isRead,
      'readBy': readBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEdited': isEdited,
      'isDeleted': isDeleted,
    };
  }
}

class SenderInfo {
  final String id;
  final String name;
  final String? avatar;

  SenderInfo({required this.id, required this.name, this.avatar});

  factory SenderInfo.fromJson(Map<String, dynamic> json) {
    return SenderInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
    );
  }
}
