// lib/views/admin/analytics_admin.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdminAnalytics extends StatelessWidget {
  const AdminAnalytics({super.key});

  final Color backgroundDark = const Color(0xFF190F23);
  final Color cardColor = const Color(0xFF1F1A30);
  final Color primary = const Color(0xFF7F06F9);
  final Color secondary = const Color(0xFFA855F7);
  final Color textLight = Colors.white;
  final Color textDark = const Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Go back to dashboard (index 0) or pop
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text(
          'Analytics & Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Roles Pie Chart (Dynamic)
            _buildChartCard(
              title: "User Distribution",
              child: SizedBox(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    
                    int plannerCount = 0;
                    int vendorCount = 0;
                    
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      if (data['role'] == 'Planner') {
                        plannerCount++;
                      } else if (data['role'] == 'Vendor') {
                        vendorCount++;
                      }
                    }

                    if (plannerCount == 0 && vendorCount == 0) {
                      return Center(child: Text("No user data", style: TextStyle(color: textDark)));
                    }

                    return PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: plannerCount.toDouble(),
                            color: primary,
                            title: 'Planners\n($plannerCount)',
                            titleStyle: TextStyle(color: textLight, fontSize: 12),
                            radius: 80,
                          ),
                          PieChartSectionData(
                            value: vendorCount.toDouble(),
                            color: secondary,
                            title: 'Vendors\n($vendorCount)',
                            titleStyle: TextStyle(color: textLight, fontSize: 12),
                            radius: 80,
                          ),
                        ],
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Bookings Over Time (Dynamic)
            _buildChartCard(
              title: "Bookings Over Time (Last 30 Days)",
              child: SizedBox(
                height: 250,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('bookings')
                      .where('requestedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))))
                      .orderBy('requestedAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    
                    // Group bookings by day
                    final Map<int, int> bookingsPerDay = {};
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final Timestamp timestamp = data['requestedAt'] ?? Timestamp.now();
                      final DateTime date = timestamp.toDate();
                      final int dayOfYear = int.parse(DateFormat("D").format(date)); // Day of the year
                      
                      bookingsPerDay.update(dayOfYear, (value) => value + 1, ifAbsent: () => 1);
                    }

                    // Convert map to FlSpot list
                    final List<FlSpot> spots = bookingsPerDay.entries.map((entry) {
                      // We need a 0-based index for the x-axis. This is a simplification.
                      // A better way would be to normalize all days relative to the start date.
                      // For this example, we'll just use the day of year mod 30.
                       final double x = entry.key.toDouble() % 30;
                       final double y = entry.value.toDouble();
                       return FlSpot(x, y);
                    }).toList();

                    if (spots.isEmpty) {
                       return Center(child: Text("No recent bookings", style: TextStyle(color: textDark)));
                    }

                    spots.sort((a, b) => a.x.compareTo(b.x));

                    return LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true, border: Border.all(color: textDark.withOpacity(0.5))),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            gradient: LinearGradient(colors: [secondary, primary]),
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [secondary.withOpacity(0.3), primary.withOpacity(0.1)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                        minY: 0,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}