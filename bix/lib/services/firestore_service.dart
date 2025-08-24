import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';
import '../constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<UserModel>> searchUsers(String query) async {
    QuerySnapshot snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('username', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Post operations
  Future<String> createPost(PostModel post) async {
    DocumentReference docRef = await _firestore
        .collection(AppConstants.postsCollection)
        .add(post.toMap());
    
    // Update user's posts count
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(post.userId)
        .update({
      'postsCount': FieldValue.increment(1),
    });

    return docRef.id;
  }

  Future<void> updatePost(PostModel post) async {
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(post.id)
        .update(post.toMap());
  }

  Future<void> deletePost(String postId, String userId) async {
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .delete();
    
    // Update user's posts count
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({
      'postsCount': FieldValue.increment(-1),
    });
  }

  Future<PostModel?> getPost(String postId) async {
    DocumentSnapshot doc = await _firestore
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .get();

    if (doc.exists) {
      return PostModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Stream<List<PostModel>> getFeedPosts(List<String> followingIds) {
    return _firestore
        .collection(AppConstants.postsCollection)
        .where('userId', whereIn: followingIds.isEmpty ? [''] : followingIds)
        .orderBy('createdAt', descending: true)
        .limit(AppConstants.postsPerPage)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<PostModel>> getExplorePosts() {
    return _firestore
        .collection(AppConstants.postsCollection)
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(AppConstants.postsPerPage)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection(AppConstants.postsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList());
  }

  // Like operations
  Future<void> likePost(String postId, String userId) async {
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // Comment operations
  Future<String> createComment(CommentModel comment) async {
    DocumentReference docRef = await _firestore
        .collection(AppConstants.commentsCollection)
        .add(comment.toMap());
    
    // Update post's comments count
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(comment.postId)
        .update({
      'commentsCount': FieldValue.increment(1),
    });

    return docRef.id;
  }

  Future<void> deleteComment(String commentId, String postId) async {
    await _firestore
        .collection(AppConstants.commentsCollection)
        .doc(commentId)
        .delete();
    
    // Update post's comments count
    await _firestore
        .collection(AppConstants.postsCollection)
        .doc(postId)
        .update({
      'commentsCount': FieldValue.increment(-1),
    });
  }

  Stream<List<CommentModel>> getPostComments(String postId) {
    return _firestore
        .collection(AppConstants.commentsCollection)
        .where('postId', isEqualTo: postId)
        .where('parentCommentId', isNull: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromMap(doc.data()))
            .toList());
  }

  // Follow operations
  Future<void> followUser(String currentUserId, String targetUserId) async {
    WriteBatch batch = _firestore.batch();

    // Add to current user's following list
    batch.update(
      _firestore.collection(AppConstants.usersCollection).doc(currentUserId),
      {
        'following': FieldValue.arrayUnion([targetUserId]),
      },
    );

    // Add to target user's followers list
    batch.update(
      _firestore.collection(AppConstants.usersCollection).doc(targetUserId),
      {
        'followers': FieldValue.arrayUnion([currentUserId]),
      },
    );

    await batch.commit();
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    WriteBatch batch = _firestore.batch();

    // Remove from current user's following list
    batch.update(
      _firestore.collection(AppConstants.usersCollection).doc(currentUserId),
      {
        'following': FieldValue.arrayRemove([targetUserId]),
      },
    );

    // Remove from target user's followers list
    batch.update(
      _firestore.collection(AppConstants.usersCollection).doc(targetUserId),
      {
        'followers': FieldValue.arrayRemove([currentUserId]),
      },
    );

    await batch.commit();
  }

  // Message operations
  Future<String> sendMessage(MessageModel message) async {
    DocumentReference docRef = await _firestore
        .collection(AppConstants.messagesCollection)
        .add(message.toMap());

    return docRef.id;
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection(AppConstants.messagesCollection)
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt', descending: true)
        .limit(AppConstants.messagesPerPage)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> markMessageAsRead(String messageId) async {
    await _firestore
        .collection(AppConstants.messagesCollection)
        .doc(messageId)
        .update({'isRead': true});
  }

  // Notification operations
  Future<String> createNotification(NotificationModel notification) async {
    DocumentReference docRef = await _firestore
        .collection(AppConstants.notificationsCollection)
        .add(notification.toMap());

    return docRef.id;
  }

  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection(AppConstants.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(AppConstants.notificationsPerPage)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore
        .collection(AppConstants.notificationsCollection)
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(AppConstants.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    WriteBatch batch = _firestore.batch();
    for (DocumentSnapshot doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Search operations
  Future<List<PostModel>> searchPosts(String query) async {
    QuerySnapshot snapshot = await _firestore
        .collection(AppConstants.postsCollection)
        .where('hashtags', arrayContains: query.toLowerCase())
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Analytics operations
  Future<Map<String, int>> getUserStats(String userId) async {
    UserModel? user = await getUser(userId);
    if (user == null) return {};

    return {
      'posts': user.postsCount,
      'followers': user.followers.length,
      'following': user.following.length,
    };
  }
}