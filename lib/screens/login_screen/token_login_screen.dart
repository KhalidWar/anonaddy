import 'package:anonaddy/screens/login_screen/change_instance_screen.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/state_management/login_state_manager.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenLoginScreen extends ConsumerWidget {
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final loginManager = watch(loginStateManagerProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: Key('loginScreenScaffold'),
        appBar: AppBar(elevation: 0, brightness: Brightness.dark),
        backgroundColor: kPrimaryColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: size.height * 0.6,
              width: size.width * 0.88,
              padding: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildHeader(context, size),
                  Container(),
                  buildTokenInputField(context, loginManager),
                  Column(
                    children: [
                      GestureDetector(
                        key: Key('loginGetAccessToken'),
                        child: Text(
                          kWhatsAccessToken,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onTap: () => buildAccessTokenInfoSheet(context),
                      ),
                      SizedBox(height: size.height * 0.01),
                      GestureDetector(
                        child: Text(
                          'Self Hosting? Change Instance!',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onTap: () => Navigator.push(
                            context, CustomPageRoute(ChangeInstanceScreen())),
                      ),
                    ],
                  ),
                  buildFooter(context, isDark, loginManager),
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
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.01),
        Divider(
          color: Color(0xFFE4E7EB),
          thickness: 2,
          indent: size.width * 0.30,
          endIndent: size.width * 0.30,
        ),
      ],
    );
  }

  Widget buildTokenInputField(
      BuildContext context, LoginStateManager loginManager) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login with Access Token',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    key: Key('loginTextField'),
                    validator: (input) =>
                        FormValidator().accessTokenValidator(input),
                    controller: _textEditingController,
                    onFieldSubmitted: (input) => loginManager.login(
                        context, _textEditingController.text.trim(), _formKey),
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      hintText: kEnterAccessToken,
                    ),
                  ),
                ),
              ),
              IconButton(
                key: Key('pasteFromClipboard'),
                icon: Icon(Icons.paste),
                onPressed: () => loginManager.pasteFromClipboard(
                  _textEditingController,
                ),
              ),
            ],
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
            BottomSheetHeader(headerLabel: kWhatsAccessToken),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kWhatsAccessToken,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 5),
                  Text(kAccessTokenDefinition),
                  SizedBox(height: 20),
                  Text(
                    kAccessTokenRequired,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 20),
                  Text(
                    kHowToGetAccessToken,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 5),
                  Text(kHowToGetAccessToken1),
                  Text(kHowToGetAccessToken2),
                  Text(kHowToGetAccessToken3),
                  Text(kHowToGetAccessToken4),
                  Text(kHowToGetAccessToken5),
                  SizedBox(height: 20),
                  Text(
                    kAccessTokenSecurityNotice,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Text(kGetAccessToken),
                onPressed: () => NicheMethod().launchURL(kAnonAddySettingsURL),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildFooter(
      BuildContext context, bool isDark, LoginStateManager loginManager) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.1,
      width: size.width,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Color(0xFFF5F7FA),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(),
        key: Key('loginButton'),
        child: loginManager.isLoading
            ? CircularProgressIndicator(
                key: Key('loginLoadingIndicator'),
                backgroundColor: kPrimaryColor,
              )
            : Text(
                'Login',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.black),
              ),
        onPressed: () => loginManager.login(
            context, _textEditingController.text.trim(), _formKey),
      ),
    );
  }
}
