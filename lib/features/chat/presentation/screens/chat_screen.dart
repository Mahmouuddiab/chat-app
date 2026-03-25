import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_app/features/chat/presentation/widgets/message_input.dart';
import 'package:chat_app/features/chat/presentation/widgets/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>()..loadMessages(), // 🔥 important
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Column(
          children: [
            Expanded(child: MessagesList()),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}