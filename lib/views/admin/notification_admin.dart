import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminNotifications extends StatelessWidget {
  const AdminNotifications({super.key});

  final Color backgroundDark = const Color(0xFF161022);
  final Color cardDark = const Color(0xFF1F1A30);
  final Color primary = const Color(0xFF5B13EC);
  final Color textLight = const Color(0xFFE5E7EB);
  final Color textDark = const Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: true, // back button visible
        title: Text(
          "Notifications",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textLight,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            title: "Vendor Registration",
            description: "New vendor 'Catering Delights' has registered.",
            time: "2h ago",
            icon: Icons.person_add,
          ),
          _buildNotificationCard(
            title: "Dispute Alert",
            description: "A dispute has been raised regarding order #12345.",
            time: "4h ago",
            icon: Icons.security,
          ),
          _buildNotificationCard(
            title: "Performance Warning",
            description:
                "System performance is slightly degraded. Check server logs.",
            time: "6h ago",
            icon: Icons.monitor,
          ),
          _buildNotificationCard(
            title: "User Report",
            description: "User 'Emily Carter' has reported a violation.",
            time: "8h ago",
            icon: Icons.flag,
          ),
          _buildNotificationCard(
            title: "Payment Issue",
            description: "Payment processing for order #67890 failed.",
            time: "10h ago",
            icon: Icons.credit_card_off,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: primary.withOpacity(0.2),
            child: Icon(icon, color: primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
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
        ],
      ),
    );
  }
}
