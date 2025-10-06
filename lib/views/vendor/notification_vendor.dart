import 'package:eventtoria/config/app_theme.dart';
import 'package:flutter/material.dart';

class VendorNotificationScreen extends StatelessWidget {
  const VendorNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'icon': Icons.new_releases,
        'title': "New booking request for 'Grand Wedding Reception'.",
        'time': '1h',
        'read': false,
      },
      {
        'icon': Icons.chat,
        'title': "New message from 'Rugwed Khairnar'.",
        'time': '3h',
        'read': false,
      },
      {
        'icon': Icons.payment,
        'title': "Payment of ₹50,000 received for 'Annual Tech Conference'.",
        'time': '1d',
        'read': true,
      },
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isRead = notification['read'] as bool;

        return ListTile(
          leading: Icon(notification['icon'] as IconData,
              color: isRead ? Colors.grey : AppTheme.kAccentPurple),
          title: Text(
            notification['title'] as String,
            style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                color: isRead ? Colors.white70 : Colors.white),
          ),
          trailing: Text(notification['time'] as String,
              style: const TextStyle(color: Colors.grey)),
          onTap: () {},
        );
      },
    );
  }
}