import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'create/create_screen.dart';
import 'messages/messages_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CreateScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 28,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1 ? Icons.search : Icons.search_outlined,
                size: 28,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: _currentIndex == 2 ? AppColors.primary : AppColors.textSecondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: _currentIndex == 2 ? Colors.white : AppColors.textSecondary,
                ),
              ),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3 ? Icons.chat_bubble : Icons.chat_bubble_outline,
                size: 28,
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _currentIndex == 4 ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.surfaceVariant,
                      backgroundImage: authProvider.userModel?.profileImageUrl != null
                          ? NetworkImage(authProvider.userModel!.profileImageUrl!)
                          : null,
                      child: authProvider.userModel?.profileImageUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 16,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                  );
                },
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}