import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';
import '../models/message_model.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      String fileName = 'profile_$userId.jpg';
      Reference ref = _storage
          .ref()
          .child(AppConstants.profileImagesPath)
          .child(fileName);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Upload video with compression
  Future<Map<String, String>> uploadVideo(File videoFile, String userId) async {
    try {
      // Compress video
      MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      if (compressedVideo == null) {
        throw Exception('Video compression failed');
      }

      String videoFileName = 'video_${userId}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      String thumbnailFileName = 'thumbnail_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload compressed video
      Reference videoRef = _storage
          .ref()
          .child(AppConstants.postVideosPath)
          .child(videoFileName);

      UploadTask videoUploadTask = videoRef.putFile(File(compressedVideo.path!));
      TaskSnapshot videoSnapshot = await videoUploadTask;
      String videoUrl = await videoSnapshot.ref.getDownloadURL();

      // Generate and upload thumbnail
      File? thumbnailFile = await VideoCompress.getFileThumbnail(
        compressedVideo.path!,
        quality: 50,
      );

      String thumbnailUrl = '';
      if (thumbnailFile != null) {
        Reference thumbnailRef = _storage
            .ref()
            .child(AppConstants.postThumbnailsPath)
            .child(thumbnailFileName);

        UploadTask thumbnailUploadTask = thumbnailRef.putFile(thumbnailFile);
        TaskSnapshot thumbnailSnapshot = await thumbnailUploadTask;
        thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();
      }

      // Clean up compressed video file
      await File(compressedVideo.path!).delete();

      return {
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'duration': compressedVideo.duration.toString(),
      };
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  // Upload message media
  Future<String> uploadMessageMedia(File mediaFile, String chatId, MessageType type) async {
    try {
      String extension = type == MessageType.image ? 'jpg' : 'mp4';
      String fileName = 'message_${chatId}_${DateTime.now().millisecondsSinceEpoch}.$extension';
      
      Reference ref = _storage
          .ref()
          .child(AppConstants.messageMediaPath)
          .child(fileName);

      File fileToUpload = mediaFile;

      // Compress video if it's a video message
      if (type == MessageType.video) {
        MediaInfo? compressedVideo = await VideoCompress.compressVideo(
          mediaFile.path,
          quality: VideoQuality.LowQuality,
          deleteOrigin: false,
        );

        if (compressedVideo != null) {
          fileToUpload = File(compressedVideo.path!);
        }
      }

      UploadTask uploadTask = ref.putFile(fileToUpload);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Clean up compressed file if it was created
      if (type == MessageType.video && fileToUpload.path != mediaFile.path) {
        await fileToUpload.delete();
      }

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload message media: $e');
    }
  }

  // Delete file from storage
  Future<void> deleteFile(String url) async {
    try {
      Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // File might not exist, ignore error
      print('Failed to delete file: $e');
    }
  }

  // Get video thumbnail
  Future<File?> getVideoThumbnail(String videoPath) async {
    try {
      File? thumbnailFile = await VideoCompress.getFileThumbnail(
        videoPath,
        quality: 50,
      );

      if (thumbnailFile != null) {
        return thumbnailFile;
      }
      return null;
    } catch (e) {
      print('Failed to generate thumbnail: $e');
      return null;
    }
  }

  // Compress image
  Future<File> compressImage(File imageFile) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // For now, just copy the file. In a real app, you'd use image compression
      File compressedFile = await imageFile.copy(targetPath);
      return compressedFile;
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }

  // Get file size in MB
  double getFileSizeInMB(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMB = sizeInBytes / (1024 * 1024);
    return sizeInMB;
  }

  // Validate video file
  bool isValidVideoFile(File videoFile) {
    double sizeInMB = getFileSizeInMB(videoFile);
    return sizeInMB <= AppConstants.maxVideoSizeMB;
  }

  // Get video duration
  Future<Duration?> getVideoDuration(String videoPath) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.getMediaInfo(videoPath);
      if (mediaInfo != null && mediaInfo.duration != null) {
        return Duration(milliseconds: mediaInfo.duration!.toInt());
      }
      return null;
    } catch (e) {
      print('Failed to get video duration: $e');
      return null;
    }
  }

  // Validate video duration
  Future<bool> isValidVideoDuration(String videoPath) async {
    Duration? duration = await getVideoDuration(videoPath);
    if (duration == null) return false;

    int durationInSeconds = duration.inSeconds;
    return durationInSeconds >= AppConstants.minVideoDurationSeconds &&
           durationInSeconds <= AppConstants.maxVideoDurationSeconds;
  }

  // Pick image from gallery or camera
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // Pick video from gallery or camera
  Future<File?> pickVideo({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: AppConstants.maxVideoDurationSeconds),
      );

      if (video != null) {
        File videoFile = File(video.path);
        
        // Validate file size
        if (!isValidVideoFile(videoFile)) {
          throw Exception('Video file is too large. Maximum size is ${AppConstants.maxVideoSizeMB}MB');
        }

        // Validate duration
        bool isValidDuration = await isValidVideoDuration(video.path);
        if (!isValidDuration) {
          throw Exception('Video duration must be between ${AppConstants.minVideoDurationSeconds} and ${AppConstants.maxVideoDurationSeconds} seconds');
        }

        return videoFile;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick video: $e');
    }
  }
}