import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/providers.dart';
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
  bool _isLoading = false;
  bool _switchValue;

  bool _isDeleted() {
    if (widget.aliasData.deletedAt == null) {
      return false;
    } else {
      return true;
    }
  }

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
            .read(aliasService)
            .restoreAlias(widget.aliasData.aliasID)
        : await context
            .read(aliasService)
            .deleteAlias(widget.aliasData.aliasID);
    Navigator.pop(context);
  }

  void _toggleAliases() async {
    final _apiService = context.read(aliasService);
    setState(() => _isLoading = true);

    if (_switchValue == true) {
      dynamic deactivateResult =
          await _apiService.deactivateAlias(widget.aliasData.aliasID);
      if (deactivateResult == null) {
        setState(() {
          _switchValue = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _switchValue = false;
          _isLoading = false;
        });
      }
    } else {
      dynamic activateResult =
          await _apiService.activateAlias(widget.aliasData.aliasID);
      if (activateResult == null) {
        setState(() {
          _switchValue = false;
          _isLoading = false;
        });
      } else {
        setState(() {
          _switchValue = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _switchValue = widget.aliasData.isAliasActive;
  }

  @override
  Widget build(BuildContext context) {
    final alias = widget.aliasData;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              leadingIconData: Icons.flaky_outlined,
              title: 'Active',
              subtitle:
                  'Alias is ${alias.isAliasActive ? 'active' : 'inactive'}',
              trailing: _isLoading
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: CircularProgressIndicator())
                  : Switch(
                      value: _switchValue,
                      onChanged:
                          _isDeleted() ? null : (toggle) => _toggleAliases(),
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
              title: alias.extension,
              subtitle: 'extension',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: Icons.alternate_email,
              title: alias.aliasID,
              subtitle: 'Alias ID',
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
                    leadingIconData: Icons.access_time_outlined,
                    title: alias.createdAt,
                    subtitle: 'Created At',
                  ),
                ),
                Expanded(
                  child: alias.deletedAt == null
                      ? AliasDetailListTile(
                          leadingIconData: Icons.av_timer_outlined,
                          title: alias.updatedAt,
                          subtitle: 'Updated At',
                        )
                      : AliasDetailListTile(
                          leadingIconData: Icons.auto_delete_outlined,
                          title: alias.deletedAt,
                          subtitle: 'Deleted At',
                        ),
                )
              ],
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
                    Text('${_isAliasDeleted() ? 'Restore' : 'Delete'} Alias?'),
                  ],
                ),
                onPressed: _deleteOrRestoreAlias,
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
