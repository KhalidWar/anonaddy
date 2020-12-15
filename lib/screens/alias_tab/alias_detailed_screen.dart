import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';

class AliasDetailScreen extends StatefulWidget {
  const AliasDetailScreen({Key key, this.aliasData}) : super(key: key);

  final AliasDataModel aliasData;

  @override
  _AliasDetailScreenState createState() => _AliasDetailScreenState();
}

class _AliasDetailScreenState extends State<AliasDetailScreen> {
  void _copyOnTab() {
    Clipboard.setData(ClipboardData(text: widget.aliasData.email));
    Fluttertoast.showToast(
      msg: kEmailCopied,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }

  bool _isAliasDeleted() {
    if (widget.aliasData.deletedAt == null) {
      return false;
    } else {
      return true;
    }
  }

  void _deleteOrRestoreAlias() async {
    _isAliasDeleted()
        ? await context
            .read(apiServiceProvider)
            .restoreAlias(widget.aliasData.aliasID)
        : await context
            .read(apiServiceProvider)
            .deleteAlias(widget.aliasData.aliasID);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final alias = widget.aliasData;
    return SafeArea(
      child: Scaffold(
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
                subtitle: 'Email',
                trailingIconData: Icons.copy,
                trailingIconOnPress: _copyOnTab,
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
                trailingIconOnPress: _copyOnTab,
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
                trailingIconOnPress: _copyOnTab,
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
                  color: _isAliasDeleted() ? Colors.green : Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_isAliasDeleted() ? Icons.restore : Icons.delete),
                      SizedBox(width: 10),
                      Text(
                          '${_isAliasDeleted() ? 'Restore' : 'Delete'} Alias?'),
                    ],
                  ),
                  onPressed: _deleteOrRestoreAlias,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
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
