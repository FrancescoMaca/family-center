
import 'package:family_center/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPersonalInfoScreen extends ConsumerStatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  ConsumerState<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends ConsumerState<EditPersonalInfoScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Infos', 
          style: Theme.of(context).textTheme.titleSmall
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Text('Name: ${userProvider.getName()}')
              ]
            ),
            TextFormField(
              
            ),
            TextFormField(
              
            ),
          ],
        ),
      ),
    );
  }
}