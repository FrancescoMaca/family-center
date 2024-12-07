import 'package:family_center/models/family_user.dart';
import 'package:family_center/providers/auth_provider.dart';
import 'package:family_center/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "One more step...",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).highlightColor,
                              width: 2,
                            ),
                          ),
                          child: _profileImage != null ?
                            ClipOval(
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            ) :
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Add Profile Picture",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What's your name?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onTapOutside: (e) => FocusScope.of(context).unfocus(),
                  controller: _nameController,
                  keyboardAppearance: MediaQuery.platformBrightnessOf(context),
                  enableSuggestions: true,
                  autofillHints: const [ AutofillHints.name ],
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 15
                    )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "How old are you?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onTapOutside: (e) => FocusScope.of(context).unfocus(),
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: MediaQuery.platformBrightnessOf(context),
                  maxLength: 2,
                  inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 15
                    )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }

                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters long';
                    }

                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final String name = _nameController.text;
                        final int age = int.parse(_ageController.text);

                        if (user == null) {
                          return;
                        }

                        final familyUser = FamilyUser(
                          id: user.uid,
                          familyIds: [],
                          name: name,
                          age: age
                        );
                        try {
                          final userNotifier = ref.read(userProvider.notifier);

                          await userNotifier.saveNewUser(familyUser);
                        } catch (err) {
                          print(err.toString());
                        }
                      }
                    },
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text(
                      "Continue",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Logged in as ${user!.email}",
                  style: Theme.of(context).textTheme.bodySmall
                ),
                ElevatedButton(
                  onPressed: () async {
                    final authNotifier = ref.read(authProvider.notifier);
                    await authNotifier.signOut();
                  },
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15)),
                    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                    side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStatePropertyAll(Theme.of(context).highlightColor.withOpacity(0.1))
                  ),
                  child: Text(
                    "This is not you? Click here",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).highlightColor
                    )
                  )
                ),
              ],
            ),
          ),
        ),
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