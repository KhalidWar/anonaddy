import 'package:anonaddy/utilities/date_time_fixer.dart';
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
    return title == null
        ? Container()
        : ListTile(
            horizontalTitleGap: 0,
            dense: true,
            leading: Icon(leadingIconData),
            title: Text(
              '${DateTimeFixer().fixDateTime(title)}',
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
