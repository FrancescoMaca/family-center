import 'package:family_center/extensions/theme_ext.dart';
import 'package:family_center/screen_manager.dart';
import 'package:family_center/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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