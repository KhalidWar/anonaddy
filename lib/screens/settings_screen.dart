import 'package:anonaddy/services/login_manager.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'initial_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AccessTokenManager loginManager = AccessTokenManager();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kAppBarColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RaisedButton(
                child: Text('Log Out'),
                onPressed: () {
                  loginManager.removeAccessToken();

                  //todo remove navigation stack upon log out
                  // Navigator.pushAndRemoveUntil(context, InitialScreen(), (route) => false);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return InitialScreen();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
