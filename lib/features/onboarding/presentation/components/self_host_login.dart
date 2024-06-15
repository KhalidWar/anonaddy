import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/app_url.dart';
import 'package:anonaddy/common/form_validator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelfHostLogin extends ConsumerStatefulWidget {
  const SelfHostLogin({super.key});

  @override
  ConsumerState createState() => _SelfHostLoginScreenState();
}

class _SelfHostLoginScreenState extends ConsumerState<SelfHostLogin> {
  final formKey = GlobalKey<FormState>();

  bool showLoading = false;

  String _url = '';
  String _token = '';

  void toggleLoading(bool isLoading) {
    setState(() {
      showLoading = isLoading;
    });
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      toggleLoading(true);
      await ref
          .read(authNotifierProvider.notifier)
          .loginWithAccessToken(_url, _token)
          .then((_) => toggleLoading(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      key: const Key('selfHostedLoginScreenScaffold'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Instance Url',
                    key: Key('selfHostedLoginScreenUrlInputLabel'),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    autofillHints: const [AutofillHints.url],
                    key: const Key('selfHostedLoginScreenUrlInputField'),
                    validator: FormValidator.requiredField,
                    onChanged: (input) => _url = input,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: AppUrl.anonAddyAuthority,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Access Token ',
                    key: Key('selfHostedLoginScreenTokenInputLabel'),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    key: const Key('selfHostedLoginScreenTokenInputField'),
                    validator: FormValidator.requiredField,
                    onChanged: (input) => _token = input,
                    onFieldSubmitted: (input) => login(),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: AppStrings.enterYourApiToken,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // TextButton(
            //   key: const Key('selfHostedLoginScreenSelfHostInfoButton'),
            //   child: const Text('How to self-host addy.io?'),
            //   onPressed: () => Utilities.launchURL(kAnonAddySelfHostingURL),
            // ),
            SizedBox(
              width: double.infinity,
              child: PlatformButton(
                key: const Key('loginFooterLoginButton'),
                onPress: login,
                child: showLoading
                    ? const CircularProgressIndicator(
                        key: Key('loginFooterLoginButtonLoading'),
                      )
                    : Text(
                        'Log in',
                        key: const Key('loginFooterLoginButtonLabel'),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.black),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
