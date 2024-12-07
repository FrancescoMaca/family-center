import 'package:family_center/providers/auth_provider.dart';
import 'package:family_center/utils/auth_error_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Sign In' : 'Sign Up',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _emailController.text = "francescomaca93@gmail.com";
                      _passwordController.text = "Francesco2002"; // Fake pass dont try to use it :D
                    },
                    icon: Icon(Icons.verified_sharp, color: Theme.of(context).primaryIconTheme.color)
                  ),
                  IconButton(
                    onPressed: () {
                      _emailController.text = "frankymacaspam@gmail.com";
                      _passwordController.text = "Francesco2002"; // Fake pass dont try to use it :D
                    },
                    icon: Icon(Icons.dangerous, color: Theme.of(context).primaryIconTheme.color)
                  ),
                ],
              ),
              TextFormField(
                controller: _emailController,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                keyboardAppearance: MediaQuery.platformBrightnessOf(context),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: true,
                autofillHints: const [ AutofillHints.email ],
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextFormField(
                controller: _passwordController,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                keyboardAppearance: MediaQuery.platformBrightnessOf(context),
                autocorrect: false,
                autofillHints: [ _isLogin ? AutofillHints.password : AutofillHints.newPassword ],
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 15
                  )
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                style: Theme.of(context).textTheme.bodyMedium
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleLogin,
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  _isLogin ? 'Sign In' : 'Sign Up',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      _isLogin ? 'Don\'t have an account?' : 'Already have an account?',
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isLogin ? 'Sign up!' : 'Sign in',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).highlightColor
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isLogin) {
          await ref.read(authProvider.notifier).signIn(
            _emailController.text,
            _passwordController.text,
          );
        } else {
          await ref.read(authProvider.notifier).signUp(
            _emailController.text,
            _passwordController.text,
          );
        }
      } catch (e) {
        showSignInError(context, e);
      }
    }
  }
}
