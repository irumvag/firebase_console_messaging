import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/notification_message.dart';
import '../providers/notification_provider.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationProvider _provider;
  final GlobalKey<NavigatorState> navigatorKey;

  FcmService({required NotificationProvider provider, required this.navigatorKey})
      : _provider = provider;

  Future<void> initialize() async {
    // Request permission (Android 13+ / iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get and store FCM token
    final token = await _messaging.getToken();
    if (token != null) {
      _provider.setToken(token);
      debugPrint('FCM Token: $token');
    }

    // Refresh token listener
    _messaging.onTokenRefresh.listen((newToken) {
      _provider.setToken(newToken);
    });

    // Foreground messages → show dialog + add to list
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final title = notification?.title ?? message.data['title'] ?? 'Notification';
      final body = notification?.body ?? message.data['body'] ?? '';

      _provider.addMessage(NotificationMessage(
        title: title,
        body: body,
        receivedAt: DateTime.now(),
      ));

      _showForegroundDialog(title, body);
    });

    // Background → app opened via notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      final title = notification?.title ?? message.data['title'] ?? 'Notification';
      final body = notification?.body ?? message.data['body'] ?? '';

      _provider.addMessage(NotificationMessage(
        title: title,
        body: body,
        receivedAt: DateTime.now(),
      ));
    });

    // App was terminated → opened by notification tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final notification = initialMessage.notification;
      final title = notification?.title ?? initialMessage.data['title'] ?? 'Notification';
      final body = notification?.body ?? initialMessage.data['body'] ?? '';

      _provider.addMessage(NotificationMessage(
        title: title,
        body: body,
        receivedAt: DateTime.now(),
      ));
    }
  }

  void _showForegroundDialog(String title, String body) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: Color(0xFFF5A623), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2340),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          body,
          style: const TextStyle(fontSize: 14, color: Color(0xFF5C6B8A)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Dismiss',
              style: TextStyle(
                color: Color(0xFF1A2340),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
