import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/notification_provider.dart';
import 'services/fcm_service.dart';

// Must be a top-level function — required by FCM for background handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final navigatorKey = GlobalKey<NavigatorState>();
  final provider = NotificationProvider();
  final fcmService = FcmService(provider: provider, navigatorKey: navigatorKey);

  runApp(
    ChangeNotifierProvider<NotificationProvider>.value(
      value: provider,
      child: App(navigatorKey: navigatorKey),
    ),
  );

  // Initialize FCM after the widget tree is mounted
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await fcmService.initialize();
  });
}
