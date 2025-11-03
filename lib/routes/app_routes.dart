  // lib/routes/app_pages.dart
  import 'package:get/get.dart';
import 'package:op_flutter/pages/State/StateWhat/state_what.dart';
  import 'package:op_flutter/pages/home/home_page.dart';
  import '../pages/login/login_page.dart';

  /// 所有路由路径定义
  class AppRoutes {
    static const login = '/login';
    static const home = '/home';
    static const demo = '/stateDemo';

    // 状态管理模块
    static const stateWhat = '/state/what';
    static const stateHow = '/state/how';

    // 路由管理模块
    static const routerWhat = '/router/what';
    static const routerHow = '/router/how';

    // 网络请求模块
    static const networkWhat = '/network/what';
    static const networkHow = '/network/how';
  }

  /// 所有路由页面配置
  class AppPages {
    static final routes = [
      GetPage(
        name: AppRoutes.login, // 路由路径
        page: () => LoginPage(), // 对应页面
      ),
      GetPage(
        name: AppRoutes.home, // 路由路径
        page: () => HomePage(), // 对应页面
      ),
      GetPage(name: AppRoutes.stateWhat, page: () => StateWhat())
    ];
  }
