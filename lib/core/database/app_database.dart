import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:wimo/core/database/converters.dart';
import 'package:wimo/core/database/tables.dart';
import 'package:wimo/core/models/chat_model.dart';
import 'package:wimo/core/models/message_model.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Chats, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Chats
  Future<List<Chat>> getAllChats() => select(chats).get();

  Future<int> insertChat(Chat chat) =>
      into(chats).insert(chat, mode: InsertMode.insertOrReplace);

  Future<void> insertChats(List<Chat> chatList) async {
    await batch((batch) {
      batch.insertAll(chats, chatList, mode: InsertMode.insertOrReplace);
    });
  }

  // Messages
  Future<List<Message>> getMessagesForChat(String chatId) =>
      (select(messages)..where((tbl) => tbl.chatId.equals(chatId))).get();

  Future<int> insertMessage(Message message) =>
      into(messages).insert(message, mode: InsertMode.insertOrReplace);

  Future<void> insertMessages(List<Message> messageList) async {
    await batch((batch) {
      batch.insertAll(messages, messageList, mode: InsertMode.insertOrReplace);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
