import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class PostProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  List<PostModel> _feedPosts = [];
  List<PostModel> _explorePosts = [];
  List<PostModel> _userPosts = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  List<PostModel> get feedPosts => _feedPosts;
  List<PostModel> get explorePosts => _explorePosts;
  List<PostModel> get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;

  // Load feed posts
  void loadFeedPosts(List<String> followingIds) {
    _firestoreService.getFeedPosts(followingIds).listen(
      (posts) {
        _feedPosts = posts;
        notifyListeners();
      },
      onError: (error) {
        _setError(error.toString());
      },
    );
  }

  // Load explore posts
  void loadExplorePosts() {
    _firestoreService.getExplorePosts().listen(
      (posts) {
        _explorePosts = posts;
        notifyListeners();
      },
      onError: (error) {
        _setError(error.toString());
      },
    );
  }

  // Load user posts
  void loadUserPosts(String userId) {
    _firestoreService.getUserPosts(userId).listen(
      (posts) {
        _userPosts = posts;
        notifyListeners();
      },
      onError: (error) {
        _setError(error.toString());
      },
    );
  }

  // Create new post
  Future<bool> createPost({
    required File videoFile,
    required String caption,
    required UserModel user,
    List<String> hashtags = const [],
    String? location,
  }) async {
    _setUploading(true);
    _clearError();

    try {
      // Upload video and get URLs
      Map<String, String> uploadResult = await _storageService.uploadVideo(videoFile, user.uid);
      
      String postId = _uuid.v4();
      PostModel post = PostModel(
        id: postId,
        userId: user.uid,
        username: user.username,
        userProfileImage: user.profileImageUrl ?? '',
        caption: caption,
        videoUrl: uploadResult['videoUrl']!,
        thumbnailUrl: uploadResult['thumbnailUrl'],
        hashtags: hashtags,
        location: location,
        duration: double.tryParse(uploadResult['duration'] ?? '0'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreService.createPost(post);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUploading(false);
    }
  }

  // Update post
  Future<bool> updatePost(PostModel post) async {
    _setLoading(true);
    _clearError();

    try {
      PostModel updatedPost = post.copyWith(updatedAt: DateTime.now());
      await _firestoreService.updatePost(updatedPost);
      
      // Update local lists
      _updatePostInLists(updatedPost);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete post
  Future<bool> deletePost(String postId, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      // Get post to delete media files
      PostModel? post = await _firestoreService.getPost(postId);
      if (post != null) {
        // Delete media files from storage
        await _storageService.deleteFile(post.videoUrl);
        if (post.thumbnailUrl != null) {
          await _storageService.deleteFile(post.thumbnailUrl!);
        }
      }

      await _firestoreService.deletePost(postId, userId);
      
      // Remove from local lists
      _removePostFromLists(postId);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Like post
  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestoreService.likePost(postId, userId);
      
      // Update local post
      _updatePostLike(postId, userId, true);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Unlike post
  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestoreService.unlikePost(postId, userId);
      
      // Update local post
      _updatePostLike(postId, userId, false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Search posts
  Future<List<PostModel>> searchPosts(String query) async {
    _setLoading(true);
    _clearError();

    try {
      List<PostModel> results = await _firestoreService.searchPosts(query);
      return results;
    } catch (e) {
      _setError(e.toString());
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Get single post
  Future<PostModel?> getPost(String postId) async {
    try {
      return await _firestoreService.getPost(postId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Extract hashtags from caption
  List<String> extractHashtags(String caption) {
    RegExp hashtagRegex = RegExp(r'#\w+');
    Iterable<Match> matches = hashtagRegex.allMatches(caption);
    return matches.map((match) => match.group(0)!.toLowerCase()).toList();
  }

  // Update post in all local lists
  void _updatePostInLists(PostModel updatedPost) {
    // Update in feed posts
    int feedIndex = _feedPosts.indexWhere((post) => post.id == updatedPost.id);
    if (feedIndex != -1) {
      _feedPosts[feedIndex] = updatedPost;
    }

    // Update in explore posts
    int exploreIndex = _explorePosts.indexWhere((post) => post.id == updatedPost.id);
    if (exploreIndex != -1) {
      _explorePosts[exploreIndex] = updatedPost;
    }

    // Update in user posts
    int userIndex = _userPosts.indexWhere((post) => post.id == updatedPost.id);
    if (userIndex != -1) {
      _userPosts[userIndex] = updatedPost;
    }

    notifyListeners();
  }

  // Remove post from all local lists
  void _removePostFromLists(String postId) {
    _feedPosts.removeWhere((post) => post.id == postId);
    _explorePosts.removeWhere((post) => post.id == postId);
    _userPosts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }

  // Update post like status in local lists
  void _updatePostLike(String postId, String userId, bool isLiked) {
    void updatePost(PostModel post) {
      List<String> likes = List.from(post.likes);
      if (isLiked && !likes.contains(userId)) {
        likes.add(userId);
      } else if (!isLiked && likes.contains(userId)) {
        likes.remove(userId);
      }
      
      PostModel updatedPost = post.copyWith(likes: likes);
      _updatePostInLists(updatedPost);
    }

    // Find and update post in all lists
    PostModel? feedPost = _feedPosts.firstWhere(
      (post) => post.id == postId,
      orElse: () => PostModel(
        id: '',
        userId: '',
        username: '',
        userProfileImage: '',
        caption: '',
        videoUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    if (feedPost.id.isNotEmpty) updatePost(feedPost);

    PostModel? explorePost = _explorePosts.firstWhere(
      (post) => post.id == postId,
      orElse: () => PostModel(
        id: '',
        userId: '',
        username: '',
        userProfileImage: '',
        caption: '',
        videoUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    if (explorePost.id.isNotEmpty) updatePost(explorePost);

    PostModel? userPost = _userPosts.firstWhere(
      (post) => post.id == postId,
      orElse: () => PostModel(
        id: '',
        userId: '',
        username: '',
        userProfileImage: '',
        caption: '',
        videoUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    if (userPost.id.isNotEmpty) updatePost(userPost);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUploading(bool uploading) {
    _isUploading = uploading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}