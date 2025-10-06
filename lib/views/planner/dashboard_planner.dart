import 'package:eventtoria/views/planner/event_details.dart';
import 'package:flutter/material.dart';
import 'profile_planner.dart';
import 'notification_screen.dart';
import 'chat_screen.dart';
import 'package:flutter/services.dart';

class DashboardPlanner extends StatefulWidget {
  const DashboardPlanner({super.key});

  @override
  State<DashboardPlanner> createState() => _DashboardPlannerState();
}

class _DashboardPlannerState extends State<DashboardPlanner> {
  int selectedIndex = 0;

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);

    Widget? targetScreen;

    if (index == 1) {
      targetScreen = const EventDetailsPage();
    } else if (index == 2) {
      targetScreen = const ChatScreen();
    } else if (index == 3) {
      targetScreen = const ProfilePlannerScreen();
    } else if (index == 4) {
      targetScreen = const NotificationScreen();
    }

    if (targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen!),
      ).then((_) {
        setState(() {
          selectedIndex = 0;
        });
      });
    }
  }

  Future<bool> _onWillPop() async {
    // Exit the app when back button is pressed
    await SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the back button
          title: const Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF7F06F9),
                child: Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text('Eventtoria', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: const [],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            buildSectionTitle('Upcoming Events'),
            const SizedBox(height: 8),
            buildUpcomingEvents(),
            const SizedBox(height: 24),
            buildSectionTitle('Quick Stats'),
            const SizedBox(height: 8),
            buildQuickStats(theme),
            const SizedBox(height: 24),
            buildSectionTitle('AI Suggestions'),
            const SizedBox(height: 8),
            buildAISuggestions(context),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
            NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            NavigationDestination(
              icon: Icon(Icons.notifications),
              label: 'Notify',
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget buildUpcomingEvents() {
    final events = [
      {
        'title': 'Grand Wedding Reception',
        'date': 'October 15, 2024',
        'image': 'assets/images/eventwedding.jpg',
      },
      {
        'title': "Sarah's 30th Birthday Bash",
        'date': 'November 20, 2024',
        'image': 'assets/images/birthday_event.jpg',
      },
      {
        'title': 'Annual Tech Conference',
        'date': 'December 5, 2024',
        'image': 'assets/images/annual_tech.jpg',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final e = events[i];
          return SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    e['image']!,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  e['date']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildQuickStats(ThemeData theme) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: statCard('Budget', '₹500,000', theme)),
            const SizedBox(width: 12),
            Expanded(child: statCard('Guest Count', '250', theme)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pending Tasks',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '15',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget statCard(String label, String value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildAISuggestions(BuildContext context) {
    final suggestions = [
      {
        'title': 'Top Vendor Picks',
        'desc': 'Based on your event needs',
        'btn': 'View All',
        'image':
            'https://images.unsplash.com/photo-1531058020387-3be344556be6?auto=format&fit=crop&w=600&q=60',
      },
      {
        'title': 'Theme Ideas',
        'desc': 'Get inspired for your next event',
        'btn': 'Explore',
        'image':
            'https://images.unsplash.com/photo-1528740561666-dc2479dc08ab?auto=format&fit=crop&w=600&q=60',
      },
    ];

    return Column(
      children: suggestions
          .map(
            (s) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF313131)
                  : Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        s['image']!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            s['desc']!,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FilledButton.tonal(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
