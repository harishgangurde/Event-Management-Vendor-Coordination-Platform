import 'package:eventtoria/views/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear SharedPreferences to prevent auto-login
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

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

    Widget _buildSettingsSection(
      String title,
      List<Map<String, dynamic>> items,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  InkWell(
                    onTap: item['onTap'],
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: backgroundDark.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'], color: primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  if (index != items.length - 1)
                    Divider(color: Colors.grey[800], height: 1),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return Scaffold(
      body: Container(
        color: backgroundDark,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
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
                _buildSettingsSection('About', [
                  {'title': 'About Us', 'icon': Icons.info, 'onTap': () {}},
                ]),
                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _logout(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(color: primary, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
