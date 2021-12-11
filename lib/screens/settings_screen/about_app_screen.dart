import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'credits_screen.dart';

class AboutAppScreen extends StatelessWidget {
  static const routeName = 'aboutAppScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('About App')),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        children: [
          buildHeader(context),
          SizedBox(height: size.height * 0.02),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Khalid Warsame'),
            subtitle: Text('AddyManager developer'),
            trailing: Icon(Icons.account_circle_outlined),
            onTap: () => NicheMethod.launchURL(kKhalidWarGithubURL),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Will Browning (AnonAddy team)'),
            subtitle: Text('Contributor'),
            trailing: Icon(Icons.account_circle_outlined),
            onTap: () => NicheMethod.launchURL(kWillBrowningGithubURL),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Exodus Privacy Report'),
            subtitle: Text('Exodus\'s privacy report of AddyManager'),
            trailing: Icon(Icons.shield_outlined),
            onTap: () => NicheMethod.launchURL(kExodusPrivacyURL),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Found a bug?'),
            subtitle: Text('Report bugs and request features'),
            trailing: Icon(Icons.bug_report_outlined),
            onTap: () => NicheMethod.launchURL(kAddyManagerIssuesURL),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Source Code'),
            subtitle: Text('AddyManager\'s open source code'),
            trailing: Icon(Icons.code_outlined),
            onTap: () => NicheMethod.launchURL(kAddyManagerRepoURL),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('AddyManager License'),
            subtitle: Text('MIT License'),
            trailing: Icon(Icons.description_outlined),
            onTap: () => NicheMethod.launchURL(kAddyManagerLicenseURL),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Packages Licenses'),
            subtitle: Text('Third party packages\' licenses'),
            trailing: Icon(Icons.receipt_long),
            onTap: () => buildLicensePage(context),
          ),
          Divider(height: 0),
          ListTile(
            dense: true,
            title: Text('Credits'),
            subtitle: Text('Credits for assets in AddyManager'),
            trailing: Icon(Icons.image_outlined),
            onTap: () {
              Navigator.pushNamed(context, CreditsScreen.routeName);
            },
          ),
          Divider(height: 0),
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
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Image.asset('assets/images/app_logo.png'),
        ),
        SizedBox(height: size.height * 0.01),
        Consumer(
          builder: (_, watch, __) {
            final packageInfo = watch(packageInfoProvider);
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
              loading: () => CircularProgressIndicator(),
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
        padding: EdgeInsets.only(top: 20),
        child: buildHeader(context),
      ),
    );
  }
}
