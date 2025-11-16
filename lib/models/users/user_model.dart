class User {
  final String token;
  final int account;
  final int terminal;
  final String merName;
  final String batchNo;
  final String orderNo;
  final String? logoUrl;
  final String merAddr;
  final String secureCode;
  final String publicKey;
  final String currency;
  final int printReceipt;
  final int voidNeedPass;
  final String? voidPass;
  final int settNeedPass;
  final String? settPass;
  final String? settingsPass;
  final int multiUser;
  final int supportPayType;
  final int clearLoginDays;
  final String companyInfo;
  final String companyContact;
  final int role;
  final String supportCurrencies;
  final int externalCall;

  User({
    required this.token,
    required this.account,
    required this.terminal,
    required this.merName,
    required this.batchNo,
    required this.orderNo,
    this.logoUrl,
    required this.merAddr,
    required this.secureCode,
    required this.publicKey,
    required this.currency,
    required this.printReceipt,
    required this.voidNeedPass,
    this.voidPass,
    required this.settNeedPass,
    this.settPass,
    this.settingsPass,
    required this.multiUser,
    required this.supportPayType,
    required this.clearLoginDays,
    required this.companyInfo,
    required this.companyContact,
    required this.role,
    required this.supportCurrencies,
    required this.externalCall,
  });

  /// fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      account: json['account'],
      terminal: json['terminal'],
      merName: json['merName'] ?? '',
      batchNo: json['batchNo'],
      orderNo: json['orderNo'],
      logoUrl: json['logoUrl'],
      merAddr: json['merAddr'],
      secureCode: json['secureCode'],
      publicKey: json['publicKey'],
      currency: json['currency'] ?? '',
      printReceipt: json['printReceipt'],
      voidNeedPass: json['voidNeedPass'],
      voidPass: json['voidPass'],
      settNeedPass: json['settNeedPass'],
      settPass: json['settPass'],
      settingsPass: json['settingsPass'],
      multiUser: json['multiUser'],
      supportPayType: json['supportPayType'],
      clearLoginDays: json['clearLoginDays'],
      companyInfo: json['companyInfo'] ?? '',
      companyContact: json['companyContact'] ?? '',
      role: json['role'],
      supportCurrencies: json['supportCurrencies'] ?? '',
      externalCall: json['externalCall'],
    );
  }

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'account': account,
      'terminal': terminal,
      'merName': merName,
      'batchNo': batchNo,
      'orderNo': orderNo,
      'logoUrl': logoUrl,
      'merAddr': merAddr,
      'secureCode': secureCode,
      'publicKey': publicKey,
      'currency': currency,
      'printReceipt': printReceipt,
      'voidNeedPass': voidNeedPass,
      'voidPass': voidPass,
      'settNeedPass': settNeedPass,
      'settPass': settPass,
      'settingsPass': settingsPass,
      'multiUser': multiUser,
      'supportPayType': supportPayType,
      'clearLoginDays': clearLoginDays,
      'companyInfo': companyInfo,
      'companyContact': companyContact,
      'role': role,
      'supportCurrencies': supportCurrencies,
      'externalCall': externalCall,
    };
  }
}


enum UserType {
  single, // 单用户 1
  multi,  // 多用户 2
}

