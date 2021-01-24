import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator {
  final isIOS = TargetedPlatform().isIOS();

  Widget customLoadingIndicator() {
    return isIOS
        ? CupertinoActivityIndicator(radius: 15)
        : CircularProgressIndicator();
  }
}
