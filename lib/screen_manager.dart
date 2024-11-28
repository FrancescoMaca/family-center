
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:family_center/screens/home_screen.dart';
import 'package:family_center/screens/settings_screen.dart';
import 'package:family_center/screens/user_profile_screen.dart';
import 'package:family_center/widgets/layout/app_bar.dart';
import 'package:flutter/material.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int _currentScreen = 0;
  final List<Widget> navigationScreens = [
    const HomeScreen(),
    const UserProfileScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
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