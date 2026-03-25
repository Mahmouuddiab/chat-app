class MessageEntity {
  final String id;
  final String senderId;
  final String? text;
  final String? mediaUrl;
  final String type; // text | image | video
  final DateTime createdAt;

  MessageEntity({
    required this.id,
    required this.senderId,
    this.text,
    this.mediaUrl,
    required this.type,
    required this.createdAt,
  });
}