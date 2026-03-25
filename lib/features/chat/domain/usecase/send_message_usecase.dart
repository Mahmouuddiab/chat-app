import 'package:chat_app/features/chat/domain/repository/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(String text) {
    return repository.sendMessage(text);
  }
}