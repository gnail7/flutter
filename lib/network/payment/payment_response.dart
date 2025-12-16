class GenerateQrcodeResponse {

  GenerateQrcodeResponse({
    required this.paymentUrl,
    required this.timeout,
  });

  factory GenerateQrcodeResponse.fromJson(Map<String, dynamic> json) {
    return GenerateQrcodeResponse(
      paymentUrl: json['paymentUrl'] as String,
      timeout: json['timeout'] as int,
    );
  }
  final String paymentUrl;
  final int timeout;
}
