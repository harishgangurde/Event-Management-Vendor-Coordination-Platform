// lib/views/planner/vendor_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventtoria/config/app_theme.dart';
import 'package:eventtoria/views/planner/planner_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorsScreen extends StatefulWidget {
  final String eventName;

  const VendorsScreen({super.key, required this.eventName});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  // Asset paths (used as fallbacks)
  static const String vendorImage1 = 'assets/images/delicious.png';
  static const String vendorImage2 = 'assets/images/moments.png';
  static const String vendorImage3 = 'assets/images/elegant.png';
  static const String vendorImage4 = 'assets/images/floral.png';
  final List<String> _mockImages = [vendorImage1, vendorImage2, vendorImage3, vendorImage4];

  // State for filters
  String? _selectedServiceType;
  double _selectedRating = 0; // 0 means no rating filter

  // Options for the filter dropdowns
  final List<String> _serviceTypes = ['Catering', 'Photography', 'Venue', 'Decor', 'Music'];
  final List<String> _ratingOptions = ['4+ Stars', '3+ Stars', '2+ Stars', '1+ Star'];


  // --- NEW FUNCTION: Send booking request to Firebase ---
  Future<void> _sendBookingRequest(BuildContext context, String vendorId, String vendorName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to book.')),
      );
      return;
    }

    try {
      // Create a new document in the 'bookings' collection
      await FirebaseFirestore.instance.collection('bookings').add({
        'plannerId': user.uid,
        'vendorId': vendorId,
        'vendorName': vendorName, // Store for easy display on both ends
        'plannerName': user.displayName ?? user.email, // Store for easy display
        'eventName': widget.eventName,
        'status': 'pending', // Status: pending, confirmed, declined
        'requestedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking request sent for "$vendorName"!',
          ),
          backgroundColor: AppTheme.kSuccessColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send request: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 💡 --- UPDATED FUNCTION: Build the Firestore query based on filters ---
  Query _buildVendorQuery() {
    // Start with the base query
    Query query = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Vendor'); // ✅ FIX: Use named parameter 'isEqualTo'

    // Apply service type filter if selected
    if (_selectedServiceType != null) {
      // Assumes vendors have a 'serviceType' field
      query = query.where('serviceType', isEqualTo: _selectedServiceType); // ✅ FIX
    }
    
    // Apply rating filter if selected
    if (_selectedRating > 0) {
      // Assumes vendors have a 'rating' field (number)
      query = query.where('rating', isGreaterThanOrEqualTo: _selectedRating); // ✅ FIX
    }

    // Note: Availability filtering is complex and often requires a different
    // data structure (e.g., a subcollection of available dates) or a
    // backend function. We will keep the UI stub but not add query logic for it.

    return query;
  }

  // Helper for navigating back to the main dashboard
  void _navigateBackToDashboard(BuildContext context) {
    // This ensures the dashboard is the root and state is preserved
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPlanner()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use theme colors from app_theme.dart
    final Color backgroundColor = isDark ? AppTheme.kBackgroundDark : AppTheme.backgroundLight;
    const Color primaryColor = AppTheme.kPrimaryColor;


    return WillPopScope(
      // Handles Android back button press
      onWillPop: () async {
        _navigateBackToDashboard(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor.withOpacity(0.8),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Vendors',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new), // Inherits color from theme
            onPressed: () {
              _navigateBackToDashboard(context);
            },
          ),
        ),
        body: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search vendors',
                  filled: true,
                  fillColor: isDark
                      ? AppTheme.kCardDarkColor
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

            // --- UPDATED FILTERS ---
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Service Type Filter
                  filterDropdown(
                    hint: 'Service Type',
                    value: _selectedServiceType,
                    items: _serviceTypes,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedServiceType = newValue;
                      });
                    },
                    isDark: isDark,
                    theme: theme, // 💡 --- FIX: Pass theme ---
                  ),
                  const SizedBox(width: 8),
                  
                  // Rating Filter
                  filterDropdown(
                    hint: 'Rating',
                    // Convert rating state back to string for display
                    value: _selectedRating == 0 ? null : '${_selectedRating.toInt()}+ Star${_selectedRating > 1 ? 's' : ''}',
                    items: _ratingOptions,
                    onChanged: (String? newValue) {
                      if(newValue == null) {
                        setState(() => _selectedRating = 0);
                        return;
                      }
                      // Parse the string "4+ Stars" to the number 4
                      setState(() {
                         _selectedRating = double.parse(newValue.substring(0, 1));
                      });
                    },
                    isDark: isDark,
                    theme: theme, // 💡 --- FIX: Pass theme ---
                  ),
                  const SizedBox(width: 8),

                  // Availability Filter (UI Stub)
                  filterButton('Availability', Icons.calendar_today, isDark, () {
                    // TODO: Implement date picker logic for availability
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Availability filter coming soon!'))
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // --- UPDATED VENDOR LIST (StreamBuilder) ---
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // The stream is now built from our filter logic
                stream: _buildVendorQuery().snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No vendors found',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Try adjusting your filters.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // We have data, build the list
                  final vendorDocs = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: vendorDocs.length,
                    itemBuilder: (context, index) {
                      final doc = vendorDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      
                      // Use profileImageUrl from Firebase, or a mock image as fallback
                      final imageUrl = data['profileImageUrl'] ?? _mockImages[index % _mockImages.length];

                      return vendorCard(
                        vendorId: doc.id, // Pass the doc ID
                        vendorData: data,
                        imageUrl: imageUrl, // Use fetched URL or mock
                        isDark: isDark, 
                        context: context
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Dropdown Widget
  Widget filterDropdown({
    required String hint, 
    required String? value, 
    required List<String> items, 
    required ValueChanged<String?> onChanged,
    required bool isDark,
    required ThemeData theme, // 💡 --- FIX: Add theme parameter ---
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.kPrimaryColor.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppTheme.kPrimaryColor, fontSize: 14)),
          icon: const Icon(Icons.expand_more, color: AppTheme.kPrimaryColor, size: 20),
          style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14), // 💡 --- FIX: Use theme ---
          dropdownColor: isDark ? AppTheme.kCardDarkColor : Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Filter Button Widget (for Availability)
  Widget filterButton(String label, IconData icon, bool isDark, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.kPrimaryColor.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.calendar_today, size: 16, color: AppTheme.kPrimaryColor),
        label: Text(
          label,
          style: const TextStyle(color: AppTheme.kPrimaryColor, fontSize: 14),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
        ),
      ),
    );
  }

  // Vendor Card Widget
  Widget vendorCard({
    required String vendorId,
    required Map<String, dynamic> vendorData,
    required String imageUrl,
    required bool isDark,
    required BuildContext context,
  }) {
    // Extract data with fallbacks
    final String name = vendorData['name'] ?? 'No Name';
    final String type = vendorData['serviceType'] ?? 'Vendor'; // Assumes 'serviceType' field
    final double rating = (vendorData['rating'] as num?)?.toDouble() ?? 0.0; // Assumes 'rating' field
    final int reviews = (vendorData['reviews'] as num?)?.toInt() ?? 0; // Assumes 'reviews' field
    
    // Check if it's a network image or local asset
    final bool isNetworkImage = imageUrl.startsWith('http');

    // 💡 --- FIX: Get theme from context ---
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppTheme.kCardDarkColor : Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  // Use Image.network or Image.asset
                  child: isNetworkImage
                    ? Image.network(
                        imageUrl,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _imageErrorPlaceholder(),
                      )
                    : Image.asset(
                        imageUrl,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _imageErrorPlaceholder(),
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.colorScheme.onSurface, // 💡 --- FIX: Use theme ---
                        ),
                      ),
                      Text(
                        type,
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
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1), // Format rating
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface, // 💡 --- FIX: Use theme ---
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviews reviews)',
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
                    onPressed: () {
                      // TODO: Navigate to Vendor Profile Detail Page
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.kPrimaryColor,
                      side: const BorderSide(color: AppTheme.kPrimaryColor),
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
                    onPressed: () => _sendBookingRequest(context, vendorId, name),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.kPrimaryColor,
                      foregroundColor: Colors.white, // Set text color
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
  
  // Helper for image errors
  Widget _imageErrorPlaceholder() {
    return Container(
      height: 80,
      width: 80,
      color: Colors.grey.shade300,
      child: const Icon(Icons.broken_image, color: Colors.red),
    );
  }
}