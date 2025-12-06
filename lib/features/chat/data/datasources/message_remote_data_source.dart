import 'package:wimo/core/constants/api_constants.dart';
import 'package:wimo/core/models/message_model.dart';
import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/utils/logger.dart';

/// Message remote data source
abstract class MessageRemoteDataSource {
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int? limit,
    String? before,
  });

  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
    String? mediaUrl,
  });

  Future<void> markAsRead({
    required String chatId,
    required List<String> messageIds,
  });

  Future<void> deleteMessage({required String messageId});
}

/// Implementation of message remote data source
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ApiServices apiServices;

  MessageRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int? limit,
    String? before,
  }) async {
    try {
      final endpoint = ApiConstants.getChatMessages(chatId);
      AppLogger.logRequest('GET', endpoint);

      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (before != null) queryParams['before'] = before;

      final response = await apiServices.getRequest(endPoint: endpoint);

      if (response.statusCode == 200) {
        final List messages = response.data['data']['messages'];
        AppLogger.logResponse(
          response.statusCode!,
          endpoint,
          'Found ${messages.length} messages',
        );
        return messages.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        AppLogger.error(
          'Failed to get messages from $endpoint',
          response.statusMessage,
        );
        throw Exception(
          'Failed to get messages from $endpoint: ${response.statusMessage}',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get messages', e, stackTrace);
      throw Exception('Failed to get messages: ${e.toString()}');
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
      final data = {
        'content': content,
        'type': type,
        if (mediaUrl != null) 'mediaUrl': mediaUrl,
      };

      final endpoint = ApiConstants.getChatMessages(chatId);
      AppLogger.logRequest('POST', endpoint, data);

      final response = await apiServices.postRequest(
        endPoint: endpoint,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.logResponse(response.statusCode!, endpoint, 'Message sent');
        return MessageModel.fromJson(response.data['data']['message']);
      } else {
        AppLogger.error(
          'Failed to send message to $endpoint',
          response.statusMessage,
        );
        throw Exception('Failed to send message: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to send message', e, stackTrace);
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<void> markAsRead({
    required String chatId,
    required List<String> messageIds,
  }) async {
    try {
      AppLogger.logRequest('POST', '${ApiConstants.messages}/read');

      final response = await apiServices.postRequest(
        endPoint: '${ApiConstants.messages}/read',
        data: {'chatId': chatId, 'messageIds': messageIds},
      );

      if (response.statusCode == 200) {
        AppLogger.info('Messages marked as read');
      } else {
        AppLogger.error('Failed to mark as read', response.statusMessage);
        throw Exception('Failed to mark as read: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to mark as read', e, stackTrace);
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteMessage({required String messageId}) async {
    try {
      AppLogger.logRequest('DELETE', '${ApiConstants.messages}/$messageId');

      final response = await apiServices.deleteRequest(
        endPoint: '${ApiConstants.messages}/$messageId',
      );

      if (response.statusCode == 200) {
        AppLogger.info('Message deleted');
      } else {
        AppLogger.error('Failed to delete message', response.statusMessage);
        throw Exception('Failed to delete message: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete message', e, stackTrace);
      throw Exception('Failed to delete message: ${e.toString()}');
    }
  }
}
