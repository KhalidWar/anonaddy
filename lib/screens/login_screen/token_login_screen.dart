import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
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
    final isLoading = loginManager.isLoading;
    final login = loginManager.login;
    final pasteFromClipboard = loginManager.pasteFromClipboard;

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
                  Padding(
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
                                  validator: (input) => FormValidator()
                                      .accessTokenValidator(input),
                                  controller: _textEditingController,
                                  onFieldSubmitted: (input) => login(
                                      context,
                                      _textEditingController.text.trim(),
                                      _formKey),
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
                                    hintText: 'Enter Access Token!',
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              key: Key('pasteFromClipboard'),
                              icon: Icon(Icons.paste),
                              onPressed: () => pasteFromClipboard(
                                _textEditingController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    key: Key('loginGetAccessToken'),
                    child: Text(
                      'What is Access Token?',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    onTap: () => buildShowModal(context),
                  ),
                  Container(
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
                      child: isLoading
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
                      onPressed: () {
                        login(
                          context,
                          _textEditingController.text.trim(),
                          _formKey,
                        );
                      },
                    ),
                  ),
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

  Future buildShowModal(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBottomSheetBorderRadius),
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomSheetHeader(headerLabel: 'What is Access Token?'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s Access Token?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Access Token is a long string of alphanumeric characters used to access your account without giving away account\'s username and password.',
                  ),
                  SizedBox(height: 5),
                  Text(
                    'To access your AnonAddy account, you\'ll have to provide your own Access Token.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'How to get Access Token?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 5),
                  Text('1. Login to your AnonAddy account'),
                  Text('2. Go to Settings'),
                  Text('3. Scroll down to API section'),
                  Text('4. Click on Generate New Token'),
                  Text('5. Paste it as is in Login field'),
                  SizedBox(height: 20),
                  Text(
                    'Security Notice: do NOT re-use Access Tokens. Make sure to generate a new token for every service you use.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Text('Get Access Token'),
                onPressed: () => NicheMethod().launchURL(kAnonAddySettingsURL),
              ),
            ),
          ],
        );
      },
    );
  }
}
