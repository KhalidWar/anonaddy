import 'package:anonaddy/services/access_token_manager.dart';
import 'package:anonaddy/services/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'initial_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AccessTokenManager loginManager = AccessTokenManager();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<ThemeManager>(
                builder: (context, themeManager, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dark Theme'),
                      Switch(
                        value: themeManager.isDarkTheme,
                        onChanged: (toggle) {
                          themeManager.toggleTheme();
                        },
                      ),
                    ],
                  );
                },
              ),
              //todo add about app
              //todo add license info
              Container(
                width: double.infinity,
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
      ),
    );
  }
}
