import 'package:eventtoria/views/landing/splash_screen.dart';
import 'package:eventtoria/views/landing/landing_screen.dart';
import 'package:eventtoria/views/auth/login_screen.dart';
import 'package:eventtoria/views/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/planner/dashboard_planner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAx7lrGMqryY4ka87Hv26aBIQboUP4jCkQ",
      appId: "1:763742703305:android:e2e7726f1dd3e519ce4718",
      messagingSenderId: "763742703305",
      projectId: "eventtoria",
    ),
  );

  runApp(const EventtoriaApp());
}

class EventtoriaApp extends StatelessWidget {
  const EventtoriaApp({super.key});

  // Primary App Colors
  static const Color primaryColor = Color(0xFF7F06F9);
  static const Color backgroundLight = Color(0xFFF7F5F8);
  static const Color backgroundDark = Color(0xFF190F23);
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    // --- Light Theme ---
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Roboto',
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryColor.withOpacity(0.8),
        background: backgroundLight,
        onBackground: textLight,
        surface: Colors.white,
        onSurface: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );

    // --- Dark Theme ---
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      fontFamily: 'Roboto',
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryColor.withOpacity(0.8),
        background: backgroundDark,
        onBackground: textDark,
        surface: const Color(0xFF313131),
        onSurface: textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1A0F24),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF313131),
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventtoria',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Automatically adapts to system mode

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardPlanner(),
      },
    );
  }
}
