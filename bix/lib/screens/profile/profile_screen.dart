import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../widgets/video_grid_item.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPosts();
    });
  }

  void _loadUserPosts() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    if (authProvider.userModel != null) {
      postProvider.loadUserPosts(authProvider.userModel!.uid);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.userModel == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return Column(
              children: [
                // App Bar
                _buildAppBar(),
                
                // Profile Header
                _buildProfileHeader(authProvider.userModel!),
                
                // Stats
                _buildStats(authProvider.userModel!),
                
                // Action Buttons
                _buildActionButtons(),
                
                // Tab Bar
                _buildTabBar(),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPostsTab(),
                      _buildLikedTab(),
                    ],
                  ),
                ),
              ],
            );
          },
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
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Text(
                authProvider.userModel?.username ?? 'Profile',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Add friends
                },
                icon: const Icon(
                  Icons.person_add_outlined,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.menu,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: CircleAvatar(
              radius: 47,
              backgroundImage: user.profileImageUrl != null
                  ? CachedNetworkImageProvider(user.profileImageUrl!)
                  : null,
              backgroundColor: AppColors.surface,
              child: user.profileImageUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.textSecondary,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Display Name
          Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          // Username
          Text(
            '@${user.username}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          
          // Bio
          if (user.bio != null && user.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                user.bio!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Posts', user.postsCount.toString()),
          _buildStatItem('Followers', user.followers.length.toString()),
          _buildStatItem('Following', user.following.length.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Edit profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // TODO: Share profile
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Share Profile',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        tabs: const [
          Tab(
            icon: Icon(Icons.grid_on),
            text: 'Posts',
          ),
          Tab(
            icon: Icon(Icons.favorite),
            text: 'Liked',
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (postProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (postProvider.userPosts.isEmpty) {
          return _buildEmptyPostsState();
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: postProvider.userPosts.length,
            itemBuilder: (context, index) {
              return VideoGridItem(post: postProvider.userPosts[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildLikedTab() {
    return const Center(
      child: Text(
        'Liked videos coming soon',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildEmptyPostsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.video_library_outlined,
              size: 40,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Share your first video to get started',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}