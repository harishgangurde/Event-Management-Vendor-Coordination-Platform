// lib/views/vendor/vendor_chat_list.dart
// --- UPDATED FILE ---
// This screen allows vendors to see a list of all planners
// they have confirmed bookings with.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/config/app_theme.dart';
import 'package:eventtoria/views/vendor/vendor_chat.dart'; // Navigates to the functional vendor chat
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorChatListScreen extends StatefulWidget {
  const VendorChatListScreen({super.key});

  @override
  State<VendorChatListScreen> createState() => _VendorChatListScreenState();
}

class _VendorChatListScreenState extends State<VendorChatListScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Handle user not logged in
    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Chats')),
        body: const Center(child: Text('Please log in to see your chats.')),
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.kBackgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'My Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark
            ? AppTheme.kBackgroundDark
            : AppTheme.backgroundLight,
        elevation: 0,
        centerTitle: true,
        // 💡 --- FIX: Removed 'automaticallyImplyLeading: false' ---
        // This screen should have a back button.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query for confirmed bookings for THIS VENDOR
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('vendorId', isEqualTo: currentUserId)
            .where(
              'status',
              // 💡 --- FIX: Changed from 'confirmed' to 'accepted' ---
              // This must match what 'vendor_booking.dart' saves.
              isEqualTo: 'accepted',
            )
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
                      'Once you accept a planner\'s booking, you can start a chat with them here.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // De-duplicate planners.
          // A vendor might be booked by the same planner for multiple events,
          // but we only want one chat channel per planner.
          final Map<String, Map<String, dynamic>> planners = {};
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final plannerId = data['plannerId'];
            if (plannerId != null && !planners.containsKey(plannerId)) {
              // Add the planner to the map
              planners[plannerId] = data;
            }
          }

          // Convert the map's values back to a list
          final plannerList = planners.values.toList();

          // Data state
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plannerList.length,
            itemBuilder: (context, index) {
              final data = plannerList[index];
              final String plannerName = data['plannerName'] ?? 'Planner';
              final String plannerId = data['plannerId'];
              // TODO: You can fetch the planner's 'profileImageUrl' from the 'users' table using plannerId

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
                  ),
                  title: Text(
                    plannerName,
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
                        // Navigate to the EXISTING functional vendor chat screen
                        builder: (context) => VendorChat(
                          plannerId: plannerId,
                          plannerName: plannerName,
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
