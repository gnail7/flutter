import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

/// WebSocket 封装类，支持 Rx / Stream 绑定
class WebSocketService {

  WebSocketService({
    required this.url,
    this.reconnectInterval = const Duration(seconds: 5),
    this.heartbeatInterval = const Duration(seconds: 30),
  });
  final String url;
  WebSocketChannel? _channel;
  bool _isConnected = false;

  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  Duration reconnectInterval;
  Duration heartbeatInterval;

  /// 接收消息 Rx
  final Rxn<dynamic> lastMessage = Rxn<dynamic>();

  /// StreamController（可选）
  final StreamController<dynamic> _streamController =
  StreamController.broadcast();

  /// 连接 WebSocket
  void connect() {
    if (_isConnected) return;

    _channel = WebSocketChannel.connect(Uri.parse(url));

    _isConnected = true;
    _channel!.stream.listen(
      _onMessage,
      onDone: _onDone,
      onError: _onError,
      cancelOnError: true,
    );

    _startHeartbeat();
    print('[WebSocket] Connected: $url');
  }

  /// 发送消息
  void send(dynamic message) {
    if (_isConnected && _channel != null) {
      if (message is Map || message is List) {
        _channel!.sink.add(jsonEncode(message));
      } else {
        _channel!.sink.add(message);
      }
    } else {
      print('[WebSocket] Cannot send, not connected');
    }
  }

  /// 关闭连接
  void disconnect() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.normalClosure);
    _isConnected = false;
    print('[WebSocket] Disconnected');
  }

  /// Stream 方式订阅消息
  Stream<dynamic> get stream => _streamController.stream;

  /// 内部方法：接收消息
  void _onMessage(dynamic message) {
    dynamic data;
    try {
      data = jsonDecode(message);
    } catch (_) {
      data = message;
    }

    // 更新 Rx 变量
    lastMessage.value = data;

    // 发送给 Stream
    _streamController.add(data);
  }

  /// 内部方法：连接关闭
  void _onDone() {
    _isConnected = false;
    _reconnectTimer = Timer(reconnectInterval, connect);
  }

  /// 内部方法：连接错误
  void _onError(error) {
    _isConnected = false;
    _reconnectTimer = Timer(reconnectInterval, connect);
  }

  /// 内部方法：心跳
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      if (_isConnected) {
        send({'type': 'ping', 'time': DateTime.now().toIso8601String()});
      }
    });
  }

  /// 清理
  void dispose() {
    disconnect();
    _streamController.close();
  }
}
