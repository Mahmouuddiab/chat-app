import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/chat_cubit.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final controller = TextEditingController();
  final ImagePicker picker = ImagePicker();

  /// ✏️ Send Text
  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(text);
    controller.clear();
  }

  /// 📸 Pick Image
  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      context.read<ChatCubit>().sendImageMessage(picked.path);
    }
  }

  /// 📦 Bottom Sheet (ONLY IMAGE)
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListTile(
          leading: const Icon(Icons.image, color: Colors.blue),
          title: const Text("Image"),
          onTap: () {
            Navigator.pop(context);
            _pickImage();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            /// ➕ Attach
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAttachmentOptions,
            ),

            /// ✏️ Text Field
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),

            const SizedBox(width: 8),

            /// 📩 Send
            IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}