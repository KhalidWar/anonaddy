import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_card_header.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    Key key,
    this.userData,
  }) : super(key: key);

  final UserModel userData;

  String _isUnlimited(int input, String unit) {
    if (input == 0) {
      return 'unlimited';
    } else {
      return '$input $unit';
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
            AccountCardHeader(
              title: userData.username,
              subtitle: '${userData.subscription} subscription',
            ),
            SizedBox(height: size.height * 0.03),
            AliasDetailListTile(
              title:
                  '${(userData.bandwidth / 1000000).toStringAsFixed(2)} MB / ${_isUnlimited(userData.bandwidthLimit, 'MD')}',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Monthly Bandwidth',
              leadingIconData: Icons.speed_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.usernameCount} / ${userData.usernameLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Add. Usernames',
                    leadingIconData: Icons.account_circle_outlined,
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.recipientCount} / ${userData.recipientLimit}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Recipients',
                    leadingIconData: Icons.account_circle_outlined,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    title:
                        '${userData.aliasCount} / ${_isUnlimited(userData.aliasLimit, '')}',
                    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    subtitle: 'Active Aliases',
                    leadingIconData: Icons.email_outlined,
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
            AliasDetailListTile(
              title: userData.id,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'ID',
              leadingIconData: Icons.perm_identity,
            ),
            Divider(height: 0),
            ExpansionTile(
              title: Text(
                'View defaults',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AliasDetailListTile(
                        title: userData.defaultAliasDomain,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        subtitle: 'Default Alias Domain',
                        leadingIconData: Icons.dns,
                      ),
                    ),
                    Expanded(
                      child: AliasDetailListTile(
                        title: userData.defaultAliasFormat,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        subtitle: 'Default Alias Format',
                        leadingIconData: Icons.alternate_email,
                      ),
                    ),
                  ],
                ),
                AliasDetailListTile(
                  title: userData.defaultRecipientId,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  subtitle: 'Default Recipient ID',
                  leadingIconData: Icons.account_circle_outlined,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
