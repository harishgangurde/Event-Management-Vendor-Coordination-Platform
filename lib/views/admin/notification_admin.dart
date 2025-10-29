// lib/views/admin/notification_admin.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminNotifications extends StatelessWidget {
  // --- *** THIS IS THE FIX *** ---
  // Removed 'const' from the constructor
  AdminNotifications({super.key});

  final Color backgroundDark = const Color(0xFF161022);
  final Color cardDark = const Color(0xFF1F1A30);
  final Color primary = const Color(0xFF5B13EC);
  final Color textLight = const Color(0xFFE5E7EB);
  final Color textDark = const Color(0xFF9CA3AF);

  // Helper to get time ago
  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final Duration diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // A map to associate notification types with icons/colors
  // This map is the reason the constructor can't be const
  final Map<String, dynamic> _notificationTypes = {
    'new_vendor': {
      'icon': Icons.person_add,
      'color': Colors.blueAccent,
    },
    'new_planner': {
      'icon': Icons.group_add,
      'color': Colors.greenAccent,
    },
    'dispute': {
      'icon': Icons.security,
      'color': Colors.redAccent,
    },
    'system': {
      'icon': Icons.monitor,
      'color': Colors.orangeAccent,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: true, // back button
        iconTheme: IconThemeData(color: textLight),
        title: Text(
          "Notifications",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textLight,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Create an 'admin_notifications' collection in Firestore
        stream: FirebaseFirestore.instance
            .collection('admin_notifications')
            .orderBy('timestamp', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: textLight)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No notifications found.',
                style: TextStyle(color: textDark),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;

              final String type = data['type'] ?? 'system';
              final String title = data['title'] ?? 'N/A';
              final String description =
                  data['description'] ?? 'No description.';
              final Timestamp? time = data['timestamp'];
              final bool isRead = data['read'] ?? false;

              final IconData icon =
                  _notificationTypes[type]?['icon'] ?? Icons.info;
              final Color iconColor =
                  _notificationTypes[type]?['color'] ?? primary;

              return _buildNotificationCard(
                title: title,
                description: description,
                time: _getTimeAgo(time),
                icon: icon,
                iconColor: iconColor,
                isRead: isRead,
                onTap: () {
                  // Mark as read when tapped
                  if (!isRead) {
                    doc.reference.update({'read': true});
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: isRead ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(14),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: textLight,
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.plusJakartaSans(
                  color: textDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  color: textDark.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}