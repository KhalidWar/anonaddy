import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class RecipientScreenActionsListTile extends StatelessWidget {
  const RecipientScreenActionsListTile({
    Key? key,
    this.subtitle,
    this.leadingIconData,
    this.title,
    this.trailing,
    this.titleTextStyle,
    this.leadingIconColor,
  }) : super(key: key);

  final IconData? leadingIconData;
  final Color? leadingIconColor;
  final dynamic title, subtitle;
  final Widget? trailing;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return title == null
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              children: [
                Icon(leadingIconData, color: leadingIconColor),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        NicheMethod.fixDateTime(title),
                        style: titleTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '$subtitle',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ?? Container()
              ],
            ),
          );
  }
}
