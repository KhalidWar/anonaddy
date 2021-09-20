import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

class ChangeInstanceScreen extends StatelessWidget {
  final _urlEditingController = TextEditingController();
  final _tokenEditingController = TextEditingController();
  final _urlFormKey = GlobalKey<FormState>();
  final _tokenFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final validator = context.read(formValidator);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(elevation: 0, title: Text('Change Instance')),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
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
                                validator.validateInstanceURL(input!),
                            controller: _urlEditingController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              border: OutlineInputBorder(),
                              hintText: 'app.anonaddy.com',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'API Token ',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text('(from the settings page)'),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Form(
                          key: _tokenFormKey,
                          child: TextFormField(
                            validator: (input) =>
                                validator.accessTokenValidator(input!),
                            controller: _tokenEditingController,
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
                              border: OutlineInputBorder(),
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
                    child: Text('How to self-host AnonAddy?'),
                    onPressed: () => context
                        .read(nicheMethods)
                        .launchURL(kAnonAddySelfHostingURL),
                  ),
                  Consumer(
                    builder: (_, watch, __) {
                      final loginManager = watch(loginStateManagerProvider);
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return Container(
                        height: size.height * 0.1,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black : Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
                                      .headline5!
                                      .copyWith(color: Colors.black),
                                ),
                          onPressed: () => loginManager.login(
                            context,
                            _tokenEditingController.text.trim(),
                            _tokenFormKey,
                            instanceURL: _urlEditingController.text.trim(),
                            urlFormKey: _urlFormKey,
                          ),
                        ),
                      );
                    },
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
