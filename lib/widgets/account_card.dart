import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    Key key,
    this.userData,
  }) : super(key: key);

  final UserModel userData;

  String isUnlimited(int input) {
    if (input == 0) {
      return 'unlimited';
    } else {
      return '$input';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Card(
        child: Column(
          children: [
            Container(
              height: size.height * 0.16,
              margin: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.account_circle_outlined, size: 50),
                  Text(
                    '${userData.username}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${'${userData.subscription}'.toUpperCase()} Subscription'),
                  Text(userData.id),
                  SizedBox(height: size.height * 0.01),
                  Divider(
                    height: 0,
                    indent: size.width * 0.4,
                    endIndent: size.width * 0.4,
                    thickness: 2,
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.03),
            AliasDetailListTile(
              title:
                  '${userData.bandwidth / 1000000} MB / ${isUnlimited(userData.bandwidthLimit)} MB',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Monthly Bandwidth',
              leadingIconData: Icons.access_time_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.aliasCount} / ${isUnlimited(userData.aliasLimit)}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Active Aliases',
                    leadingIconData: Icons.email_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.recipientCount} / ${userData.recipientLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Recipients',
                    leadingIconData: Icons.alternate_email,
                  ),
                ),
              ],
            ),
            Divider(height: 0),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.usernameCount} / ${userData.usernameLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Usernames',
                    leadingIconData: Icons.account_circle_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.activeDomainCount} / ${userData.activeDomainLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Active Domain Count',
                    leadingIconData: Icons.dns,
                  ),
                ),
              ],
            ),
            Divider(height: 0),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title: userData.defaultAliasDomain,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Default Alias Domain',
                    leadingIconData: Icons.access_time_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title: userData.defaultAliasFormat,
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Default Alias Format',
                    leadingIconData: Icons.access_time_outlined,
                  ),
                ),
              ],
            ),
            AliasDetailListTile(
              title: userData.defaultRecipientId,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Default Recipient ID',
              leadingIconData: Icons.access_time_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
