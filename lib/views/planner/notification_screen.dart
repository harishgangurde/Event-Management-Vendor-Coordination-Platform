import 'package:flutter/material.dart';

// Define the colors used in the notification screen (similar to event_details_page)
const Color kPrimaryColor = Color(0xFF7F06F9);
const Color kAccentPurple = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of mock notifications based on the image content
    final List<Map<String, dynamic>> notifications = [
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
          automaticallyImplyLeading: false, // Hide back button as per image
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          // Removed the actions list containing the settings button
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Implement mark all as read logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All marked as read')),
                      );
                    },
                    child: const Text(
                      'Mark all as read',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement clear all logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cleared all notifications'),
                        ),
                      );
                    },
                    child: const Text(
                      'Clear all',
                      style: TextStyle(color: kAccentPurple, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
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
                  final notification = notifications[index];
                  final isRead = notification['read'] as bool;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: notification['iconColor'].withOpacity(
                        0.1,
                      ),
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
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Text(
                      notification['time'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      // Handle notification tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildCustomBottomNavBar(
          context,
          4,
        ), // Selected index 4 (Notify/Alerts)
      ),
    );
  }

  Widget _buildCustomBottomNavBar(BuildContext context, int selectedIndex) {
    // This replicates the appearance of the DashboardPlanner's NavigationBar
    // to maintain consistency, but is styled for the dark screen.
    // Note: The Alerts icon is kept here as it defines the overall navigation bar structure.
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
        // Implement navigation logic here if needed, or simply pop if it's not the current screen.
        if (index != selectedIndex) {
          Navigator.pop(context); // Assuming this is pushed from Dashboard
        }
      },
      backgroundColor: kBackgroundDark,
      selectedItemColor: kAccentPurple,
      unselectedItemColor: Colors.grey.shade700,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item['icon'] as IconData),
          label: item['label'] as String,
        );
      }).toList(),
    );
  }
}
