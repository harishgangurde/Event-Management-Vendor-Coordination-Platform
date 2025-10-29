// lib/views/admin/setting_admin.dart
// This file is correct as-is. The logout function is dynamic.

import 'package:eventtoria/views/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  Future<void> _logout(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF190F23),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7F06F9)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFF7F06F9)),
            ),
          ),
        ],
      ),
    );

    if (confirm != null && confirm) {
      if (!context.mounted) return;
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear SharedPreferences to prevent auto-login
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!context.mounted) return;
      // Navigate to Login screen
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = Tween(
              begin: 0.0,
              end: 1.0,
            ).animate(animation);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF7F06F9);
    final Color backgroundDark = const Color(0xFF190F23);
    final Color cardDark = const Color(0xFF1F1A30); // Use card color


    Widget _buildSettingsSection(
      String title,
      List<Map<String, dynamic>> items,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color: primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                return Column(
                  children: [
                    ListTile(
                      onTap: item['onTap'],
                      leading: Container(
                        height: 40, // consistent size
                        width: 40,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item['icon'], color: primary, size: 20),
                      ),
                      title: Text(
                        item['title'],
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    ),
                    if (index != items.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 68.0), // Align with title
                        child: Divider(color: Colors.grey[800], height: 1),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // No back button on a main tab
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            _buildSettingsSection('Platform Configuration', [
              {
                'title': 'User Management',
                'icon': Icons.group,
                'onTap': () {},
              },
              {
                'title': 'System Alerts & Logs',
                'icon': Icons.dvr,
                'onTap': () {},
              },
            ]),
            _buildSettingsSection('Notification Preferences', [
              {
                'title': 'New Registrations',
                'icon': Icons.person_add,
                'onTap': () {},
              },
              {'title': 'Disputes', 'icon': Icons.flag, 'onTap': () {}},
            ]),
            _buildSettingsSection('App Preferences', [
              {
                'title': 'Theme',
                'icon': Icons.brightness_6,
                'onTap': () {},
              },
              {'title': 'Language', 'icon': Icons.language, 'onTap': () {}},
            ]),
            _buildSettingsSection('Help & Support', [
              {
                'title': 'Help Center',
                'icon': Icons.help_center,
                'onTap': () {},
              },
              {
                'title': 'Contact Support',
                'icon': Icons.headset_mic,
                'onTap': () {},
              },
            ]),
            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: Icon(Icons.logout, color: Colors.redAccent),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: BorderSide(color: Colors.redAccent.withOpacity(0.5), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}