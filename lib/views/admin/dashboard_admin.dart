import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161022),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161022).withOpacity(0.8),
        elevation: 0,
        title: Row(
          children: [
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCO63qdvL9K8YHhFc--PN-aig4y0DDxGKecMy8WKiwDguozWtNulPN7xqFt84O7BegUiag46BJbi_EPn40rqk-I2nujT1Sl7wl05xwMpUavwutbWWXl_qbjKqoNBItITLQhwBD-B0McnAIayv7x76XBBXqPJd4IuwcieiuFEiWBwE4e6wiF9L6nAdbVscYYE4tlSbpCngEDrwzG10S-YKPirHgXM4a-kT5XR2EjZFGjcHqC5vz3bHhXze7VqMeI_oDdje2XtdOZtg',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2,
              children: [
                _statCard('Planners', '1,250', '+15%', Colors.green),
                _statCard('Vendors', '8,420', '+22%', Colors.green),
                _statCard('Events', '3,200', '+8%', Colors.green),
                _statCard('Transactions', '\$1.2M', '-3%', Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Analytics Chart
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1f1a30),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 250,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: 'Monthly',
                        dropdownColor: const Color(0xFF1f1a30),
                        underline: Container(),
                        style: const TextStyle(color: Colors.white),
                        items: <String>['Monthly', 'Weekly', 'Yearly'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180, // fixed height to avoid overflow
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) =>
                              FlLine(color: const Color(0xFF1f1a30)),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                ];
                                return Text(
                                  months[value.toInt() % 6],
                                  style: const TextStyle(
                                    color: Color(0xFF9ca3af),
                                  ),
                                );
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Color(0xFF9ca3af),
                                ),
                              ),
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 65),
                              FlSpot(1, 59),
                              FlSpot(2, 80),
                              FlSpot(3, 81),
                              FlSpot(4, 56),
                              FlSpot(5, 95),
                            ],
                            isCurved: true,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7e42f5), Color(0xFF5b13ec)],
                            ),
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF5b13ec).withOpacity(0.5),
                                  const Color(0xFF5b13ec).withOpacity(0),
                                ],
                              ),
                            ),
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, bar, index) =>
                                  FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.white,
                                    strokeWidth: 2,
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
            const SizedBox(height: 24),

            // Action Cards
            _actionCard(
              'Vendor Registrations',
              '3 new pending requests',
              Colors.purple,
              buttonText: 'Approve/Reject',
              icon: Icons.arrow_forward,
            ),
            const SizedBox(height: 12),
            _actionCard(
              'Monitor Activity',
              'View platform usage logs',
              Colors.purple.shade200,
              buttonText: 'View Logs',
              icon: Icons.monitor,
            ),
            const SizedBox(height: 24),

            // AI Assistant
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5b13ec), Color(0xFFa855f7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy, color: Colors.white, size: 36),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'AI Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Get insights and suggestions.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF161022).withOpacity(0.8),
        selectedItemColor: const Color(0xFF5b13ec),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    String change,
    Color changeColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1f1a30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: Colors.purple, size: 16),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(color: Color(0xFF9ca3af))),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(change, style: TextStyle(fontSize: 12, color: changeColor)),
        ],
      ),
    );
  }

  Widget _actionCard(
    String title,
    String subtitle,
    Color color, {
    required String buttonText,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1f1a30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(subtitle, style: const TextStyle(color: Color(0xFF9ca3af))),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            icon: Icon(icon, size: 16),
            label: Text(buttonText, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
