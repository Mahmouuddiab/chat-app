import 'package:chat_app/features/chat/domain/entity/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages();
  Future<void> sendMessage(String text);
  Future<void> sendImageMessage(String imagePath);
}