import 'package:anonaddy/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDetailListTile extends StatelessWidget {
  const AliasDetailListTile({
    Key? key,
    this.trailingIconOnPress,
    this.trailingIconData,
    this.subtitle,
    this.leadingIconData,
    this.title,
    this.trailing,
    this.titleTextStyle,
    this.leadingIconColor,
  }) : super(key: key);

  final Function? trailingIconOnPress;
  final IconData? trailingIconData, leadingIconData;
  final Color? leadingIconColor;
  final dynamic title, subtitle;
  final Widget? trailing;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return title == null
        ? Container()
        : InkWell(
            onTap: trailingIconOnPress as void Function()?,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  Icon(leadingIconData, color: leadingIconColor),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read(nicheMethods).fixDateTime(title),
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
                  IgnorePointer(
                    child: trailingIconData == null
                        ? trailing ?? Container()
                        : IconButton(
                            icon: Icon(trailingIconData),
                            onPressed: trailingIconOnPress as void Function()?,
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
