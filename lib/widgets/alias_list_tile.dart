import 'package:flutter/material.dart';

import 'manage_alias_dialog.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({
    Key key,
    this.email,
    this.emailDescription,
    this.switchOnPress,
    this.listTileOnPress,
    this.switchValue,
    this.apiDataManager,
    this.index,
  }) : super(key: key);

  final String email, emailDescription;
  final Function switchOnPress, listTileOnPress;
  final bool switchValue;
  final dynamic apiDataManager;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: () {},
          title: Text(apiDataManager.aliasList[index].email,
              style: Theme.of(context).textTheme.bodyText1),
          subtitle: Text(apiDataManager.aliasList[index].emailDescription),
          leading: Switch(
            value: apiDataManager.aliasList[index].isAliasActive,
            onChanged: (toggle) {
              if (apiDataManager.aliasList[index].isAliasActive == true) {
                apiDataManager.deactivateAlias(
                  aliasID: apiDataManager.aliasList[index].aliasID,
                );
                apiDataManager.aliasList[index].isAliasActive = false;
              } else {
                apiDataManager.activateAlias(
                  aliasID: apiDataManager.aliasList[index].aliasID,
                );
                apiDataManager.aliasList[index].isAliasActive = true;
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
                      title: apiDataManager.aliasList[index].email,
                      emailDescription:
                          apiDataManager.aliasList[index].emailDescription,
                      deleteOnPress: () {
                        apiDataManager.deleteAlias(
                            aliasID: apiDataManager.aliasList[index].aliasID);
                        Navigator.pop(context);
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
