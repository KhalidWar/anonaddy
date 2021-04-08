import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile(
      {Key key,
      this.title,
      this.subtitle,
      this.leadingIconData,
      this.trailingIconData,
      this.method})
      : super(key: key);

  final String title, subtitle;
  final IconData leadingIconData, trailingIconData;
  final Function method;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        trailingIconData == null
            ? Container()
            : IconButton(
                icon: Icon(trailingIconData),
                onPressed: method,
              ),
      ],
    );
  }
}
