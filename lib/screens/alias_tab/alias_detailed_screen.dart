import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/material.dart';

class AliasDetailScreen extends StatefulWidget {
  const AliasDetailScreen({Key key, this.aliasData}) : super(key: key);

  final AliasDataModel aliasData;

  @override
  _AliasDetailScreenState createState() => _AliasDetailScreenState();
}

class _AliasDetailScreenState extends State<AliasDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final alias = widget.aliasData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AliasDetailListTile(
              leadingIconData: Icons.flaky_outlined,
              title: 'Active',
              subtitle:
                  'Alias is ${alias.isAliasActive ? 'active' : 'inactive'}',
              trailing: Switch(
                value: alias.isAliasActive,
                onChanged: (toggle) {},
              ),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.comment,
              title: alias.emailDescription,
              subtitle: 'Description',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.email_outlined,
              title: alias.email,
              subtitle: 'Description',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.check_circle_outline,
              title: 'extension',
              subtitle: alias.extension,
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.alternate_email,
              title: alias.aliasID,
              subtitle: 'Alias ID and Local Port',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.dns,
              title: alias.domain,
              subtitle: 'Domain',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.account_circle_outlined,
              title: alias.userId,
              subtitle: 'User ID',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () {},
            ),

            Divider(),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.forward_to_inbox,
                    title: alias.emailsForwarded,
                    subtitle: 'Emails Forwarded',
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.reply,
                    title: alias.emailsReplied,
                    subtitle: 'Emails Replied',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.mark_email_read_outlined,
                    title: alias.emailsSent,
                    subtitle: 'Emails Sent',
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.block,
                    title: alias.emailsBlocked,
                    subtitle: 'Emails Blocked',
                  ),
                ),
              ],
            ),

            Divider(),
            AliasDetailListTile(
              leadingIconData: Icons.access_time_outlined,
              title: 'Created At',
              subtitle: alias.createdAt,
            ),
            AliasDetailListTile(
              leadingIconData: Icons.av_timer_outlined,
              title: 'Updated At',
              subtitle: alias.updatedAt,
            ),
            AliasDetailListTile(
              leadingIconData: Icons.auto_delete_outlined,
              title: 'Deleted At',
              subtitle: alias.deletedAt,
            ),

            Divider(),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text('Delete Alias?'),
                  ],
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Alias Details'),
      backgroundColor: Colors.white,
    );
  }
}
