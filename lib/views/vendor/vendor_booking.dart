// lib/views/vendor/vendor_booking.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorBooking extends StatefulWidget {
  const VendorBooking({super.key});

  @override
  State<VendorBooking> createState() => _VendorBookingState();
}

class _VendorBookingState extends State<VendorBooking> {
  final String? currentVendorId = FirebaseAuth.instance.currentUser?.uid;

  // Update status in Firebase
  Future<void> _updateStatus(String bookingId, String eventName, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': newStatus.toLowerCase()}); // e.g., 'accepted' or 'declined'

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking "$eventName" marked as $newStatus',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor:
              newStatus == 'Accepted' ? Colors.green : Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentVendorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Requests')),
        body: const Center(child: Text('Please log in to see requests.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A102E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Requests',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Fetch bookings for this vendor that are still pending
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('vendorId', isEqualTo: currentVendorId)
            // .where('status', isEqualTo: 'pending') // You can filter for just pending
            .orderBy('requestedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No booking requests found.',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final doc = bookings[index];
              final data = doc.data() as Map<String, dynamic>;
              final String status = data['status'] ?? 'pending';

              return _buildBookingCard(
                bookingId: doc.id, // Pass the document ID
                data: data,
                status: status,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard({
    required String bookingId,
    required Map<String, dynamic> data,
    required String status,
  }) {
    final String eventName = data['eventName'] ?? 'N/A';
    
    // Capitalize first letter of status for display
    final String displayStatus = status[0].toUpperCase() + status.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2B1C4C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event title
          Center(
            child: Column(
              children: [
                Text(
                  'Event',
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  eventName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Planner
          _infoRow('Planner', data['plannerName'] ?? 'N/A'),
          const SizedBox(height: 16),

          // Quoted Price (Assuming you add this field)
          _infoRow(
            'Quoted Price',
            data['price']?.toString() ?? 'N/A', // Example: '₹${data['price']}'
            valueColor: const Color(0xFFB184FF),
            valueWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),

          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: status == 'pending'
                      ? const Color(0xFF3B217A)
                      : status == 'accepted'
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      displayStatus,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Accept / Decline buttons
          if (status == 'pending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _updateStatus(bookingId, eventName, 'Declined'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B217A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Decline',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _updateStatus(bookingId, eventName, 'Accepted'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9B62FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Accept',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {Color valueColor = Colors.white70,
      FontWeight valueWeight = FontWeight.w500}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: valueColor,
            fontSize: 15,
            fontWeight: valueWeight,
          ),
        ),
      ],
    );
  }
}