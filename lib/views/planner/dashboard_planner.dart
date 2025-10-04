import 'package:flutter/material.dart';

class PlannerDashboard extends StatelessWidget {
  const PlannerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF7F06F9);
    final backgroundLight = const Color(0xFFF7F5F8);
    final backgroundDark = const Color(0xFF190F23);
    final cardDark = const Color(0xFF1A0F2E);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: backgroundLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFA564E9), Color(0xFF7F06F9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "AI",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Eventtoria",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming Events
                    const Text(
                      "Upcoming Events",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _eventCard(
                            "Grand Wedding Reception",
                            "October 15, 2024",
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuD_Ash2Dj4N9PtV17blvYUe7qVvOsgC78FhI00SEsv3lTXm79zPbeB_wMP5GF0_p0Vp0ykZ0wHxsJgRGVmhJE6EQ-wKdZ53fMXHtiNzxkjCoqUhjNNty4WV6DNXP8M6wP7Zkj3HioboLOWsQ06LnA2zF6fPGjqkat5WqiFcUvcfWWnGDBaaM57iINr-7mZ3YUw9U4VscEoBPXee7QrH10EVIpz-aD-n4xOGgNwObC2mesZ0p1iXPLQAEP4bl3etq4nLHUaZx47kRg",
                          ),
                          _eventCard(
                            "Sarah's 30th Birthday Bash",
                            "November 20, 2024",
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuCf_Lzl1Hjb5S11jAbYSAOVsuGYadtVWfDIOhZQJkB2Zu-wVzgDkKeETfNwNyAoJDMBg1WTlcWSYhSfIHgIMryrUXx1H0ftvqxCBdLILOFGW5ADf6JUZvT2a1NgJmF8i5QRQMTPW_I5TxwURAT_Sql-sUaoxWf4_Oafl8y5MLm9UqafUafcHr5oTr5BdAXuP0WMYsB2vYyA9OnvAb5pU3o_E8NKmz9IoLz1s7ERPDmUQFiAoGK1-HP_-gmwJpdcc2oUDjBeZHZZSQ",
                          ),
                          _eventCard(
                            "Annual Tech Conference",
                            "December 5, 2024",
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuAfapVUQ7y0jqz7fxo6eNppTMDVv32X-FnS16MU43OKx4ZShcRLkjWyHEjCiEiWSSN9F3C4dG4T9MwprZQmxq6hdUaOlBEqxwpHy-q3QxVDjp4Z7PopL7K998uBQS7BSHSLmb1JQcuPO20FA83KbYTyW7c8YcEJikXNIXWlAmMreNgpcuMCewts7lXTM576ueEb1WKxfg5rjKSTwLUPN1r_ZZ-aPqAoYxjGhs3sFWBXCYcr87ubtkeR_95Cce_oByJLf_EOOV4XrQ",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Quick Stats
                    const Text(
                      "Quick Stats",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: [
                        _statsCard("Budget", "₹500,000", primaryColor),
                        _statsCard("Guest Count", "250", primaryColor),
                        _statsCard("Pending Tasks", "15", primaryColor, crossAxis: 2),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // AI Suggestions
                    const Text(
                      "AI Suggestions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _aiSuggestionCard(
                      "Top Vendor Picks",
                      "Based on your event needs",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDe8RNX9aJTJc0_U_Q2K7nXHlBOErHYBnfhCXCun0ywU39BkJPqGcILbQLYCLZlkFIMdMsOtrfaGXOX5H4xR28xatdcqxxCsoJfn6JmRqMCvg4ytkQuyV-DlNS6l4WoE-K7MSy9KRuRX52a9PSpwQzL3GUwt3T8h7Bix2zIXw-7KLmbI0E-ebhjYZf0cCssePLTvMzeGdA9LNuz7brlhftfwPtdkv6_9U4a0ONlLzHq0Rg",
                      primaryColor,
                    ),
                    _aiSuggestionCard(
                      "Theme Ideas",
                      "Get inspired for your next event",
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuAdPtPRWEsoWU_Xti_SM6Lclw3_Cd7p3WYNipFluM_tgGpcOjmpc7eD0TDClPLS7Nvh9oart8GzbvW64v1vcRHTB48JhWFhC_sxFQ_1sXin9xZIr7EJh-A43VVQsI2SrGw5KyTLOKySaXkD-i9j11VtcZqx1X3LTvAKFV-LAbDaHpA6oubPE0VrENs3aRMTTOgSDm74G52cEy0UEgrc-ZtjKoLKQw932IEbghmldkRbIwhRuZG3Fh0bbN1feQbFix6rf2x0NEK6GQ",
                      primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notify"),
        ],
      ),
    );
  }

  // Widget for Event Cards
  Widget _eventCard(String title, String date, String image) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget for Stats Cards
  Widget _statsCard(String title, String value, Color color, {int crossAxis = 1}) {
    return GridTile(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  // Widget for AI Suggestion Cards
  Widget _aiSuggestionCard(String title, String subtitle, String image, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
            label: const Text("View", style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }
}
