import 'package:chat_app/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDs {
  Stream<List<MessageModel>> getMessages();
  Future<void> sendMessage(String text);
  Future<void> sendImageMessage(String path);
}