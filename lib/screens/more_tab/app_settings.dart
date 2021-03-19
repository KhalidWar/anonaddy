import 'package:animations/animations.dart';
import 'package:anonaddy/screens/app_settings/about_app_screen.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/services/secure_app_service/secure_app_service.dart';
import 'package:anonaddy/services/theme/theme_service.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/target_platform.dart';
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
      value: SystemUiOverlayStyle(
        statusBarColor: kBlueNavyColor,
        systemNavigationBarColor: Colors.red,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('App Settings')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                      'Disables screenshot taking and blocks app switcher view'),
                  trailing: Switch.adaptive(
                    value: secureApp.isAppSecured,
                    onChanged: (toggle) => secureApp.toggleSecureApp(),
                  ),
                  onTap: () => secureApp.toggleSecureApp(),
                );
              },
            ),
            Spacer(),
            ListTile(
              title: Center(
                child: Text(
                  'About App',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionsBuilder:
                        (context, animation, secondAnimation, child) {
                      animation = CurvedAnimation(
                          parent: animation, curve: Curves.linearToEaseOut);

                      return SlideTransition(
                        position: Tween(
                          begin: Offset(1.0, 0.0),
                          end: Offset(0.0, 0.0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondAnimation) {
                      return AboutAppScreen();
                    },
                  ),
                );
              },
            ),
            Container(
              height: size.height * 0.08,
              child: ListTile(
                tileColor: Colors.red,
                title: Center(
                  child: Text(
                    'Log Out',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                onTap: () => buildLogoutDialog(context),
              ),
            ),
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
