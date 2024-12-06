
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:family_center/providers/auth_provider.dart';
import 'package:family_center/providers/user_provider.dart';
import 'package:family_center/screens/auth_screen.dart';
import 'package:family_center/screens/home_screen.dart';
import 'package:family_center/screens/personal_info_screen.dart';
import 'package:family_center/screens/settings_screen.dart';
import 'package:family_center/screens/user_profile_screen.dart';
import 'package:family_center/widgets/layout/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenManager extends ConsumerStatefulWidget {
  const ScreenManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends ConsumerState<ConsumerStatefulWidget> {
  int _currentScreen = 0;
  
  final List<Widget> navigationScreens = [
    const HomeScreen(),
    const UserProfileScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final userData = ref.watch(userProvider);

    if (user == null) {
      return const AuthScreen();
    }

    if (userData.value == null) {
      return const PersonalInfoScreen();
    }

    return Scaffold(
      appBar: const FCAppBar(),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _createNavigationBar(),
      body: navigationScreens[_currentScreen],
    );
  }

  Widget _createNavigationBar() {
    return CurvedNavigationBar(
      color: const Color(0xFF171142),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      animationCurve: Curves.elasticOut,
      animationDuration: const Duration(milliseconds: 500),
      items: [
        Icon(Icons.groups_3_rounded, color: Theme.of(context).primaryColor), //Color(0xFF403c75)
        Icon(Icons.account_circle_rounded, color: Theme.of(context).primaryColor), //Color(0xFF403c75)
        Icon(Icons.settings, color: Theme.of(context).primaryColor),
      ],
      onTap: (index) => {
        setState(() => _currentScreen = index)
      },
    );
  }
}