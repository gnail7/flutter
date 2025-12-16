import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';

class AmountInputPOS extends StatefulWidget {
  const AmountInputPOS({
    required this.onSuccess,
    this.currency = 'HKD',
    this.descriptionText = 'Please set amount',
    super.key,
  });

  final Function(double amount) onSuccess;
  final String currency;
  final String descriptionText;

  @override
  State<AmountInputPOS> createState() => _AmountInputPOSState();
}

class _AmountInputPOSState extends State<AmountInputPOS> {
  String _digits = '';

  String get displayAmount {
    double amount = 0;
    if (_digits.isNotEmpty) {
      amount = double.parse(_digits) / 100;
    }
    return amount.toStringAsFixed(2);
  }

  void _addDigit(String digit) {
    setState(() {
      if (_digits.length < 9) {
        _digits += digit;
      }
    });
  }

  void _deleteDigit() {
    setState(() {
      if (_digits.isNotEmpty) {
        _digits = _digits.substring(0, _digits.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        title: const Text('Transaction Amount'),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 金额显示区
          Expanded(
            child: Container(
              color: AppColor.primaryColor,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.currency} $displayAmount',
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.descriptionText,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // OK 按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final inputAmount = double.tryParse(displayAmount);
                  if (inputAmount != null && inputAmount != 0) {
                    widget.onSuccess(inputAmount);
                  }

                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // 数字键盘
          _buildNumPad(),
        ],
      ),
    );
  }

  Widget _buildNumPad() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
            ['del', '0', 'confirm'] // 改为 'confirm' 表示确认按钮
          ])
            Row(
              children: row.map((e) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (e == 'del') {
                        _deleteDigit();
                      } else if (e == 'confirm') {
                        final inputAmount = double.tryParse(displayAmount);
                        if (inputAmount != null && inputAmount != 0) {
                          widget.onSuccess(inputAmount);
                        }
                      } else if (e.isNotEmpty) {
                        _addDigit(e);
                      }
                    },
                    child: Container(
                      height: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(1),
                      color: Colors.white,
                      child: e == 'del'
                          ? const Icon(Icons.backspace_outlined)
                          : e == 'confirm'
                          ? const Icon(Icons.check, size: 32)
                          : Text(
                        e,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

}
