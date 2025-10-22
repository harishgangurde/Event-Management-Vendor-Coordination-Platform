// lib/views/planner/bookings_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/config/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  // Helper widget to create the status chip
  Widget _buildStatusChip(String status) {
    Color color;
    String text = status;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        break;
      case 'confirmed':
        color = AppTheme.kSuccessColor; // Use success color from theme
        text = 'Confirmed';
        break;
      case 'declined':
        color = Colors.red;
        text = 'Declined';
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Handle user not logged in
    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(
          child: Text('Please log in to see your bookings.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.kBackgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppTheme.kBackgroundDark : AppTheme.backgroundLight,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query the 'bookings' collection
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('plannerId', isEqualTo: currentUserId) // Filter by current user
            .orderBy('requestedAt', descending: true) // Show newest first
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
                    Icon(Icons.calendar_month_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No Bookings Yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Your requested and confirmed bookings will appear here.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Data state
          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final doc = bookings[index];
              final data = doc.data() as Map<String, dynamic>;
              
              return Card(
                color: isDark ? AppTheme.kCardDarkColor : Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Name
                          Expanded(
                            child: Text(
                              data['eventName'] ?? 'Event',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Status Chip
                          _buildStatusChip(data['status'] ?? 'unknown'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Vendor Name
                      Text(
                        'Vendor: ${data['vendorName'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      
                      // Requested Date
                       Text(
                        'Requested: ${data['requestedAt'] != null ? (data['requestedAt'] as Timestamp).toDate().toLocal().toString().substring(0, 10) : 'N/A'}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}