import 'package:animations/animations.dart';
import 'package:anonaddy/screens/app_settings/about_app_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/services/secure_app_service/secure_app_service.dart';
import 'package:anonaddy/services/theme/theme_service.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:anonaddy/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: kBlueNavyColor),
      child: Scaffold(
        appBar: AppBar(title: Text('App Settings')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // todo implement feedback mechanism.
            // todo Give dev email to receive feedback and suggestions
            // todo encourage users to get into beta program
            ListTile(
              title: Text(
                'Dark Theme',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text('App follows system by default'),
              trailing: Switch.adaptive(
                value: context.read(themeServiceProvider).isDarkTheme,
                onChanged: (toggle) =>
                    context.read(themeServiceProvider).toggleTheme(),
              ),
              onTap: () => context.read(themeServiceProvider).toggleTheme(),
            ),
            Consumer(
              builder: (_, watch, __) {
                final secureApp = watch(secureAppProvider);
                return ListTile(
                  title: Text(
                    'Secure App',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    'Blocks screenshots, screen recording, and app switcher view',
                  ),
                  trailing: Switch.adaptive(
                    value: secureApp.isAppSecured,
                    onChanged: (toggle) => secureApp.toggleSecureApp(),
                  ),
                  onTap: () => secureApp.toggleSecureApp(),
                );
              },
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
        ),
      ),
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
