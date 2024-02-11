import 'package:anonaddy/features/auth/presentation/components/access_token_info.dart';
import 'package:anonaddy/features/auth/presentation/components/label_input_field_separator.dart';
import 'package:anonaddy/features/auth/presentation/components/login_card.dart';
import 'package:anonaddy/features/auth/presentation/components/login_footer.dart';
import 'package:anonaddy/features/auth/presentation/components/login_header.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnonAddyLoginScreen extends ConsumerStatefulWidget {
  const AnonAddyLoginScreen({Key? key}) : super(key: key);

  static const routeName = 'loginScreen';

  @override
  ConsumerState createState() => _AnonAddyLoginScreenState();
}

class _AnonAddyLoginScreenState extends ConsumerState<AnonAddyLoginScreen> {
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
                  buildTokenInputField(context),
                  Column(
                    children: [
                      TextButton(
                        key: const Key('loginScreenAccessTokenInfoButton'),
                        child: const Text(AppStrings.whatsAccessToken),
                        onPressed: () => buildAccessTokenInfoSheet(context),
                      ),
                      TextButton(
                        key: const Key('loginScreenChangeInstanceButton'),
                        child: const Text('Self Hosted? Change Instance!'),
                        onPressed: () => ref
                            .read(authStateNotifier.notifier)
                            .goToSelfHostedLogin(),
                      ),
                    ],
                  ),
                  LoginFooter(
                    key: const Key('anonAddyLoginScreenLoginFooter'),
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

  Widget buildTokenInputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login with Access Token',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const LabelInputFieldSeparator(),
          Form(
            key: _tokenFormKey,
            child: TextFormField(
              key: const Key('loginScreenTextField'),
              validator: (input) => FormValidator.accessTokenValidator(input!),
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
    );
  }

  Future buildAccessTokenInfoSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.kBottomSheetBorderRadius),
      ),
      builder: (context) => const AccessTokenInfo(),
    );
  }
}
