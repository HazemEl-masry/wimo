import 'package:drift/drift.dart';
import 'package:wimo/core/database/converters.dart';

class Chats extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get participants => text().map(const StringListConverter())();
  TextColumn get lastMessageId => text().nullable()();
  DateTimeColumn get lastMessageTime => dateTime().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get otherParticipant =>
      text().map(const ChatParticipantInfoConverter()).nullable()();
  TextColumn get groupName => text().nullable()();
  TextColumn get groupAvatar => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().references(Chats, #id)();
  TextColumn get senderId => text()();
  TextColumn get content => text()();
  TextColumn get type => text()();
  TextColumn get mediaUrl => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get readBy => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get senderInfo =>
      text().map(const SenderInfoConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
