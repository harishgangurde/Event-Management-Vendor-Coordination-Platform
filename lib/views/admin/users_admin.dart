// lib/views/admin/users_admin.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final Color backgroundLight = const Color(0xFFF7F5F8);
  final Color backgroundDark = const Color(0xFF190F23);
  final Color primary = const Color(0xFF7F06F9);

  bool isDarkMode = false;
  String selectedTab = "Planners"; // Default tab
  String _searchQuery = "";

  // Stream for fetching users
  Stream<QuerySnapshot> _getUsersStream() {
    Query query = FirebaseFirestore.instance.collection('users');

    if (_searchQuery.isNotEmpty) {
      // Basic search by name (case-insensitive is tricky without 3rd party)
      query = query
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }
    
    // Always filter by role based on the selected tab
    query = query.where('role', isEqualTo: selectedTab.substring(0, selectedTab.length - 1)); // "Planners" -> "Planner"

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textDark = Colors.grey[400]!;

    return Scaffold(
      backgroundColor: isDarkMode ? backgroundDark : backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? backgroundDark.withOpacity(0.8)
            : backgroundLight.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Manage Users",
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search users by name...",
                filled: true,
                fillColor: isDarkMode ? Colors.black12 : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Tabs
          Row(children: [_tabItem("Planners"), _tabItem("Vendors")]),
          const SizedBox(height: 8),
          // User list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${selectedTab.toLowerCase()} found.',
                      style: TextStyle(color: textDark),
                    ),
                  );
                }

                final users = snapshot.data!.docs;

                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: primary.withOpacity(0.2), height: 1),
                  itemBuilder: (context, index) {
                    final doc = users[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final String name = data['name'] ?? 'N/A';
                    final String role = data['role'] ?? 'N/A';
                    final String avatarUrl = data['profileImageUrl'] ?? '';
                    final String status = data['status'] ?? 'Active'; // Assume 'status' field

                    Color statusColor;
                    switch (status) {
                      case "Active":
                        statusColor = Colors.green;
                        break;
                      case "Inactive":
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.yellow[700]!;
                    }

                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? backgroundDark
                                      : backgroundLight,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        role,
                        style: TextStyle(color: textDark),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // TODO: Show options like 'Deactivate', 'Delete'
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(String title) {
    final bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(width: 2, color: const Color(0xFF7F06F9)),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            color: isSelected ? primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}