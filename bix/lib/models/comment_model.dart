import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String userProfileImage;
  final String text;
  final List<String> likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? parentCommentId; // For replies

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.text,
    this.likes = const [],
    required this.createdAt,
    required this.updatedAt,
    this.parentCommentId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      text: map['text'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      parentCommentId: map['parentCommentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'text': text,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'parentCommentId': parentCommentId,
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? userProfileImage,
    String? text,
    List<String>? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentCommentId,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }
}