import 'dart:io';

import 'package:anonaddy/services/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
      return PageRouteBuilder(
        transitionsBuilder: (context, animation, secondAnimation, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          );
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

  /// Displays platform specific modal sheets. iOS sheets expand and cover
  /// the full height of the screen unlike Android modal sheets.
  static platformModalSheet(
      {required BuildContext context, required Widget child}) {
    if (isIOS()) {
      return showCupertinoModalBottomSheet(
        context: context,
        expand: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
          ),
        ),
        builder: (context) {
          /// [Material] widget is needed to wrap material input fields
          return Material(child: child);
        },
      );
    } else {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
          ),
        ),
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
