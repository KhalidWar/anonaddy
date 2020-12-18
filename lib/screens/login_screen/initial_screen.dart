import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../constants.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: context.read(accessTokenServiceProvider).getAccessToken(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return LottieWidget(
                lottie: 'assets/lottie/errorCone.json',
                label: kNoInternetConnection,
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
    );
  }
}
