import 'dart:io';

import 'package:flutter/cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    } else {
      return buildMaterialWidget(context);
    }
  }
}
