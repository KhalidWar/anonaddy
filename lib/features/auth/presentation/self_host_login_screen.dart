import 'package:anonaddy/features/auth/presentation/components/label_input_field_separator.dart';
import 'package:anonaddy/features/auth/presentation/components/login_card.dart';
import 'package:anonaddy/features/auth/presentation/components/login_footer.dart';
import 'package:anonaddy/features/auth/presentation/components/login_header.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/app_url.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelfHostLoginScreen extends ConsumerStatefulWidget {
  const SelfHostLoginScreen({Key? key}) : super(key: key);

  static const routeName = 'selfHostedScreen';

  @override
  ConsumerState createState() => _SelfHostLoginScreenState();
}

class _SelfHostLoginScreenState extends ConsumerState<SelfHostLoginScreen> {
  final _urlFormKey = GlobalKey<FormState>();
  final _tokenFormKey = GlobalKey<FormState>();

  String _url = '';
  String _token = '';

  Future<void> login() async {
    if (_urlFormKey.currentState!.validate() &&
        _tokenFormKey.currentState!.validate()) {
      await ref.read(authStateNotifier.notifier).login(_url, _token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: const Key('selfHostedLoginScreenScaffold'),
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: LoginCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LoginHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'addy.io Instance',
                          key: const Key('selfHostedLoginScreenUrlInputLabel'),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const LabelInputFieldSeparator(),
                        Form(
                          key: _urlFormKey,
                          child: TextFormField(
                            key:
                                const Key('selfHostedLoginScreenUrlInputField'),
                            validator: (input) =>
                                FormValidator.validateInstanceURL(input!),
                            onChanged: (input) => _url = input,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: AppUrl.anonAddyAuthority,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'API Token ',
                              key: const Key(
                                  'selfHostedLoginScreenTokenInputLabel'),
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              '(from the settings page)',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        const LabelInputFieldSeparator(),
                        Form(
                          key: _tokenFormKey,
                          child: TextFormField(
                            key: const Key(
                                'selfHostedLoginScreenTokenInputField'),
                            validator: (input) =>
                                FormValidator.accessTokenValidator(input!),
                            onChanged: (input) => _token = input,
                            onFieldSubmitted: (input) => login(),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 4,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: AppStrings.enterYourApiToken,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        child: const Text('Login with addy.io instead!'),
                        onPressed: () => ref
                            .read(authStateNotifier.notifier)
                            .goToAnonAddyLogin(),
                      ),
                    ],
                  ),
                  LoginFooter(
                    key: const Key('selfHostedLoginScreenLoginFooter'),
                    onPress: () => login(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
