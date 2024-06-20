import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformAware {
  const PlatformButton({
    super.key,
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
        backgroundColor: color ?? AppColors.accentColor,
      ),
      onPressed: onPress,
      child: child,
    );
  }
}
