import 'package:animations/animations.dart';
import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/home_screen_components/settings_screen/components/rate_addymanager.dart';
import 'package:anonaddy/screens/login_screen/logout_screen.dart';
import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'about_app_screen.dart';
import 'components/app_version.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final nicheMethod = context.read(nicheMethods);
    final isIOS = context.read(targetedPlatform).isIOS();

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Consumer(builder: (_, watch, __) {
        final settings = watch(settingsStateManagerProvider);
        final biometricAuth = context.read(biometricAuthServiceProvider);

        Future<void> enableBiometricAuth() async {
          await biometricAuth.canEnableBiometric().then((canCheckBio) async {
            await biometricAuth.authenticate(canCheckBio).then((isAuthSuccess) {
              if (isAuthSuccess) {
                settings.toggleBiometricRequired();
              } else {
                nicheMethod.showToast(kFailedToAuthenticate);
              }
            }).catchError((error) => nicheMethod.showToast(error.toString()));
          }).catchError((error) => nicheMethod.showToast(error.toString()));
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              dense: true,
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
              dense: true,
              title: Text(
                'Auto Copy Email',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('Automatically copy email after alias creation'),
              trailing: IgnorePointer(
                child: Switch.adaptive(
                  value: settings.isAutoCopy,
                  onChanged: (toggle) {},
                ),
              ),
              onTap: () => settings.toggleAutoCopy(),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Biometric Authentication',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('Require biometric authentication'),
              trailing: IgnorePointer(
                child: Switch.adaptive(
                  value: settings.isBiometricAuth,
                  onChanged: (toggle) {},
                ),
              ),
              onTap: () => enableBiometricAuth(),
            ),
            Divider(height: 0),
            ListTile(
              dense: true,
              title: Text(
                'AnonAddy Help Center',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('Learn more about AnonAddy'),
              trailing: Icon(Icons.open_in_new_outlined),
              onTap: () => nicheMethod.launchURL(kAnonAddyHelpCenterURL),
            ),
            ListTile(
              dense: true,
              title: Text(
                'AnonAddy FAQ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('Learn more about AnonAddy'),
              trailing: Icon(Icons.open_in_new_outlined),
              onTap: () => nicheMethod.launchURL(kAnonAddyFAQURL),
            ),
            Divider(height: 0),
            ListTile(
              dense: true,
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
            // ListTile(
            //   title: Text(
            //     'Logout',
            //     textAlign: TextAlign.center,
            //   ),
            //   tileColor: Colors.red,
            //   onTap: () {
            //     Navigator.push(context, CustomPageRoute(AboutAppScreen()));
            //   },
            // ),
            const Spacer(),
            const AppVersion(),
            const RateAddyManager(),
            Container(
              width: size.width,
              height: size.height * 0.05,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.red,
                ),
                child: Text('Logout'),
                onPressed: () => buildLogoutDialog(context, isIOS),
              ),
            ),
            SizedBox(height: size.height * 0.01),
          ],
        );
      }),
    );
  }

  Future buildLogoutDialog(BuildContext context, bool isIOS) {
    final confirmDialog = context.read(confirmationDialog);

    logout() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogoutScreen()),
      );
    }

    return showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? confirmDialog.iOSAlertDialog(
                context, kLogOutAlertDialog, logout, 'Logout')
            : confirmDialog.androidAlertDialog(
                context, kLogOutAlertDialog, logout, 'Logout');
      },
    );
  }
}
