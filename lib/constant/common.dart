class OceanConstants {
  // Intent / Extras keys
  static const String extraIsScanMode = "EXTRA_IS_SCAN_MODE";
  static const String extraAmount = "EXTRA_AMOUNT";
  static const String extraDirectRespJson = "EXTRA_DIRECT_RESP_JSON";
  static const String extraTransDetailJson = "EXTRA_TRANS_DETAIL_JSON";
  static const String extraTransSummaryJson = "EXTRA_TRANS_SUMMARY_JSON";
  static const String extraIsSearchResult = "EXTRA_IS_SEARCH_RESULT";
  static const String extraPasswordLockAction = "EXTRA_PASSWORD_LOCK_ACTION";
  static const String extraOldPassword = "EXTRA_OLD_PASSWORD";
  static const String extraSearchBillNo = "EXTRA_SEARCH_BILL_NO";
  static const String extraSearchAmount = "EXTRA_SEARCH_AMOUNT";
  static const String extraUserJson = "EXTRA_USER_JSON";

  // Time constants
  static const int millisecondsOneDay = 24 * 60 * 60 * 1000;
  static const int settlementDays = 7;
  static const int scanTimeout = 30;
  static const int qrCodeTimeout = 60;
  static const int defaultDialogWaitTime = 2000;

  // UI constants
  static const int toolbarIconSize = 18;
  static const int defaultPageSize = 10;
  static const int showBackToTopCount = 2;

  // Payment methods
  static const String methodWechatPay = "WeChatPay";
  static const String methodAlipay = "Alipay";

  // Item types
  static const int itemTypeSummary = 100;
  static const int itemTypeDetail = 101;

  // Response codes
  static const int respCodeInvalidToken = 95;
  static const int respCodeInvalidTID = 94;
  static const int respCodeInvalidTIDUID = 97;

  // Form validators
  static const int terminalMinLength = 8;
  static const int terminalMaxLength = 9;
  static const int usernameMinLength = 3;
  static const int passwordMinLength = 6;

  // Device
  static const String posDeviceAndroid = "ANDROID";
}
