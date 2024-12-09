
import 'dart:ui';
import 'package:family_center/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCAppBar extends ConsumerWidget implements PreferredSizeWidget {
  // double scrollOffset;

  const FCAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: change this to a state manager
    const scrollOffset = 0;

    return AppBar(
      title: Text(
        'Family Center', 
        style: Theme.of(context).textTheme.titleMedium
      ),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: scrollOffset > 0 ? 10 : 0, sigmaY: scrollOffset > 0 ? 10 : 0),
          child: Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications, 
            color: Theme.of(context).primaryIconTheme.color
          ),
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
}