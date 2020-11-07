import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/services/access_token_service.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TokenLoginScreen extends StatefulWidget {
  @override
  _TokenLoginScreenState createState() => _TokenLoginScreenState();
}

class _TokenLoginScreenState extends State<TokenLoginScreen> {
  TextEditingController _textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _error = '';

  Future _logIn() async {
    final _accessTokenManager = serviceLocator<AccessTokenService>();
    final textInput = _textEditingController.text.trim();

    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      if (await serviceLocator<APIService>().validateAccessToken(textInput) ==
          true) {
        await _accessTokenManager.saveAccessToken(textInput.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        await _accessTokenManager.removeAccessToken();
        setState(() {
          _isLoading = false;
          _error = 'Invalid Access Token';
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _error = '';
      });
    }
  }

  Future _pasteFromClipboard() async {
    ClipboardData data = await Clipboard.getData('text/plain');
    if (data == null || data.text.isEmpty) {
      setState(() {
        _error = 'Nothing to paste. Clipboard is empty.';
      });
    } else {
      _textEditingController.clear();
      setState(() {
        _textEditingController.text = data.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF19216C),
        body: Form(
          key: _formKey,
          child: Center(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) => value.length < 1
                                          ? 'Please Enter Access Token'
                                          : null,
                                      controller: _textEditingController,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        border: OutlineInputBorder(),
                                        hintText: 'Paste here!',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.paste),
                                    onPressed: () {
                                      _pasteFromClipboard();
                                    },
                                  ),
                                ],
                              ),
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
                        Text(
                          _error,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.red),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 50),
                          child: RaisedButton(
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Color(0xFF19216C))
                                : Text(
                                    'Login',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                            onPressed: () => _logIn(),
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
      ),
    );
  }
}
