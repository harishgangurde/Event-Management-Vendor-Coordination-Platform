import 'package:eventtoria/views/planner/create_event.dart';
import 'package:eventtoria/views/planner/eventoria_ai_screen.dart';
import 'package:flutter/material.dart';
import 'payment_screen.dart';
import 'vendor_screen.dart';

// *** ASSUMPTION: Replace this with the actual import for your dashboard page ***
// import 'package:eventtoria/views/planner/dashboard_planner.dart';
// class DashboardPlannerPage extends StatelessWidget { ... }
// ****************************************************************************

// Define the colors used for consistency
const Color kPrimaryColor = Color(0xFF7F06F9);
const Color kCardDarkColor = Color(0xFF1E122D);
const Color kAccentPurple = Color(0xFFA564E9);
const Color kAccentRed = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);

// NOTE: I will use CreateEventPage as a temporary stand-in for DashboardPlannerPage
// You must replace CreateEventPage() with your actual Dashboard class name.
class DashboardPlannerPage extends StatelessWidget {
  const DashboardPlannerPage({super.key});
  @override
  Widget build(BuildContext context) {
    // This is a dummy page for the fix. Replace it with your actual Dashboard!
    return const CreateEventPage();
  }
}

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  Widget _buildAIIcon({double size = 28, double fontSize = 16}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [kAccentPurple, kPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          'AI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardDarkColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: kAccentPurple, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAISuggestionTile(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: kBackgroundDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildAIIcon(size: 24, fontSize: 12),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorRow(String name, String type, String cost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              type,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Text(
          cost,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kAccentPurple,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: kPrimaryColor,
          surface: kCardDarkColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              // *** THE CRITICAL CHANGE IS HERE ***
              // Use pushAndRemoveUntil to clear the stack and ensure the
              // DashboardPlannerPage is the new root.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  // ⚠️ REPLACE DashboardPlannerPage() with your ACTUAL dashboard widget
                  builder: (context) => const DashboardPlannerPage(),
                ),
                (route) => false, // This ensures the Login page is removed
              );
            },
          ),
          title: const Text(
            'Event Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          flexibleSpace: ClipRect(
            child: Container(
              color: kBackgroundDark.withOpacity(0.5),
              child: const SizedBox(height: kToolbarHeight + 25),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kBackgroundDark, kCardDarkColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 40,
                bottom: 120,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1️⃣ Event Summary Card
                  _buildDetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Varad's Birthday Bash",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          context,
                          icon: Icons.calendar_month,
                          title: 'Date & Time',
                          value: 'November 9, 2025, 7:00 PM',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          icon: Icons.location_on,
                          title: 'Venue',
                          value: 'The Grand Ballroom',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoRow(
                                context,
                                icon: Icons.people,
                                title: 'Guest Count',
                                value: '250',
                              ),
                            ),
                            Expanded(
                              child: _buildInfoRow(
                                context,
                                icon: Icons.account_balance_wallet,
                                title: 'Budget',
                                value: '₹500,000',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2️⃣ AI Suggestions Card
                  _buildDetailCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'AI Suggestions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EventtoriaAIScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(color: kAccentPurple),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildAISuggestionTile(
                          'Suggest decor based on \'Royal\' theme',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _buildAISuggestionTile(
                          'Find top-rated caterers in Mumbai',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3️⃣ Booked Vendors Card
                  _buildDetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Booked Vendors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateEventPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Add New',
                                style: TextStyle(color: kAccentPurple),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildVendorRow(
                          'Royal Catering Services',
                          'Catering',
                          '₹150,000',
                        ),
                        const SizedBox(height: 16),
                        _buildVendorRow(
                          'Enchanted Decors',
                          'Decoration',
                          '₹75,000',
                        ),
                        const SizedBox(height: 16),
                        _buildVendorRow(
                          'DJ Sonic Waves',
                          'Entertainment',
                          '₹50,000',
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Divider(color: Colors.white12, thickness: 1),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Total Spent',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '₹275,000',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4️⃣ Footer Buttons - Only 'Make Payment' remains
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: kBackgroundDark,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Make Payment Button (Now the only button)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentScreen(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: kAccentRed,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Make Payment',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
