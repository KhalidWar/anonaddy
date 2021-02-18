import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/widgets/account_card_header.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/custom_app_bar.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
import 'package:flutter/material.dart';

class UsernameDetailedScreen extends StatefulWidget {
  const UsernameDetailedScreen({Key key, this.username}) : super(key: key);

  final UsernameDataModel username;

  @override
  _UsernameDetailedScreenState createState() => _UsernameDetailedScreenState();
}

class _UsernameDetailedScreenState extends State<UsernameDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    final username = widget.username;

    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            AccountCardHeader(
              title: username.username,
              subtitle: username.description ?? 'No description',
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title: username.active == true ? 'Yes' : 'No',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Is active?',
                    leadingIconData: Icons.toggle_off_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title: username.catchAll == true ? 'Yes' : 'No',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Is catch all?',
                    leadingIconData: Icons.repeat,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title: username.createdAt,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Created at',
                    leadingIconData: Icons.access_time_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title: username.updatedAt,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Updated at',
                    leadingIconData: Icons.av_timer_outlined,
                  ),
                ),
              ],
            ),
            Divider(height: 0),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'Default Recipient',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              children: [
                if (username.defaultRecipient == null)
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text('No default recipient found'),
                  )
                else
                  RecipientListTile(
                    recipientDataModel: username.defaultRecipient,
                  ),
              ],
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text('Associated Aliases',
                  style: Theme.of(context).textTheme.bodyText1),
              children: [
                username.aliases.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: Text('No aliases found'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: username.aliases.length,
                        itemBuilder: (context, index) {
                          return AliasListTile(
                            aliasData: username.aliases[index],
                          );
                        },
                      ),
              ],
            ),
            Divider(height: 0),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder buildPageRouteBuilder(Widget child) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);

        return SlideTransition(
          position: Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondAnimation) {
        return child;
      },
    );
  }

  Widget buildAppBar() {
    final customAppBar = CustomAppBar();
    return customAppBar.androidAppBar(context, 'Additional Username');

    //todo fix CupertinoNavigationBar causing build failure
    // return TargetedPlatform().isIOS()
    //     ? customAppBar.iOSAppBar(context, 'Additional Username')
    //     : customAppBar.androidAppBar(context, 'Additional Username');
  }
}
