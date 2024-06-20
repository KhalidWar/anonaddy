import 'package:anonaddy/common/constants/app_colors.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformLoadingIndicator extends PlatformAware {
  const PlatformLoadingIndicator({
    super.key,
    this.color,
    this.size,
  });

  final Color? color;
  final double? size;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoActivityIndicator(color: color);
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.accentColor,
      ),
    );
  }
}
