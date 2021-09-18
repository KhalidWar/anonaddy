import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator {
  const CustomLoadingIndicator(this._isIOS);
  final bool _isIOS;

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
