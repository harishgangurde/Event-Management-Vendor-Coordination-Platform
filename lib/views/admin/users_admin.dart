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
  String selectedTab = "Planners";

  final List<Map<String, String>> planners = [
    {
      "name": "Sophia Bennett",
      "role": "Planner",
      "status": "Active",
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDkPBHperLMz-ArrW0Se9pf8oPlbrvfA0jEd8dVl4q4m-SgkW1KTZgMMlI_wZZBqC6XtF49KxgghGBUYq_xttM7YSAnxGq4zQfzE2rq9QF_LFzGMYU_EBtko9tRMiBsnr1sWXIjS5mbgUfAKVJmDb1IpEwMs7_orjl4oN5iXqTt1W6BxVgOfQfcYaaKR41Ms4v1vYtOhzrHfZf4Hbyi4z-F61Q6n-gjLa8bOdmnwT9iG4815PV6xw0rttKfS-wDwQHFZS2JqS0z6g",
    },
    {
      "name": "Ethan Carter",
      "role": "Planner",
      "status": "Active",
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuB0RZQgmpnOhjGqWNOPKA36wk_cRQeS9aQQGekEw-2Chx8_oVrEEPUxLwWKxh-HsR5FBwQ2SQ8k0SH_PQvlgBC8RqLWcgD6GGyWfXc0pHhsYfMr6NsMI7YEpi8qyouM3OyTRMFp6TZRkaX8dhH5IlZ2Gk3i4I8OuFrNkaob27MKwxPPq9NVm6JcB-hEhb3q_jeSlMPCEw5b-AP7mueh8bxcdGNG40gvXb9N06nz41mCC5V2j2LB0iFMvWQOG7euD6cWNfHR-AbITw",
    },
  ];

  final List<Map<String, String>> vendors = [
    {
      "name": "Olivia Davis",
      "role": "Vendor",
      "status": "Inactive",
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAH5LUZ3AAe-lpjCf8alvefjYw6bSMNmnUrgHYAg3mQNZiusH9BFWm5kpWd--3bbE10wjyhGvv5jvlh7N2IjDArbNXqKcTAc-lmwxZAFz5VT2DHni7adHPIQTZ-vViQCmRM0pEsU67oT9GRrUPwplPXwIJ6OXnRwm7SsOMUmwQn-PrBWJMn9iH0CEQQ_NQaYT5wq5Pbnjou9GvtcD_TcVJXqGwwDHe8TmyG_foevWBbBXimwIYGhM3UqUnLyB9jr7Xggl-qAi4djQ",
    },
    {
      "name": "Liam Foster",
      "role": "Vendor",
      "status": "Active",
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCd8AcuIa3lBr7XzMX5sM_aPnh2wFgVefSNrXKfQkRMDia2P2zZx0D1hLLYFrxiwTQz6qALwJC_gow1pe1gcCs9w4HzCigkZQo6DT7o2lA2iKrAaL9nAwWiDfbxR75IvhcJ0lwxuBkocS46uoQoJg9Vvs4HJh8a4P2p_8NIexz-GdRGvfUPMZWG0qa0ZvFHjHSKLlMUZejoM76mmh45yI3B9GdqipKqD9CNhv2xtFL8BxN3Ms1WTHryMc76eduyjLcf_P9DJx4HnA",
    },
  ];

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, String>> displayedUsers = selectedTab == "Planners"
        ? planners
        : vendors;
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
                hintText: "Search users by name or role...",
                filled: true,
                fillColor: isDarkMode ? Colors.black12 : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Tabs
          Row(children: [_tabItem("Planners"), _tabItem("Vendors")]),
          const SizedBox(height: 8),
          // Animated User list
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: ListView.separated(
                key: ValueKey<String>(selectedTab),
                itemCount: displayedUsers.length,
                separatorBuilder: (_, __) =>
                    Divider(color: primary.withOpacity(0.2), height: 1),
                itemBuilder: (context, index) {
                  final user = displayedUsers[index];
                  Color statusColor;
                  switch (user["status"]) {
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
                          backgroundImage: NetworkImage(user["avatar"]!),
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
                      user["name"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      user["role"]!,
                      style: TextStyle(color: textDark),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  );
                },
              ),
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
