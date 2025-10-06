import 'package:eventtoria/config/app_theme.dart';
import 'package:flutter/material.dart';

class VendorSettingsScreen extends StatelessWidget {
  const VendorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'ACCOUNT'),
              _buildSettingTile(context, Icons.lock, 'Change Password', () {}),
              _buildSettingTile(
                  context, Icons.mail, 'Email Preferences', () {}),
              _buildSectionHeader(context, 'PREFERENCES'),
              _buildSettingTile(
                  context, Icons.notifications, 'Notification Settings', () {}),
              _buildSettingTile(
                  context, Icons.security, 'Privacy Settings', () {}),
              _buildSectionHeader(context, 'SUPPORT'),
              _buildSettingTile(
                  context, Icons.help_outline, 'Help & Support', () {}),
              _buildSettingTile(
                  context, Icons.info_outline, 'About Us', () {}),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.kAccentPurple,
                      side: const BorderSide(
                          color: AppTheme.kAccentPurple, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Logout',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 24.0, right: 16, top: 32, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 13),
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: AppTheme.kAccentPurple, size: 28),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: onTap,
    );
  }
}