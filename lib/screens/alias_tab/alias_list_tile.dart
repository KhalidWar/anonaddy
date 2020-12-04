import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../widgets/domain_format_widget.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({Key key, this.aliasModel}) : super(key: key);

  final AliasDataModel aliasModel;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  final _apiService = serviceLocator<APIService>();
  bool _isLoading = false;

  void _toggleAliases() async {
    setState(() => _isLoading = true);

    if (widget.aliasModel.isAliasActive == true) {
      dynamic deactivateResult =
          await _apiService.deactivateAlias(aliasID: widget.aliasModel.aliasID);
      if (deactivateResult == null) {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong. Could not deactivate alias.'),
          ));
        });
      } else {
        setState(() {
          _isLoading = false;
          // widget.aliasModel.isAliasActive = false;
        });
      }
    } else {
      dynamic activateResult =
          await _apiService.activateAlias(aliasID: widget.aliasModel.aliasID);
      if (activateResult == null) {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong. Could not activate alias.'),
          ));
        });
      } else {
        setState(() {
          _isLoading = false;
          // widget.aliasModel.isAliasActive = true;
        });
      }
    }
  }

  void deleteAlias(dynamic aliasID) async {
    setState(() => _isLoading = true);
    dynamic deleteResult =
        await serviceLocator<APIService>().deleteAlias(aliasID: aliasID);
    if (deleteResult == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong. Could not delete alias.')));
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Alias Successfully Deleted!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //   _isLoading ? LinearProgressIndicator() : Container(),

    return Slidable(
      key: Key(widget.aliasModel.toString()),
      actionPane: SlidableStrechActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.red,
          iconWidget: Icon(
            Icons.delete,
            size: 35,
            color: Colors.white,
          ),
          onTap: () => deleteAlias(widget.aliasModel.aliasID),
        ),
      ],
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        leading: _isLoading
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CircularProgressIndicator())
            : Switch(
                value: widget.aliasModel.isAliasActive,
                onChanged: (toggle) => _toggleAliases(),
              ),
        title: Text(
          widget.aliasModel.email,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(widget.aliasModel.emailDescription),
        trailing: Icon(Icons.chevron_left),
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
      ),
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
