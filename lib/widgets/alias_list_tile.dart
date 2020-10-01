import 'package:anonaddy/services/api_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({
    Key key,
    this.aliasModel,
    this.apiDataManager,
  }) : super(key: key);

  final dynamic aliasModel;
  final APIDataManager apiDataManager;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  @override
  Widget build(BuildContext context) {
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
}
