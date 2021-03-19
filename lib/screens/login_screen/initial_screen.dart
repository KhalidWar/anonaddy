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

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class InitialScreen extends ConsumerWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    /// and returns AsyncValue of same type.
    final accessToken = watch(accessTokenManager);

    /// Customize Status Bar and Bottom Navigator Bar colors.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: kBlueNavyColor,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        key: Key('initialScreenScaffold'),
        backgroundColor: kBlueNavyColor,

        /// AsyncValue's [when] function returns 3 states:
        body: accessToken.when(
          /// 1) future is loading
          loading: () => Container(),

          /// 2) data is obtained
          data: (data) {
            if (data == null) {
              return TokenLoginScreen();
            } else {
              return HomeScreen();
            }
          },

          /// 3) error is thrown
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
