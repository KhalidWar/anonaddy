import 'package:anonaddy/screens/login_screen/self_host_login_screen.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
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

  Future<void> login(BuildContext context) async {
    if (_tokenFormKey.currentState!.validate()) {
      await ref.read(authStateNotifier.notifier).login(kAuthorityURL, _token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: const Key('loginScreenScaffold'),
        appBar: AppBar(elevation: 0, brightness: Brightness.dark),
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
                  buildHeader(context, size),
                  Container(),
                  buildTokenInputField(context),
                  Column(
                    children: [
                      TextButton(
                        key: const Key('loginGetAccessToken'),
                        style: TextButton.styleFrom(),
                        child: const Text(AddyManagerString.whatsAccessToken),
                        onPressed: () => buildAccessTokenInfoSheet(context),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(),
                        child: const Text('Self Hosted? Change Instance!'),
                        onPressed: () => Navigator.pushNamed(
                            context, SelfHostLoginScreen.routeName),
                      ),
                    ],
                  ),
                  buildFooter(context, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, Size size) {
    return Column(
      children: [
        Text(
          'AddyManager',
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.01),
        Divider(
          color: const Color(0xFFE4E7EB),
          thickness: 2,
          indent: size.width * 0.30,
          endIndent: size.width * 0.30,
        ),
      ],
    );
  }

  Widget buildTokenInputField(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login with Access Token',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: size.height * 0.01),
          Form(
            key: _tokenFormKey,
            child: TextFormField(
              key: const Key('loginTextField'),
              validator: (input) => FormValidator.accessTokenValidator(input!),
              onChanged: (input) => _token = input,
              onFieldSubmitted: (input) => login(context),
              textInputAction: TextInputAction.go,
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
                hintText: AddyManagerString.enterAccessToken,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBottomSheetBorderRadius),
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BottomSheetHeader(
              headerLabel: AddyManagerString.whatsAccessToken,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AddyManagerString.whatsAccessToken,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  const Text(AddyManagerString.accessTokenDefinition),
                  const SizedBox(height: 20),
                  Text(
                    AddyManagerString.accessTokenRequired,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AddyManagerString.howToGetAccessToken,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5),
                  const Text(AddyManagerString.howToGetAccessToken1),
                  const Text(AddyManagerString.howToGetAccessToken2),
                  const Text(AddyManagerString.howToGetAccessToken3),
                  const Text(AddyManagerString.howToGetAccessToken4),
                  const Text(AddyManagerString.howToGetAccessToken5),
                  const SizedBox(height: 20),
                  Text(
                    AddyManagerString.accessTokenSecurityNotice,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(AddyManagerString.getAccessToken),
                    SizedBox(width: 4),
                    Icon(Icons.open_in_new_outlined),
                  ],
                ),
                onPressed: () => NicheMethod.launchURL(kAnonAddySettingsURL),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildFooter(BuildContext context, bool isDark) {
    final size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
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
            onPressed: () => login(context),
          ),
        );
      },
    );
  }
}
