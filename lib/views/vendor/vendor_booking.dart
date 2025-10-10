import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorBooking extends StatefulWidget {
  const VendorBooking({super.key});

  @override
  State<VendorBooking> createState() => _VendorBookingState();
}

class _VendorBookingState extends State<VendorBooking> {
  // Sample booking request data
  final List<Map<String, dynamic>> _bookings = [
    {
      'event': 'Gala Night',
      'planner': 'Sophia Carter',
      'price': '₹2,00,000',
      'status': 'Pending',
    },
    {
      'event': 'Corporate Summit',
      'planner': 'Acme Corp',
      'price': '₹4,50,000',
      'status': 'Pending',
    },
    {
      'event': 'Wedding Reception',
      'planner': 'Emily & David',
      'price': '₹3,20,000',
      'status': 'Pending',
    },
    {
      'event': 'Charity Gala',
      'planner': 'Olivia Brown',
      'price': '₹2,80,000',
      'status': 'Pending',
    },
  ];

  // Update status for Accept / Decline
  void _updateStatus(int index, String newStatus) {
    setState(() {
      _bookings[index]['status'] = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking "${_bookings[index]['event']}" marked as $newStatus',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        backgroundColor:
            newStatus == 'Accepted' ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A102E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A102E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Requests',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2B1C4C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Event',
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          booking['event'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Planner
                  _infoRow('Planner', booking['planner']),
                  const SizedBox(height: 16),

                  // Quoted Price
                  _infoRow(
                    'Quoted Price',
                    booking['price'],
                    valueColor: const Color(0xFFB184FF),
                    valueWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 16),

                  // Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: booking['status'] == 'Pending'
                              ? const Color(0xFF3B217A)
                              : booking['status'] == 'Accepted'
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              booking['status'],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Accept / Decline buttons
                  if (booking['status'] == 'Pending')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateStatus(index, 'Declined'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B217A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'Decline',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateStatus(index, 'Accepted'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9B62FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'Accept',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {Color valueColor = Colors.white70,
      FontWeight valueWeight = FontWeight.w500}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: valueColor,
            fontSize: 15,
            fontWeight: valueWeight,
          ),
        ),
      ],
    );
  }
}
