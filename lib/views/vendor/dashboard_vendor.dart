import 'package:eventtoria/config/app_theme.dart';
import 'package:eventtoria/views/vendor/booking_vendor.dart';
import 'package:eventtoria/views/vendor/chat_vendor.dart';
import 'package:eventtoria/views/vendor/notification_vendor.dart';
import 'package:eventtoria/views/vendor/profile_vendor.dart';
import 'package:eventtoria/views/vendor/setting_vendor.dart';
import 'package:flutter/material.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    VendorHomeScreen(),
    BookingRequestsScreen(),
    VendorChatScreen(),
    VendorProfileScreen(),
    VendorNotificationScreen(),
  ];

  static const List<String> _titles = <String>[
    'Vendor Dashboard',
    'Booking Requests',
    'Chat',
    'Profile',
    'Notifications'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: _selectedIndex != 0
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                  )
                : null,
            title: _selectedIndex == 0
                ? Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.kAccentPurple,
                              AppTheme.kPrimaryColor
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('AI',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Vendor Dashboard',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                : Text(_titles[_selectedIndex],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VendorSettingsScreen()),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event_note), label: 'Bookings'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'Notify'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppTheme.kAccentPurple,
            unselectedItemColor: Colors.grey.shade700,
            backgroundColor: AppTheme.kBackgroundDark,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Upcoming Events'),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _eventCard('assets/images/eventwedding.jpg',
                    'Grand Wedding Reception', 'October 15, 2024'),
                _eventCard('assets/images/birthday_event.jpg',
                    "Sarah's 30th Birthday", 'November 20, 2024'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Quick Stats'),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            children: [
              _statCard('Total Earnings', '₹1,25,000',
                  Icons.account_balance_wallet),
              _statCard('Completed Events', '12', Icons.check_circle),
              _statCard('Pending Bookings', '3', Icons.pending_actions),
              _statCard('Reviews', '4.8/5', Icons.star),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Activity'),
          const SizedBox(height: 12),
          _activityTile('Payment of ₹25,000 received', 'from Rugwed Khairnar',
              Icons.payment, Colors.green),
          _activityTile('New Booking Request', "for 'Annual Tech Conference'",
              Icons.new_releases, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white));
  }

  Widget _eventCard(String imagePath, String title, String date) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white)),
          Text(date,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.kCardDarkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.kAccentPurple, size: 28),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _activityTile(
      String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.kCardDarkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}