import 'package:wimo/core/database/app_database.dart';
import 'package:wimo/core/models/chat_model.dart';
import 'package:wimo/core/models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChats(List<ChatModel> chats);
  Future<List<ChatModel>> getCachedChats();
  Future<void> cacheMessages(List<MessageModel> messages);
  Future<List<MessageModel>> getCachedMessages(String chatId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final AppDatabase database;

  ChatLocalDataSourceImpl(this.database);

  @override
  Future<void> cacheChats(List<ChatModel> chats) async {
    final chatEntities = chats.map((chat) {
      return Chat(
        id: chat.id,
        type: chat.type,
        participants: chat.participants,
        lastMessageId: chat.lastMessageId,
        lastMessageTime: chat.lastMessageTime,
        unreadCount: chat.unreadCount,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        otherParticipant: chat.otherParticipant,
        groupName: chat.groupName,
        groupAvatar: chat.groupAvatar,
      );
    }).toList();

    await database.insertChats(chatEntities);
  }

  @override
  Future<List<ChatModel>> getCachedChats() async {
    final cachedChats = await database.getAllChats();
    return cachedChats.map((chat) {
      return ChatModel(
        id: chat.id,
        type: chat.type,
        participants: chat.participants,
        lastMessageId: chat.lastMessageId,
        lastMessageTime: chat.lastMessageTime,
        unreadCount: chat.unreadCount,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        otherParticipant: chat.otherParticipant,
        groupName: chat.groupName,
        groupAvatar: chat.groupAvatar,
      );
    }).toList();
  }

  @override
  Future<void> cacheMessages(List<MessageModel> messages) async {
    final messageEntities = messages.map((msg) {
      return Message(
        id: msg.id,
        chatId: msg.chatId,
        senderId: msg.senderId,
        content: msg.content,
        type: msg.type,
        mediaUrl: msg.mediaUrl,
        isRead: msg.isRead,
        readBy: msg.readBy,
        createdAt: msg.createdAt,
        updatedAt: msg.updatedAt,
        isEdited: msg.isEdited,
        isDeleted: msg.isDeleted,
        senderInfo: msg.senderInfo,
      );
    }).toList();

    await database.insertMessages(messageEntities);
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final cachedMessages = await database.getMessagesForChat(chatId);
    return cachedMessages.map((msg) {
      return MessageModel(
        id: msg.id,
        chatId: msg.chatId,
        senderId: msg.senderId,
        content: msg.content,
        type: msg.type,
        mediaUrl: msg.mediaUrl,
        isRead: msg.isRead,
        readBy: msg.readBy,
        createdAt: msg.createdAt,
        updatedAt: msg.updatedAt,
        isEdited: msg.isEdited,
        isDeleted: msg.isDeleted,
        senderInfo: msg.senderInfo,
      );
    }).toList();
  }
}
