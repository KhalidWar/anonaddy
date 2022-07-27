import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformAware {
  const PlatformButton({
    Key? key,
    required this.child,
    required this.onPress,
    this.color,
  }) : super(key: key);
  final Widget child;
  final Function() onPress;
  final Color? color;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoButton(
      color: color ?? AppColors.accentColor,
      padding: const EdgeInsets.all(0),
      onPressed: onPress,
      child: child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        primary: color ?? AppColors.accentColor,
      ),
      onPressed: onPress,
      child: child,
    );
  }
}
