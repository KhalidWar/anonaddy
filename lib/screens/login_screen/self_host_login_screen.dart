import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
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
      //todo fix navigation issue. Screen stays on top.
      await ref.read(authStateNotifier.notifier).login(_url, _token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: const Text('Change Instance')),
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: size.height * 0.6,
              width: size.width * 0.88,
              padding: const EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                color: isDark
                    ? Theme.of(context).cardTheme.color
                    : Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AnonAddy Instance',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Form(
                          key: _urlFormKey,
                          child: TextFormField(
                            validator: (input) =>
                                FormValidator.validateInstanceURL(input!),
                            onChanged: (input) => _url = input,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: 'app.anonaddy.com',
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
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const Text('(from the settings page)'),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Form(
                          key: _tokenFormKey,
                          child: TextFormField(
                            validator: (input) =>
                                FormValidator.accessTokenValidator(input!),
                            onChanged: (input) => _token = input,
                            onFieldSubmitted: (input) => login(),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 6,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: 'Enter your API token',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(),
                  TextButton(
                    style: TextButton.styleFrom(),
                    child: const Text('How to self-host AnonAddy?'),
                    onPressed: () =>
                        NicheMethod.launchURL(kAnonAddySelfHostingURL),
                  ),
                  loginButton(context, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Consumer loginButton(BuildContext context, bool isDark) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (_, ref, __) {
        final authState = ref.watch(authStateNotifier);

        return Container(
          height: size.height * 0.1,
          width: size.width,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : const Color(0xFFF5F7FA),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(),
            key: const Key('loginButton'),
            child: authState.loginLoading!
                ? const CircularProgressIndicator(
                    key: Key('loginLoadingIndicator'),
                    backgroundColor: AppColors.primaryColor,
                  )
                : Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.black),
                  ),
            onPressed: () => login(),
          ),
        );
      },
    );
  }
}
