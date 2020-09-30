import 'package:anonaddy/constants.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/services/login_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TokenLoginScreen extends StatefulWidget {
  @override
  _TokenLoginScreenState createState() => _TokenLoginScreenState();
}

class _TokenLoginScreenState extends State<TokenLoginScreen> {
  final AccessTokenManager _loginManager = AccessTokenManager();
  TextEditingController _textEditingController = TextEditingController();
  bool _showError = false;

  Widget errorMessage() {
    return Container(
        child: Text(
      'Please enter Access Token!',
      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red),
    ));
  }

  Future logIn() async {
    if (_textEditingController.text.isNotEmpty) {
      await _loginManager
          .saveAccessToken(_textEditingController.text.toString());

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    } else {
      setState(() {
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kAppBarColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: size.width * 0.5,
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  height: size.height * 0.6,
                  width: size.width * 0.8,
                  padding: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Welcome!',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login with Access Token',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: size.height * 0.01),
                            TextField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kAccentColor),
                                ),
                                border: OutlineInputBorder(),
                                hintText: 'Paste here!',
                              ),
                            ),
                            _showError ? errorMessage() : Container(),
                            SizedBox(height: size.height * 0.01),
                            GestureDetector(
                              child: Text('How to get Access Token?'),
                              onTap: () {
                                //todo add how to get Access Token
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.1,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        child: RaisedButton(
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          onPressed: () {
                            logIn();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
