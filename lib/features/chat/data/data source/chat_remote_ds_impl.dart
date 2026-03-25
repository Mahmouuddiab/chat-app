import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/features/chat/data/data source/chat_remote_ds.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_storage/firebase_storage.dart';

@LazySingleton(as: ChatRemoteDs)
class ChatRemoteDsImpl implements ChatRemoteDs {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ChatRemoteDsImpl({
    required this.firestore,
    required this.auth,
    required this.storage,
  });

  /// 🔥 Get real-time messages
  @override
  Stream<List<MessageModel>> getMessages() {
    return firestore
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MessageModel.fromJson(doc.id, data);
      }).toList();
    });
  }

  /// 📤 Send text message
  @override
  Future<void> sendMessage(String text) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await firestore.collection('messages').add({
        'text': text.trim(),
        'type': 'text',
        'senderId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// 🖼 Send image message
  @override
  Future<void> sendImageMessage(String path) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final file = File(path);

      if (!await file.exists()) {
        throw Exception('File does not exist');
      }

      final ref = storage
          .ref()
          .child('chat_images')
          .child(user.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        final progress =
            event.bytesTransferred / event.totalBytes;
        print("📤 Upload progress: ${(progress * 100).toStringAsFixed(0)}%");
      });

      /// ✅ Wait for upload completion
      final snapshot = await uploadTask.whenComplete(() => null);

      /// ✅ Ensure upload success
      if (snapshot.state != TaskState.success) {
        throw Exception('Upload failed');
      }

      /// ✅ Get download URL safely
      final url = await ref.getDownloadURL();

      /// ✅ Save message
      await firestore.collection('messages').add({
        'mediaUrl': url,
        'type': 'image',
        'senderId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      throw Exception('Failed to send image: $e');
    }
  }
}