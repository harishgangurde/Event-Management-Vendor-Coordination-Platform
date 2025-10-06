import 'package:eventtoria/config/app_theme.dart';
import 'package:flutter/material.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      {
        'eventName': 'Grand Wedding Reception',
        'plannerName': 'Rugwed Khairnar',
        'date': 'October 15, 2024',
        'status': 'Pending',
      },
      {
        'eventName': 'Annual Tech Conference',
        'plannerName': 'Jane Doe',
        'date': 'December 5, 2024',
        'status': 'Accepted',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          color: AppTheme.kCardDarkColor,
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request['eventName']!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text('Planner: ${request['plannerName']}',
                    style: const TextStyle(color: Colors.white70)),
                Text('Date: ${request['date']}',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status: ${request['status']}',
                        style: TextStyle(
                            color: request['status'] == 'Pending'
                                ? Colors.orange
                                : Colors.green)),
                    if (request['status'] == 'Pending')
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.kPrimaryColor),
                              child: const Text('Accept')),
                          const SizedBox(width: 8),
                          OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.kAccentPurple),
                              ),
                              child: const Text('Decline')),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}