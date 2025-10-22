// lib/main.dart

import 'package:eventtoria/config/app_theme.dart'; // Import your AppTheme
import 'package:eventtoria/firebase_options.dart'; // Import Firebase options
import 'package:eventtoria/views/landing/splash_screen.dart';
import 'package:eventtoria/views/landing/landing_screen.dart';
import 'package:eventtoria/views/auth/login_screen.dart';
import 'package:eventtoria/views/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/planner/planner_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the generated firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EventtoriaApp());
}

class EventtoriaApp extends StatelessWidget {
  const EventtoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventtoria',
      
      // Use the themes from your app_theme.dart file
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically adapts to system mode

      // Define your app's routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        // This route is your main entry point after login for planners
        '/dashboard': (context) => const DashboardPlanner(),
      },
    );
  }
}