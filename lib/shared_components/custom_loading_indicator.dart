import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator {
  final _isIOS = TargetedPlatform().isIOS();

  Widget customLoadingIndicator() {
    return _isIOS
        ? CupertinoActivityIndicator(radius: 15)
        : Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: kAccentColor),
          );
  }
}
