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

  final List<Map<String, dynamic>> vendors = [
    {
      "category": "Catering",
      "name": "Eventtoria Catering",
      "rating": 4.9,
      "reviews": 120,
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDd1G2ma43BFP9OMHky-R28N2194mP446javGzOpoiiIkLflTDTeYRIpX6sbhGy9691A34TTGwn4lWGE3HNCu5kD8fGgIg3q3j2ISbtwh_UXjIhvWmdEG_vVIHC9loO8mkHUPsKhh74ZkB7Xq3-juFuMcXEcp0P9Yk-BSYVzSX5Rcq13RX582uMskzOkQSk_5pn5ulV-0vA4wCHTAZyhcFSEL7OrMbkEgJNL45uk5FOKcgyDHshdWaBcPP9PGnUJFt5q_ItgYibEw",
    },
    {
      "category": "Photography",
      "name": "Eventtoria Photography",
      "rating": 4.8,
      "reviews": 95,
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAHVEfogePdS4-7iZtUxUqIL2GHkj3UzH9GUN4MZQVzzr5l7WTcXA8EpXREjWuk6gy1o5OFCTcEuWy0cZOCfAGaRsquwF3-_Ef3I-8PrQm4oQZu1IHhEnTKqYYbiOccPbwblojNpqwChrJssfxC2rOyJL7SStiVFsPH_4BN4pw1XEDenP791kMvXp51zu6xrF9KCLOqG5cC7Ma37VdqVzVOHgMcaiMqY__03J2EBHkBvdOoU-fkBHZ-BsEebO4E0-rel6x_BZaU1Q",
    },
    {
      "category": "Decor",
      "name": "Eventtoria Decor",
      "rating": 5.0,
      "reviews": 210,
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCy8Ha96MlcCajOfENbMuKJWk59zpl58NxA0nB-42lmu65ptbNpogRKcRlQDzv3G5Kay2huRSQaFYG2T_aTvHFOw4zy6mHxg-3lLk5DCOBC8hXQI3sq-5UO-egmSamhqgNiRoBUDV9C6Qc6_akFvaRmaLSQGgkAqUMFnlCMqtgaJvYxUFlYLLlIM0HNGwUcRCHTOomt-tkGxp5GLdWA6ar2Pm35WXpF0I5TlwiUbRtgj_RAnqyHSh4LoC4vTf-B6qkrPts0NkRovA",
    },
    {
      "category": "Music",
      "name": "Eventtoria Music",
      "rating": 4.7,
      "reviews": 88,
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAO7K31rLy-UkT9Ph63A1vvaaRnXmHCQzDKMnUUhAZtDixjZVYj1ZpajLW1xUp7o-HE4BEZMsz4wmw2FDnK470XcdpaKuFvWA1ZsTXgPLkr6SoucTIsr8J-KZRnUmsRHu4vyGjI-IgyAW7g0obEOchwpvrgac868TXOd9UgYb6BQBvX9HydXULL04-nBNOT_Lzf0tmPlrDtDseT6oqg6OuEL886azc_OGv6Y77j-4bjT1V4jRAkayV8qQcdxXh5tvCYfjrPAH93kw",
    },
  ];

  void _showSnackBar(String vendorName, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$vendorName has been $action"),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
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
          icon: const Icon(Icons.arrow_back),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return Card(
            color: isDarkMode
                ? backgroundDark.withOpacity(0.5)
                : backgroundLight,
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
                          image: DecorationImage(
                            image: NetworkImage(vendor["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendor["category"],
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vendor["name"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${vendor["rating"]} (${vendor["reviews"]} reviews)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
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
                            _showSnackBar(vendor["name"], "rejected");
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
                            _showSnackBar(vendor["name"], "approved");
                          },
                          icon: const Icon(Icons.check, color: Colors.white),
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
      ),
    );
  }
}
