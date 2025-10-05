import 'package:flutter/material.dart';

// Define the colors used in the settings screen
const Color kPrimaryColor = Color(0xFF7F06F9); // Purple
const Color kAccentPurple = Color(0xFFA564E9); // Lighter Purple/Accent
const Color kBackgroundDark = Color(0xFF100819);

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  // Reusable widget for section headers (e.g., 'ACCOUNT', 'PREFERENCES')
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 16,
        top: 32,
        bottom: 12,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  // Reusable widget for a clickable setting tile
  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: kAccentPurple, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 18,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply a custom theme for the dark screen look
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark().copyWith(primary: kPrimaryColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ACCOUNT Section
              _buildSectionHeader(context, 'ACCOUNT'),
              _buildSettingTile(context, Icons.lock, 'Change Password', () {}),
              _buildSettingTile(context, Icons.mail, 'Email', () {}),

              // PREFERENCES Section
              _buildSectionHeader(context, 'PREFERENCES'),
              _buildSettingTile(
                context,
                Icons.calendar_today,
                'Event Preferences',
                () {},
              ),
              _buildSettingTile(
                context,
                Icons.notifications,
                'Notification Preferences',
                () {},
              ),
              _buildSettingTile(
                context,
                Icons.security,
                'Privacy Settings',
                () {},
              ),
              _buildSettingTile(context, Icons.apps, 'App Preferences', () {}),

              // SUPPORT Section
              _buildSectionHeader(context, 'SUPPORT'),
              _buildSettingTile(
                context,
                Icons.help_outline,
                'Help & Support',
                () {},
              ),
              _buildSettingTile(context, Icons.info_outline, 'About Us', () {}),

              const SizedBox(height: 40),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Implement logout logic
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kAccentPurple,
                      side: const BorderSide(color: kAccentPurple, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
