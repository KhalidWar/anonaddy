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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(leadingIconData, color: leadingIconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NicheMethod.fixDateTime(title),
                  style: titleTextStyle,
                ),
                Text(
                  '$subtitle',
                  style: Theme.of(context).textTheme.caption,
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
