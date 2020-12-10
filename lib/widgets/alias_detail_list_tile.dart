import 'package:flutter/material.dart';

class AliasDetailListTile extends StatelessWidget {
  const AliasDetailListTile({
    Key key,
    this.trailingIconOnPress,
    this.trailingIconData,
    this.subtitle,
    this.leadingIconData,
    this.title,
    this.trailing,
    this.titleTextStyle,
  }) : super(key: key);

  final Function trailingIconOnPress;
  final IconData trailingIconData, leadingIconData;
  final dynamic title, subtitle;
  final Widget trailing;
  final TextStyle titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return subtitle == null
        ? Container()
        : ListTile(
            horizontalTitleGap: 0,
            dense: true,
            leading: Icon(leadingIconData),
            title: Text('$title', style: titleTextStyle ?? null),
            subtitle: Text('${subtitle ?? 'Alias not deleted'}'),
            trailing: trailingIconData == null
                ? trailing
                : IconButton(
                    icon: Icon(trailingIconData),
                    onPressed: trailingIconOnPress,
                  ),
          );
  }
}
