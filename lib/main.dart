import 'package:eventtoria/views/landing/splash_screen.dart';
import 'package:eventtoria/views/planner/dashboard_planner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/landing/landing_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase (existing logic preserved)
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

  // Define custom hex colors from the HTML/Tailwind configuration
  static const Color primaryColor = Color(0xFF7F06F9);
  static const Color backgroundLight = Color(0xFFF7F5F8); // background-light
  static const Color backgroundDark = Color(0xFF190F23); // background-dark

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventtoria',

      // --- Light Theme Configuration ---
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: backgroundLight,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      // --- Dark Theme Configuration ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: backgroundDark,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      themeMode: ThemeMode.system,

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/landing': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),

        // <<< FIX: REGISTERED PLANNER DASHBOARD ROUTE >>>
        '/dashboard': (context) => const DashboardPlanner(),
      },
    );
  }
}
