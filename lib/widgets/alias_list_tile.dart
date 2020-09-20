import 'package:flutter/material.dart';

class AliasListTile extends StatelessWidget {
  const AliasListTile({
    Key key,
    this.email,
    this.emailDescription,
    this.switchOnPress,
    this.listTileOnPress,
    this.switchValue,
    this.child,
  }) : super(key: key);

  final String email, emailDescription;
  final Function switchOnPress, listTileOnPress;
  final bool switchValue;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: listTileOnPress,
          title: Text(
            email,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(emailDescription),
          leading: Switch(
            value: switchValue,
            onChanged: switchOnPress,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return child;
                  });
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}
