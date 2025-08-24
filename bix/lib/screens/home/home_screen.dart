import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../widgets/video_player_widget.dart';
import '../../models/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeedPosts();
    });
  }

  void _loadFeedPosts() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    if (authProvider.userModel != null) {
      List<String> followingIds = List.from(authProvider.userModel!.following);
      followingIds.add(authProvider.userModel!.uid); // Include own posts
      postProvider.loadFeedPosts(followingIds);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Video Feed
            Expanded(
              child: Consumer<PostProvider>(
                builder: (context, postProvider, child) {
                  if (postProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (postProvider.feedPosts.isEmpty) {
                    return _buildEmptyState();
                  }

                  return PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() {
                        _currentVideoIndex = index;
                      });
                    },
                    itemCount: postProvider.feedPosts.length,
                    itemBuilder: (context, index) {
                      final post = postProvider.feedPosts[index];
                      return VideoPlayerWidget(
                        post: post,
                        isPlaying: index == _currentVideoIndex,
                      );
                    },
                  );
                },
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
          // Logo
          const Text(
            'Bix',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          
          // Actions
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Implement live streaming
                },
                icon: const Icon(
                  Icons.live_tv_outlined,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement notifications
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.video_library_outlined,
              size: 60,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No videos yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Follow some users to see their videos here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to search/discover
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Discover Users',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}