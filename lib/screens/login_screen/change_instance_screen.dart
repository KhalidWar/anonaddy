import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeInstanceScreen extends StatefulWidget {
  @override
  _ChangeInstanceScreenState createState() => _ChangeInstanceScreenState();
}

class _ChangeInstanceScreenState extends State<ChangeInstanceScreen> {
  final _urlEditingController = TextEditingController();
  final _tokenEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text('Change Instance')),
      backgroundColor: kPrimaryColor,
      body: Center(
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
                    TextFormField(
                      validator: (input) =>
                          FormValidator().validateInstanceURL(input),
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
                        hintText: 'https://app.anonaddy.com',
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
                    TextFormField(
                      validator: (input) =>
                          FormValidator().accessTokenValidator(input),
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
                        hintText: 'Enter you API token',
                      ),
                    ),
                  ],
                ),
              ),
              Container(),
              GestureDetector(
                child: Text(
                  'How to self-host AnonAddy?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () => NicheMethod().launchURL(kAnonAddySelfHostingURL),
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
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
