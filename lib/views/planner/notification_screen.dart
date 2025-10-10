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
  // Notification data
  List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.flash_on,
      'iconColor': kAccentPurple,
      'title':
          "Vendor 'Catering Delights' has accepted your booking request for the wedding event.",
      'subtitle': 'Vendor Booking',
      'time': '2h',
      'read': false,
    },
    {
      'icon': Icons.chat,
      'iconColor': kPrimaryColor,
      'title':
          "You have a new message from 'Floral Fantasies' regarding your event's floral arrangements.",
      'subtitle': 'New Chat Message',
      'time': '4h',
      'read': false,
    },
    {
      'icon': Icons.check_circle,
      'iconColor': kAccentPurple,
      'title':
          "Reminder: Confirm final guest list for the wedding event by tomorrow.",
      'subtitle': 'Task Reminder',
      'time': '6h',
      'read': true,
    },
    {
      'icon': Icons.monetization_on,
      'iconColor': kPrimaryColor,
      'title':
          "You've exceeded the budget for 'Photography' by 10%. Review and adjust your spending.",
      'subtitle': 'Budget Alert',
      'time': '8h',
      'read': false,
    },
    {
      'icon': Icons.auto_awesome,
      'iconColor': kAccentPurple,
      'title':
          "Based on your event details, the AI suggests a 'Rustic Charm' theme. Explore now!",
      'subtitle': 'AI Theme Suggestion',
      'time': '10h',
      'read': true,
    },
    {
      'icon': Icons.info_outline,
      'iconColor': kPrimaryColor,
      'title':
          "Your event 'Summer Soiree' is approaching. Ensure all vendor contracts are finalized.",
      'subtitle': 'System Alert',
      'time': '12h',
      'read': true,
    },
  ];

  // Mark all notifications as read
  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['read'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  // Clear all notifications
  void clearAll() {
    setState(() {
      notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications cleared')),
    );
  }

  // Count unread notifications
  int get unreadCount {
    return notifications.where((n) => n['read'] == false).length;
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard',
                (route) => false,
              );
            },
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: markAllAsRead,
                    child: const Text(
                      'Mark all as read',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: clearAll,
                    child: const Text(
                      'Clear all',
                      style: TextStyle(color: kAccentPurple, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white.withOpacity(0.05),
                        thickness: 1,
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final isRead = notification['read'] as bool;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                (notification['iconColor'] as Color).withOpacity(0.1),
                            child: Icon(
                              notification['icon'] as IconData,
                              color: notification['iconColor'] as Color,
                              size: 20,
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              notification['title'] as String,
                              style: TextStyle(
                                color: isRead ? Colors.grey : Colors.white,
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            notification['subtitle'] as String,
                            style:
                                TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          trailing: Text(
                            notification['time'] as String,
                            style:
                                TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          ),
                          onTap: () {
                            // Mark this single notification as read
                            setState(() {
                              notification['read'] = true;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: _buildCustomBottomNavBar(context, 4),
      ),
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context, int selectedIndex) {
    final items = [
      {'icon': Icons.home, 'label': 'Home', 'index': 0},
      {'icon': Icons.event, 'label': 'Events', 'index': 1},
      {'icon': Icons.chat_bubble, 'label': 'Chat', 'index': 2},
      {'icon': Icons.person, 'label': 'Profile', 'index': 3},
      {'icon': Icons.notifications, 'label': 'Alerts', 'index': 4},
    ];

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index != selectedIndex) {
          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        }
      },
      backgroundColor: kBackgroundDark,
      selectedItemColor: kAccentPurple,
      unselectedItemColor: Colors.grey.shade700,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: items.map((item) {
        // Show badge for Notifications
        if (item['index'] == 4 && unreadCount > 0) {
          return BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(item['icon'] as IconData),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
            label: item['label'] as String,
          );
        } else {
          return BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            label: item['label'] as String,
          );
        }
      }).toList(),
    );
  }
}
