import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppBar {
  Widget androidAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget iOSAppBar(BuildContext context, String title) {
    return CupertinoNavigationBar(
      middle: Text(title, style: TextStyle(color: Colors.white)),
      backgroundColor: kBlueNavyColor,
      actionsForegroundColor: Colors.white,
    );
  }
}
