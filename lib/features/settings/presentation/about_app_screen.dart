import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/custom_app_bar.dart';
import 'package:anonaddy/common/package_info_service.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage(name: 'AboutAppScreenRoute')
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
            onTap: () => Utilities.launchURL(kKhalidWarGithubURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Will Browning (AnonAddy team)'),
            subtitle: const Text('Contributor'),
            trailing: const Icon(Icons.account_circle_outlined),
            onTap: () => Utilities.launchURL(kWillBrowningGithubURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Exodus Privacy Report'),
            subtitle: const Text('Exodus\'s privacy report of AddyManager'),
            trailing: const Icon(Icons.shield_outlined),
            onTap: () => Utilities.launchURL(kExodusPrivacyURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Found a bug?'),
            subtitle: const Text('Report bugs and request features'),
            trailing: const Icon(Icons.bug_report_outlined),
            onTap: () => Utilities.launchURL(kAddyManagerIssuesURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('Source Code'),
            subtitle: const Text('AddyManager\'s open source code'),
            trailing: const Icon(Icons.code_outlined),
            onTap: () => Utilities.launchURL(kAddyManagerRepoURL),
          ),
          const Divider(height: 0),
          ListTile(
            dense: true,
            title: const Text('AddyManager License'),
            subtitle: const Text('MIT License'),
            trailing: const Icon(Icons.description_outlined),
            onTap: () => Utilities.launchURL(kAddyManagerLicenseURL),
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
              context.router.push(const CreditsScreenRoute());
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
