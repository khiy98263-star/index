import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/main_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const BixApp());
}

class BixApp extends StatelessWidget {
  const BixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Bix',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textPrimary),
            bodySmall: TextStyle(color: AppColors.textSecondary),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const MainScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}