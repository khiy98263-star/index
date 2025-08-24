import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/post_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/video_grid_item.dart';
import '../../models/post_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  List<PostModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExplorePosts();
    });
  }

  void _loadExplorePosts() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.loadExplorePosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExploreTab(),
                  _buildUsersTab(),
                  _buildHashtagsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search videos, users, hashtags...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: _performSearch,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      _searchResults.clear();
                      _isSearching = false;
                    });
                  }
                },
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                  _isSearching = false;
                });
              },
              icon: const Icon(
                Icons.clear,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Explore'),
          Tab(text: 'Users'),
          Tab(text: 'Hashtags'),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        List<PostModel> posts = _isSearching ? _searchResults : postProvider.explorePosts;

        if (postProvider.isLoading && !_isSearching) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (posts.isEmpty) {
          return _buildEmptyState();
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
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return VideoGridItem(post: posts[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Text(
        'Users search coming soon',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHashtagsTab() {
    return const Center(
      child: Text(
        'Hashtags search coming soon',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
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
              Icons.search_off,
              size: 60,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isSearching ? 'No results found' : 'Discover amazing videos',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching 
                ? 'Try searching for something else'
                : 'Explore trending videos and creators',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    final postProvider = Provider.of<PostProvider>(context, listen: false);
    List<PostModel> results = await postProvider.searchPosts(query.trim());

    setState(() {
      _searchResults = results;
    });
  }
}