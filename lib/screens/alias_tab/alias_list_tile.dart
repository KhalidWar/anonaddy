import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/domain_format_widget.dart';
import 'alias_detailed_screen.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({Key key, this.aliasModel}) : super(key: key);

  final AliasDataModel aliasModel;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  final _apiService = serviceLocator<APIService>();
  bool _isLoading = false;

  bool _isDeleted() {
    if (widget.aliasModel.deletedAt == null) {
      return false;
    } else {
      return true;
    }
  }

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

  void _deleteOrRestoreAlias() async {
    setState(() => _isLoading = true);
    final result = _isDeleted()
        ? await context
            .read(apiServiceProvider)
            .restoreAlias(widget.aliasModel.aliasID)
        : await context
            .read(apiServiceProvider)
            .deleteAlias(widget.aliasModel.aliasID);

    if (result == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Something went wrong. Could not ${_isDeleted() ? 'restore' : 'delete'} alias.')),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Alias ${_isDeleted() ? 'restored' : 'deleted'} successfully!')),
      );
    }
  }

  void _copyOnTab() {
    Clipboard.setData(ClipboardData(text: widget.aliasModel.email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email Alias copied to clipboard!')),
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
              onChanged: _isDeleted() ? null : (toggle) => _toggleAliases(),
            ),
      trailing:
          IconButton(icon: Icon(Icons.copy), onPressed: () => _copyOnTab()),
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
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
              _isDeleted()
                  ? DomainFormatWidget(
                      label: 'Deleted At', value: widget.aliasModel.deletedAt)
                  : Container(),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    color: _isDeleted() ? Colors.green : Colors.red,
                    child:
                        Text(_isDeleted() ? 'Restore alias' : 'Delete alias'),
                    onPressed: _deleteOrRestoreAlias,
                  ),
                  FlatButton(
                    color: Colors.grey,
                    child: Text('View details'),
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AliasDetailScreen(
                              aliasData: widget.aliasModel,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
