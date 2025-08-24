class AppConstants {
  // App Info
  static const String appName = 'Bix';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Short Video Social Media App';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String messagesCollection = 'messages';
  static const String notificationsCollection = 'notifications';
  static const String followersCollection = 'followers';
  static const String likesCollection = 'likes';
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String postVideosPath = 'post_videos';
  static const String postThumbnailsPath = 'post_thumbnails';
  static const String messageMediaPath = 'message_media';
  
  // Shared Preferences Keys
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  
  // Video Constraints
  static const int maxVideoDurationSeconds = 60;
  static const int minVideoDurationSeconds = 3;
  static const double maxVideoSizeMB = 100.0;
  
  // Text Constraints
  static const int maxCaptionLength = 500;
  static const int maxBioLength = 150;
  static const int maxUsernameLength = 30;
  static const int minUsernameLength = 3;
  static const int maxCommentLength = 200;
  
  // Pagination
  static const int postsPerPage = 10;
  static const int commentsPerPage = 20;
  static const int messagesPerPage = 50;
  static const int notificationsPerPage = 30;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // API Endpoints (if using custom backend)
  static const String baseUrl = 'https://api.bix.com';
  static const String uploadEndpoint = '/upload';
  static const String searchEndpoint = '/search';
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String unknownError = 'An unknown error occurred.';
  static const String authError = 'Authentication failed.';
  static const String permissionError = 'Permission denied.';
  
  // Success Messages
  static const String postUploadSuccess = 'Post uploaded successfully!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String followSuccess = 'User followed successfully!';
  static const String unfollowSuccess = 'User unfollowed successfully!';
  
  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String usernamePattern = r'^[a-zA-Z0-9_]{3,30}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  
  // Social Media Links
  static const String instagramUrl = 'https://instagram.com/bix_app';
  static const String twitterUrl = 'https://twitter.com/bix_app';
  static const String facebookUrl = 'https://facebook.com/bix_app';
  
  // Support
  static const String supportEmail = 'support@bix.com';
  static const String privacyPolicyUrl = 'https://bix.com/privacy';
  static const String termsOfServiceUrl = 'https://bix.com/terms';
}