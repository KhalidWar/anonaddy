import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformAware {
  const PlatformButton({
    required this.child,
    required this.onPress,
    this.color,
  });
  final Widget child;
  final Function() onPress;
  final Color? color;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoButton(
      color: color ?? kAccentColor,
      padding: EdgeInsets.all(0),
      child: child,
      onPressed: onPress,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        primary: color ?? kAccentColor,
      ),
      child: child,
      onPressed: onPress,
    );
  }
}
