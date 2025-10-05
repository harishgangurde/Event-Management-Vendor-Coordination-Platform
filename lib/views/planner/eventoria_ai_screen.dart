import 'package:flutter/material.dart';

// Define the colors used for consistency
const Color kPrimaryColor = Color(0xFF7F06F9);
const Color kAccentPurple = Color(0xFFA564E9);
const Color kBackgroundDark = Color(0xFF100819);
const Color kCardDarkColor = Color(0xFF1E122D);

class EventtoriaAIScreen extends StatelessWidget {
  const EventtoriaAIScreen({super.key});

  // Reusable widget for the task cards
  Widget _buildTaskCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: kCardDarkColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List of tasks matching the image
    final List<Map<String, dynamic>> tasks = [
      {
        'icon': Icons.location_on_outlined,
        'color': kAccentPurple,
        'title': 'Venue Recommendations',
        'subtitle': 'Find the perfect venue for your event',
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'color': kPrimaryColor,
        'title': 'Budget Optimization',
        'subtitle': 'Optimize your budget for maximum impact',
      },
      {
        'icon': Icons.emoji_objects_outlined,
        'color': kAccentPurple,
        'title': 'Theme Ideas',
        'subtitle': 'Get personalized theme ideas',
      },
      {
        'icon': Icons.checklist_rtl,
        'color': kPrimaryColor,
        'title': 'Task Reminders',
        'subtitle': 'Stay on track with your planning',
      },
    ];

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        colorScheme: const ColorScheme.dark().copyWith(primary: kPrimaryColor),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Eventtoria AI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi, Planner! How can I assist you today?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 24),

                  // AI Feature Cards
                  ...tasks
                      .map(
                        (task) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildTaskCard(
                            icon: task['icon'] as IconData,
                            title: task['title'] as String,
                            subtitle: task['subtitle'] as String,
                            iconColor: task['color'] as Color,
                            onTap: () {
                              // Action for specific AI feature
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${task['title']} clicked.'),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),

                  const SizedBox(
                    height: 120,
                  ), // Space for the floating text field
                ],
              ),
            ),

            // Fixed/Floating Input Field at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kBackgroundDark,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor:
                              kCardDarkColor, // Darker input field background
                          prefixIcon: Icon(
                            Icons.mic,
                            color: Colors.grey.shade500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Handle send action
                        },
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
