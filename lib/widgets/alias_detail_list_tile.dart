import 'package:anonaddy/utilities/niche_method.dart';
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
    this.leadingIconColor,
  }) : super(key: key);

  final Function trailingIconOnPress;
  final IconData trailingIconData, leadingIconData;
  final Color leadingIconColor;
  final dynamic title, subtitle;
  final Widget trailing;
  final TextStyle titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return title == null
        ? Container()
        : ListTile(
            horizontalTitleGap: 0,
            dense: true,
            leading: Icon(leadingIconData, color: leadingIconColor),
            title: Text(
              '${NicheMethod().fixDateTime(title)}',
              style: titleTextStyle ?? null,
            ),
            subtitle: Text('$subtitle'),
            trailing: trailingIconData == null
                ? trailing
                : IconButton(
                    icon: Icon(trailingIconData),
                    onPressed: trailingIconOnPress,
                  ),
          );
  }
}
