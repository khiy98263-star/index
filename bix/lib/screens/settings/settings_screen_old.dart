import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Section
            _buildSection(
              title: 'Account',
              items: [
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your profile information',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy',
                  subtitle: 'Manage your privacy settings',
                  onTap: () {
                    // TODO: Navigate to privacy settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: 'Password and security settings',
                  onTap: () {
                    // TODO: Navigate to security settings
                  },
                ),
              ],
            ),

            // Preferences Section
            _buildSection(
              title: 'Preferences',
              items: [
                _buildSettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    // TODO: Navigate to notification settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  subtitle: 'Choose your preferred theme',
                  onTap: () {
                    // TODO: Navigate to theme settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'Select your language',
                  onTap: () {
                    // TODO: Navigate to language settings
                  },
                ),
              ],
            ),

            // Content Section
            _buildSection(
              title: 'Content',
              items: [
                _buildSettingsItem(
                  icon: Icons.download_outlined,
                  title: 'Downloads',
                  subtitle: 'Manage downloaded videos',
                  onTap: () {
                    // TODO: Navigate to downloads
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.storage,
                  title: 'Storage',
                  subtitle: 'Manage app storage usage',
                  onTap: () {
                    // TODO: Navigate to storage settings
                  },
                ),
              ],
            ),

            // Support Section
            _buildSection(
              title: 'Support',
              items: [
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    // TODO: Navigate to help center
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts with us',
                  onTap: () {
                    // TODO: Navigate to feedback
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),

            // Legal Section
            _buildSection(
              title: 'Legal',
              items: [
                _buildSettingsItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms of service',
                  onTap: () {
                    // TODO: Navigate to terms
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
              ],
            ),

            // Sign Out Section
            _buildSection(
              title: 'Account Actions',
              items: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Sign out of your account',
                      textColor: AppColors.error,
                      onTap: () => _showSignOutDialog(context, authProvider),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  textColor: AppColors.error,
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textTertiary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Sign Out',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.signOut();
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Account',
          style: TextStyle(color: AppColors.error),
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Bix',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.play_circle_filled,
          size: 32,
          color: Colors.white,
        ),
      ),
      children: const [
        Text(
          'Bix is a short video social media app where you can share your moments with the world.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}