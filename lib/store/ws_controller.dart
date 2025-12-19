// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:get/get.dart';
// import 'package:op_flutter/store/user_controller.dart';
// import 'package:op_flutter/utils/sign_helper_epay.dart';
//
// class WebSocketController extends GetxController {
//   static WebSocketController get to => Get.find();
//
//   late Socket _socket;
//   final RxBool connected = false.obs;
//   final RxString? channelId = RxString('');
//   Timer? _heartBeatTimer;
//   bool _authSent = false;
//
//   final int port = 8090;
//   final String host = '192.168.10.39';
//
//   @override
//   void onInit() {
//     super.onInit();
//     _connect();
//   }
//
//   void _connect() async {
//     try {
//       _socket = await Socket.connect(host, port, timeout: Duration(seconds: 5));
//       connected.value = true;
//       print('[TCP] Connected to $host:$port');
//
//       // 监听服务端消息
//       _socket.listen(
//         _onMessage,
//         onDone: _onDone,
//         onError: _onError,
//         cancelOnError: true,
//       );
//
//       // 建立连接后立即发送认证消息
//       _sendAuthMessage();
//     } catch (e) {
//       connected.value = false;
//       print('[TCP] Connection failed: $e');
//       // 可设置延迟重连
//       Future.delayed(Duration(seconds: 5), _connect);
//     }
//   }
//
//   void _onMessage(Uint8List data) {
//     final msg = utf8.decode(data);
//     print('[TCP] Received: $msg');
//
//     try {
//       final Map<String, dynamic> jsonMsg = json.decode(msg);
//
//       // 如果包含 channelId 表示认证成功
//       if (jsonMsg.containsKey('channelId')) {
//         channelId!.value = jsonMsg['channelId'];
//         print('[TCP] Auth success, channelId: ${channelId!.value}');
//
//         // 启动心跳
//         _startHeartBeat();
//       }
//
//       // TODO: 处理其他业务消息，如交易明细
//     } catch (e) {
//       print('[TCP] Message parse error: $e');
//     }
//   }
//
//   void _onDone() {
//     print('[TCP] Connection closed by server');
//     connected.value = false;
//     channelId?.value = '';
//     _stopHeartBeat();
//
//     // 自动重连
//     Future.delayed(Duration(seconds: 5), _connect);
//   }
//
//   void _onError(dynamic error) {
//     print('[TCP] Connection error: $error');
//     connected.value = false;
//     channelId?.value = '';
//     _stopHeartBeat();
//
//     // 自动重连
//     Future.delayed(Duration(seconds: 5), _connect);
//   }
//
//   void _sendAuthMessage() {
//     if (_authSent) return;
//     final user = UserController.to.user.value;
//     if (user == null) return;
//
//     final helper = SignHelperEPay(user.secureCode);
//     helper.addKeyValue("terminal", user.terminal.toString());
//     helper.addKeyValue("msgType", "1"); // AUTH
//     helper.addKeyValue("token", user.token);
//     helper.createSign();
//     final sign = helper.getMap()["sign"];
//
//     final message = json.encode({
//       "terminal": user.terminal,
//       "msgType": 1,
//       "token": user.token,
//       "sign": sign,
//     });
//
//     _socket.write(message);
//     _authSent = true;
//     print('[TCP] Sent auth message: $message');
//   }
//
//   void _startHeartBeat() {
//     _heartBeatTimer?.cancel();
//     _heartBeatTimer = Timer.periodic(Duration(seconds: 30), (_) {
//       if (channelId?.value == null) return;
//       final msg = json.encode({"channelId": channelId!.value, "msgType": 2}); // 心跳
//       _socket.write(msg);
//       print('[TCP] Heartbeat sent: $msg');
//     });
//   }
//
//   void _stopHeartBeat() {
//     _heartBeatTimer?.cancel();
//     _heartBeatTimer = null;
//   }
//
//   void sendMessage(Map<String, dynamic> message) {
//     if (connected.value && channelId?.value != null) {
//       final msg = json.encode(message);
//       _socket.write(msg);
//       print('[TCP] Sent message: $msg');
//     } else {
//       print('[TCP] Not connected or not authenticated yet');
//     }
//   }
//
//   @override
//   void onClose() {
//     _stopHeartBeat();
//     _socket.close();
//     super.onClose();
//   }
// }
