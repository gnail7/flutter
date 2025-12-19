import 'dart:io';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class TcpClient {
  static final TcpClient _instance = TcpClient._internal();
  factory TcpClient() => _instance;
  TcpClient._internal();

  Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connect(String host, int port) async {
    print('in connect');
    if (_isConnected) return;
    try {
      _socket = await Socket.connect(host, port);
      _isConnected = true;
      print('connected');

      _socket!.listen(
            (data) {
          print('Received: ${String.fromCharCodes(data)}');
        },
        onDone: () {
          print('Connection closed by server');
          _isConnected = false;
        },
        onError: (error) {
          print('Socket error: $error');
          _isConnected = false;
        },
        cancelOnError: true,
      );

      print('Connected to $host:$port');
    } catch (e) {
      print('Connection failed: $e');
      _isConnected = false;
    }
  }

  void send(String message) {
    if (_socket != null && _isConnected) {
      _socket!.write(message);
      print('Sent: $message');
    } else {
      print('Not connected');
    }
  }

  void close() {
    _socket?.destroy();
    _isConnected = false;
  }
}



Future<void> connectSecure() async {
  try {
    print('1️⃣ start load cert');
    final certBytes = await rootBundle.load('assets/oceanpayment-com.pem');
    print('2️⃣ cert loaded, size=${certBytes.lengthInBytes}');

    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(certBytes.buffer.asUint8List());
    print('3️⃣ security context ready');

    print('4️⃣ start connect...');
    final socket = await SecureSocket.connect(
      '192.168.10.39',
      8090,
      onBadCertificate: (_) => true,
      timeout: const Duration(seconds: 10),
    );
    print('5️⃣ CONNECTED ✅');

    socket.listen(
          (data) {
        print('📩 server says: ${String.fromCharCodes(data)}');
      },
      onDone: () {
        print('🔌 server closed connection');
      },
      onError: (e) {
        print('❌ socket error: $e');
      },
    );

    print('6️⃣ send data');
    socket.write('Hello server\n');
    await socket.flush();
    print('7️⃣ data sent');

  } catch (e, stack) {
    print('❌ CONNECT FAILED');
    print(e);
    print(stack);
  }
}
