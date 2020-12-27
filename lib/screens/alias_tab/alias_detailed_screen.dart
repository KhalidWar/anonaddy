import 'package:animations/animations.dart';
import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final editDescription = aliasDataProvider.editDescription;

    final _textEditingController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLoading ? LinearProgressIndicator(minHeight: 6) : Container(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SvgPicture.asset(
              'assets/images/mailbox.svg',
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          ),
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
          Divider(height: 0),
          AliasDetailListTile(
            leadingIconData: Icons.alternate_email,
            title: aliasDataModel.email,
            subtitle: 'Email',
            trailingIconData: Icons.copy,
            trailingIconOnPress: () => copyOnTap(aliasDataModel.email),
          ),
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
            trailingIconOnPress: () {
              buildEditDescriptionDialog(
                context,
                _textEditingController,
                editDescription,
                aliasDataModel,
              );
              // editDescription();
            },
          ),
          AliasDetailListTile(
            leadingIconData: Icons.check_circle_outline,
            title: aliasDataModel.extension,
            subtitle: 'extension',
            trailingIconData: Icons.edit,
            trailingIconOnPress: () {},
          ),
          Divider(height: 0),
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
          Divider(height: 0),
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
                    '${isAliasDeleted(aliasDataModel.deletedAt) ? 'Restore' : 'Delete'} Alias',
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
    );
  }

  Future buildEditDescriptionDialog(
      BuildContext context,
      TextEditingController _textEditingController,
      Function editDescription,
      AliasDataModel aliasDataModel) {
    return showModal(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Edit Description'),
          contentPadding: EdgeInsets.all(20),
          children: [
            TextFormField(
              autofocus: true,
              controller: _textEditingController,
              onFieldSubmitted: (toggle) => editDescription(
                context,
                aliasDataModel.aliasID,
                _textEditingController.text.trim(),
              ),
              decoration: kTextFormFieldDecoration.copyWith(
                hintText: '${aliasDataModel.emailDescription}',
              ),
            ),
            SizedBox(height: 25),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Update Description'),
              onPressed: () => editDescription(
                context,
                aliasDataModel.aliasID,
                _textEditingController.text.trim(),
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Alias Details',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
