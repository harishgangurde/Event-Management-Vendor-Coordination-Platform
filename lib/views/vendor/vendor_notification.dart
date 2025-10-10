import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_dashboard.dart';

class VendorNotifications extends StatefulWidget {
  const VendorNotifications({super.key});

  @override
  State<VendorNotifications> createState() => _VendorNotificationsState();
}

class _VendorNotificationsState extends State<VendorNotifications> {
  List<Map<String, dynamic>> notifications = [
    {
      "icon": Icons.event_available_rounded,
      "title":
          "Vendor ‘Catering Delights’ has accepted your booking request for the wedding event.",
      "subtitle": "Vendor Booking",
      "time": "2h",
      "read": false
    },
    {
      "icon": Icons.chat_bubble_outline_rounded,
      "title":
          "You have a new message from ‘Floral Fantasies’ regarding your event’s floral arrangements.",
      "subtitle": "New Chat Message",
      "time": "4h",
      "read": false
    },
    {
      "icon": Icons.check_circle_outline_rounded,
      "title":
          "Reminder: Confirm final guest list for the wedding event by tomorrow.",
      "subtitle": "Task Reminder",
      "time": "6h",
      "read": true
    },
    {
      "icon": Icons.attach_money_rounded,
      "title":
          "You’ve exceeded the budget for ‘Photography’ by 10%. Review and adjust your spending.",
      "subtitle": "Budget Alert",
      "time": "8h",
      "read": true
    },
    {
      "icon": Icons.lightbulb_outline_rounded,
      "title":
          "Based on your event details, the AI suggests a ‘Rustic Charm’ theme. Explore now!",
      "subtitle": "AI Theme Suggestion",
      "time": "10h",
      "read": false
    },
    {
      "icon": Icons.warning_amber_rounded,
      "title":
          "Your event ‘Summer Soiree’ is approaching. Ensure all vendor contracts are finalized.",
      "subtitle": "System Alert",
      "time": "12h",
      "read": true
    },
  ];

  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n["read"] = true;
      }
    });
  }

  void clearAll() {
    setState(() {
      notifications.clear();
    });
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VendorDashboard()),
            );
          },
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Top Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: markAllAsRead,
                  child: Text(
                    "Mark all as read",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF9B62FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: clearAll,
                  child: Text(
                    "Clear all",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Notifications List
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Text(
                        "No notifications",
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final n = notifications[index];
                        return _notificationTile(
                          n["icon"],
                          n["title"],
                          n["subtitle"],
                          n["time"],
                          n["read"],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationTile(IconData icon, String title, String subtitle,
      String time, bool isRead) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B1C4C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Icon(icon, color: const Color(0xFF9B62FF), size: 24),
              if (!isRead)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.8),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: isRead ? Colors.white70 : Colors.white,
                    fontSize: 13.5,
                    fontWeight:
                        isRead ? FontWeight.w400 : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
