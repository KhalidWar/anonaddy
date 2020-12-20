import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDetailScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasDataProvider = watch(aliasStateManagerProvider);
    final aliasDataModel = aliasDataProvider.aliasDataModel;
    final switchValue = aliasDataProvider.switchValue;
    final toggleAlias = aliasDataProvider.toggleAlias;
    final isLoading = aliasDataProvider.isLoading;
    final copyOnTap = aliasDataProvider.copyToClipboard;
    final isAliasDeleted = aliasDataProvider.isAliasDeleted;
    final deleteOrRestoreAlias = aliasDataProvider.deleteOrRestoreAlias;

    return Scaffold(
      appBar:
          AppBar(title: Text('Alias Details'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading ? LinearProgressIndicator(minHeight: 6) : Container(),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.forward_to_inbox,
                    title: aliasDataModel.emailsForwarded,
                    subtitle: 'Emails Forwarded',
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.reply,
                    title: aliasDataModel.emailsReplied,
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
                    title: aliasDataModel.emailsSent,
                    subtitle: 'Emails Sent',
                  ),
                ),
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.block,
                    title: aliasDataModel.emailsBlocked,
                    subtitle: 'Emails Blocked',
                  ),
                ),
              ],
            ),
            Divider(),
            AliasDetailListTile(
              leadingIconData: Icons.flaky_outlined,
              title: 'Alias is ${switchValue ? 'active' : 'inactive'}',
              subtitle: 'Activity',
              trailing: Switch(
                value: switchValue,
                onChanged: (toggle) {
                  toggleAlias(context, aliasDataModel.aliasID);
                },
              ),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.comment,
              title: aliasDataModel.emailDescription,
              subtitle: 'Description',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.email_outlined,
              title: aliasDataModel.email,
              subtitle: 'Email',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () => copyOnTap(aliasDataModel.email),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.check_circle_outline,
              title: aliasDataModel.extension,
              subtitle: 'extension',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.alternate_email,
              title: aliasDataModel.aliasID,
              subtitle: 'Alias ID',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () => copyOnTap(aliasDataModel.aliasID),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.dns,
              title: aliasDataModel.domain,
              subtitle: 'Domain',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.account_circle_outlined,
              title: aliasDataModel.userId,
              subtitle: 'User ID',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () => copyOnTap(aliasDataModel.userId),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: AliasDetailListTile(
                    leadingIconData: Icons.access_time_outlined,
                    title: aliasDataModel.createdAt,
                    subtitle: 'Created At',
                  ),
                ),
                Expanded(
                  child: aliasDataModel.deletedAt == null
                      ? AliasDetailListTile(
                          leadingIconData: Icons.av_timer_outlined,
                          title: aliasDataModel.updatedAt,
                          subtitle: 'Updated At',
                        )
                      : AliasDetailListTile(
                          leadingIconData: Icons.auto_delete_outlined,
                          title: aliasDataModel.deletedAt,
                          subtitle: 'Deleted At',
                        ),
                )
              ],
            ),
            Divider(),
            Center(
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: isAliasDeleted(aliasDataModel.deletedAt)
                    ? Colors.green
                    : Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isAliasDeleted(aliasDataModel.deletedAt)
                        ? Icons.restore
                        : Icons.delete),
                    SizedBox(width: 10),
                    Text(
                      '${isAliasDeleted(aliasDataModel.deletedAt) ? 'Restore' : 'Delete'} Alias?',
                    ),
                  ],
                ),
                onPressed: () {
                  deleteOrRestoreAlias(
                    context,
                    aliasDataModel.deletedAt,
                    aliasDataModel.aliasID,
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
