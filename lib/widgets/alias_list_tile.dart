import 'package:anonaddy/services/api_data_manager.dart';
import 'package:anonaddy/widgets/manage_alias_dialog.dart';
import 'package:flutter/material.dart';

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
          dense: true,
          onTap: () {
            //todo copy email address upon tap
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
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ManageAliasDialog(
                      emailDescription: widget.aliasModel.emailDescription,
                      title: widget.aliasModel.email,
                      deleteOnPress: () {
                        setState(() {
                          widget.apiDataManager.deleteAlias(
                            aliasID: widget.aliasModel.aliasID,
                          );
                          Navigator.pop(context);
                        });
                      },
                    );
                  });
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}
