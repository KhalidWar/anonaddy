import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/token_login_screen.dart';
import 'package:anonaddy/services/access_token_service.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  void initialWidget() async {
    var token = await AccessTokenService().getAccessToken();
    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return TokenLoginScreen();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }));
    }
  }

  @override
  void initState() {
    super.initState();
    initialWidget();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingWidget(),
      ),
    );
  }
}
