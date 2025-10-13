import 'package:flutter/material.dart';

class VendorsScreen extends StatelessWidget {
  final String eventName;

  const VendorsScreen({super.key, required this.eventName});

  // Tailwind-like custom colors
  static const Color primaryColor = Color(0xFF7F06F9);
  static const Color backgroundLight = Color(0xFFF7F5F8);
  static const Color backgroundDark = Color(0xFF190F23);

  void _sendBookingRequest(BuildContext context, String vendorName) {
    // Example: show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking request sent for "$vendorName" in event "$eventName"',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Integrate Firebase or backend logic to save booking request
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
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuClCKBDbMKgv0-WwT69JGz0xGYUbNej-n1oVqHyoIWjRS_UJ2ybWJiZAtOOPvEMTtqZsdmYnC5lucRKYmOPuq2WLpCUwvAZj8z_UVdBWG9qcoZAM55Hi784D0ksfG5z0rfhDsFcYa_AgFowM_gUS5kcX7aHgeWUW7-pRFUyMjCZUZThtSFSVUD4x7n1X13qqdWJUzpgMFu15P0SoBtN7mEw-TXziWsm6fOTo19ndtbYumX1zWWgNgbfLRekquBs3YoykSExQKKa2w',
      },
      {
        'name': 'Captured Moments',
        'type': 'Photography',
        'rating': 5.0,
        'reviews': 85,
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBCghMybtaNZpcX6GzRuYX1kBXGYKWGOeiYlsShZUrN1hhXoEJi_ZlDtfpUMI9F1j2xQu_AnNcD9n4I8N53hJ4Keq-BY7HEppIHO0M9vnngwJo32-rI36TuR_b0ry4elr3_HOvlS4Hrsbtf_ffZzoqGewiMilMVhn0yDRu7YW1E-YECjnnjqJ86G-JXwHu72GVs336MeST_do7J1XZpxL0aGO9VFEW1fi3u5G4Mkv86uAjvWZa4_3miqxOtDLkm-PkgPhd3abCmZA',
      },
      {
        'name': 'Elegant Spaces',
        'type': 'Venue',
        'rating': 4.8,
        'reviews': 210,
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD8lKyaqdFn2Gpx821auZx-7DxNkxeIZJtDVXnvHkqxriR-smdd6m7tIIUsqzV1WJzRbmuO-XG3kKPKRRmmMw2hfxjJZEGN7BHJPXtK-FtXPXuhXhlSI59haaAlFRepB1EzlaIIPJ7I9a22OBZf7icdCr6rNMbAkvkUtzAvTjYewha9fOTA0zB0dx_OIK8F2HYm5XtWC1CQxx-KQH9ZAzYi3GSd6RiWsloPzpNiBHQv2GtBqJA7LXGnT_h35Pq0c6TVL5LbkzWUWg',
      },
      {
        'name': 'Floral Fantasies',
        'type': 'Decor',
        'rating': 4.9,
        'reviews': 98,
        'image':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDOqYXkoi-_I635pnkNpBgSgVXy3dXqe2aVbYsN_xKYIEI1COopy7m7A-9mnHbTcSi3vSPIyQhqiJKK_41NqlBahud6pVFRSWyF7mxuBCIRSQxaaijsluYYS4GqDd9mHoFz8euM_h3vv65OjCRI-Zs--kFCuMUJ6_UvTPAGYCeG6IAKMjfxo9IDfP6LLr-f-ksJMHEnyS1GWLRm7Zix0rVKtahfQUf-e6DxcoRWOp0Y1PbKm-LsOQt_yTdrLxkyqDO7jGZTGAuGVA',
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? backgroundDark.withOpacity(0.8)
            : backgroundLight.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Vendors for "$eventName"',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
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
                  borderSide: BorderSide(color: Colors.transparent),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        backgroundColor: isDark
            ? backgroundDark.withOpacity(0.8)
            : backgroundLight.withOpacity(0.8),
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration),
            label: 'Vendors',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
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
                  child: Image.network(
                    vendor['image']!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                    child: const Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: VendorsScreen.primaryColor,
                      side: const BorderSide(color: VendorsScreen.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _sendBookingRequest(context, vendor['name']!),
                    child: const Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VendorsScreen.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
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
