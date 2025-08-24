import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { like, comment, follow, message, mention }

class NotificationModel {
  final String id;
  final String userId; // Who will receive the notification
  final String fromUserId; // Who triggered the notification
  final String fromUsername;
  final String fromUserProfileImage;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? postId; // If related to a post
  final String? commentId; // If related to a comment

  NotificationModel({
    required this.id,
    required this.userId,
    required this.fromUserId,
    required this.fromUsername,
    required this.fromUserProfileImage,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.postId,
    this.commentId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      fromUsername: map['fromUsername'] ?? '',
      fromUserProfileImage: map['fromUserProfileImage'] ?? '',
      type: NotificationType.values[map['type'] ?? 0],
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
      postId: map['postId'],
      commentId: map['commentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fromUserId': fromUserId,
      'fromUsername': fromUsername,
      'fromUserProfileImage': fromUserProfileImage,
      'type': type.index,
      'title': title,
      'body': body,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'postId': postId,
      'commentId': commentId,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? fromUserId,
    String? fromUsername,
    String? fromUserProfileImage,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? postId,
    String? commentId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUsername: fromUsername ?? this.fromUsername,
      fromUserProfileImage: fromUserProfileImage ?? this.fromUserProfileImage,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
    );
  }
}