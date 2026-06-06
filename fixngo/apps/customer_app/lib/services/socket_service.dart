import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'storage_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket socket;
  final StorageService _storageService = StorageService();

  bool get isConnected => socket.connected;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  Future<void> connect() async {
    try {
      final token = await _storageService.getToken();
      // Android emulator: 10.0.2.2 maps to host machine localhost
      // Real device: Use your backend URL
      const String serverUrl = 'http://10.0.2.2:5000';

      socket = io.io(
        serverUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({'token': token})
            .build(),
      );

      socket.onConnect((_) {
        debugPrint('Socket connected');
        socket.emit('user-online', {});
      });

      socket.onDisconnect((_) {
        debugPrint('Socket disconnected');
      });

      socket.onConnectError((error) {
        debugPrint('Connection error: $error');
      });

      socket.onError((error) {
        debugPrint('Socket error: $error');
      });

      socket.connect();
    } catch (e) {
      debugPrint('Error connecting to socket: $e');
    }
  }

  void disconnect() {
    socket.disconnect();
  }

  // Listen to order updates
  void onOrderUpdated(Function(dynamic) callback) {
    socket.on('order-updated', (data) {
      callback(data);
    });
  }

  // Listen to technician location
  void onTechnicianLocation(Function(dynamic) callback) {
    socket.on('technician-location', (data) {
      callback(data);
    });
  }

  // Listen to notifications
  void onNotification(Function(dynamic) callback) {
    socket.on('notification', (data) {
      callback(data);
    });
  }

  // Listen to user status
  void onUserStatus(Function(dynamic) callback) {
    socket.on('user-status', (data) {
      callback(data);
    });
  }

  // Listen to chat messages
  void onChatMessage(Function(dynamic) callback) {
    socket.on('chat-message', (data) {
      callback(data);
    });
  }

  // Emit order status update
  void updateOrderStatus(String orderId, String status, String? note) {
    socket.emit('order-status-update', {
      'orderId': orderId,
      'status': status,
      'note': note,
    });
  }

  // Emit notification
  void sendNotification(
    String recipientId,
    String type,
    String title,
    String message,
    String orderId,
  ) {
    socket.emit('order-notification', {
      'recipientId': recipientId,
      'type': type,
      'title': title,
      'message': message,
      'orderId': orderId,
    });
  }

  // Emit chat message
  void sendChatMessage(String recipientId, String message, String orderId) {
    socket.emit('chat-message', {
      'recipientId': recipientId,
      'message': message,
      'orderId': orderId,
    });
  }

  // Remove listener
  void off(String event) {
    socket.off(event);
  }
}
