import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:wimo/core/models/chat_model.dart';
import 'package:wimo/core/models/message_model.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    return List<String>.from(json.decode(fromDb));
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

class ChatParticipantInfoConverter
    extends TypeConverter<ChatParticipantInfo?, String?> {
  const ChatParticipantInfoConverter();

  @override
  ChatParticipantInfo? fromSql(String? fromDb) {
    if (fromDb == null || fromDb.isEmpty) {
      return null;
    }
    return ChatParticipantInfo.fromJson(json.decode(fromDb));
  }

  @override
  String? toSql(ChatParticipantInfo? value) {
    if (value == null) {
      return null;
    }
    return json.encode({
      '_id': value.id,
      'name': value.name,
      'avatar': value.avatar,
      'isOnline': value.isOnline,
    });
  }
}

class SenderInfoConverter extends TypeConverter<SenderInfo?, String?> {
  const SenderInfoConverter();

  @override
  SenderInfo? fromSql(String? fromDb) {
    if (fromDb == null || fromDb.isEmpty) {
      return null;
    }
    return SenderInfo.fromJson(json.decode(fromDb));
  }

  @override
  String? toSql(SenderInfo? value) {
    if (value == null) {
      return null;
    }
    return json.encode({
      '_id': value.id,
      'name': value.name,
      'avatar': value.avatar,
    });
  }
}
