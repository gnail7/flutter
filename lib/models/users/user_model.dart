class User {
  final String token;
  final int account;
  final int terminal;
  final String userName;
  final String merName;
  final String batchNo;
  final String orderNo;
  final String logoUrl;
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
  final String secureKey;

  User({
    required this.token,
    required this.account,
    required this.terminal,
    required this.userName,
    required this.merName,
    required this.batchNo,
    required this.orderNo,
    required this.logoUrl,
    required this.merAddr,
    required this.secureCode,
    required this.publicKey,
    required this.currency,
    required this.printReceipt,
    required this.voidNeedPass,
    required this.secureKey,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json["token"] ?? "",
      account: json["account"] ?? 0,
      terminal: json["terminal"] ?? 0,
      userName: json["userName"] ?? "",
      merName: json["merName"] ?? "",
      batchNo: json["batchNo"] ?? "",
      orderNo: json["orderNo"] ?? "",
      logoUrl: json["logoUrl"] ?? "",
      merAddr: json["merAddr"] ?? "",
      secureCode: json["secureCode"] ?? "",
      publicKey: json["publicKey"] ?? "",
      currency: json["currency"] ?? "",
      printReceipt: json["printReceipt"] ?? 0,
      voidNeedPass: json["voidNeedPass"] ?? 0,
      voidPass: json["voidPass"],
      settNeedPass: json["settNeedPass"] ?? 0,
      settPass: json["settPass"],
      settingsPass: json["settingsPass"],
      multiUser: json["multiUser"] ?? 0,
      supportPayType: json["supportPayType"] ?? 0,
      clearLoginDays: json["clearLoginDays"] ?? 0,
      companyInfo: json["companyInfo"] ?? "",
      companyContact: json["companyContact"] ?? "",
      role: json["role"] ?? 0,
      supportCurrencies: json["supportCurrencies"] ?? "",
      externalCall: json["externalCall"] ?? 0,
      secureKey: json["secureKey"] ?? 0
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "account": account,
    "terminal": terminal,
    "userName": userName,
    "merName": merName,
    "batchNo": batchNo,
    "orderNo": orderNo,
    "logoUrl": logoUrl,
    "merAddr": merAddr,
    "secureCode": secureCode,
    "publicKey": publicKey,
    "currency": currency,
    "printReceipt": printReceipt,
    "voidNeedPass": voidNeedPass,
    "voidPass": voidPass,
    "settNeedPass": settNeedPass,
    "settPass": settPass,
    "settingsPass": settingsPass,
    "multiUser": multiUser,
    "supportPayType": supportPayType,
    "clearLoginDays": clearLoginDays,
    "companyInfo": companyInfo,
    "companyContact": companyContact,
    "role": role,
    "supportCurrencies": supportCurrencies,
    "externalCall": externalCall,
  };
}
