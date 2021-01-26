import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar {
  final isIOS = TargetedPlatform().isIOS();

  Widget androidAppBar(BuildContext context, String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
      child: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // Widget iOSAppBar(BuildContext context, String title) {
  //   return CupertinoNavigationBar(
  //     middle: Text(title, style: TextStyle(color: Colors.white)),
  //     backgroundColor: kBlueNavyColor,
  //     actionsForegroundColor: Colors.white,
  //   );
  // }
}
