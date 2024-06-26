import 'package:flutter/material.dart';

class RecipientScreenActionsListTile extends StatelessWidget {
  const RecipientScreenActionsListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingIconData,
    this.trailing,
    this.leadingIconColor,
  });

  final String title;
  final String subtitle;
  final IconData? leadingIconData;
  final Color? leadingIconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(leadingIconData, color: leadingIconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
