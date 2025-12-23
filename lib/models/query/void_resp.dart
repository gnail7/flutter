import 'package:xml/xml.dart';

class VoidResp {

  VoidResp({
    required this.account,
    required this.terminal,
    required this.signValue,
    required this.orderNumber,
    required this.paymentId,
    required this.paymentStatus,
    required this.paymentDetails,
  });

  /// 从 XML 字符串解析
  factory VoidResp.fromXml(String xmlString) {
    final doc = XmlDocument.parse(xmlString);
    final root = doc.getElement('respon');
    if (root == null) {
      throw Exception('Invalid XML: missing <respon> root element');
    }

    return VoidResp(
      account: root.getElement('account')?.value ?? '',
      terminal: root.getElement('terminal')?.value ?? '',
      signValue: root.getElement('signValue')?.value ?? '',
      orderNumber: root.getElement('order_number')?.value ?? '',
      paymentId: root.getElement('payment_id')?.value ?? '',
      paymentStatus: root.getElement('payment_status')?.value ?? '0',
      paymentDetails: root.getElement('payment_details')?.value ?? '',
    );
  }
  final String account;
  final String terminal;
  final String signValue;
  final String orderNumber;
  final String paymentId;
  final String paymentStatus;
  final String paymentDetails;

  /// 是否撤销成功
  bool get isVoidSuccess => paymentStatus == '1';
}
