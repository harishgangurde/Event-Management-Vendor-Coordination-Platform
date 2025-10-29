// lib/views/planner/notification_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Define colors
const Color kPrimaryColor = Color(0xFF7F06F9);
const Color kAccentPurple = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the stream of notifications for the current user
  Stream<QuerySnapshot> _getNotificationStream() {
    if (currentUserId == null) {
      return Stream.empty(); // Return an empty stream if not logged in
    }
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId) // Filter for this user
        .orderBy('timestamp', descending: true) // Show newest first
        .snapshots();
  }

  // A map to associate notification types with icons/colors
  final Map<String, dynamic> _notificationTypes = {
    'booking_accepted': {
      'icon': Icons.flash_on,
      'color': kAccentPurple,
    },
    'new_message': {
      'icon': Icons.chat,
      'color': kPrimaryColor,
    },
    'task_reminder': {
      'icon': Icons.check_circle,
      'color': kAccentPurple,
    },
    'budget_alert': {
      'icon': Icons.monetization_on,
      'color': kPrimaryColor,
    },
    'ai_suggestion': {
      'icon': Icons.auto_awesome,
      'color': kAccentPurple,
    },
    'system_alert': {
      'icon': Icons.info_outline,
      'color': kPrimaryColor,
    },
    // Add more types as needed
  };

  // Mark all notifications as read
  void markAllAsRead(List<DocumentSnapshot> docs) async {
    if (currentUserId == null) return;

    WriteBatch batch = _firestore.batch();
    for (var doc in docs) {
      if (doc['read'] == false) {
        batch.update(doc.reference, {'read': true});
      }
    }
    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  // Clear all notifications
  void clearAll(List<DocumentSnapshot> docs) async {
    if (currentUserId == null) return;

    WriteBatch batch = _firestore.batch();
    for (var doc in docs) {
      batch.delete(doc.reference); // Deletes the notification
    }
    await batch.commit();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All notifications cleared')));
  }

  // Mark a single notification as read
  void _markOneAsRead(DocumentReference ref) {
    ref.update({'read': true});
  }

  // Helper to get time ago
  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final Duration diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Just pop to go back
            },
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _getNotificationStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Column(
                children: [
                  _buildActionsRow([]), // Pass empty list
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No notifications',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            }

            final notifications = snapshot.data!.docs;

            return Column(
              children: [
                _buildActionsRow(notifications),
                Expanded(
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white.withOpacity(0.05),
                      thickness: 1,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final doc = notifications[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final String type = data['type'] ?? 'system_alert';
                      final bool isRead = data['read'] ?? false;
                      final IconData icon =
                          _notificationTypes[type]?['icon'] ?? Icons.info;
                      final Color iconColor =
                          _notificationTypes[type]?['color'] ?? kPrimaryColor;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: iconColor.withOpacity(0.1),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            data['title'] ?? 'N/A',
                            style: TextStyle(
                              color: isRead ? Colors.grey : Colors.white,
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          data['subtitle'] ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Text(
                          _getTimeAgo(data['timestamp'] as Timestamp?),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          if (!isRead) {
                            _markOneAsRead(doc.reference);
                          }
                          // TODO: Add navigation logic based on notification type
                          // e.g., if (type == 'new_message') navigate to chat
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionsRow(List<DocumentSnapshot> notifications) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => markAllAsRead(notifications),
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => clearAll(notifications),
            child: const Text(
              'Clear all',
              style: TextStyle(color: kAccentPurple, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}