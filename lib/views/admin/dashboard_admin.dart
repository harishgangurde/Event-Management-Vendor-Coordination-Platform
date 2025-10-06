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
            Image.asset('assets/images/logo.png', height: 35, width: 35),
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
                MaterialPageRoute(
                  builder: (context) => const AdminNotifications(),
                ),
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
                    ? 3
                    : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isDesktop ? 1.6 : 1.2,
                children: [
                  _buildStatCard(
                    icon: Icons.group,
                    title: "Planners",
                    value: "1,250",
                    change: "+15% last month",
                    color: Colors.greenAccent,
                  ),
                  _buildStatCard(
                    icon: Icons.storefront,
                    title: "Vendors",
                    value: "8,420",
                    change: "+22% last month",
                    color: Colors.greenAccent,
                  ),
                  _buildStatCard(
                    icon: Icons.analytics,
                    title: "Analytics",
                    value: "320",
                    change: "+8% last month",
                    color: Colors.greenAccent,
                  ),
                  _buildStatCard(
                    icon: Icons.payments,
                    title: "Transactions",
                    value: "\$1.2M",
                    change: "-3% last month",
                    color: Colors.redAccent,
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
                    subtitle: "3 new pending requests",
                    buttonText: "Approve/Reject",
                    buttonColor: primary,
                    icon: Icons.arrow_forward,
                  ),
                  _buildActionCard(
                    title: "Monitor Activity",
                    subtitle: "View platform usage logs",
                    buttonText: "View Logs",
                    buttonColor: secondary.withOpacity(0.2),
                    icon: Icons.monitor_heart_outlined,
                    textColor: secondary,
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
    required String value,
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
          children: [
            Row(
              children: [
                Icon(icon, color: secondary, size: 20),
                const SizedBox(width: 6),
                Text(title, style: TextStyle(color: textDark, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: textLight,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(change, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required IconData icon,
    Color? textColor,
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
                  Text(
                    subtitle,
                    style: TextStyle(color: textDark, fontSize: 13),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
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
