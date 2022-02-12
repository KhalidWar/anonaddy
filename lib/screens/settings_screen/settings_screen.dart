import 'package:anonaddy/screens/authorization_screen/logout_screen.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/state_management/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/state_management/settings/settings_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'about_app_screen.dart';
import 'components/app_version.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'settingsScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Consumer(
        builder: (_, ref, __) {
          final settingsState = ref.watch(settingsStateNotifier);
          final settingsNotifier = ref.read(settingsStateNotifier.notifier);
          final biometric = ref.watch(biometricNotifier);

          return ListView(
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
                  onChanged: (toggle) => ref
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
                onTap: () => NicheMethod.launchURL(kAnonAddyHelpCenterURL),
              ),
              ListTile(
                dense: true,
                title: Text(
                  'AnonAddy FAQ',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text('Learn more about AnonAddy'),
                trailing: Icon(Icons.open_in_new_outlined),
                onTap: () => NicheMethod.launchURL(kAnonAddyFAQURL),
              ),
              Divider(height: 0),
              AppVersion(),
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
              ListTile(
                dense: true,
                title: Text(
                  'Enjoying AddyManager?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text('Tap to rate it on the App Store'),
                trailing: Icon(Icons.help_outline),
                onTap: () {
                  NicheMethod.launchURL(
                    PlatformAware.isIOS()
                        ? kAddyManagerAppStoreURL
                        : kAddyManagerPlayStoreURL,
                  );
                },
              ),
              Divider(height: 0),
              SizedBox(height: size.height * 0.01),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text('All app data will be deleted'),
                  trailing: Icon(Icons.logout),
                  onTap: () => buildLogoutDialog(context),
                ),
              ),
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
