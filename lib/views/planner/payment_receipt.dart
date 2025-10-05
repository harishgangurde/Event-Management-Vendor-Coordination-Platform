import 'package:flutter/material.dart';

// Define the colors used for consistency
const Color kPrimaryColor = Color(0xFF7F06F9);
const Color kAccentPurple = Color(0xFFA564E9);
const Color kSuccessColor = Color(0xFF27AE60); // Green checkmark color
const Color kBackgroundDark = Color(0xFF100819);

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        colorScheme: const ColorScheme.dark().copyWith(primary: kPrimaryColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Payment Receipt',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Success Icon ---
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kSuccessColor, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: kSuccessColor,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Success Text ---
                    const Text(
                      'Payment Successful',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Details of your transaction',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 40),

                    // --- Receipt Details Table ---
                    _buildDetailRow('Event Name', 'Varad & Priya\'s Wedding'),
                    _buildDetailRow('Vendor', 'Rhythm & Hues'),
                    _buildDetailRow(
                      'Amount Paid',
                      '₹50,000.00',
                      isAmount: true,
                    ),
                    _buildDetailRow(
                      'Payment Method',
                      'Visa •••• 4732',
                      hasCardIcon: true,
                    ),
                    _buildDetailRow('Transaction ID', 'pay_NF6jXoY7rZk81P'),
                    _buildDetailRow('Date & Time', '28 Oct 2025, 06:15 PM'),
                    const SizedBox(height: 40),

                    // --- Download Button ---
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          // Implement file download logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Downloading receipt...'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          'Download Receipt',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Footer ---
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Powered by Eventtoria AI',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isAmount = false,
    bool hasCardIcon = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Row(
            children: [
              if (hasCardIcon)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.credit_card, color: Colors.white, size: 18),
                ),
              Text(
                value,
                style: TextStyle(
                  color: isAmount ? kSuccessColor : Colors.white,
                  fontSize: 16,
                  fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
