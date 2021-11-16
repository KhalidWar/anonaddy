import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformAware {
  const PlatformButton({
    required this.label,
    required this.onPress,
    this.color,
    this.labelColor,
  });
  final String label;
  final Function() onPress;
  final Color? color, labelColor;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoButton(
      color: color ?? kAccentColor,
      padding: EdgeInsets.all(0),
      child: Text(
        label,
        style: TextStyle(color: labelColor),
      ),
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
      child: Text(
        label,
        style: TextStyle(color: labelColor),
      ),
      onPressed: onPress,
    );
  }
}
