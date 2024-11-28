import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_center/providers/auth_provider.dart';
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
    // Load user profile data
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = ref.read(authProvider);
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = (data['age'] ?? '').toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: Image.network('https://picsum.photos/100'),
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
                  onPressed: () => { print('clicked edit profile')},
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryIconTheme.color)
                )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('${_nameController.text} - ${_ageController.text}')
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Sign out',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
