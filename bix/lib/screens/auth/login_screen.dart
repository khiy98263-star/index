import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../l10n/app_localizations.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  int _selectedTab = 0; // 0: Email, 1: Phone
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2D2D2D),
                  ]
                : [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Language & Theme Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              return IconButton(
                                onPressed: () {
                                  final newLocale = themeProvider.locale.languageCode == 'ar'
                                      ? const Locale('en', 'US')
                                      : const Locale('ar', 'SA');
                                  themeProvider.setLocale(newLocale);
                                },
                                icon: Icon(
                                  Icons.language,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              );
                            },
                          ),
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              return IconButton(
                                onPressed: () {
                                  final newMode = themeProvider.themeMode == AppThemeMode.light
                                      ? AppThemeMode.dark
                                      : AppThemeMode.light;
                                  themeProvider.setThemeMode(newMode);
                                },
                                icon: Icon(
                                  isDark ? Icons.light_mode : Icons.dark_mode,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Logo and Title
                      Center(
                        child: Column(
                          children: [
                            Hero(
                              tag: 'app_logo',
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.video_library_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Bix',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.welcomeSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Login Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              localizations.login,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Tab Selector
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedTab = 0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _selectedTab == 0 
                                              ? theme.primaryColor 
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          localizations.email,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _selectedTab == 0 
                                                ? Colors.white 
                                                : theme.textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedTab = 1),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _selectedTab == 1 
                                              ? theme.primaryColor 
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          localizations.phoneNumber,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _selectedTab == 1 
                                                ? Colors.white 
                                                : theme.textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Form Fields
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _selectedTab == 0 
                                  ? _buildEmailForm(localizations, theme)
                                  : _buildPhoneForm(localizations, theme),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Login Button
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.primaryColor,
                                        theme.primaryColor.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: authProvider.isLoading ? null : () => _handleLogin(authProvider),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: authProvider.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            localizations.login,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Forgot Password
                            TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password
                              },
                              child: Text(
                                localizations.forgotPassword,
                                style: TextStyle(color: theme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Social Login
                      _buildSocialLogin(localizations, theme),
                      
                      const SizedBox(height: 32),
                      
                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب؟ ',
                            style: TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              localizations.register,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(AppLocalizations localizations, ThemeData theme) {
    return Column(
      key: const ValueKey('email_form'),
      children: [
        CustomTextField(
          controller: _emailController,
          label: localizations.email,
          hintText: localizations.email,
          labelText: localizations.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.fieldRequired;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return localizations.invalidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: localizations.password,
          hintText: localizations.password,
          labelText: localizations.password,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.fieldRequired;
            }
            if (value.length < 6) {
              return localizations.passwordTooShort;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneForm(AppLocalizations localizations, ThemeData theme) {
    return Column(
      key: const ValueKey('phone_form'),
      children: [
        CustomTextField(
          controller: _phoneController,
          label: localizations.phoneNumber,
          hintText: localizations.phoneNumber,
          labelText: localizations.phoneNumber,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.fieldRequired;
            }
            if (value.length < 10) {
              return 'رقم الهاتف غير صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'سيتم إرسال رمز التحقق إلى رقم هاتفك',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin(AppLocalizations localizations, ThemeData theme) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Social Buttons
        Row(
          children: [
            Expanded(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    label: 'Google',
                    onPressed: authProvider.isLoading ? null : () async {
                      await authProvider.signInWithGoogle();
                      if (authProvider.error != null) {
                        _showError(authProvider.error!);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return _buildSocialButton(
                    icon: Icons.person_outline,
                    label: localizations.guest,
                    onPressed: authProvider.isLoading ? null : () async {
                      await authProvider.signInAsGuest();
                      if (authProvider.error != null) {
                        _showError(authProvider.error!);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTab == 0) {
        await authProvider.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        // TODO: Implement phone login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تسجيل الدخول بالهاتف قيد التطوير'),
          ),
        );
      }
      
      if (authProvider.error != null) {
        _showError(authProvider.error!);
      }
    }
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}