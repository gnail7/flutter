import 'package:flutter/material.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/widgets/toast.dart';

/// === MOCK 开关：调样式时设为 true，上线前删掉或改成 false ===
const bool useMockPaymentDetail = true;

/// Mock 数据
PaymentRecord mockPaymentRecord() {
  return PaymentRecord(
    orderNo: 'ORD202412180001',
    paymentId: 'PMT123456789',
    paymentMethod: 'WeChat Pay',
    currency: 'SGD',
    amount: 128.50,
    transType: 1, // 1 Sale / 2 Void / 3 Failed
    transTime: '2024-12-18 14:32:10',
  );
}


class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({required this.orderNo, super.key});

  final String orderNo;

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  PaymentRecord? payment;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPaymentDetail();
  }

  Future<void> fetchPaymentDetail() async {
    // ===== MOCK 模式 =====
    if (useMockPaymentDetail) {
      await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络延迟
      setState(() {
        payment = mockPaymentRecord();
        isLoading = false;
      });
      return;
    }

    // ===== 正式接口 =====
    try {
      final token = UserController.to.user.value?.token;
      final terminal = UserController.to.user.value?.terminal;
      final batchNo = UserController.to.user.value?.batchNo;

      if (token == null || terminal == null || batchNo == null) {
        setState(() {
          error = 'User not logged in or batch not set';
          isLoading = false;
        });
        return;
      }

      final res = await QueryApi.fetchTransactionDetail(
        terminal: terminal,
        batchNo: batchNo,
        orderNo: widget.orderNo,
        token: token,
      );

      if (res.code == '0' && res.data != null) {
        setState(() {
          payment = res.data;
          isLoading = false;
        });
      } else {
        showCenterToast('No transaction result', type: ToastType.warning);
        setState(() {
          error = res.message ?? 'Failed to load';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrey,
      appBar: AppBar(
        title: const Text('Payment Detail'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? const Center(child: Text('暂无数据'))
            : _buildDetail(payment!),
      ),
    );
  }

  Widget _buildDetail(PaymentRecord payment) {
    String typeText;
    switch (payment.transType) {
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

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildKV('Type', typeText),
            _buildKV('Currency', payment.currency),
            _buildKV('Amount', payment.amount.toString()),
            const Divider(height: 32),
            _buildKV('Payment Method', payment.paymentMethod),
            _buildKV('Transaction Time', payment.transTime),
            _buildKV('Payment ID', payment.paymentId),
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
                  print('Print Payment: ${payment.paymentId}');
                },
                child: const Text(
                  'Print',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKV(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(key, style: const TextStyle(color: Colors.black54))),
          Text(value),
        ],
      ),
    );
  }
}
