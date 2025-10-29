// lib/views/admin/vendor_approval.dart
// This file is already dynamic and correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorApproval extends StatefulWidget {
  const VendorApproval({super.key});

  @override
  State<VendorApproval> createState() => _VendorApprovalState();
}

class _VendorApprovalState extends State<VendorApproval> {
  final Color backgroundLight = const Color(0xFFF7F5F8);
  final Color backgroundDark = const Color(0xFF190F23);
  final Color primary = const Color(0xFF7F06F9);

  bool isDarkMode = false;

  final Stream<QuerySnapshot> _approvalStream = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Vendor')
      .where('status', isEqualTo: 'Pending') // This is the key filter
      .snapshots();

  Future<void> _updateVendorStatus(String uid, String name, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'status': newStatus});

      _showSnackBar(name, newStatus.toLowerCase());
    } catch (e) {
      _showSnackBar('Error updating $name', 'error');
    }
  }

  void _showSnackBar(String vendorName, String action) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            action == 'error' ? vendorName : "$vendorName has been $action"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: action == 'active' // Match the status string
            ? Colors.green
            : (action == 'rejected' ? Colors.red : Colors.orange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? backgroundDark : backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? backgroundDark.withOpacity(0.8)
            : backgroundLight.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Vendor Approval",
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _approvalStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No pending vendor approvals.',
                style:
                    TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
              ),
            );
          }

          final vendors = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final doc = vendors[index];
              final data = doc.data() as Map<String, dynamic>;

              final String name = data['name'] ?? 'N/A';
              final String category = data['serviceType'] ?? 'N/A';
              final String imageUrl = data['profileImageUrl'] ?? '';

              return Card(
                color: isDarkMode
                    ? backgroundDark.withOpacity(0.9)
                    : Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: imageUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              color: imageUrl.isEmpty ? Colors.grey[700] : null,
                            ),
                            child: imageUrl.isEmpty
                                ? const Icon(Icons.store, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.isNotEmpty ? category : "No Category",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _updateVendorStatus(doc.id, name, 'Rejected');
                              },
                              icon: const Icon(Icons.close, color: Colors.red),
                              label: const Text(
                                "Reject",
                                style: TextStyle(color: Colors.red),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary.withOpacity(0.1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // You must approve them as 'Active'
                                _updateVendorStatus(doc.id, name, 'Active');
                              },
                              icon:
                                  const Icon(Icons.check, color: Colors.white),
                              label: const Text(
                                "Approve",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
            },
          );
        },
      ),
    );
  }
}