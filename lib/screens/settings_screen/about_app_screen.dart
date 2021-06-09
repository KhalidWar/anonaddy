import 'package:anonaddy/screens/settings_screen/credits_screen.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutAppScreen extends StatelessWidget {
  final _launchURL = NicheMethod().launchURL;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('About App')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Column(
          children: [
            Column(
              children: [
                buildAppLogo(size),
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
                          Text('Failed to load  package info: $error'),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Khalid Warsame'),
              subtitle: Text('AddyManager developer'),
              trailing: Icon(Icons.open_in_new_outlined),
              onTap: () => _launchURL(kKhalidWarGithubURL),
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Will Browning (AnonAddy team)'),
              subtitle: Text('Contributor'),
              trailing: Icon(Icons.open_in_new_outlined),
              onTap: () => _launchURL(kWillBrowningGithubURL),
            ),
            Divider(height: 0),
            ListTile(
              title: Text('How to contribute?'),
              subtitle: Text(
                'Open an issue for bugs, feature requests, and suggestions.',
              ),
              trailing: Icon(Icons.bug_report_outlined),
              onTap: () => _launchURL(kAddyManagerIssuesURL),
            ),
            Divider(height: 0),
            ListTile(
              title: Text('AddyManager License'),
              subtitle: Text('MIT License'),
              trailing: Icon(Icons.description),
              onTap: () => _launchURL(kAddyManagerLicenseURL),
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Packages Licenses'),
              subtitle: Text('View used packages licenses'),
              trailing: Icon(Icons.receipt_long),
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'AddyManager',
                applicationIcon: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: buildAppLogo(size),
                ),
              ),
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Credits'),
              subtitle: Text('Credits for assets in AddyManager'),
              trailing: Icon(Icons.image_outlined),
              onTap: () {
                Navigator.push(context, CustomPageRoute(CreditsScreen()));
              },
            ),
            Divider(height: 0),
          ],
        ),
      ),
    );
  }

  Container buildAppLogo(Size size) {
    return Container(
      width: size.width * 0.4,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Image.asset('assets/images/app_logo.png'),
    );
  }
}
