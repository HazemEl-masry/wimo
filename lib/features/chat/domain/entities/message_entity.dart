import 'package:equatable/equatable.dart';

/// Message entity for domain layer
class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String type;
  final String? mediaUrl;
  final bool isRead;
  final List<String> readBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEdited;
  final bool isDeleted;
  final SenderInfo? senderInfo;

  const MessageEntity({
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

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    content,
    type,
    mediaUrl,
    isRead,
    readBy,
    createdAt,
    updatedAt,
    isEdited,
    isDeleted,
    senderInfo,
  ];
}

/// Sender information
class SenderInfo extends Equatable {
  final String id;
  final String name;
  final String? avatar;

  const SenderInfo({required this.id, required this.name, this.avatar});

  @override
  List<Object?> get props => [id, name, avatar];
}
