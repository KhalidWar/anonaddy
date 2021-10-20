import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class PlatformAware<C extends Widget, M extends Widget>
    extends StatelessWidget {
  const PlatformAware({Key? key}) : super(key: key);

  C buildCupertinoWidget(BuildContext context);
  M buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    } else {
      return buildMaterialWidget(context);
    }
  }
}
