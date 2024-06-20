import 'package:flutter/material.dart';

class AliasDetailListTile extends StatelessWidget {
  const AliasDetailListTile({
    super.key,
    required this.subtitle,
    this.trailingIconOnPress,
    this.trailingIconData,
    this.leadingIconData,
    this.title,
    this.trailing,
    this.titleTextStyle,
    this.leadingIconColor,
  });

  final Function()? trailingIconOnPress;
  final IconData? trailingIconData, leadingIconData;
  final Color? leadingIconColor;
  final String? title;
  final String subtitle;
  final Widget? trailing;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    if (title == null) return const SizedBox.shrink();

    return InkWell(
      onTap: trailingIconOnPress,
      child: Container(
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
                    title!,
                    style: titleTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              child: trailingIconData == null
                  ? trailing ?? Container()
                  : IconButton(
                      icon: Icon(trailingIconData),
                      onPressed: trailingIconOnPress,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
