import 'dart:async';
import 'package:chat_app/features/chat/domain/usecase/get_message_usecase.dart';
import 'package:chat_app/features/chat/domain/usecase/send_image_message.dart';
import 'package:chat_app/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:chat_app/features/chat/presentation/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final SendImageMessageUseCase sendImage;

  StreamSubscription? _subscription;

  ChatCubit(this.getMessages, this.sendMessage,this.sendImage)
      : super(ChatInitial());

  void loadMessages() {
    emit(ChatLoading());

    _subscription = getMessages().listen(
          (messages) => emit(ChatLoaded(messages)),
      onError: (e) => emit(ChatError(e.toString())),
    );
  }

  void send(String text) async {
    try {
      await sendMessage(text);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  /// 🖼️ Send Image
  void sendImageMessage(String path) {
    sendImage(path);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}