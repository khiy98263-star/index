import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userProfileImage;
  final String caption;
  final String videoUrl;
  final String? thumbnailUrl;
  final List<String> likes;
  final int commentsCount;
  final int sharesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> hashtags;
  final bool isPublic;
  final String? location;
  final double? duration;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.caption,
    required this.videoUrl,
    this.thumbnailUrl,
    this.likes = const [],
    this.commentsCount = 0,
    this.sharesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.hashtags = const [],
    this.isPublic = true,
    this.location,
    this.duration,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      caption: map['caption'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      likes: List<String>.from(map['likes'] ?? []),
      commentsCount: map['commentsCount'] ?? 0,
      sharesCount: map['sharesCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      hashtags: List<String>.from(map['hashtags'] ?? []),
      isPublic: map['isPublic'] ?? true,
      location: map['location'],
      duration: map['duration']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'caption': caption,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'likes': likes,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'hashtags': hashtags,
      'isPublic': isPublic,
      'location': location,
      'duration': duration,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userProfileImage,
    String? caption,
    String? videoUrl,
    String? thumbnailUrl,
    List<String>? likes,
    int? commentsCount,
    int? sharesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? hashtags,
    bool? isPublic,
    String? location,
    double? duration,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hashtags: hashtags ?? this.hashtags,
      isPublic: isPublic ?? this.isPublic,
      location: location ?? this.location,
      duration: duration ?? this.duration,
    );
  }
}