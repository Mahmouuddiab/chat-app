import 'package:chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:chat_app/features/chat/domain/repository/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<MessageEntity>> call() {
    return repository.getMessages();
  }
}