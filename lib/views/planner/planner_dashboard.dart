// lib/views/planner/planner_dashboard.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_planner.dart';
import 'notification_screen.dart';
import 'chat_list_screen.dart';
import 'bookings_screen.dart';
import 'event_details.dart'; // This is now used as a placeholder
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
// 1. HOME CONTENT WIDGET (PlannerHome)
// ===================================================

class PlannerHome extends StatelessWidget {
  const PlannerHome({super.key});

  Widget buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  // --- UPDATED: buildUpcomingEvents ---
  Widget buildUpcomingEvents(BuildContext context, ThemeData theme) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('plannerId', isEqualTo: currentUserId)
          // TODO: Add a date filter for 'upcoming'
          // .where('date', isGreaterThanOrEqualTo: Timestamp.now().toDate().toString())
          .orderBy('createdAt', descending: true) // Show newest first
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12)
            ),
            child: const Center(
              child: Text('No upcoming events.\nTap "Create Event" to start!', textAlign: TextAlign.center,),
            ),
          );
        }

        final events = snapshot.data!.docs;

        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final doc = events[i];
              final data = doc.data() as Map<String, dynamic>;

              final String title = data['eventName'] ?? 'N/A';
              final String date = data['date'] ?? 'N/A';
              // Use the first image from the uploaded list
              final String imageUrl = (data['imageUrls'] as List<dynamic>?)?.first ?? '';

              return GestureDetector(
                onTap: () {
                  // TODO: Navigate to a REAL event details page
                  // This placeholder is from the original code
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventInfoPage(
                        title: title,
                        date: date,
                        image: imageUrl.isNotEmpty ? imageUrl : 'assets/images/eventwedding.jpg', // Pass URL or fallback
                        isNetworkImage: imageUrl.isNotEmpty, // Tell widget it's a network image
                        description: data['description'] ?? 'No description.',
                        venue: data['venue'] ?? 'N/A',
                        organizer: 'Managed by you',
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (imageUrl.isNotEmpty)
                          ? Image.network(
                              imageUrl,
                              height: 120,
                              width: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => _imageErrorPlaceholder(theme),
                            )
                          : _imageErrorPlaceholder(theme),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _imageErrorPlaceholder(ThemeData theme) {
     return Container(
        height: 120,
        width: 160,
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        child: Icon(
          Icons.image_not_supported,
          color: theme.colorScheme.onSurface.withOpacity(0.5)
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
    // This can also be fetched from the 'events' data
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

  Widget buildAISuggestions(BuildContext context, ThemeData theme) {
    final suggestions = [
      {
        'title': 'Top Vendor Picks',
        'desc': 'Based on your event needs',
        'btn': 'View All',
        'image': 'assets/images/functionss.jpg',
        'prompt': 'Show me the top vendor picks for my upcoming event.',
      },
      {
        'title': 'Theme Ideas',
        'desc': 'Get inspired for your next event',
        'btn': 'Explore',
        'image': 'assets/images/themee.jpg',
        'prompt': 'Give me creative theme ideas for my next event.',
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
                    child: Image.asset(
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventtoriaAIScreen(
                                  initialPrompt: s['prompt'] as String?,
                                ),
                              ),
                            );
                          },
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
          buildUpcomingEvents(context, theme),
          const SizedBox(height: 24),
          buildSectionTitle('Quick Stats', theme),
          const SizedBox(height: 8),
          buildQuickStats(theme),
          const SizedBox(height: 24),
          buildSectionTitle('AI Suggestions', theme),
          const SizedBox(height: 8),
          buildAISuggestions(context, theme),
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
// 2. MAIN DASHBOARD WIDGET (Handles Bottom Navigation)
// ===================================================

class DashboardPlanner extends StatefulWidget {
  const DashboardPlanner({super.key});

  @override
  State<DashboardPlanner> createState() => _DashboardPlannerState();
}

class _DashboardPlannerState extends State<DashboardPlanner> {
  int selectedIndex = 0;
  // This is no longer needed here, it's fetched by PlannerHome
  // final String currentEventName = "Annual Tech Conference";

  late final List<Widget> _widgetOptions;

  _DashboardPlannerState() {
    _widgetOptions = <Widget>[
      const PlannerHome(), // Index 0: Home
      // eventName is required by VendorsScreen, but we don't know
      // which event is "active". This is a design flaw to fix.
      // For now, let's pass a placeholder.
      const VendorsScreen(eventName: "General Vendor Search"), // Index 1
      const BookingsScreen(), // Index 2: Bookings
      const ChatListScreen(), // Index 3: Chat
      const ProfilePlanner(), // Index 4: Profile
    ];
  }

  Future<bool> _onWillPop() async {
    if (selectedIndex == 0) {
      // Exit app only if on the Home tab
      await SystemNavigator.pop();
    } else {
      // If on another tab, go back to Home
      setState(() {
        selectedIndex = 0;
      });
    }
    return false; // Prevent default pop behavior
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // Use IndexedStack to keep the state of each tab alive
        body: IndexedStack(index: selectedIndex, children: _widgetOptions),

        bottomNavigationBar: NavigationBar(
          // Apply theme colors
          backgroundColor: theme.scaffoldBackgroundColor,
          indicatorColor: theme.colorScheme.primary.withOpacity(0.2),

          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
                label: 'Vendors'),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
              label: 'Bookings',
            ),
            NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: 'Chat'),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }
}

// ===============================================
// 3. EVENT INFO PAGE (Hardcoded Details Display)
// ===============================================

class EventInfoPage extends StatelessWidget {
  final String title;
  final String date;
  final String image;
  final String description;
  final String venue;
  final String organizer;
  final bool isNetworkImage; // NEW: Flag for network image

  const EventInfoPage({
    super.key,
    required this.title,
    required this.date,
    required this.image,
    required this.description,
    required this.venue,
    required this.organizer,
    this.isNetworkImage = false, // Default to asset
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.colorScheme.primary, // Apply theme color
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // Use Image.network or Image.asset based on flag
              child: isNetworkImage
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    errorBuilder: (ctx, err, stack) => _imageErrorPlaceholder(theme),
                  )
                : Image.asset(
                    image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    errorBuilder: (ctx, err, stack) => _imageErrorPlaceholder(theme),
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(date, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              'Venue',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(venue, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              'Organizer',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(organizer, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _imageErrorPlaceholder(ThemeData theme) {
     return Container(
        height: 200,
        width: double.infinity,
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: theme.colorScheme.onSurface.withOpacity(0.5)
        ),
      );
  }
}