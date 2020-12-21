import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final accessTokenManager = FutureProvider(
  (ref) => ref.watch(accessTokenServiceProvider).getAccessToken(),
);

class InitialScreen extends ConsumerWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accessToken = watch(accessTokenManager);
    return Scaffold(
      body: accessToken.when(
        loading: () => LoadingWidget(),
        data: (data) {
          if (data == null) {
            return TokenLoginScreen();
          } else {
            return HomeScreen();
          }
        },
        error: (error, stackTrace) => LottieWidget(
          lottie: 'assets/lottie/errorCone.json',
          label: error,
        ),
      ),
    );
  }
}
