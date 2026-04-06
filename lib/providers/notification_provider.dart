import 'package:flutter/foundation.dart';
import '../models/notification_message.dart';

class NotificationProvider extends ChangeNotifier {
  String? _deviceToken;
  final List<NotificationMessage> _messages = [];

  String? get deviceToken => _deviceToken;
  List<NotificationMessage> get messages => List.unmodifiable(_messages);

  void setToken(String token) {
    _deviceToken = token;
    notifyListeners();
  }

  void addMessage(NotificationMessage message) {
    _messages.insert(0, message);
    notifyListeners();
  }
}
