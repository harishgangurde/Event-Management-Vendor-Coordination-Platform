import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventtoria/views/auth/login_screen.dart'; // ⚠️ Update this path if different

class VendorSetting extends StatefulWidget {
  const VendorSetting({super.key});

  @override
  State<VendorSetting> createState() => _VendorSettingState();
}

class _VendorSettingState extends State<VendorSetting>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.2)).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          color: const Color(0xFF9B62FF),
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2B1C4C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white70,
          size: 16,
        ),
        onTap: onTap,
        dense: true,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final bool? confirmLogout = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "Logout",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Are you sure you want to logout?",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Logout",
              style: GoogleFonts.poppins(
                color: const Color(0xFFD9415D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      setState(() => _isLoggingOut = true);
      await _controller.forward(); // play animation

      await FirebaseAuth.instance.signOut();

      // Navigate to Login screen after animation completes
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final fadeIn = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeIn,
                  );
                  return FadeTransition(opacity: fadeIn, child: child);
                },
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A102E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: ReverseAnimation(_fadeAnimation),
            child: SlideTransition(position: _slideAnimation, child: child),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Account"),
              _buildSettingTile("Change Password"),
              _buildSettingTile("Email"),

              _buildSectionTitle("Service & Pricing"),
              _buildSettingTile("Manage Services"),
              _buildSettingTile("Pricing Settings"),

              _buildSectionTitle("Availability"),
              _buildSettingTile("Availability Settings"),

              _buildSectionTitle("Notifications"),
              _buildSettingTile("New Bookings"),
              _buildSettingTile("Payments"),
              _buildSettingTile("Client Messages"),

              _buildSectionTitle("App Preferences"),
              _buildSettingTile("Theme"),
              _buildSettingTile("Language"),

              _buildSectionTitle("Support & Information"),
              _buildSettingTile("Help & Support"),
              _buildSettingTile("Privacy Policy"),
              _buildSettingTile("About Us"),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: _isLoggingOut ? null : () => _logout(context),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: Text(
                    _isLoggingOut ? "Logging Out..." : "Logout",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9415D),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
