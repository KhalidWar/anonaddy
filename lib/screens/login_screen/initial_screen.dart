import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/services/access_token_service.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../error_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: context.read(accessTokenServiceProvider).getAccessToken(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return ErrorScreen(
                  label: 'No Internet Connection.\nMake sure you\'re online.',
                  buttonLabel: 'Reload',
                  buttonOnPress: () {},
                );
                break;
              case ConnectionState.waiting:
                return LoadingWidget();
              default:
                if (snapshot.data == null) {
                  return TokenLoginScreen();
                } else {
                  return HomeScreen();
                }
            }
          },
        ),
      ),
    );
  }
}
