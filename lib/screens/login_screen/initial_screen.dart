import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/screens/login_screen/anonaddy_login_screen.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ConsumerWidget is used to update state using ChangeNotifierProvider
class InitialScreen extends ConsumerWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    /// Use [watch] method to access different providers
    /// and returns AsyncValue of same type.
    final accessTokenAsync = watch(accessTokenProvider);

    /// Customize Status Bar and Bottom Navigator Bar colors.
    return Scaffold(
      key: Key('initialScreenScaffold'),
      backgroundColor: kPrimaryColor,

      /// AsyncValue's [when] function returns 3 states:
      body: accessTokenAsync.when(
        /// 1) future is loading
        loading: () => Container(),

        /// 2) data is obtained
        data: (accessToken) {
          if (accessToken.isEmpty) {
            return AnonAddyLoginScreen();
          } else {
            return HomeScreen();
          }
        },

        /// 3) error is thrown
        error: (error, stackTrace) {
          return LottieWidget(
            key: Key('errorWidget'),
            lottie: 'assets/lottie/errorCone.json',
            label: error.toString(),
          );
        },
      ),
    );
  }
}
