import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, audio }

extension MessageTypeExtension on MessageType {
  String get value {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.video:
        return 'video';
      case MessageType.audio:
        return 'audio';
    }
  }

  static MessageType fromString(String value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      default:
        return MessageType.text;
    }
  }
}

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isRead;
  final String? mediaUrl;
  final String? thumbnailUrl;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.mediaUrl,
    this.thumbnailUrl,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      type: MessageTypeExtension.fromString(map['type'] ?? 'text'),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
      mediaUrl: map['mediaUrl'],
      thumbnailUrl: map['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.value,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    bool? isRead,
    String? mediaUrl,
    String? thumbnailUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}