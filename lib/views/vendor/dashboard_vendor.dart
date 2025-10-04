import 'package:flutter/material.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F8), // background-light
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F8),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA564E9), Color(0xFF7F06F9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Vendor Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Events Section
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _eventCard(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuD_Ash2Dj4N9PtV17blvYUe7qVvOsgC78FhI00SEsv3lTXm79zPbeB_wMP5GF0_p0Vp0ykZ0wHxsJgRGVmhJE6EQ-wKdZ53fMXHtiNzxkjCoqUhjNNty4WV6DNXP8M6wP7Zkj3HioboLOWsQ06LnA2zF6fPGjqkat5WqiFcUvcfWWnGDBaaM57iINr-7mZ3YUw9U4VscEoBPXee7QrH10EVIpz-aD-n4xOGgNwObC2mesZ0p1iXPLQAEP4bl3etq4nLHUaZx47kRg',
                    'Grand Wedding Reception',
                    'October 15, 2024',
                  ),
                  _eventCard(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCf_Lzl1Hjb5S11jAbYSAOVsuGYadtVWfDIOhZQJkB2Zu-wVzgDkKeETfNwNyAoJDMBg1WTlcWSYhSfIHgIMryrUXx1H0ftvqxCBdLILOFGW5ADf6JUZvT2a1NgJmF8i5QRQMTPW_I5TxwURAT_Sql-sUaoxWf4_Oafl8y5MLm9UqafUafcHr5oTr5BdAXuP0WMYsB2vYyA9OnvAb5pU3o_E8NKmz9IoLz1s7ERPDmUQFiAoGK1-HP_-gmwJpdcc2oUDjBeZHZZSQ',
                    'Sarah\'s 30th Birthday Bash',
                    'November 20, 2024',
                  ),
                  _eventCard(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAfapVUQ7y0jqz7fxo6eNppTMDVv32X-FnS16MU43OKx4ZShcRLkjWyHEjCiEiWSSN9F3C4dG4T9MwprZQmxq6hdUaOlBEqxwpHy-q3QxVDjp4Z7PopL7K998uBQS7BSHSLmb1JQcuPO20FA83KbYTyW7c8YcEJikXNIXWlAmMreNgpcuMCewts7lXTM576ueEb1WKxfg5rjKSTwLUPN1r_ZZ-aPqAoYxjGhs3sFWBXCYcr87ubtkeR_95Cce_oByJLf_EOOV4XrQ',
                    'Annual Tech Conference',
                    'December 5, 2024',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Stats Section
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              children: [
                _statCard('Budget', '₹500,000'),
                _statCard('Guest Count', '250'),
                _statCard('Pending Tasks', '15', crossAxis: 2),
              ],
            ),
            const SizedBox(height: 24),
            // AI Suggestions Section
            const Text(
              'AI Suggestions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _aiSuggestionCard(
                  'Top Vendor Picks',
                  'Based on your event needs',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDe8RNX9aJTJc0_U_Q2K7nXHlBOErHYBnfhCXCun0ywU39BkJPqGcILbQLYCLZlkFIMdMsOtrfaGXOX5H4xR28xatdcqxxCsoJfn6JmRqMCvg4ytkQuyV-DlNS6l4WoE-K7MSy9KRuRX52a9PSpwQzL3GUwt3T8h7Bix2zIXw-7KLmbI0E-ebhjYZf0cCssePLTvMzeGdA9LNuz7brlhftfwPtdkv6_9U4a0ONlLzHq0Rg',
                ),
                const SizedBox(height: 12),
                _aiSuggestionCard(
                  'Theme Ideas',
                  'Get inspired for your next event',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAdPtPRWEsoWU_Xti_SM6Lclw3_Cd7p3WYNipFluM_tgGpcOjmpc7eD0TDClPLS7Nvh9oart8GzbvW64v1vcRHTB48JhWFhC_sxFQ_1sXin9xZIr7EJh-A43VVQsI2SrGw5KyTLOKySaXkD-i9j11VtcZqx1X3LTvAKFV-LAbDaHpA6oubPE0VrENs3aRMTTOgSDm74G52cEy0UEgrc-ZtjKoLKQw932IEbghmldkRbIwhRuZG3Fh0bbN1feQbFix6rf2x0NEK6GQ',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF7F06F9),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notify',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _eventCard(String imageUrl, String title, String date) {
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
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, {int crossAxis = 1}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF7F06F9).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7F06F9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _aiSuggestionCard(String title, String subtitle, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F06F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('View', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
