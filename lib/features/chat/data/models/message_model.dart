import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    super.text,
    super.mediaUrl,
    required super.type,
    required super.createdAt,
  });

  /// 🔥 From Firestore (robust + safe)
  factory MessageModel.fromJson(
      String id,
      Map<String, dynamic> json,
      ) {
    return MessageModel(
      id: id,
      senderId: json['senderId'] ?? '',

      // ✅ Safe casting
      text: json['text'] as String?,
      mediaUrl: json['mediaUrl'] as String?,

      // ✅ Default fallback
      type: json['type'] ?? 'text',

      // ✅ Stable timestamp handling
      createdAt: _parseDate(json['createdAt']),
    );
  }

  /// 🔥 Handle Firestore Timestamp safely
  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    // ⚠️ Important: DON'T use DateTime.now()
    // This prevents UI jumping & wrong ordering
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// 📤 To Firestore (clean structure)
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),

      // ✅ Only include if not null
      if (text != null && text!.trim().isNotEmpty) 'text': text,
      if (mediaUrl != null && mediaUrl!.isNotEmpty) 'mediaUrl': mediaUrl,
    };
  }

  /// 💡 Helpers (VERY useful in UI)
  bool get isImage => type == 'image';
  bool get isText => type == 'text';

  /// 💡 Optional: detect empty message (safety)
  bool get isEmpty =>
      (text == null || text!.trim().isEmpty) &&
          (mediaUrl == null || mediaUrl!.isEmpty);
}