import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../constants/colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../widgets/custom_text_field.dart';

class VideoEditorScreen extends StatefulWidget {
  final File videoFile;

  const VideoEditorScreen({
    super.key,
    required this.videoFile,
  });

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  VideoPlayerController? _controller;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isInitialized = false;
  bool _isPlaying = false;
  List<String> _hashtags = [];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.file(widget.videoFile);
    
    try {
      await _controller!.initialize();
      _controller!.setLooping(true);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Video',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              return TextButton(
                onPressed: postProvider.isUploading ? null : _publishVideo,
                child: postProvider.isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Text(
                        'Publish',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video Preview
            _buildVideoPreview(),
            
            // Video Info Form
            _buildVideoInfoForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Video Player
            if (_isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),

            // Play/Pause Overlay
            if (_isInitialized)
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: !_isPlaying
                      ? const Center(
                          child: Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 64,
                          ),
                        )
                      : null,
                ),
              ),

            // Video Controls
            if (_isInitialized)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    // Progress Bar
                    VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppColors.primary,
                        bufferedColor: AppColors.surfaceVariant,
                        backgroundColor: AppColors.border,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _togglePlayPause,
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {
                            _controller!.seekTo(Duration.zero);
                          },
                          icon: const Icon(
                            Icons.replay,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfoForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caption
          CustomTextField(
            controller: _captionController,
            label: 'Caption',
            hintText: 'Write a caption for your video...',
            maxLines: 4,
            maxLength: AppConstants.maxCaptionLength,
            onChanged: (value) {
              _extractHashtags(value);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Hashtags
          if (_hashtags.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hashtags',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _hashtags.map((hashtag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Text(
                        hashtag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          
          // Location
          CustomTextField(
            controller: _locationController,
            label: 'Location (Optional)',
            hintText: 'Add a location...',
            prefixIcon: Icons.location_on_outlined,
          ),
          
          const SizedBox(height: 24),
          
          // Privacy Settings
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
                const Text(
                  'Privacy Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.public,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Public',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Anyone can see this video',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: true,
                      groupValue: true,
                      onChanged: (value) {
                        // TODO: Implement privacy settings
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _isPlaying = false;
        } else {
          _controller!.play();
          _isPlaying = true;
        }
      });
    }
  }

  void _extractHashtags(String text) {
    RegExp hashtagRegex = RegExp(r'#\w+');
    Iterable<Match> matches = hashtagRegex.allMatches(text);
    List<String> hashtags = matches
        .map((match) => match.group(0)!.toLowerCase())
        .toSet()
        .toList();
    
    setState(() {
      _hashtags = hashtags;
    });
  }

  void _publishVideo() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    if (authProvider.userModel == null) {
      _showErrorSnackBar('Please sign in to publish videos');
      return;
    }

    if (_captionController.text.trim().isEmpty) {
      _showErrorSnackBar('Please add a caption for your video');
      return;
    }

    bool success = await postProvider.createPost(
      videoFile: widget.videoFile,
      caption: _captionController.text.trim(),
      user: authProvider.userModel!,
      hashtags: _hashtags,
      location: _locationController.text.trim().isNotEmpty 
          ? _locationController.text.trim() 
          : null,
    );

    if (success) {
      _showSuccessSnackBar('Video published successfully!');
      Navigator.pop(context);
    } else if (postProvider.error != null) {
      _showErrorSnackBar(postProvider.error!);
    }
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}