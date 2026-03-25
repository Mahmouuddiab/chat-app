import 'package:chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:chat_app/features/chat/domain/repository/chat_repository.dart';
import 'package:injectable/injectable.dart';
import '../data source/chat_remote_ds.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDs remote;

  ChatRepositoryImpl(this.remote);

  @override
  Stream<List<MessageEntity>> getMessages() {
    return remote.getMessages();
  }

  @override
  Future<void> sendMessage(String text) {
    return remote.sendMessage(text);
  }

  @override
  Future<void> sendImageMessage(String path) {
    return remote.sendImageMessage(path);
  }
}