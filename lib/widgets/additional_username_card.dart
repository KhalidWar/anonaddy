import 'package:anonaddy/models/username_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/widgets/account_card_header.dart';
import 'package:flutter/material.dart';

import 'alias_detail_list_tile.dart';

class AdditionalUsernameCard extends StatelessWidget {
  const AdditionalUsernameCard({
    Key key,
    @required this.username,
  }) : super(key: key);

  final UsernameDataModel username;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountCardHeader(
          title: '${username.username}',
          subtitle: username.description,
        ),
        AliasDetailListTile(
          title: '${username.id}',
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'ID',
          leadingIconData: Icons.perm_identity,
        ),
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
          title: Text('Aliases', style: Theme.of(context).textTheme.bodyText1),
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
                      return ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        leading: Icon(Icons.email_outlined),
                        title: Text('${username.aliases[index].email}'),
                        subtitle:
                            Text('${username.aliases[index].emailDescription}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AliasDetailScreen(
                                  aliasData: username.aliases[index],
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
        Divider(height: 0),
        ExpansionTile(
          title: Text('Default Recipient',
              style: Theme.of(context).textTheme.bodyText1),
          children: [
            username.defaultRecipient.email == 'tempSolution'
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Text('No default recipient found'),
                  )
                : ListTile(
                    dense: true,
                    horizontalTitleGap: 0,
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('${username.defaultRecipient.email}'),
                    subtitle: Text('${username.defaultRecipient.userId}'),
                    onTap: () {},
                  ),
          ],
        ),
      ],
    );
  }
}
