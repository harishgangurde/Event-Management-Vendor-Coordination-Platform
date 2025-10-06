import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAnalytics extends StatelessWidget {
  const AdminAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundDark = const Color(0xFF190F23);
    final Color cardColor = const Color(0xFF1F1A30);
    final Color primary = const Color(0xFF7F06F9);
    final Color secondary = const Color(0xFFA855F7);
    final Color textLight = Colors.white;
    final Color textDark = const Color(0xFF9CA3AF);

    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600 && width < 1000;
    final bool isDesktop = width >= 1000;

    // Determine number of columns for grid layout
    int crossAxisCount = isDesktop ? 2 : isTablet ? 1 : 1;

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Analytics & Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isDesktop ? 1.6 : 1.2,
          children: [
            _buildChartCard(
              title: "Bookings",
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                            return Text(months[value.toInt() % 6],
                                style: TextStyle(color: textDark));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 65),
                          FlSpot(1, 59),
                          FlSpot(2, 80),
                          FlSpot(3, 81),
                          FlSpot(4, 56),
                          FlSpot(5, 92),
                        ],
                        isCurved: true,
                        gradient: LinearGradient(colors: [primary.withOpacity(0.6), primary.withOpacity(0)]),
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildChartCard(
              title: "Payments",
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                            return Text(weeks[value.toInt() % 4], style: TextStyle(color: textDark));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 12000, color: primary)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 19000, color: secondary)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15000, color: Colors.blue)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 21000, color: Colors.green)]),
                    ],
                  ),
                ),
              ),
            ),
            _buildChartCard(
              title: "Platform Activity",
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 12),
                          FlSpot(1, 19),
                          FlSpot(2, 3),
                          FlSpot(3, 5),
                          FlSpot(4, 2),
                          FlSpot(5, 8),
                          FlSpot(6, 15),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 5),
                          FlSpot(1, 8),
                          FlSpot(2, 2),
                          FlSpot(3, 4),
                          FlSpot(4, 1),
                          FlSpot(5, 6),
                          FlSpot(6, 7),
                        ],
                        isCurved: true,
                        color: Colors.pink,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Text(days[value.toInt() % 7], style: TextStyle(color: textDark));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildChartCard(
              title: "User Engagement",
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: 300, color: primary, title: 'Likes', titleStyle: TextStyle(color: textLight)),
                      PieChartSectionData(value: 150, color: secondary, title: 'Comments', titleStyle: TextStyle(color: textLight)),
                      PieChartSectionData(value: 100, color: Colors.blue, title: 'Shares', titleStyle: TextStyle(color: textLight)),
                      PieChartSectionData(value: 200, color: Colors.pink, title: 'Saves', titleStyle: TextStyle(color: textLight)),
                    ],
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                  ),
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
        color: const Color(0xFF1F1A30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
