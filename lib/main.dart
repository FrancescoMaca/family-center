import 'package:family_center/extensions/theme_ext.dart';
import 'package:family_center/notifications/notification_service.dart';
import 'package:family_center/screen_manager.dart';
import 'package:family_center/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

void main() async {
  /*WidgetsBinding widgetsBinding = */WidgetsFlutterBinding.ensureInitialized();
  // Keeps the splash screen
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Removes it (when init is done)
  // FlutterNativeSplash.remove();

  // Firebase
  await Firebase.initializeApp();

  // 3D touch actions
  const QuickActions quickActions = QuickActions();

  quickActions.initialize((String shortcut) {
    if (shortcut == 'action_one') {
      print('Actione one clicked');
    }
  });

  // In-App Notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Family Center',
      theme: context.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const ScreenManager()
    );
  }
}