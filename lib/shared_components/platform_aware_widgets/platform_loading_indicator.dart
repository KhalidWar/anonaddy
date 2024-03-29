import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformLoadingIndicator extends PlatformAware {
  const PlatformLoadingIndicator({
    Key? key,
    this.color,
    this.size,
  }) : super(key: key);
  final Color? color;
  final double? size;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return const CupertinoActivityIndicator();
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
