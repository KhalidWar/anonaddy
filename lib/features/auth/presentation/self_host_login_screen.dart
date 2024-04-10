import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/app_url.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelfHostLoginScreen extends ConsumerStatefulWidget {
  const SelfHostLoginScreen({super.key});

  @override
  ConsumerState createState() => _SelfHostLoginScreenState();
}

class _SelfHostLoginScreenState extends ConsumerState<SelfHostLoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _url = '';
  String _token = '';

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      await ref
          .read(authStateNotifier.notifier)
          .loginWithAccessToken(_url, _token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: GestureDetector(
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
                      key: const Key('selfHostedLoginScreenUrlInputField'),
                      validator: FormValidator.requiredField,
                      onChanged: (input) => _url = input,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
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
                      key: const Key('selfHostedLoginScreenTokenInputField'),
                      validator: FormValidator.requiredField,
                      onChanged: (input) => _token = input,
                      onFieldSubmitted: (input) => login(),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
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
                  child: Consumer(
                    builder: (context, ref, _) {
                      final authAsync = ref.watch(authStateNotifier);
                      return authAsync.when(
                        data: (authState) {
                          return authState.loginLoading
                              ? const CircularProgressIndicator(
                                  key: Key('loginFooterLoginButtonLoading'),
                                )
                              : Text(
                                  'Log in',
                                  key: const Key('loginFooterLoginButtonLabel'),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                );
                        },
                        error: (_, __) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
