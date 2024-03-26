import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This class is used to display the appropriate widgets for
/// whatever platform AddyManager is running on.
/// For example, show [Cupertino] buttons when on iPhone
/// and [Material] buttons when on Android.
///
/// I'm planning on expanding this class to cover every
/// platform specific UI.
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
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  /// Custom page route animation
  static customPageRoute(Widget child) {
    if (isIOS()) {
      return CupertinoPageRoute(
        builder: (BuildContext context) => child,
      );
    } else {
      return MaterialPageRoute(
        builder: (BuildContext context) => child,
      );
    }
  }

  /// Shows platform base dialog that can contain other dialogs such as
  /// alert and info dialogs. The purpose of this dialog is to mimic the
  /// behavior of platform specific dialogs.
  ///
  /// For example, iOS dialogs don't dismiss when tapped outside
  /// the dialog container. That's not the case for Android dialogs.
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
