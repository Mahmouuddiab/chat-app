import 'package:chat_app/features/chat/domain/repository/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendImageMessageUseCase {
  final ChatRepository repository;

  SendImageMessageUseCase(this.repository);

  Future<void> call(String path) {
    return repository.sendImageMessage(path);
  }
}