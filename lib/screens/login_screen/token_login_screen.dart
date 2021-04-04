import 'package:animations/animations.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(systemNavigationBarColor: kBlueNavyColor),
        child: Scaffold(
          key: Key('loginScreenScaffold'),
          appBar: AppBar(elevation: 0, brightness: Brightness.dark),
          backgroundColor: kBlueNavyColor,
          body: Center(
            child: SingleChildScrollView(
              child: Card(
                child: Container(
                  height: size.height * 0.6,
                  width: size.width * 0.8,
                  padding: EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'AddyManager',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Divider(
                            color: Color(0xFFE4E7EB),
                            thickness: 2,
                            indent: size.width * 0.30,
                            endIndent: size.width * 0.30,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
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
                                      minLines: 1,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                        border: OutlineInputBorder(),
                                        hintText: 'Paste here!',
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
                              SizedBox(height: size.height * 0.01),
                              GestureDetector(
                                key: Key('loginGetAccessToken'),
                                child: Text(
                                  'How to get Access Token?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                onTap: () {
                                  buildShowModal(context);
                                },
                              ),
                            ],
                          ),
                        ),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          key: Key('loginButton'),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  key: Key('loginLoadingIndicator'),
                                  backgroundColor: kBlueNavyColor,
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
        ),
      ),
    );
  }

  buildShowModal(BuildContext context) async {
    showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text('How to get Access Token?'),
          content: Text(kGetAccessToken),
          actions: [
            FlatButton(
              child: Text('Get Token Now!'),
              onPressed: () async {
                await launch(kAnonAddySettingsAPIURL)
                    .catchError((error, stackTrace) {
                  throw Fluttertoast.showToast(
                    msg: error.message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[600],
                  );
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
