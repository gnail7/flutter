import 'package:xml/xml.dart';
import 'package:op_flutter/store/user_controller.dart';

class DirectResp {
  DirectResp({
    required this.account,
    required this.terminal,
    required this.signValue,
    required this.methods,
    required this.orderNumber,
    required this.cardCountry,
    required this.orderCurrency,
    required this.orderAmount,
    required this.orderNotes,
    required this.cardNumber,
    required this.cardType,
    required this.paymentCountry,
    required this.paymentId,
    required this.paymentAuthType,
    required this.paymentStatus,
    required this.paymentDetails,
    required this.paymentSolutions,
    required this.paymentRisk,
    required this.customerId,
    required this.subscribe,
    required this.payBankCode,
    required this.payBarCode,
    required this.createDate,
  });

  /// ===== XML 解析 =====
  factory DirectResp.fromXml(String xmlString) {
    final doc = XmlDocument.parse(xmlString);
    final root = doc.getElement('response');

    if (root == null) {
      throw Exception('Invalid XML: missing <response> root element');
    }

    String _get(String name) => root.getElement(name)?.value ?? '';

    return DirectResp(
      account: _get('account'),
      terminal: _get('terminal'),
      signValue: _get('signValue'),
      methods: _get('methods'),
      orderNumber: _get('order_number'),
      cardCountry: _get('card_country'),
      orderCurrency: _get('order_currency'),
      orderAmount: _get('order_amount'),
      orderNotes: _get('order_notes'),
      cardNumber: _get('card_number'),
      cardType: _get('card_type'),
      paymentCountry: _get('payment_country'),
      paymentId: _get('payment_id'),
      paymentAuthType: _get('payment_authType'),
      paymentStatus: _get('payment_status'),
      paymentDetails: _get('payment_details'),
      paymentSolutions: _get('payment_solutions'),
      paymentRisk: _get('payment_risk'),
      customerId: _get('customer_id'),
      subscribe: _get('subscribe'),
      payBankCode: _get('pay_bankCode'),
      payBarCode: _get('pay_barCode'),
      createDate: DateTime.now(),
    );
  }

  /// ===== 原始字段 =====
  final String account;
  final String terminal;
  final String signValue;
  final String methods;
  final String orderNumber;
  final String cardCountry;
  final String orderCurrency;
  final String orderAmount;
  final String orderNotes;
  final String cardNumber;
  final String cardType;
  final String paymentCountry;
  final String paymentId;
  final String paymentAuthType;
  final String paymentStatus;
  final String paymentDetails;
  final String paymentSolutions;
  final String paymentRisk;
  final String customerId;
  final String subscribe;
  final String payBankCode;
  final String payBarCode;
  final DateTime createDate;

  /// ===== 业务 Getter（对齐 Java） =====

  /// 是否支付成功
  bool get isPaymentSuccess => paymentStatus == '1';

  /// 金额 + 币种（如：USD 12.34）
  String get amountCurrency {
    if (orderCurrency.isEmpty || orderAmount.isEmpty) {
      return '';
    }
    return '$orderCurrency $orderAmount';
  }

  /// 从 orderNumber 中解析 billNo
  String get billNoFromOrderNumber {
    if (orderNumber.isEmpty) {
      return '';
    }

    if (orderNumber.length <= 6) {
      return orderNumber;
    }

    final batchNo = UserController.to.user.value?.batchNo;
    if (batchNo != null && batchNo.isNotEmpty && orderNumber.startsWith(batchNo)) {
      return orderNumber.substring(batchNo.length);
    }

    return orderNumber;
  }

  /// 创建时间（本地格式）
  String get createDateTime {
    return createDate.toLocal().toString();
  }

}
