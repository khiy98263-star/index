import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../services/storage_service.dart';
import 'video_editor_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      'Create Your Video',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'Share your moments with the world',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Create Options
                    Column(
                      children: [
                        // Record Video
                        _buildCreateOption(
                          icon: Icons.videocam,
                          title: 'Record Video',
                          subtitle: 'Use camera to record a new video',
                          gradient: AppColors.primaryGradient,
                          onTap: () => _recordVideo(),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Upload Video
                        _buildCreateOption(
                          icon: Icons.video_library,
                          title: 'Upload Video',
                          subtitle: 'Choose a video from your gallery',
                          gradient: AppColors.secondaryGradient,
                          onTap: () => _uploadVideo(),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Live Stream (Coming Soon)
                        _buildCreateOption(
                          icon: Icons.live_tv,
                          title: 'Go Live',
                          subtitle: 'Start a live stream (Coming Soon)',
                          gradient: AppColors.accentGradient,
                          onTap: () => _showComingSoonDialog(),
                          isDisabled: true,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppColors.accent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tips for great videos',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildTip('Keep videos between 15-60 seconds'),
                          _buildTip('Use good lighting and clear audio'),
                          _buildTip('Add engaging captions and hashtags'),
                          _buildTip('Be creative and authentic'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Create',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Show create history or drafts
            },
            icon: const Icon(
              Icons.history,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDisabled ? null : gradient,
          color: isDisabled ? AppColors.surfaceVariant : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDisabled ? null : [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                icon,
                color: isDisabled ? AppColors.textTertiary : Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDisabled ? AppColors.textTertiary : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDisabled 
                          ? AppColors.textTertiary 
                          : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDisabled 
                  ? AppColors.textTertiary 
                  : Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _recordVideo() async {
    // Check camera permission
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      try {
        File? videoFile = await _storageService.pickVideo(source: ImageSource.camera);
        if (videoFile != null) {
          _navigateToVideoEditor(videoFile);
        }
      } catch (e) {
        _showErrorSnackBar(e.toString());
      }
    } else {
      _showErrorSnackBar('Camera and microphone permissions are required');
    }
  }

  void _uploadVideo() async {
    // Check storage permission
    PermissionStatus storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted || storageStatus.isLimited) {
      try {
        File? videoFile = await _storageService.pickVideo(source: ImageSource.gallery);
        if (videoFile != null) {
          _navigateToVideoEditor(videoFile);
        }
      } catch (e) {
        _showErrorSnackBar(e.toString());
      }
    } else {
      _showErrorSnackBar('Storage permission is required');
    }
  }

  void _navigateToVideoEditor(File videoFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoEditorScreen(videoFile: videoFile),
      ),
    );
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Coming Soon',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Live streaming feature will be available in a future update. Stay tuned!',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}