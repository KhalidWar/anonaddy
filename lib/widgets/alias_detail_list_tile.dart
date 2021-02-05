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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color themedColor() {
      return isDark ? Colors.white : Colors.grey;
    }

    return title == null
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Icon(
                  leadingIconData,
                  color: leadingIconColor ?? themedColor(),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${NicheMethod().fixDateTime(title)}',
                        style: titleTextStyle ?? null,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          '$subtitle',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                trailingIconData == null
                    ? trailing ?? Container()
                    : IconButton(
                        icon: Icon(
                          trailingIconData,
                          color: themedColor(),
                        ),
                        onPressed: trailingIconOnPress,
                      ),
              ],
            ),
          );
  }
}
