import 'package:animations/animations.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'about_app_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('App Settings')),
      body: Consumer(builder: (_, watch, __) {
        final settings = watch(settingsStateManagerProvider);

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // todo encourage users to get into beta program
            ListTile(
              title: Text(
                'Dark Theme',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('App follows system by default'),
              trailing: IgnorePointer(
                child: Switch.adaptive(
                    value: settings.isDarkTheme, onChanged: (toggle) {}),
              ),
              onTap: () => settings.toggleTheme(),
            ),
            ListTile(
              title: Text(
                'Secure App',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text(
                'Block screenshot and screen recording',
              ),
              trailing: IgnorePointer(
                child: Switch.adaptive(
                    value: settings.isAppSecured, onChanged: (toggle) {}),
              ),
              onTap: () => settings.toggleSecureApp(),
            ),
            ListTile(
              title: Text(
                'Auto Copy Email',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text(
                'Automatically copy email after alias creation',
              ),
              trailing: IgnorePointer(
                child: Switch.adaptive(
                    value: settings.isAutoCopy, onChanged: (toggle) {}),
              ),
              onTap: () => settings.toggleAutoCopy(),
            ),
            ListTile(
              title: Text(
                'About App',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('View AddyManager details'),
              trailing: Icon(Icons.help_outline),
              onTap: () {
                Navigator.push(context, CustomPageRoute(AboutAppScreen()));
              },
            ),
            Spacer(),
            Container(
              width: size.width,
              height: size.height * 0.05,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.red,
                ),
                child: Text('Log out'),
                onPressed: () => buildLogoutDialog(context),
              ),
            ),
            SizedBox(height: size.height * 0.01),
          ],
        );
      }),
    );
  }

  Future buildLogoutDialog(BuildContext context) {
    final logout = context.read(loginStateManagerProvider).logout;
    final confirmationDialog = ConfirmationDialog();

    signOut() async {
      await logout(context).whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TokenLoginScreen();
            },
          ),
        );
      });
    }

    return showModal(
      context: context,
      builder: (context) {
        return TargetedPlatform().isIOS()
            ? confirmationDialog.iOSAlertDialog(
                context, kSignOutAlertDialog, signOut, 'Sign out')
            : confirmationDialog.androidAlertDialog(
                context, kSignOutAlertDialog, signOut, 'Sign out');
      },
    );
  }
}
