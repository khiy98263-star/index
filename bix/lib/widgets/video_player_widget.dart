import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../constants/colors.dart';
import '../models/post_model.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';

class VideoPlayerWidget extends StatefulWidget {
  final PostModel post;
  final bool isPlaying;

  const VideoPlayerWidget({
    super.key,
    required this.post,
    required this.isPlaying,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isLiked = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _checkIfLiked();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.videoUrl));
    
    try {
      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      
      if (widget.isPlaying) {
        _controller!.play();
      }
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _checkIfLiked() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      setState(() {
        _isLiked = widget.post.likes.contains(authProvider.user!.uid);
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : widget.post.thumbnailUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.post.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.error,
                            color: AppColors.error,
                            size: 48,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      ),
          ),
        ),

        // Play/Pause Overlay
        if (!_isInitialized || !_controller!.value.isPlaying)
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.overlay,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

        // Right Side Actions
        Positioned(
          right: 12,
          bottom: 80,
          child: Column(
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to user profile
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundImage: widget.post.userProfileImage.isNotEmpty
                        ? CachedNetworkImageProvider(widget.post.userProfileImage)
                        : null,
                    backgroundColor: AppColors.surface,
                    child: widget.post.userProfileImage.isEmpty
                        ? const Icon(Icons.person, color: AppColors.textSecondary)
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Like Button
              _buildActionButton(
                icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? AppColors.like : Colors.white,
                count: widget.post.likes.length,
                onTap: _toggleLike,
              ),

              const SizedBox(height: 24),

              // Comment Button
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                color: Colors.white,
                count: widget.post.commentsCount,
                onTap: () {
                  // TODO: Show comments
                },
              ),

              const SizedBox(height: 24),

              // Share Button
              _buildActionButton(
                icon: Icons.share_outlined,
                color: Colors.white,
                count: widget.post.sharesCount,
                onTap: () {
                  // TODO: Share post
                },
              ),

              const SizedBox(height: 24),

              // Mute/Unmute Button
              GestureDetector(
                onTap: _toggleMute,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Info
        Positioned(
          left: 12,
          right: 80,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username
              Row(
                children: [
                  Text(
                    '@${widget.post.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeago.format(widget.post.createdAt),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Caption
              if (widget.post.caption.isNotEmpty)
                Text(
                  widget.post.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

              // Hashtags
              if (widget.post.hashtags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    children: widget.post.hashtags.take(3).map((hashtag) {
                      return Text(
                        hashtag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Location
              if (widget.post.location != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.location!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.overlay,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    }
  }

  void _toggleLike() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    if (authProvider.user != null) {
      setState(() {
        _isLiked = !_isLiked;
      });

      if (_isLiked) {
        await postProvider.likePost(widget.post.id, authProvider.user!.uid);
      } else {
        await postProvider.unlikePost(widget.post.id, authProvider.user!.uid);
      }
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _controller?.setVolume(_isMuted ? 0.0 : 1.0);
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}