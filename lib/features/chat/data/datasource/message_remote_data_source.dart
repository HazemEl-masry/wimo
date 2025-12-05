import 'package:wimo/core/services/api_services.dart';
import 'package:wimo/core/models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<MessageModel> editMessage({
    required String messageId,
    required String content,
  });
  Future<void> deleteMessage({
    required String messageId,
    bool deleteForEveryone = false,
  });
  Future<void> markAsRead({required String messageId});
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ApiServices apiServices;

  MessageRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<MessageModel> editMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final response = await apiServices.patchRequest(
        endPoint: 'messages/$messageId',
        data: {'content': content},
      );

      if (response.statusCode == 200) {
        return MessageModel.fromJson(response.data['data']['message']);
      } else {
        throw Exception('Failed to edit message: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to edit message: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteMessage({
    required String messageId,
    bool deleteForEveryone = false,
  }) async {
    try {
      final response = await apiServices.deleteRequest(
        endPoint: 'messages/$messageId',
        data: {'deleteForEveryone': deleteForEveryone},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete message: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete message: ${e.toString()}');
    }
  }

  @override
  Future<void> markAsRead({required String messageId}) async {
    try {
      final response = await apiServices.postRequest(
        endPoint: 'messages/$messageId/read',
        data: {},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to mark as read: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }
}
