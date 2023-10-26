import 'package:anonaddy/notifiers/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/notifiers/settings/settings_notifier.dart';
import 'package:anonaddy/screens/authorization_screen/logout_screen.dart';
import 'package:anonaddy/screens/settings_screen/about_app_screen.dart';
import 'package:anonaddy/screens/settings_screen/components/app_version.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = 'settingsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsNotifier);
    final biometric = ref.watch(biometricNotifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.settings,
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: false,
      ),
      body: settingsState.when(
        data: (settings) {
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsDarkTheme,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: const Text(AppStrings.settingsDarkThemeSubtitle),
                trailing: PlatformSwitch(
                  value: settings.isDarkTheme,
                  onChanged: (toggle) {
                    ref.read(settingsNotifier.notifier).toggleTheme();
                  },
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsAutoCopyEmail,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: const Text(AppStrings.settingsAutoCopyEmailSubtitle),
                trailing: PlatformSwitch(
                  value: settings.isAutoCopyEnabled,
                  onChanged: (toggle) {
                    ref.read(settingsNotifier.notifier).toggleAutoCopy();
                  },
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsBiometricAuth,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: const Text(AppStrings.settingsBiometricAuthSubtitle),
                trailing: PlatformSwitch(
                  value: biometric.isEnabled,
                  onChanged: (toggle) => ref
                      .read(biometricNotifier.notifier)
                      .toggleBiometric(toggle),
                ),
              ),
              const Divider(height: 0),
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsAnonAddyHelpCenter,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle:
                    const Text(AppStrings.settingsAnonAddyHelpCenterSubtitle),
                trailing: const Icon(Icons.open_in_new_outlined),
                onTap: () => Utilities.launchURL(kAnonAddyHelpCenterURL),
              ),
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsAnonAddyFAQ,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: const Text(AppStrings.settingsAnonAddyFAQSubtitle),
                trailing: const Icon(Icons.open_in_new_outlined),
                onTap: () => Utilities.launchURL(kAnonAddyFAQURL),
              ),
              const Divider(height: 0),
              const AppVersion(),
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsAboutApp,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: const Text(AppStrings.settingsAboutAppSubtitle),
                trailing: const Icon(Icons.help_outline),
                onTap: () {
                  Navigator.pushNamed(context, AboutAppScreen.routeName);
                },
              ),
              ListTile(
                dense: true,
                title: Text(
                  AppStrings.settingsEnjoyingApp,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: const Text(AppStrings.settingsEnjoyingAppSubtitle),
                trailing: const Icon(Icons.help_outline),
                onTap: () {
                  Utilities.launchURL(
                    PlatformAware.isIOS()
                        ? kAddyManagerAppStoreURL
                        : kAddyManagerPlayStoreURL,
                  );
                },
              ),
              const Divider(height: 20),
              TextButton(
                child: Text(
                  AppStrings.settingsLogout,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.red),
                  textAlign: TextAlign.left,
                ),
                onPressed: () {
                  PlatformAware.platformDialog(
                    context: context,
                    child: PlatformAlertDialog(
                      title: AppStrings.settingsLogout,
                      content: AppStrings.logOutAlertDialog,
                      method: () {
                        Navigator.pushReplacementNamed(
                            context, LogoutScreen.routeName);
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
        error: (err, _) => Center(child: Text(err.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
