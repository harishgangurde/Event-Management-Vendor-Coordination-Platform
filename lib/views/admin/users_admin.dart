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

  // --- *** FIXES ARE HERE *** ---
  final Color cardDark = const Color(0xFF1F1A30); // 1. ADDED THIS LINE
  final Color textDarkColor = Colors.grey[400]!; // 2. MOVED THIS LINE UP
  // --- *** END OF FIXES *** ---

  bool isDarkMode = false;
  String selectedTab = "Planners"; // Default tab
  String _searchQuery = "";

  // Stream for fetching users
  Stream<QuerySnapshot> _getUsersStream() {
    Query query = FirebaseFirestore.instance.collection('users');

    // Filter by role based on the selected tab
    String role = selectedTab.substring(
      0,
      selectedTab.length - 1,
    ); // "Planners" -> "Planner"
    query = query.where('role', isEqualTo: role);

    if (_searchQuery.isNotEmpty) {
      // Basic prefix search by name
      query = query
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }

    return query.snapshots();
  }

  // --- NEW FUNCTION: Update User Status ---
  Future<void> _updateUserStatus(
    String uid,
    String name,
    String newStatus,
  ) async {
    if (!mounted) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name is now $newStatus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- NEW FUNCTION: Delete User ---
  Future<void> _deleteUser(String uid, String name) async {
    if (!mounted) return;
    // NOTE: This only deletes the Firestore record.
    // To delete the Firebase Auth user, you need a Firebase Function.
    // Deleting from the client SDK is a security risk.
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name has been deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- NEW FUNCTION: Show options dialog ---
  void _showUserOptions(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String name = data['name'] ?? 'N/A';
    final String uid = doc.id;
    final String currentStatus = data['status'] ?? 'Active';
    final bool isBanned = currentStatus == 'Banned';

    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundDark,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                isBanned ? Icons.check_circle : Icons.block,
                color: isBanned ? Colors.green : Colors.orange,
              ),
              title: Text(
                isBanned
                    ? 'Re-activate User'
                    : 'Ban User (Set status to "Banned")',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                String newStatus = isBanned ? 'Active' : 'Banned';
                _updateUserStatus(uid, name, newStatus);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text(
                'Delete User Record (Firestore)',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context);
                // Show confirmation dialog before deleting
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text(
                      'Are you sure you want to delete $name? This only removes the Firestore record, not the Auth user.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _deleteUser(uid, name);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final Color textDarkColor = Colors.grey[400]!; // <-- MOVED TO CLASS LEVEL

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
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
                hintText: "Search users by name...",
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
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
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${selectedTab.toLowerCase()} found.',
                      style: TextStyle(color: textDarkColor),
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
                    // final String role = data['role'] ?? 'N/A'; // No longer needed, we show status
                    final String avatarUrl = data['profileImageUrl'] ?? '';
                    final String status =
                        data['status'] ?? 'Active'; // Assume 'status' field

                    Color statusColor;
                    switch (status) {
                      case "Active":
                        statusColor = Colors.green;
                        break;
                      case "Pending":
                        statusColor = Colors.yellow[700]!;
                        break;
                      case "Banned":
                      case "Inactive":
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                cardDark, // <-- *** FIX IS HERE ***
                            backgroundImage: avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl.isEmpty
                                ? Icon(Icons.person, color: textDarkColor)
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
                        "Status: $status", // Show the status
                        style: TextStyle(color: textDarkColor),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert, color: textDarkColor),
                        onPressed: () {
                          // --- NEW: Show options ---
                          _showUserOptions(context, doc);
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
          _searchQuery = ""; // Clear search when changing tabs
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(width: 2, color: primary))
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
