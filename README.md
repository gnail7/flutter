## step 1 描述

xxx 简介：Flutter 是一个跨平台的 UI 工具集，它的设计初衷，就是允许在各种操作系统上复用同样的代码，例如 iOS 和 Android，同时让应用程序可以直接与底层平台服务进行交互。如此设计是为了让开发者能够在不同的平台上，都能交付拥有原生体验的高性能应用，尽可能地共享复用代码的同时，包容不同平台的差异。

简单来说就是实现单一代码库，可以在不同的设备上面运行。

### page 2

那么其实我们前端也是有很多跨平台的框架的，比如说 react native 和 uniapp(就是我们公司现在正在用的这么一个框架，我们可以从这几个框架实现跨平台的方案来进行 flutter 的学习)

由于 Android 和 iOS 的 UI 渲染机制完全不同（分别基于 Skia 与 CoreGraphics，并最终通过 OpenGL / Metal 等图形接口驱动 GPU 绘制），跨平台框架在调用系统绘制接口时需要适配大量差异。
uni-app 的方案是利用各操作系统原生提供的 WebView 控件 作为统一渲染容器，借助 Web 技术完成界面绘制，并通过 JSBridge 与原生层通信，从而实现单一代码库、多平台一致的运行效果。

那么我们可以比较一下这三个跨平台的框架都是如何实现的。

- uni-app 的做法是：开发者使用 HTML、CSS、JavaScript（基于 Vue 语法） 编写页面逻辑，框架在编译时会将这些代码打包成可在 WebView 中运行的资源文件。
  当 App 启动后，WebView 负责渲染 UI 界面，而通过 JSBridge，JavaScript 层可以与原生层交互（如调用相机、蓝牙、定位等原生能力）。
  这样，开发者只需维护一套前端代码，就能在 Android、iOS 乃至 Web 等多个平台上运行，实现真正的“一次开发，多端运行”。

- react native，从名字就可以看出点端倪，native 就是原生的，在 uni-app 的虽然也通过 jsbrdge 与原生层交互，但 uni-app 渲染的是 WebView 内的网页内容，而 react native 完全是通过 jsbridge，
  React Native 最终渲染的是系统原生控件，而 uni-app 渲染的是 WebView 内的网页内容；两者都依赖 JSBridge，但 RN 的 Bridge 更深入地参与了 UI 渲染流程。

- flutter，实现跨平台的方案就是使用自绘引擎，不使用对应系统的控件而是自己调用绘制图形的接口实现了自己的渲染引擎，所以无论在任何系统都能保证 ui 的一致性

| 对比项   | **uni-app**                  | **React Native**      | **Flutter**                   |
| :------- | :--------------------------- | :-------------------- | :---------------------------- |
| 技术栈   | Vue / JavaScript             | React / JavaScript    | Dart                          |
| 渲染方式 | WebView（或 nvue 原生渲染）  | 原生控件渲染          | 自绘引擎（Skia）              |
| 性能     | 中等                         | 接近原生              | 接近原生甚至更优              |
| 开发成本 | 低（Web 开发者易上手）       | 中（需前端+原生知识） | 高（需学 Dart）               |
| 生态     | 成熟，小程序支持强           | 成熟，生态稳定        | 快速增长，生态完善            |
| 典型场景 | 中小型 App、小程序、混合应用 | 原生 App、高性能需求  | 高性能跨平台 App、全自定义 UI |
| 代表产品 | 支付宝、头条小程序、快应用   | Facebook、滴滴、携程  | 闪送、阿里咸鱼、京东          |

### 如何快速开始 flutter 的开发

#### Dart 的语言特性

【图片展示（与 ts 相近）】
Dart 是由 Google 开发的一种面向对象、强类型的语言，专门为构建高性能、多平台应用设计。
它兼具 脚本语言的灵活性 与 系统语言的高性能。
Dart 的几个核心特性如下：

- AOT 和 JIT
  即时编译 + 预编译（运行的时候使用即使编译，代码更改之后会热重载看到代码变动带来的影响，提示开发效率）
  在发布时 AOT 编译成原生机器码（无需 VM、启动更快）。（所以这个也是 flutter 相比 uniapp 以及 react native 来说可能性能更好的一个点，因为 js 是 jit）

- 强类型
  js 是一个弱语言类型，使用 dart 开发很多错误是能在编译阶段就能发现错误的。

- 单线程 & 与 js 同样是单线程 （js 与 dart 的 event loop 图片比较）
  单线程的语言都会面临一个问题就是遇到耗费时间长的一些任务，会被阻塞，与 js 一样的是，Dart 的运行时模型也是基于事件循环。那大致的事件循环的机制就是在任务的执行栈中按照顺序一个一个执行任务，当遇到耗时长的任务（这种耗费时间长的任务也就是异步任务）为避免堵塞就将这些任务挂起，然后将这些异步任务对应的回调函数注册到 callback 注册表，当异步任务执行完成之后将对应的回调任务 push 进去执行栈执行。

- ODD 面向对象

#### 使用 flutter 进行布局

- 核心概念`Widget`, `StatelessWidget`,`StatefulWidget`

Widget 是 Flutter UI 的基本构建块，相当于前端的组件或 HTML 元素，Flutter 中一切都是 Widget：布局（Row/Column）、容器（Container）、文本（Text）、图片（Image）、按钮（ElevatedButton）等等。比如说我们要展示一张卡片，那么可以像这段代码一样描述这个卡片是什么样的

```
  // 模块卡片
  Widget _buildCard(String title, int color, IconData icon, String routeName) {
    return GestureDetector(
      onTap: () {
        print('routername $routeName');
        Get.toNamed(routeName);
      },
      child: Container(
        width: 160,
        height: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.grey[700]),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
```

这样子我们就已经写好了一个按钮的样式，接下来就是把这个按钮渲染到页面中。渲染到页面上需要继承 `StatelessWidget`,`StatefulWidget`这两个类，然后我们对`build`方法重写，将我们的组件像搭积木一样，搭进去，把组件放到想放到的位置就行了，这样子就大功告成啦。

-在 Flutter 中，我们通常通过继承 StatelessWidget 或 StatefulWidget 来创建页面或组件，并在其中重写 build 方法，将各个 Widget 组合起来渲染到界面上。

这两者的主要区别在于是否需要维护可变状态：

对于不会随时间或交互变化的静态组件，使用 StatelessWidget；

对于需要根据用户操作或数据变化动态更新界面的组件，使用 StatefulWidget。

Flutter 的视图更新是通过 diff 算法 实现的。当某个状态组件（StatefulWidget）调用 setState 导致状态变化时，框架会触发一次重新构建（build），并将新的 Widget 树与旧的进行对比（diff）。

在这个过程中，Flutter 会智能地识别出哪些部分发生了变化，只重新构建对应的子树，而对未变化的部分进行复用，从而实现高效的界面更新。

### 状态管理

状态管理，通俗的来讲就是页面组件需要渲染展示哪些数据，逻辑依赖哪些数据，这些状态该放在哪里管理。像上面说到的 StatefulWidget 是维护有状态的组件，看下 StatefulWidget 是如何进行状态的管理.首先要明白一个概念就是 flutter 的设计理念是，widget 是不可变的，就是对于 ui 配置信息是静态的，你描述 ui 是什么样的，这个 widget 就是什么样的，如果你要更新 widget 的样式那么就需要通过`setState`对状态更新，然后状态更新之后会生成新的一个 widget 去描述新的 ui 配置信息，而不是在原先的基础上进行修改，所以就如下面代码的写法，通过重载 createState，将状态和对应的 widget 绑定，这样子如果要更新状态就可以通过 setState 方法更新视图了。（很像在写 jsx）

```

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // 状态和逻辑在这里
  @override
  Widget build(BuildContext context) {
    return ...
  }
}
```

上面说的状态管理主要是针对单一 Widget 内部的状态，如果仅涉及一个组件，用 setState 就足够了。像父子组件之间的值的传递

```

// 父组件
class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int counter = 0;

  // 子组件回调时更新父组件状态
  void _updateCounter(int newValue) {
    setState(() {
      counter = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('父子组件传值示例')),
      body: Center(
        // 将父组件的数据和回调函数传给子组件
        child: ChildWidget(
          value: counter,
          onValueChanged: _updateCounter,
        ),
      ),
    );
  }
}

```

但是在实际应用中，父子组件之间、或者层级更深的组件往往需要共享状态，这时单纯依靠 setState 就很难管理和维护。就比如这个例子，子组件要拿到父组件的状态就像这样子将值传递且在对应的构造函数要声明接受值以及更新状态方法

```
 const ChildWidget({
    super.key,
    required this.value,
    required this.onValueChanged,
  });
```

当涉及到要共享状态的组件层级更深之后，会造成状态层层传递，难以维护，在这种情况下，可以使用像 GetX 这样的状态管理框架，它能够实现 全局状态管理，让不同组件无论处于哪一层级，都可以访问、修改同一份状态，并且自动触发 UI 更新，从而极大简化了跨组件状态同步的复杂性。

#### getX 的使用

controller 注册，依赖注入、响应式状态更新、全局状态共享。
通过`.obs`进行响应式变量的注册，然后在需要用到对应状态的 widget 中依赖注册`final LoginController controller = Get.put(LoginController(), permanent: true);`,在 build 的 widget 树中将需要响应式更新的部分使用`obx`监听，当状态发生变化的时候会自动重新生成对应的 widget。全局注册对应的状态`Get.put(LoginController(), permanent: true); // permanent: true 保证不会被释放`.
[todolist 的例子讲解]

### 生命周期

StatefulWidget 创建
│
createState()
│
initState() ──> didChangeDependencies()
│
build() <── setState() ──┐
│ │
didUpdateWidget(oldWidget) │
│ │
deactivate() ────────────────┘
│
dispose()

#### 路由管理

getX 同样能够进行路由管理，路由管理就是对 app 的所有的页面进行一个管理，包含路由跳转的行为，路由守卫的拦截。

- 路由表的注册

```

  // lib/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:op_flutter/pages/State/StateWhat/state_what.dart';
import 'package:op_flutter/pages/chatRoom/chart_room.dart';
import 'package:op_flutter/pages/home/home_page.dart';
import 'package:op_flutter/pages/requestDemo/request_demo.dart';
import 'package:op_flutter/pages/routeDemo/route_demo.dart';
import 'package:op_flutter/pages/routeDemo/route_guard.dart';
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
    static const routerGuard = '/guard';

    // 网络请求模块
    static const networkWhat = '/network/what';

    static const sdkAbility = '/sdk';
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
      GetPage(name: AppRoutes.stateWhat, page: () => StateWhat()),
      GetPage(name: AppRoutes.routerWhat, page: () => RouteShowcasePage()),
      GetPage(name: AppRoutes.routerGuard, page: () => TodoSummaryPage(), middlewares: [TodoGuard()]),
      GetPage(name: AppRoutes.networkWhat, page: () => RequestDemoPage()),
      GetPage(name: AppRoutes.sdkAbility, page: () => ChatRoomPage())
    ];
  }

```

- 路由表的注册

```
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 全局白色背景
        primarySwatch: Colors.blue,            // 可选，全局主题色
      ),
      initialRoute: AppRoutes.login, // 默认启动页
      getPages: AppPages.routes, // 路由表
    );
  }
}
```

那么现在就可以控制路由的跳转了。
跳转的方法和我们的 vue-router 用法类似。(换成图片)

```

方法	路由栈行为	是否可传参数	异步返回
Get.to()	push	✅	✅
Get.off()	替换当前	✅	✅
Get.offAll()	清空栈	✅	✅
Get.toNamed()	push	✅	✅
Get.offNamed()	替换当前	✅	✅
Get.offAllNamed()	清空栈	✅	✅
Get.back()	pop	✅	✅
如何携带参数进行跳转

方式	使用方法	特点
arguments	Get.to(() => Page(), arguments: {...})	传任意对象，灵活
路径参数	Get.toNamed('/page/:id')	URL 风格，方便 Deep Link / Web
```

 - 路由的前置守卫（相当于中间件）


 #### 网络请求部分

flutter官方推荐的网络请求库`dio`。来实现网络请求的能力。
使用单例模式进行一个全局的网络请求的封装，思路上与我们在开发前端项目其实是一致的。
首先就是这个dioManager类的初始化，传入基础请求地址，请求头。因为这个是全局公共的配置，所以全局都应该是需要用的同一个实例对象，且这个实例对象只可读，不可修改。
cancelToken就是用于中断请求的，这种场景也是蛮多的比如说请求接口长时间没有响应这个时候需要中断这次请求重新发起一次请求。和js原生提供的`AbortController`的作用类似
```

import 'package:dio/dio.dart';

class DioManager {
  static final DioManager _instance = DioManager._internal();
  factory DioManager() => _instance;

  late Dio dio;

  DioManager._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com/', // 全局 baseUrl
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    // 添加拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 请求: ${options.method} ${options.path}');
          print('请求参数: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 响应: ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('❌ 错误: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// GET 请求
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      Response response = await dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  /// POST 请求
  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      Response response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  /// 错误处理
  Exception _handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectionTimeout:
        return Exception('连接超时');
      case DioErrorType.receiveTimeout:
        return Exception('接收超时');
      case DioErrorType.badResponse:
        return Exception('服务器错误: ${e.response?.statusCode}');
      case DioErrorType.cancel:
        return Exception('请求取消');
      default:
        return Exception('未知错误: ${e.message}');
    }
  }
}

```

### 扩展能力

#### 调用本地sdk以及pos机器的sdk