import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/colors.dart';
import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/main_screen.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Bix',
            debugShowCheckedModeBanner: false,
            
            // Localization
            locale: themeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Theme
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.getEffectiveThemeMode(context),
            
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isAuthenticated) {
                  return const MainScreen();
                } else {
                  return const WelcomeScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}