import 'package:flutter/material.dart';
import 'package:op_flutter/network/direct_pay/direct_pay.dart';
import 'package:op_flutter/routes/app_routes.dart';
import 'package:op_flutter/theme/app_colors.dart';
import 'package:op_flutter/models/query/payment_record.dart';
import 'package:op_flutter/network/query/api.dart';
import 'package:op_flutter/store/user_controller.dart';
import 'package:op_flutter/widgets/custom_loading_dialog.dart';
import 'package:op_flutter/widgets/toast.dart';
import 'package:get/get.dart';

import '../../models/query/void_resp.dart';

class VoidDetailPage extends StatefulWidget {
  const VoidDetailPage({
    required this.orderNo,
    super.key,
  });

  final String orderNo;

  @override
  State<VoidDetailPage> createState() => _VoidDetailPageState();
}

class _VoidDetailPageState extends State<VoidDetailPage> {
  PaymentRecord? _payment;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchByOrderNo(widget.orderNo);
  }

  Future<void> _fetchByOrderNo(String orderNo) async {
    setState(() => _loading = true);

    try {
      final user = UserController.to.user.value;
      if (user == null) {
        throw Exception('User not login');
      }

      final res = await QueryApi.fetchTransactionDetail(
        terminal: user.terminal!,
        batchNo: user.batchNo!,
        orderNo: orderNo,
        token: user.token!,
      );

      if (res.code == '0' && res.data != null) {
        _payment = res.data;
      } else {
        _error = res.message ?? 'No transaction result';
        showCenterToast(_error!, type: ToastType.warning);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(
      isLoading: _loading,
      child: Scaffold(
        backgroundColor: AppColor.bgGrey,
        appBar: AppBar(
          title: const Text('Void Detail'),
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: _payment == null ? null : () => _print(_payment!),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildBody(),
        ),
      ),
    );
}

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return const Center(child: Text('暂无数据'));
    }

    if (_payment == null) {
      return const SizedBox();
    }

    return _VoidDetailCard(
      payment: _payment!,
      onConfirm: _confirmVoid,
    );
  }

  void _confirmVoid() async {
    if (_payment == null) return;

    setState(() => _loading = true);

    try {
      final xmlString = await DirectPayApi.voidTransaction(
        paymentId: _payment!.paymentId,
        orderNumber: _payment!.orderNo,
      );

      final resp = VoidResp.fromXml(xmlString);

      if (resp.isVoidSuccess) {
        showCenterToast(resp.paymentDetails, type: ToastType.success);
        await Future.delayed(const Duration(milliseconds: 1000));
        Get.offAllNamed(AppRoutes.home);
      } else {
        showCenterToast(resp.paymentDetails, type: ToastType.error);
      }
    } catch (e) {
      showCenterToast('Void failed: $e', type: ToastType.error);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _print(PaymentRecord payment) {
    // TODO: 调 void receipt 打印
    debugPrint('Print void receipt: ${payment.paymentId}');
  }
}


class _VoidDetailCard extends StatelessWidget {
  const _VoidDetailCard({
    required this.payment,
    required this.onConfirm,
  });

  final PaymentRecord payment;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final typeText = switch (payment.transType) {
      2 => 'Void',
      1 => 'Sale',
      _ => 'Failed',
    };

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _kv('Type', typeText),
            _kv('Currency', payment.currency),
            _kv('Amount', payment.amount.toString()),
            const Divider(height: 32),
            _kv('Payment Method', payment.paymentMethod),
            _kv('Transaction Time', payment.transTime),
            _kv('Payment ID', payment.paymentId),
            _kv('Status', typeText),
            const Spacer(),

            /// ✅ 底部 Confirm 按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                ),
                onPressed: onConfirm,
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: const TextStyle(color: Colors.black54)),
          ),
          Text(v),
        ],
      ),
    );
  }
}
