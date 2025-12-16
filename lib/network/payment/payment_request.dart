class GenerateQrcodeParams {

  GenerateQrcodeParams({
    required this.terminal,
    required this.channelId,
    required this.orderNo,
    required this.amount,
    required this.currency,
    required this.token,
    this.sign,
  });

  final int terminal;
  final String channelId;
  final String orderNo;
  final num amount;
  final String currency;
  final String token;
  final String? sign;

  Map<String, dynamic> toJson() {
    return {
      'terminal': terminal,
      'channelId': channelId,
      'orderNo': orderNo,
      'amount': amount,
      'currency': currency,
      'token': token,
      if (sign != null) 'sign': sign,
    };
  }
}