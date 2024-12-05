
import 'package:family_center/models/family_user.dart';
import 'package:family_center/providers/auth_provider.dart';
import 'package:family_center/providers/user_provider.dart';
import 'package:family_center/screens/edit_personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (user) {
        String userName = user?.name ?? "No Data";
        String userAge = user?.age.toString() ?? "No data";
        
        _nameController.text = userName;
        _ageController.text = userAge;
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _createProfileSection(),
              _createEntry('Privacy', Icons.privacy_tip_rounded, () {}),
              _createEntry('Invite a Friend', Icons.offline_bolt_rounded, () {}),
              _createEntry('Sign out', Icons.exit_to_app_rounded, handleLogOut, true),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget _createProfileSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: Image.asset(
                  'assets/images/default_pfp.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: -8,
                bottom: -8,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  constraints: BoxConstraints.tight(const Size(32, 32)),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditPersonalInfoScreen(),
                      ),
                    )
                  },
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryIconTheme.color)
                )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('${_nameController.text} - ${_ageController.text}')
          ),
        ]
      ),
    );
  }

  Widget _createEntry(String name, IconData icon, VoidCallback onClick, [bool isOutlined = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onClick,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: isOutlined ? const WidgetStatePropertyAll(Colors.transparent) : Theme.of(context).elevatedButtonTheme.style?.backgroundColor,
          side: WidgetStatePropertyAll(BorderSide(
            width: 3,
            color: isOutlined ? Colors.redAccent : Colors.transparent
          )),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 5, horizontal: 10))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isOutlined ?
                  Colors.redAccent :
                  Theme.of(context).primaryIconTheme.color,
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isOutlined ?
                    Colors.redAccent :
                    Theme.of(context).textTheme.bodyMedium?.color
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void handleLogOut() {
    ref.read(authProvider.notifier).signOut();
  }
}
