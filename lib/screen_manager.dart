
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:family_center/screens/home_screen.dart';
import 'package:family_center/screens/notification_screen.dart';
import 'package:family_center/screens/settings_screen.dart';
import 'package:family_center/screens/user_profile_screen.dart';
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
      appBar: _createAppBar(),
      bottomNavigationBar: _createNavigationBar(),
      body: navigationScreens[_currentScreen],
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      title: Text('Family Center', style: Theme.of(context).textTheme.titleMedium),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Theme.of(context).primaryIconTheme.color),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
      ],
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