import 'package:animations/animations.dart';
import 'package:anonaddy/screens/login_screen/token_login_screen.dart';
import 'package:anonaddy/services/theme/theme_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class SettingsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loginManager = watch(loginStateManagerProvider);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ExpansionTile(
          //   collapsedBackgroundColor: Colors.grey[300],
          //   childrenPadding: EdgeInsets.all(5),
          //   title: Text(
          //     'Default Settings',
          //     style: TextStyle(color: Colors.black),
          //   ),
          //   leading: Icon(
          //     Icons.account_circle_outlined,
          //     color: Colors.grey[700],
          //   ),
          //    initiallyExpanded: true,
          //   children: [],
          // ),
          // SizedBox(height: size.height * 0.01),
          ExpansionTile(
            collapsedBackgroundColor: Colors.grey[300],
            childrenPadding: EdgeInsets.all(5),
            leading: Icon(Icons.settings, color: Colors.grey[700]),
            title: Text('App Settings', style: TextStyle(color: Colors.black)),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark Theme',
                      style: Theme.of(context).textTheme.headline5),
                  Switch(
                    value: context.read(themeServiceProvider).isDarkTheme,
                    onChanged: (toggle) =>
                        context.read(themeServiceProvider).toggleTheme(),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'About App',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Icon(FontAwesomeIcons.github),
                  ],
                ),
                onTap: () => aboutAlertDialog(context),
              ),
              SizedBox(height: size.height * 0.01),
              // todo add license info
              RaisedButton(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  'Log Out',
                  style: Theme.of(context).textTheme.headline6,
                ),
                onPressed: () => loginManager.logout(context),
              ),
              // SizedBox(height: size.height * 0.01),
            ],
          ),
        ],
      ),
    );
  }

  aboutAlertDialog(BuildContext context) async {
    showModal(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('About App'),
            content: Text(kAboutAppText),
            actions: [
              RaisedButton(
                child: Text('Visit Project Repo'),
                onPressed: () async {
                  if (await canLaunch(kGithubRepoURL)) {
                    await launch(kGithubRepoURL);
                  } else {
                    throw 'Could not launch $kGithubRepoURL';
                  }
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
