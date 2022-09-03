import 'package:anonaddy/screens/settings_screen/credits_screen.dart';
import 'package:anonaddy/services/package_info_service/package_info_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  static const routeName = 'aboutAppScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'About App',
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: false,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        children: [
          buildHeader(context),
          SizedBox(height: size.height * 0.02),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Khalid Warsame'),
            subtitle: const Text('AddyManager developer'),
            trailing: const Icon(Icons.account_circle_outlined),
            onTap: () => NicheMethod.launchURL(kKhalidWarGithubURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Will Browning (AnonAddy team)'),
            subtitle: const Text('Contributor'),
            trailing: const Icon(Icons.account_circle_outlined),
            onTap: () => NicheMethod.launchURL(kWillBrowningGithubURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Exodus Privacy Report'),
            subtitle: const Text('Exodus\'s privacy report of AddyManager'),
            trailing: const Icon(Icons.shield_outlined),
            onTap: () => NicheMethod.launchURL(kExodusPrivacyURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Found a bug?'),
            subtitle: const Text('Report bugs and request features'),
            trailing: const Icon(Icons.bug_report_outlined),
            onTap: () => NicheMethod.launchURL(kAddyManagerIssuesURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Source Code'),
            subtitle: const Text('AddyManager\'s open source code'),
            trailing: const Icon(Icons.code_outlined),
            onTap: () => NicheMethod.launchURL(kAddyManagerRepoURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('AddyManager License'),
            subtitle: const Text('MIT License'),
            trailing: const Icon(Icons.description_outlined),
            onTap: () => NicheMethod.launchURL(kAddyManagerLicenseURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Packages Licenses'),
            subtitle: const Text('Third party packages\' licenses'),
            trailing: const Icon(Icons.receipt_long),
            onTap: () => buildLicensePage(context),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Credits'),
            subtitle: const Text('Credits for assets in AddyManager'),
            trailing: const Icon(Icons.image_outlined),
            onTap: () {
              Navigator.pushNamed(context, CreditsScreen.routeName);
            },
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.35,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset('assets/images/app_logo.png'),
        ),
        SizedBox(height: size.height * 0.01),
        Consumer(
          builder: (_, ref, __) {
            final packageInfo = ref.watch(packageInfoProvider);
            return packageInfo.when(
              data: (data) {
                return Column(
                  children: [
                    Text(
                      data.appName,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text('${data.version} (${data.buildNumber})'),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) =>
                  Text('Failed to load package info: $error'),
            );
          },
        ),
      ],
    );
  }

  void buildLicensePage(BuildContext context) {
    return showLicensePage(
      context: context,
      applicationName: 'AddyManager',
      applicationIcon: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: buildHeader(context),
      ),
    );
  }
}
