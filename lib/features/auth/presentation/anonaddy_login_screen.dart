import 'package:anonaddy/features/auth/presentation/components/access_token_info.dart';
import 'package:anonaddy/features/auth/presentation/components/login_card.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddyLoginScreen extends ConsumerStatefulWidget {
  const AddyLoginScreen({Key? key}) : super(key: key);

  static const routeName = 'loginScreen';

  @override
  ConsumerState createState() => _AddyLoginScreenState();
}

class _AddyLoginScreenState extends ConsumerState<AddyLoginScreen> {
  final _tokenFormKey = GlobalKey<FormState>();

  String _token = '';

  Future<void> login() async {
    if (_tokenFormKey.currentState!.validate()) {
      await ref.read(authStateNotifier.notifier).login(kAuthorityURL, _token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: const Key('loginScreenScaffold'),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: LoginCard(
            footerOnPress: login,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login with Access Token',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Form(
                      key: _tokenFormKey,
                      child: TextFormField(
                        key: const Key('loginScreenTextField'),
                        validator: (input) =>
                            FormValidator.accessTokenValidator(input!),
                        onChanged: (input) => _token = input,
                        onFieldSubmitted: (input) => login(),
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.multiline,
                        minLines: 6,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: AppStrings.enterAccessToken,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      key: const Key('loginScreenAccessTokenInfoButton'),
                      child: const Text(AppStrings.whatsAccessToken),
                      onPressed: () async {
                        await WoltModalSheet.show(
                          context: context,
                          onModalDismissedWithBarrierTap:
                              Navigator.of(context).pop,
                          pageListBuilder: (context) {
                            return [
                              Utilities.buildWoltModalSheetSubPage(
                                context,
                                topBarTitle: AppStrings.whatsAccessToken,
                                child: const AccessTokenInfo(),
                                sabGradientColor: Colors.transparent,
                                stickyActionBar: Container(
                                  height: 72,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.open_in_new_outlined,
                                    ),
                                    label: const Text(
                                      AppStrings.getAccessToken,
                                    ),
                                    onPressed: () {
                                      Utilities.launchURL(kAnonAddySettingsURL);
                                    },
                                  ),
                                ),
                              ),
                            ];
                          },
                        );
                      },
                    ),
                    TextButton(
                      key: const Key('loginScreenChangeInstanceButton'),
                      onPressed: ref
                          .read(authStateNotifier.notifier)
                          .goToSelfHostedLogin,
                      child: const Text('Self Hosted? Change Instance!'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
