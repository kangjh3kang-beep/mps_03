import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  bool _isConnected = false;

  void init() {
    // Replace with your actual backend IP (e.g., 10.0.2.2 for Android Emulator)
    _socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.onConnect((_) {
      print('Socket connected');
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
      _isConnected = false;
    });
    
    _socket.connect();
  }

  void sendMeasurementData(Map<String, dynamic> data) {
    if (_isConnected) {
      _socket.emit('measure_data', data);
    }
  }

  void updateSessionStatus(String status) {
    if (_isConnected) {
      _socket.emit('session_status', {'status': status});
    }
  }
  
  void dispose() {
    _socket.disconnect();
  }
}
