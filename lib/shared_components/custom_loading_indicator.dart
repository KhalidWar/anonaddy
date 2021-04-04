import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator {
  final _isIOS = TargetedPlatform().isIOS();

  Widget customLoadingIndicator() {
    return _isIOS
        ? CupertinoActivityIndicator(radius: 15)
        : CircularProgressIndicator();
  }
}
