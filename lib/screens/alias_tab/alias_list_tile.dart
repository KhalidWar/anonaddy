import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _deleteAlias(dynamic aliasID) async {
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

  void _copyOnTab() {
    Clipboard.setData(ClipboardData(text: widget.aliasModel.email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email Alias copied to clipboard!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ExpansionTile(
      tilePadding: EdgeInsets.all(0),
      backgroundColor: Colors.grey[200],
      title: Text(
        '${widget.aliasModel.email}',
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        '${widget.aliasModel.emailDescription}',
        style: TextStyle(color: Colors.grey),
      ),
      leading: _isLoading
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: CircularProgressIndicator())
          : Switch(
              value: widget.aliasModel.isAliasActive,
              onChanged: (toggle) => _toggleAliases()),
      trailing:
          IconButton(icon: Icon(Icons.copy), onPressed: () => _copyOnTab()),
      children: [
        Container(
          height: size.height * 0.22,
          // color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DomainFormatWidget(
                label: 'Emails Forwarded',
                value: widget.aliasModel.emailsForwarded.toString(),
              ),
              DomainFormatWidget(
                label: 'Emails Blocked',
                value: widget.aliasModel.emailsBlocked.toString(),
              ),
              DomainFormatWidget(
                label: 'Emails Sent',
                value: widget.aliasModel.emailsSent,
              ),
              DomainFormatWidget(
                label: 'Created At',
                value: widget.aliasModel.createdAt,
              ),
              // DomainFormatWidget(
              //   label: 'Deleted At:',
              //   value: widget.aliasModel.deletedAt.toString(),
              // ),

              FlatButton(
                child: Text('View more details'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ],
    );
  }
}
