import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/colors.dart';
import '../models/post_model.dart';

class VideoGridItem extends StatelessWidget {
  final PostModel post;

  const VideoGridItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to video detail or full screen player
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Thumbnail
              post.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: post.thumbnailUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.error,
                          color: AppColors.error,
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.video_library,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
                    ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Play Icon
              const Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 48,
                ),
              ),

              // Bottom Info
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Caption
                    if (post.caption.isNotEmpty)
                      Text(
                        post.caption,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: 4),
                    
                    // Stats
                    Row(
                      children: [
                        // Likes
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: AppColors.like,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(post.likes.length),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Comments
                        Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(post.commentsCount),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        const Spacer(),
                        
                        // Duration
                        if (post.duration != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatDuration(post.duration!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // User Avatar (Top Right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: CircleAvatar(
                    radius: 11,
                    backgroundImage: post.userProfileImage.isNotEmpty
                        ? CachedNetworkImageProvider(post.userProfileImage)
                        : null,
                    backgroundColor: AppColors.surface,
                    child: post.userProfileImage.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 12,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  String _formatDuration(double durationInSeconds) {
    int minutes = (durationInSeconds / 60).floor();
    int seconds = (durationInSeconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}