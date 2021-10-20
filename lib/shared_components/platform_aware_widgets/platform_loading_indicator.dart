import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformLoadingIndicator extends PlatformAware {
  const PlatformLoadingIndicator({this.color});
  final Color? color;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoActivityIndicator();
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return CircularProgressIndicator(color: color ?? kAccentColor);
  }
}
