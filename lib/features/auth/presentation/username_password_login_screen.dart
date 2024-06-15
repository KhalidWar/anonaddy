import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernamePasswordLoginScreen extends ConsumerStatefulWidget {
  const UsernamePasswordLoginScreen({super.key});

  @override
  ConsumerState createState() => _UsernamePasswordLoginScreenState();
}

class _UsernamePasswordLoginScreenState
    extends ConsumerState<UsernamePasswordLoginScreen> {
  bool hidePassword = true;
  String email = '';
  String password = '';

  void toggleShowPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Note that logging in with username and password are NOT available for accounts with 2FA',
          ),
          const SizedBox(height: 16),
          TextFormField(
            onChanged: (input) => email = input,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Username',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            onChanged: (input) => password = input,
            autocorrect: false,
            obscureText: hidePassword,
            textInputAction: TextInputAction.go,
            // inputFormatters: [TextInputFormatter],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Password',
              suffixIcon: IconButton(
                onPressed: toggleShowPassword,
                icon: Icon(
                  hidePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref
                .read(authNotifierProvider.notifier)
                .loginWithUsernameAndPassword(email, password),
            child: Text(
              'Log in',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
