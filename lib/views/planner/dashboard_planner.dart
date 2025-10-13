import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_planner.dart';
import 'notification_screen.dart';
import 'chat_screen.dart';
import 'event_details.dart';
import 'create_event.dart';
import 'eventoria_ai_screen.dart';
import 'vendor_screen.dart';

// Helper method for Notification button navigation
void _openNotifications(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NotificationScreen()),
  );
}

// ===================================================
// 1. EXTRACTED HOME SCREEN CONTENT: DashboardBody
// ===================================================

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  Widget buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget buildUpcomingEvents(ThemeData theme) {
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  e['date']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '15',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAISuggestions(ThemeData theme) {
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
      children: suggestions.map((s) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: theme.cardColor,
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          s['desc']!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            s['btn']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        title: const Text(
          'Eventtoria',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _openNotifications(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildSectionTitle('Upcoming Events', theme),
          const SizedBox(height: 8),
          buildUpcomingEvents(theme),
          const SizedBox(height: 24),
          buildSectionTitle('Quick Stats', theme),
          const SizedBox(height: 8),
          buildQuickStats(theme),
          const SizedBox(height: 24),
          buildSectionTitle('AI Suggestions', theme),
          const SizedBox(height: 8),
          buildAISuggestions(theme),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateEventPage()),
                );
              },
              label: const Text('Create Event'),
              icon: const Icon(Icons.event_note),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EventtoriaAIScreen()),
                );
              },
              backgroundColor: theme.colorScheme.secondary,
              child: const Icon(
                Icons.auto_awesome,
                size: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================
// 2. MAIN DASHBOARD WIDGET (Handles Navigation)
// ===================================================

class DashboardPlanner extends StatefulWidget {
  const DashboardPlanner({super.key});

  @override
  State<DashboardPlanner> createState() => _DashboardPlannerState();
}

class _DashboardPlannerState extends State<DashboardPlanner> {
  int selectedIndex = 0;

  final String currentEventName = "Annual Tech Conference";

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);
  }

  Future<bool> _onWillPop() async {
    if (selectedIndex == 0) {
      await SystemNavigator.pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Screens are dynamically created here to include VendorsScreen
    final List<Widget> _widgetOptions = [
      const DashboardBody(),
      VendorsScreen(eventName: currentEventName),
      const EventDetailsPage(),
      const ChatScreen(),
      const ProfilePlannerScreen(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(index: selectedIndex, children: _widgetOptions),
        bottomNavigationBar: NavigationBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.groups), label: 'Vendors'),
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: 'Bookings',
            ),
            NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}
