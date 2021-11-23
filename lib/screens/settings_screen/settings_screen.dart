import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/authorization_screen/logout_screen.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/state_management/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/state_management/settings/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'about_app_screen.dart';
import 'components/app_version.dart';
import 'components/rate_addymanager.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'settingsScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final nicheMethod = context.read(nicheMethods);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Consumer(
        builder: (_, watch, __) {
          final settingsState = watch(settingsStateNotifier);
          final settingsNotifier = context.read(settingsStateNotifier.notifier);
          final biometric = watch(biometricNotifier);

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
                trailing: PlatformSwitch(
                  value: settingsState.isDarkTheme!,
                  onChanged: (toggle) => settingsNotifier.toggleTheme(),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Auto Copy Email',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text('Automatically copy email after alias creation'),
                trailing: PlatformSwitch(
                  value: settingsState.isAutoCopy!,
                  onChanged: (toggle) => settingsNotifier.toggleAutoCopy(),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'Biometric Authentication',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text('Require biometric authentication'),
                trailing: PlatformSwitch(
                  value: biometric.isEnabled,
                  onChanged: (toggle) => context
                      .read(biometricNotifier.notifier)
                      .toggleBiometric(toggle),
                ),
              ),
              Divider(height: 0),
              ListTile(
                dense: true,
                title: Text(
                  'AnonAddy Help Center',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text('AnonAddy\'s terminologies...etc.'),
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
                  Navigator.pushNamed(context, AboutAppScreen.routeName);
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
                  onPressed: () => buildLogoutDialog(context),
                ),
              ),
              SizedBox(height: size.height * 0.01),
            ],
          );
        },
      ),
    );
  }

  void buildLogoutDialog(BuildContext context) {
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: 'Logout',
        content: kLogOutAlertDialog,
        method: () {
          Navigator.pushReplacementNamed(context, LogoutScreen.routeName);
        },
      ),
    );
  }
}
