import 'package:anonaddy/constants.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accessTokenManager = FutureProvider(
  (ref) => ref.watch(accessTokenServiceProvider).getAccessToken(),
);

class InitialScreen extends ConsumerWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accessToken = watch(accessTokenManager);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: kBlueNavyColor,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        key: Key('initialScreenScaffold'),
        backgroundColor: kBlueNavyColor,
        body: accessToken.when(
          loading: () => Center(
              child: CircularProgressIndicator(key: Key('loadingIndicator'))),
          data: (data) {
            if (data == null) {
              return TokenLoginScreen();
            } else {
              return HomeScreen();
            }
          },
          error: (error, stackTrace) {
            return LottieWidget(
              key: Key('errorWidget'),
              lottie: 'assets/lottie/errorCone.json',
              label: error,
            );
          },
        ),
      ),
    );
  }
}
