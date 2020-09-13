import 'package:flutter/material.dart';

class AliasesListTile extends StatelessWidget {
  const AliasesListTile({
    Key key,
    this.email,
    this.emailDescription,
    this.editOnPress,
    this.switchOnPress,
    this.listTileOnPress,
    this.switchValue,
  }) : super(key: key);

  final String email, emailDescription;
  final Function editOnPress, switchOnPress, listTileOnPress;
  final bool switchValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          dense: true,
          onTap: listTileOnPress,
          title: Text(email, style: Theme.of(context).textTheme.bodyText1),
          subtitle: Text(emailDescription),
          leading: Switch(
            value: switchValue,
            onChanged: switchOnPress,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: editOnPress,
          ),
        ),
        Divider(
          thickness: 1,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
      ],
    );
  }
}
