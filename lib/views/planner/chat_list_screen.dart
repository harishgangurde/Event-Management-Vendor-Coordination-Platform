// lib/views/planner/chat_list_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/config/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// 💡 IMPORT
// Make sure you have renamed your original 'chat_screen.dart' to 'chat_detail_screen.dart'
// and that it accepts 'vendorId' and 'vendorName' parameters.
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Handle user not logged in
    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: const Center(child: Text('Please log in to see your chats.')),
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.kBackgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark
            ? AppTheme.kBackgroundDark
            : AppTheme.backgroundLight,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 💡 Query for confirmed bookings to enable chat
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('plannerId', isEqualTo: currentUserId)
            // ✅ --- FIX: Used named argument 'isEqualTo' ---
            .where(
              'status',
              isEqualTo: 'confirmed',
            ) // Only show chats for confirmed bookings
            .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Active Chats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Once a vendor confirms your booking, you can start a chat with them here.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // 💡 De-duplicate vendors.
          // A planner might book the same vendor for multiple events,
          // but we only want to show one chat channel per vendor.
          final Map<String, Map<String, dynamic>> vendors = {};
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final vendorId = data['vendorId'];
            if (vendorId != null && !vendors.containsKey(vendorId)) {
              // Add the vendor to the map
              vendors[vendorId] = data;
            }
          }

          // Convert the map's values back to a list
          final vendorList = vendors.values.toList();

          // Data state
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vendorList.length,
            itemBuilder: (context, index) {
              final data = vendorList[index];
              final String vendorName = data['vendorName'] ?? 'Vendor';
              final String vendorId = data['vendorId'];
              // TODO: You can fetch the vendor's 'profileImageUrl' from the 'users' table using vendorId

              return Card(
                color: isDark ? AppTheme.kCardDarkColor : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.kAccentPurple,
                    child: Icon(Icons.person, color: Colors.white),
                    // You would replace this with:
                    // backgroundImage: NetworkImage(vendorData['profileImageUrl']),
                  ),
                  title: Text(
                    vendorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Tap to view chat', // You could show the last message here
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ✅ --- FIX: Renamed class to ChatDetailScreen and added const ---
                        builder: (context) => ChatDetailScreen(
                          vendorId: vendorId,
                          vendorName: vendorName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
