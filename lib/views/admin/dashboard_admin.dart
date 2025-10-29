// lib/views/admin/dashboard_admin.dart

import 'package:async/async.dart'; // Make sure you've added this: flutter pub add async
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/views/admin/analytics_admin.dart';
import 'package:eventtoria/views/admin/setting_admin.dart';
import 'package:eventtoria/views/admin/notification_admin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'users_admin.dart';
import 'vendor_approval.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color backgroundDark = const Color(0xFF161022);
  final Color cardDark = const Color(0xFF1F1A30);
  final Color primary = const Color(0xFF5B13EC);
  final Color secondary = const Color(0xFFA855F7);
  final Color textLight = const Color(0xFFE5E7EB);
  final Color textDark = const Color(0xFF9CA3AF);

  int _selectedIndex = 0;

  // Helper to create a stream for a collection count
  Stream<int> _getCollectionCount(
    String collection,
    String? field,
    String? isEqualTo,
  ) {
    Query query = FirebaseFirestore.instance.collection(collection);
    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    return query.snapshots().map((snapshot) => snapshot.size);
  }

  // Helper for pending vendors
  Stream<int> _getPendingVendorCount() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Vendor')
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // We need to combine planner and vendor counts.
  // Using AsyncMemoizer to avoid re-fetching on rebuild.
  final AsyncMemoizer<Stream<int>> _memoizer = AsyncMemoizer<Stream<int>>();

  // --- *** THIS IS THE FIX *** ---
  // Removed 'async' from the function signature
  Future<Stream<int>> _getTotalUserCount() {
    return _memoizer.runOnce(() async {
      Stream<int> plannerStream = _getCollectionCount(
        'users',
        'role',
        'Planner',
      );
      Stream<int> vendorStream = _getCollectionCount('users', 'role', 'Vendor');

      // Combine the two streams
      return StreamZip([plannerStream, vendorStream]).map((counts) {
        return counts[0] + counts[1]; // planners + vendors
      });
    });
  }

  late final List<Widget> _pages = [
    _buildDashboardContent(),
    const AdminUsers(),
    const VendorApproval(),
    const AdminAnalytics(),
    const AdminSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Assuming you have this logo in your assets
            // Image.asset('assets/images/logo.png', height: 35, width: 35),
            const Icon(Icons.shield_moon, color: Colors.white, size: 35),
            const SizedBox(width: 10),
            Text(
              'Admin Dashboard',
              style: GoogleFonts.plusJakartaSans(
                fontSize: isTablet || isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: textLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminNotifications()),
              );
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundDark.withOpacity(0.9),
        selectedItemColor: primary,
        unselectedItemColor: textDark,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: "Vendors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  // ---------- Dashboard Content ----------
  Widget _buildDashboardContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = MediaQuery.of(context).size.width;
        final bool isTablet = width >= 600 && width < 1000;
        final bool isDesktop = width >= 1000;

        return SingleChildScrollView(
          padding: EdgeInsets.all(
            isDesktop
                ? 32
                : isTablet
                ? 24
                : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop
                    ? 4
                    : isTablet
                    ? 2 // Better for tablets
                    : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 1.6 : 1.2,
                children: [
                  // Planners Card
                  _buildStatCard(
                    icon: Icons.group,
                    title: "Planners",
                    stream: _getCollectionCount('users', 'role', 'Planner'),
                    change: "Total Planners",
                    color: Colors.transparent, // No change color
                  ),
                  // Vendors Card
                  _buildStatCard(
                    icon: Icons.storefront,
                    title: "Vendors",
                    stream: _getCollectionCount('users', 'role', 'Vendor'),
                    change: "Total Vendors",
                    color: Colors.transparent,
                  ),
                  // Bookings Card
                  _buildStatCard(
                    icon: Icons.calendar_month,
                    title: "Bookings",
                    stream: _getCollectionCount('bookings', null, null),
                    change: "Total Bookings",
                    color: Colors.transparent,
                  ),
                  // Total Users Card (Example of more complex stream)
                  _buildStatCard(
                    icon: Icons.analytics,
                    title: "Total Users",
                    // This uses the combined stream
                    futureStream: _getTotalUserCount(),
                    change: "Planners + Vendors",
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Actions Section
              Text(
                "Actions",
                style: GoogleFonts.plusJakartaSans(
                  color: textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet || isDesktop ? 20 : 18,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildActionCard(
                    title: "Vendor Registrations",
                    stream: _getPendingVendorCount(),
                    buttonText: "Approve/Reject",
                    buttonColor: primary,
                    icon: Icons.arrow_forward,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VendorApproval(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    title: "Manage All Users",
                    subtitle: "View, edit, or remove users",
                    buttonText: "View Users",
                    buttonColor: secondary.withOpacity(0.2),
                    icon: Icons.people,
                    textColor: secondary,
                    onTap: () => _onItemTapped(1), // Go to Users tab
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- Reusable Widgets ----------
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    Stream<int>? stream,
    Future<Stream<int>>? futureStream, // For the combined stream
    required String change,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: secondary, size: 20),
                const SizedBox(width: 6),
                Text(title, style: TextStyle(color: textDark, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            // Use StreamBuilder to display the dynamic count
            if (stream != null)
              StreamBuilder<int>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Text(
                      "0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      color: textLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              )
            else if (futureStream != null)
              FutureBuilder<Stream<int>>(
                future: futureStream,
                builder: (context, futureSnapshot) {
                  if (!futureSnapshot.hasData) {
                    return const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  return StreamBuilder<int>(
                    stream: futureSnapshot.data,
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      if (!streamSnapshot.hasData) {
                        return const Text(
                          "0",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text(
                        streamSnapshot.data.toString(),
                        style: TextStyle(
                          color: textLight,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  );
                },
              ),
            Text(
              change,
              style: TextStyle(
                color: color == Colors.transparent ? textDark : color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    String? subtitle,
    Stream<int>? stream, // For dynamic subtitle
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 400, // Max width for wrap
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  // Use StreamBuilder for dynamic subtitle
                  if (stream != null)
                    StreamBuilder<int>(
                      stream: stream,
                      builder: (context, snapshot) {
                        String subText = "0 new pending requests";
                        if (snapshot.hasData) {
                          subText = "${snapshot.data} new pending requests";
                        }
                        return Text(
                          subText,
                          style: TextStyle(color: textDark, fontSize: 13),
                        );
                      },
                    )
                  else if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(color: textDark, fontSize: 13),
                    ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: textColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
              ),
              icon: Icon(icon, size: 18),
              label: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
