import 'package:eventtoria/views/planner/planner_dashboard.dart';
import 'package:flutter/material.dart';

class VendorsScreen extends StatelessWidget {
  final String eventName;

  const VendorsScreen({super.key, required this.eventName});

  // Tailwind-like custom colors
  static const Color primaryColor = Color(0xFF7F06F9);
  static const Color backgroundLight = Color(0xFFF7F5F8);
  static const Color backgroundDark = Color(0xFF190F23);

  // 💡 Asset paths for vendor images (Using generic placeholders for mock data)
  static const String vendorImage1 = 'assets/images/delicious.png';
  static const String vendorImage2 = 'assets/images/moments.png';
  static const String vendorImage3 = 'assets/images/elegant.png';
  static const String vendorImage4 = 'assets/images/floral.png';

  void _sendBookingRequest(BuildContext context, String vendorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking request sent for "$vendorName" in event "$eventName"',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Helper function to handle consistent navigation back to the Dashboard
  void _navigateBackToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPlanner()),
      (route) => false, // Clears the entire stack
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final vendors = [
      {
        'name': 'Delicious Delights',
        'type': 'Catering',
        'rating': 4.9,
        'reviews': 120,
        'image': vendorImage1,
      },
      {
        'name': 'Captured Moments',
        'type': 'Photography',
        'rating': 5.0,
        'reviews': 85,
        'image': vendorImage2,
      },
      {
        'name': 'Elegant Spaces',
        'type': 'Venue',
        'rating': 4.8,
        'reviews': 210,
        'image': vendorImage3,
      },
      {
        'name': 'Floral Fantasies',
        'type': 'Decor',
        'rating': 4.9,
        'reviews': 98,
        'image': vendorImage4,
      },
    ];

    return WillPopScope(
      // ✅ FIX 1: Apply the requested pushAndRemoveUntil logic to the back gesture/button
      onWillPop: () async {
        _navigateBackToDashboard(context);
        return false; // Prevents the default pop action
      },
      child: Scaffold(
        backgroundColor: isDark ? backgroundDark : backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? backgroundDark.withOpacity(0.8)
              : backgroundLight.withOpacity(0.8),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Vendors',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // ✅ FIX 2: Apply the requested pushAndRemoveUntil logic to the leading icon
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              _navigateBackToDashboard(context);
            },
          ),
        ),
        body: Column(
          children: [
            // ... (Search Field and Filters Scrollable remain unchanged) ...

            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search vendors',
                  filled: true,
                  fillColor: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),

            // Filters Scrollable
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  filterButton('Service Type', Icons.expand_more, isDark),
                  const SizedBox(width: 8),
                  filterButton('Availability', Icons.expand_more, isDark),
                  const SizedBox(width: 8),
                  filterButton('Rating', Icons.expand_more, isDark),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Vendor List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return vendorCard(vendor, isDark, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String label, IconData icon, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: VendorsScreen.primaryColor.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 16, color: VendorsScreen.primaryColor),
        label: Text(
          label,
          style: TextStyle(color: VendorsScreen.primaryColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget vendorCard(
    Map<String, dynamic> vendor,
    bool isDark,
    BuildContext context,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  // Image.asset is correctly implemented here
                  child: Image.asset(
                    vendor['image']!, // Get asset path from the vendor map
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80,
                      width: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor['name']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        vendor['type']!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vendor['rating']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${vendor['reviews']} reviews)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: VendorsScreen.primaryColor,
                      side: const BorderSide(color: VendorsScreen.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text('View Profile'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _sendBookingRequest(context, vendor['name']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VendorsScreen.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
