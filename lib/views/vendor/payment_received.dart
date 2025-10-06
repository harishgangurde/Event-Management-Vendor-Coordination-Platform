import 'package:flutter/material.dart';
import 'package:eventtoria/config/app_theme.dart';

class PaymentReceivedScreen extends StatelessWidget {
  const PaymentReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Payment Received',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.kSuccessColor, width: 2),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.kSuccessColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Received',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Transaction details below',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              _buildDetailRow('Event Name', "Varad's Birthday Bash"),
              _buildDetailRow('Planner', 'Rugwed Khairnar'),
              _buildDetailRow(
                'Amount Received',
                '₹25,000.00',
                isAmount: true,
              ),
              _buildDetailRow('Transaction ID', 'pay_NF6jXoY7rZk81P'),
              _buildDetailRow('Date & Time', '28 Oct 2025, 06:15 PM'),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context)
                      .popUntil((route) => route.isFirst), // Go back to dashboard
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              color: isAmount ? AppTheme.kSuccessColor : Colors.white,
              fontSize: 16,
              fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}