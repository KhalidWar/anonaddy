import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile(
      {Key? key,
      this.title,
      required this.subtitle,
      required this.leadingIconData,
      this.trailingIconData,
      this.onTap})
      : super(key: key);

  final String? title;
  final String subtitle;
  final IconData leadingIconData;
  final IconData? trailingIconData;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(leadingIconData),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? 'No default selected',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(subtitle),
              ],
            ),
            Spacer(),
            IgnorePointer(
              child: trailingIconData == null
                  ? Container()
                  : IconButton(
                      icon: Icon(trailingIconData),
                      onPressed: () {},
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
