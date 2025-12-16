import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_flutter/theme/app_colors.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({required this.payment, super.key});

  final Map<String, dynamic> payment;

  @override
  Widget build(BuildContext context) {
    final type = payment['transType'];
    String typeText;
    switch (type) {
      case 1:
        typeText = 'Sale';
        break;
      case 2:
        typeText = 'Void';
        break;
      case 3:
      default:
        typeText = 'Failed';
        break;
    }

    final currency = payment['currency'] ?? '-';
    final amount = payment['amount']?.toString() ?? '-';

    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        title: const Text('Payment Detail'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildKV('Type', typeText),
                _buildKV('Currency', currency),
                _buildKV('Amount', amount),
                const Divider(height: 32),
                _buildKV('Payment Method', payment['paymentMethod'] ?? '-'),
                _buildKV('Transaction Time', payment['transTime'] ?? '-'),
                _buildKV('Payment ID', payment['paymentId'] ?? '-'),
                _buildKV('Status', typeText),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // TODO: 打印单笔交易
                      print('Print Payment: ${payment['paymentId']}');
                    },
                    child: const Text(
                      'Print',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKV(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              child: Text(key, style: const TextStyle(color: Colors.black54))),
          Text(value),
        ],
      ),
    );
  }
}
