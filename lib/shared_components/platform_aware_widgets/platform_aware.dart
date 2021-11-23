import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PlatformAware<C extends Widget, M extends Widget>
    extends StatelessWidget {
  const PlatformAware({Key? key}) : super(key: key);

  C buildCupertinoWidget(BuildContext context);
  M buildMaterialWidget(BuildContext context);

  /// This function's main use is to simplify development.
  /// It's to be used everywhere a platform check is needed.
  /// Uncomment "return true" statement to force app to present
  /// iOS UI if you don't have an iOS device when developing.
  static bool isIOS() {
    // return true;
    if (Platform.isIOS)
      return true;
    else
      return false;
  }

  /// Custom page route animation
  static customPageRoute(Widget child) {
    if (isIOS()) {
      return CupertinoPageRoute(
        builder: (BuildContext context) => child,
      );
    } else {
      return PageRouteBuilder(
        transitionsBuilder: (context, animation, secondAnimation, child) {
          final tween = Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
          animation =
              CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);
          return SlideTransition(
            position: tween.animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondAnimation) => child,
      );
    }
  }

  /// Shows platform dialog
  static platformDialog(
      {required BuildContext context, required Widget child}) {
    if (isIOS()) {
      showCupertinoDialog(
        context: context,
        builder: (context) => child,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isIOS()) {
      return buildCupertinoWidget(context);
    } else {
      return buildMaterialWidget(context);
    }
  }
}
