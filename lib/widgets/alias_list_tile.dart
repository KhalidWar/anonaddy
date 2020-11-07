import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'domain_format_widget.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({
    Key key,
    this.aliasModel,
  }) : super(key: key);

  final dynamic aliasModel;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  final _apiService = serviceLocator<APIService>();
  bool isLoading = false;

  void toggleAliases() async {
    setState(() => isLoading = true);

    if (widget.aliasModel.isAliasActive == true) {
      dynamic deactivateResult =
          await _apiService.deactivateAlias(aliasID: widget.aliasModel.aliasID);
      if (deactivateResult == null) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong. Could not deactivate alias.'),
          ));
        });
      } else {
        setState(() {
          isLoading = false;
          widget.aliasModel.isAliasActive = false;
        });
      }
    } else {
      dynamic activateResult =
          await _apiService.activateAlias(aliasID: widget.aliasModel.aliasID);
      if (activateResult == null) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong. Could not activate alias.'),
          ));
        });
      } else {
        setState(() {
          isLoading = false;
          widget.aliasModel.isAliasActive = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () {
        Clipboard.setData(ClipboardData(text: widget.aliasModel.email));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email Alias copied to clipboard!'),
          ),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return buildBottomSheet();
          },
        );
      },
      leading: isLoading
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: CircularProgressIndicator())
          : Switch(
              value: widget.aliasModel.isAliasActive,
              onChanged: (toggle) => toggleAliases(),
            ),
      title: Text(
        widget.aliasModel.email,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(widget.aliasModel.emailDescription),
      trailing: Icon(Icons.chevron_left),
    );
  }

  Container buildBottomSheet() {
    Size size = MediaQuery.of(context).size;

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
