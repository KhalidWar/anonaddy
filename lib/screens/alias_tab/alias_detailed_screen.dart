import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/fetch_data_indicator.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error_screen.dart';

class AliasDetailScreen extends StatefulWidget {
  const AliasDetailScreen({Key key, this.aliasData}) : super(key: key);

  final AliasDataModel aliasData;

  @override
  _AliasDetailScreenState createState() => _AliasDetailScreenState();
}

class _AliasDetailScreenState extends State<AliasDetailScreen> {
  Future<AliasDataModel> _aliasDataModel;

  void _copyOnTab() {
    Clipboard.setData(ClipboardData(text: widget.aliasData.email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email Alias copied to clipboard!')),
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
  void initState() {
    super.initState();
    _aliasDataModel = context
        .read(apiServiceProvider)
        .getSpecificAliasData(widget.aliasData.aliasID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: FutureBuilder<AliasDataModel>(
        future: _aliasDataModel,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ErrorScreen(
                label: '${snapshot.error}',
                buttonLabel: 'Sign In',
                buttonOnPress: () {},
              );
            case ConnectionState.waiting:
              return FetchingDataIndicator();
            default:
              if (snapshot.hasData) {
                final data = snapshot.data;
                print(data);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AliasDetailListTile(
                        leadingIconData: Icons.flaky_outlined,
                        title: 'Active',
                        subtitle:
                            'Alias is ${data.isAliasActive ? 'active' : 'inactive'}',
                        trailing: Switch(
                          value: data.isAliasActive,
                          onChanged: (toggle) {},
                        ),
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.comment,
                        title: data.emailDescription,
                        subtitle: 'Description',
                        trailingIconData: Icons.edit,
                        trailingIconOnPress: () {},
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.email_outlined,
                        title: data.email,
                        subtitle: 'Email',
                        trailingIconData: Icons.copy,
                        trailingIconOnPress: _copyOnTab,
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.check_circle_outline,
                        title: 'extension',
                        subtitle: data.extension,
                        trailingIconData: Icons.edit,
                        trailingIconOnPress: () {},
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.alternate_email,
                        title: data.aliasID,
                        subtitle: 'Alias ID and Local Port',
                        trailingIconData: Icons.copy,
                        trailingIconOnPress: _copyOnTab,
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.dns,
                        title: data.domain,
                        subtitle: 'Domain',
                        trailingIconData: Icons.edit,
                        trailingIconOnPress: () {},
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.account_circle_outlined,
                        title: data.userId,
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
                              title: data.emailsForwarded,
                              subtitle: 'Emails Forwarded',
                            ),
                          ),
                          Expanded(
                            child: AliasDetailListTile(
                              leadingIconData: Icons.reply,
                              title: data.emailsReplied,
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
                              title: data.emailsSent,
                              subtitle: 'Emails Sent',
                            ),
                          ),
                          Expanded(
                            child: AliasDetailListTile(
                              leadingIconData: Icons.block,
                              title: data.emailsBlocked,
                              subtitle: 'Emails Blocked',
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      AliasDetailListTile(
                        leadingIconData: Icons.access_time_outlined,
                        title: 'Created At',
                        subtitle: data.createdAt,
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.av_timer_outlined,
                        title: 'Updated At',
                        subtitle: data.updatedAt,
                      ),
                      AliasDetailListTile(
                        leadingIconData: Icons.auto_delete_outlined,
                        title: 'Deleted At',
                        subtitle: data.deletedAt,
                      ),
                      Divider(),
                      Center(
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          color: _isAliasDeleted() ? Colors.green : Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_isAliasDeleted()
                                  ? Icons.restore
                                  : Icons.delete),
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
                );
              } else if (snapshot.hasError) {
                return ErrorScreen(
                  label: '${snapshot.error}',
                  buttonLabel: 'Sign In',
                  buttonOnPress: () {},
                );
              } else {
                return LoadingWidget();
              }
          }
        },
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
