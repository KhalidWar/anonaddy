import 'dart:io';

import 'package:flutter/material.dart';

class PlatformApp extends StatelessWidget {
  const PlatformApp({
    Key? key,
    required this.mobileApp,
    required this.desktopApp,
  }) : super(key: key);
  final Widget mobileApp;
  final Widget desktopApp;

  static const _mobileWidth = 600;
  // static const _desktopWidth = 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (Platform.isIOS) return mobileApp;

        if (constraint.maxWidth == _mobileWidth) {
          return mobileApp;
        }

        return desktopApp;
      },
    );
  }
}
