  // lib/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:op_flutter/pages/about_us/about_us.dart';
import 'package:op_flutter/pages/failed_trans/fail_trans_page.dart';
import 'package:op_flutter/pages/home/home_page.dart';
import 'package:op_flutter/pages/query/query_page.dart';
import 'package:op_flutter/pages/scan_qr_code/qr_code.dart';
import 'package:op_flutter/pages/settlement/settlement_page.dart';
import 'package:op_flutter/pages/system_info/system_page.dart';
import 'package:op_flutter/widgets/password_verify.dart';
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
    /// 密码验证
    static const passwordVerify = '/password-verify';

    static const aboutUs = '/about-us';
  }

  /// 所有路由页面配置
  class AppPages {
    static final routes = [
      GetPage(
        name: AppRoutes.login, // 路由路径
        page: () => OceanPayLoginPage(), // 对应页面
      ),
      GetPage(
        name: AppRoutes.home, // 路由路径
        page: () => HomePage(), // 对应页面
      ),
      GetPage(name: AppRoutes.system, page: ()=> SystemInfoPage(),),
      GetPage(name: AppRoutes.transaction, page: () => SearchPrintPage()),
      GetPage(name: AppRoutes.passwordVerify, page: () => PasswordVerifyPage()),
      GetPage(name: AppRoutes.settlement, page: () => SettlementPage()),
      GetPage(name: AppRoutes.scanQrCode, page: ()=> QRScanPage()),
      GetPage(name: AppRoutes.failTrans, page: () => VoidPage(), middlewares: []),
      GetPage(name: AppRoutes.aboutUs, page: () => AboutPage())
    ];
  }
