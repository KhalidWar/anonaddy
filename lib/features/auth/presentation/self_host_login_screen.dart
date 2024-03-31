import 'package:anonaddy/features/auth/presentation/components/login_card.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/app_url.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelfHostLoginScreen extends ConsumerStatefulWidget {
  const SelfHostLoginScreen({super.key});

  static const routeName = 'selfHostedScreen';

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
        child: Scaffold(
          key: const Key('selfHostedLoginScreenScaffold'),
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.primaryColor,
          body: Center(
            child: LoginCard(
              footerOnPress: login,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Addy.io Instance',
                          key: Key('selfHostedLoginScreenUrlInputLabel'),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          key: const Key('selfHostedLoginScreenUrlInputField'),
                          validator: FormValidator.validateInstanceURL,
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Access Token ',
                          key: Key('selfHostedLoginScreenTokenInputLabel'),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          key:
                              const Key('selfHostedLoginScreenTokenInputField'),
                          validator: FormValidator.requiredField,
                          onChanged: (input) => _token = input,
                          onFieldSubmitted: (input) => login(),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 4,
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
                    Column(
                      children: [
                        TextButton(
                          key: const Key(
                              'selfHostedLoginScreenSelfHostInfoButton'),
                          child: const Text('How to self-host addy.io?'),
                          onPressed: () =>
                              Utilities.launchURL(kAnonAddySelfHostingURL),
                        ),
                        TextButton(
                          key: const Key(
                              'selfHostedLoginScreenAnonAddyLoginButton'),
                          onPressed: ref
                              .read(authStateNotifier.notifier)
                              .goToAddyLogin,
                          child: const Text('Login with addy.io instead!'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
