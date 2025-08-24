import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final String? bio;
  final DateTime? birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> followers;
  final List<String> following;
  final int postsCount;
  final bool isVerified;
  final bool isPrivate;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    this.bio,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
    this.followers = const [],
    this.following = const [],
    this.postsCount = 0,
    this.isVerified = false,
    this.isPrivate = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      bio: map['bio'],
      birthDate: map['birthDate'] != null 
          ? (map['birthDate'] as Timestamp).toDate() 
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      postsCount: map['postsCount'] ?? 0,
      isVerified: map['isVerified'] ?? false,
      isPrivate: map['isPrivate'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'followers': followers,
      'following': following,
      'postsCount': postsCount,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? displayName,
    String? profileImageUrl,
    String? bio,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? followers,
    List<String>? following,
    int? postsCount,
    bool? isVerified,
    bool? isPrivate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      postsCount: postsCount ?? this.postsCount,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}