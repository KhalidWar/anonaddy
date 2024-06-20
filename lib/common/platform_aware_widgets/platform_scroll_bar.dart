import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformScrollbar extends PlatformAware {
  const PlatformScrollbar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoScrollbar(child: child);
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Scrollbar(child: child);
  }
}
