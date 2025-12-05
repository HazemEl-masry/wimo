import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/models/chat_model.dart';
import 'package:wimo/core/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<ChatModel> getChatById({required String chatId});
  Future<ChatModel> createDirectChat({required String participantId});
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? mediaUrl,
  });
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  });
  Future<void> markAllAsRead({required String chatId});
  Future<void> clearChat({required String chatId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiServices apiServices;

  ChatRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final response = await apiServices.getRequest(endPoint: 'chats');

      if (response.statusCode == 200) {
        final List chats =
            response.data['data']['chats'] ?? response.data['data'];
        return chats.map((json) => ChatModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get chats: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get chats: ${e.toString()}');
    }
  }

  @override
  Future<ChatModel> getChatById({required String chatId}) async {
    try {
      final response = await apiServices.getRequest(endPoint: 'chats/$chatId');

      if (response.statusCode == 200) {
        return ChatModel.fromJson(response.data['data']['chat']);
      } else {
        throw Exception('Failed to get chat: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get chat: ${e.toString()}');
    }
  }

  @override
  Future<ChatModel> createDirectChat({required String participantId}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'chats',
        data: {'participantId': participantId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatModel.fromJson(response.data['data']['chat']);
      } else {
        throw Exception('Failed to create chat: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to create chat: ${e.toString()}');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? mediaUrl,
  }) async {
    try {
      final data = {'content': content, 'type': type};
      if (mediaUrl != null) {
        data['mediaUrl'] = mediaUrl;
      }

      final response = await apiServices.postRequest(
        endPoint: 'chats/$chatId/messages',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageModel.fromJson(response.data['data']['message']);
      } else {
        throw Exception('Failed to send message: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await apiServices.getRequest(
        endPoint: 'chats/$chatId/messages',
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final List messages = response.data['data']['messages'];
        return messages.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get messages: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get messages: ${e.toString()}');
    }
  }

  @override
  Future<void> markAllAsRead({required String chatId}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'chats/$chatId/read',
        data: {},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to mark as read: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  @override
  Future<void> clearChat({required String chatId}) async {
    try {
      final response = await apiServices.deleteRequest(
        endPoint: 'chats/$chatId/clear',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear chat: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to clear chat: ${e.toString()}');
    }
  }
}
