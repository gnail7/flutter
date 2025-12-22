  // lib/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:op_flutter/pages/failed_trans/fail_trans_page.dart';
import 'package:op_flutter/pages/home/home_page.dart';
import 'package:op_flutter/pages/login/login_binding.dart';
import 'package:op_flutter/pages/qr_code/qr_code.dart';
import 'package:op_flutter/pages/query/query_page.dart';
import 'package:op_flutter/pages/query/search_result_page.dart';
import 'package:op_flutter/pages/query/summary_page.dart';
import 'package:op_flutter/pages/scan_qr_code/qr_code.dart';
import 'package:op_flutter/pages/settlement/settlement_page.dart';
import 'package:op_flutter/pages/system_info/about_us/about_us.dart';
import 'package:op_flutter/pages/system_info/reset_password/reset_password.dart';
import 'package:op_flutter/pages/system_info/settings.dart';
import 'package:op_flutter/pages/system_info/system_page.dart';
import 'package:op_flutter/pages/void/void_detail.dart';
import 'package:op_flutter/pages/void/void_page.dart';
import '../pages/login/login_page.dart';

  /// 所有路由路径定义
  class AppRoutes {
    static const login = '/login';
    static const home = '/home';
    static const system = '/system';
    /// 扫码
    static const scanQrCode = '/scan-qr-code';
    /// 查询模块
    static const transaction = '/transaction';
    /// 清空模块
    static const settlement = '/settlement';
    /// 撤回模块
    static const voidPage = '/void';
    /// 失败交易模块
    static const failTrans = '/failed-trans';
    /// 二维码被扫页面
    static const qrCode = '/qr-code';
    /// 查询汇总页面
    static const querySummaryPage = '/query-summary-page';
    /// 交易详情页面
    static const paymentDetailPage = '/payment-detail-page';
    /// 重制密码
    static const resetPassword = '/reset-password';
    /// 关于我们
    static const aboutUs = '/about-us';
    /// 用户管理
    static const userManagement = '/user-management';
    /// 搜索结果页面
    static const searchResultPage = '/searchResult';

    static const setting = '/setting';
  }

  /// 所有路由页面配置
  class AppPages {
    static final routes = [
      GetPage(
        name: AppRoutes.login, // 路由路径
        page: () => OceanPayLoginPage(), // 对应页面
        binding: LoginBinding()
      ),
      GetPage(
        name: AppRoutes.home, // 路由路径
        page: () => HomePage(), // 对应页面
      ),
      GetPage(name: AppRoutes.system, page: ()=> SystemInfoPage(),),
      GetPage(name: AppRoutes.transaction, page: () => SearchPrintPage()),
      GetPage(name: AppRoutes.settlement, page: () => const SettlementPageEntry()),
      GetPage(name: AppRoutes.scanQrCode, page: ()=> QRScanEntryPage()),
      GetPage(name: AppRoutes.voidPage, page: () => VoidPageEntry()),
      GetPage(name: AppRoutes.aboutUs, page: () => const AboutPage()),
      GetPage(name: AppRoutes.qrCode, page: () => QrCodePage()),
      GetPage(name: AppRoutes.querySummaryPage, page: () => SummaryPage()),
      GetPage(name: AppRoutes.resetPassword, page: () => const ChangePasswordEntry()),
      GetPage(
        name: AppRoutes.searchResultPage,
        page: () => SearchResultPage(),
      ),
      GetPage(name: AppRoutes.failTrans, page: () => FailedTransactionPage()),
      GetPage(name: AppRoutes.setting, page: () => const SettingPage())
    ];
  }
