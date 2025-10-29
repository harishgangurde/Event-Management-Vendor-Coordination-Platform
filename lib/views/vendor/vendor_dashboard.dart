// lib/views/vendor/vendor_dashboard.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_booking.dart';
import 'vendor_profile.dart';
// 💡 --- IMPORT THE NEW CHAT LIST SCREEN ---
import 'vendor_chat_list.dart'; 
import 'vendor_notification.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int _selectedIndex = 0;
  final String? currentVendorId = FirebaseAuth.instance.currentUser?.uid;
  String _vendorName = "Vendor"; // Default name

  @override
  void initState() {
    super.initState();
    _loadVendorName();
  }

  Future<void> _loadVendorName() async {
    if (currentVendorId == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentVendorId)
          .get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          _vendorName = doc.data()!['name'] ?? 'Vendor';
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _onItemTapped(int index) {
    // 💡 --- MODIFIED LOGIC ---
    // Don't change state if tapping the same index
    if (_selectedIndex == index) return;

    // Handle navigation for tabs that are separate pages
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VendorBooking()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VendorProfile()),
      );
    } else if (index == 3) {
      // 💡 --- UPDATED: Navigate to the new chat list screen ---
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VendorChatListScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VendorNotifications()),
      );
    } else {
      // Only update state for index 0 (Home)
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 💡 --- MODIFIED: The body is now a list of widgets ---
    // Only 'Home' (index 0) is part of this screen.
    // Other indices are handled by _onItemTapped navigation.
    // This setup assumes 'Home' is the main screen.
    final List<Widget> _pages = [
      _buildHomeScreen(), // Index 0
      Container(), // Index 1 (Bookings) - Handled by Nav
      Container(), // Index 2 (Profile) - Handled by Nav
      Container(), // Index 3 (Chat) - Handled by Nav
      Container(), // Index 4 (Alerts) - Handled by Nav
    ];
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      // 💡 --- MODIFIED: Body now uses the selected index ---
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A102E),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF9B62FF),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Alerts'),
        ],
      ),
    );
  }

  // 💡 --- NEW: Extracted Home screen content into its own method ---
  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Eventtoria',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Welcome back, $_vendorName', // Use loaded name
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 25),

          // Upcoming Bookings
          Text(
            'Upcoming Bookings',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          _buildUpcomingBookings(), // Firebase-powered widget

          const SizedBox(height: 30),

          // Revenue Statistics
          Text(
            'Revenue Statistics',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          _buildRevenueStats(), // Firebase-powered widget

          const SizedBox(height: 30),

          // New Requests
          Text(
            'New Requests',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          _buildNewRequests(), // Firebase-powered widget

          const SizedBox(height: 30),

          // AI Suggestions (can remain static or be fetched)
          Text(
            'AI Suggestions',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          _aiCard(
            title: 'Adjust Pricing for Off-Peak Dates',
            subtitle: 'Increase your booking rate',
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 10),
          _aiCard(
            title: 'Connect with Clients Seeking Similar Events',
            subtitle: 'Match with potential clients',
            icon: Icons.people_alt_rounded,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Firebase-powered Helper Widgets ---

  Widget _buildUpcomingBookings() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('bookings')
          .where('vendorId', isEqualTo: currentVendorId)
          .where('status', isEqualTo: 'accepted')
          // TODO: Add a date filter for 'upcoming'
          // .where('eventDate', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('requestedAt') // Replace with 'eventDate' when available
          .limit(2)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text('No upcoming bookings.', style: TextStyle(color: Colors.white54));
        }

        final bookings = snapshot.data!.docs;
        return Row(
          children: [
            Expanded(
              child: _bookingCard(
                // TODO: Fetch event image from 'events' collection using eventId
                imageUrl:
                    'https://images.unsplash.com/photo-1556745753-b2904692b3cd',
                title: bookings[0]['eventName'] ?? 'Event',
                date: 'N/A', // TODO: Get from event data
              ),
            ),
            if (bookings.length > 1) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _bookingCard(
                  imageUrl:
                      'https://cdn.prod.website-files.com/6331e19fdfcbe01f4c12b610/66baffd5ee7f9fa6efed4473_640f82ab5d300300a891d92a_viva.jpeg',
                  title: bookings[1]['eventName'] ?? 'Event',
                  date: 'N/A', // TODO: Get from event data
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildRevenueStats() {
    // This is complex. A real implementation would use a
    // Firebase Function to calculate and store these stats in a
    // separate 'vendor_stats' document for easy fetching.
    // For now, we'll keep the static data.
    return Row(
      children: [
        Expanded(
          child: _statCard(
            label: 'Total Revenue',
            value: '₹9,960,000',
            percent: '+15%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            label: 'Avg. Booking Value',
            value: '₹830,000',
            percent: '+5%',
          ),
        ),
      ],
    );
  }

  Widget _buildNewRequests() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('vendorId', isEqualTo: currentVendorId)
          .where('status', isEqualTo: 'pending')
          .orderBy('requestedAt', descending: true)
          .limit(2)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text('No new requests.', style: TextStyle(color: Colors.white54));
        }

        final requests = snapshot.data!.docs;
        return Column(
          children: requests.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _requestTile(
                data['plannerName'] ?? 'N/A',
                data['eventName'] ?? 'Event',
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // --- Helper Widgets (UI) ---
  Widget _bookingCard({
    required String imageUrl,
    required String title,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B1C4C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
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

  Widget _statCard({
    required String label,
    required String value,
    required String percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B217A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            percent,
            style: GoogleFonts.poppins(
              color: Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestTile(String name, String type) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B1C4C),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  type,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget _aiCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B217A),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
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
