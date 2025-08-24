import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart' hide ThemeMode;
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.userModel != null) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: authProvider.userModel!.photoURL.isNotEmpty
                                ? NetworkImage(authProvider.userModel!.photoURL)
                                : null,
                            child: authProvider.userModel!.photoURL.isEmpty
                                ? Text(
                                    authProvider.userModel!.displayName.isNotEmpty
                                        ? authProvider.userModel!.displayName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.userModel!.displayName,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${authProvider.userModel!.username}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                if (authProvider.isGuestMode)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      localizations.guest,
                                      style: TextStyle(
                                        color: Colors.orange[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // TODO: Navigate to edit profile
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Appearance Section
            Text(
              localizations.theme,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return ListTile(
                        leading: Icon(
                          theme.brightness == Brightness.dark 
                              ? Icons.dark_mode 
                              : Icons.light_mode,
                        ),
                        title: Text(localizations.theme),
                        subtitle: Text(_getThemeModeText(themeProvider.themeMode, localizations)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showThemeDialog(context, themeProvider, localizations),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(localizations.language),
                        subtitle: Text(_getLanguageText(themeProvider.locale, localizations)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showLanguageDialog(context, themeProvider, localizations),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Settings Section
            Text(
              'إعدادات التطبيق',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(localizations.notifications),
                    trailing: Switch(
                      value: true, // TODO: Connect to notification settings
                      onChanged: (value) {
                        // TODO: Handle notification toggle
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: Text(localizations.privacy),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: Text(localizations.security),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Section
            Text(
              'معلومات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(localizations.about),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showAboutDialog(context, localizations);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('المساعدة والدعم'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('تقييم التطبيق'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Open app store for rating
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Logout Button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context, authProvider, localizations),
                    icon: const Icon(Icons.logout),
                    label: Text(localizations.logout),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // App Version
            Center(
              child: Text(
                'Bix v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeText(AppThemeMode mode, AppLocalizations localizations) {
    switch (mode) {
      case AppThemeMode.light:
        return localizations.lightMode;
      case AppThemeMode.dark:
        return localizations.darkMode;
      case AppThemeMode.system:
        return localizations.systemMode;
    }
  }

  String _getLanguageText(Locale locale, AppLocalizations localizations) {
    switch (locale.languageCode) {
      case 'ar':
        return localizations.arabic;
      case 'en':
        return localizations.english;
      default:
        return localizations.arabic;
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppThemeMode>(
              title: Text(localizations.lightMode),
              value: AppThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: Text(localizations.darkMode),
              value: AppThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: Text(localizations.systemMode),
              value: AppThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, ThemeProvider themeProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(localizations.arabic),
              value: const Locale('ar', 'SA'),
              groupValue: themeProvider.locale,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<Locale>(
              title: Text(localizations.english),
              value: const Locale('en', 'US'),
              groupValue: themeProvider.locale,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations localizations) {
    showAboutDialog(
      context: context,
      applicationName: 'Bix',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(
          Icons.video_library_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: [
        const SizedBox(height: 16),
        Text(
          localizations.welcomeSubtitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'تطبيق Bix هو منصة لمشاركة الفيديوهات القصيرة والتواصل مع الأصدقاء. يمكنك إنشاء ومشاركة المحتوى المرئي بسهولة.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.logout),
        content: Text(
          authProvider.isGuestMode 
              ? 'هل تريد الخروج من وضع الضيف؟'
              : 'هل تريد تسجيل الخروج من حسابك؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.signOut();
            },
            child: Text(
              localizations.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}