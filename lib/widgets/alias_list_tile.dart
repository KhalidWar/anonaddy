import 'package:anonaddy/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'domain_format_widget.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({
    Key key,
    this.aliasModel,
    this.apiDataManager,
  }) : super(key: key);

  final dynamic aliasModel;
  final APIService apiDataManager;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        ListTile(
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.aliasModel.email));
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Email Alias copied to clipboard!'),
              ),
            );
          },
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return buildBottomSheet(size, context);
                });
          },
          title: Text(
            widget.aliasModel.email,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(widget.aliasModel.emailDescription),
          leading: Switch(
            value: widget.aliasModel.isAliasActive,
            onChanged: (toggle) {
              if (widget.aliasModel.isAliasActive == true) {
                widget.apiDataManager.deactivateAlias(
                  aliasID: widget.aliasModel.aliasID,
                );
                setState(() {
                  widget.aliasModel.isAliasActive = false;
                });
              } else {
                widget.apiDataManager.activateAlias(
                  aliasID: widget.aliasModel.aliasID,
                );
                setState(() {
                  widget.aliasModel.isAliasActive = true;
                });
              }
            },
          ),
          trailing: Icon(Icons.chevron_left),
        ),
        Divider(),
      ],
    );
  }

  Container buildBottomSheet(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.7,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Divider(
                thickness: 3,
                color: Colors.grey,
                indent: size.width * 0.35,
                endIndent: size.width * 0.35,
              ),
              Text(
                'Alias Details',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      widget.aliasModel.email,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                DomainFormatWidget(
                  label: 'ID:',
                  value: widget.aliasModel.userId,
                ),
                DomainFormatWidget(
                  label: 'Domain:',
                  value: '@anonaddy.me',
                ),
                DomainFormatWidget(
                  label: 'Email Description:',
                  value: widget.aliasModel.emailDescription,
                ),
                DomainFormatWidget(
                  label: 'Format:',
                  value: 'UUID',
                ),
                DomainFormatWidget(
                  label: 'Active:',
                  value: widget.aliasModel.isAliasActive ? 'Yes' : 'No',
                ),
                DomainFormatWidget(
                  label: 'Emails Forwarded:',
                  value: widget.aliasModel.emailsForwarded.toString(),
                ),
                DomainFormatWidget(
                  label: 'Emails Blocked:',
                  value: widget.aliasModel.emailsBlocked.toString(),
                ),
                DomainFormatWidget(
                  label: 'Emails Sent:',
                  value: widget.aliasModel.emailsSent,
                ),
                DomainFormatWidget(
                  label: 'Created At:',
                  value: widget.aliasModel.createdAt,
                ),
                // DomainFormatWidget(
                //   label: 'Deleted At:',
                //   value: widget.aliasModel.deletedAt.toString(),
                // ),
                DomainFormatWidget(
                  label: 'Updated At:',
                  value: widget.aliasModel.updatedAt.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
