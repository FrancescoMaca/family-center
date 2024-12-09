
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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenManager extends ConsumerStatefulWidget {
  const ScreenManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends ConsumerState<ConsumerStatefulWidget> {
  final PageController _pageController = PageController();
  final double _dragThreshold = 0.1;
  
  int _currentPage = 0;
  double _dragStartX = 0;
  bool _dragEnabled = true;

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
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      return const AuthScreen();
    }

    if (userData.value == null) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      return const PersonalInfoScreen();
    }

    return Scaffold(
      appBar: const FCAppBar(),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _createNavigationBar(),
      body: GestureDetector(
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            HapticFeedback.lightImpact();
            setState(() {
              _currentPage = index;
            });
          },
          children: navigationScreens,
        ),
      )
    );
  }

  Widget _createNavigationBar() {
    return CurvedNavigationBar(
      index: _currentPage, 
      color: const Color(0xFF171142),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      animationCurve: Curves.elasticOut,
      animationDuration: const Duration(milliseconds: 500),
      items: [
        Icon(Icons.groups_3_rounded, color: Theme.of(context).primaryColor),
        Icon(Icons.account_circle_rounded, color: Theme.of(context).primaryColor),
        Icon(Icons.settings, color: Theme.of(context).primaryColor),
      ],
      onTap: (index) => {
        HapticFeedback.lightImpact(),
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut
          )
        }
      },
    );
  }

  void _handleDragStart(DragStartDetails dInfo) {
    _dragStartX = dInfo.localPosition.dx;
    _dragEnabled = true;
  }

  void _handleDragUpdate(DragUpdateDetails dInfo) {
    if (!_dragEnabled) {
      return;
    }

    // Calculates the percentage of screen dragged
    final dragDistancePercentage = (dInfo.localPosition.dx - _dragStartX).abs() / MediaQuery.of(context).size.width;

    // If the percentage is enough
    if (dragDistancePercentage >= _dragThreshold) {
      
      // Finds the direction of the drag and changes the page
      final direction = dInfo.localPosition.dx > _dragStartX ? -1 : 1;
      final nextPage = _currentPage + direction;
      
      // Boundaries check
      if (nextPage >= 0 && nextPage < navigationScreens.length) {
        HapticFeedback.lightImpact();
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        // Disables drags
        _dragEnabled = false;
      }
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}