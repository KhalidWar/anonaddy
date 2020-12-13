import 'package:flutter/material.dart';

class AccountCardHeader extends StatelessWidget {
  const AccountCardHeader({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Icon(Icons.account_circle_outlined, size: 50),
          Text(
            '$title',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text('$subtitle'),
          SizedBox(height: size.height * 0.01),
          Divider(
            height: 0,
            indent: size.width * 0.4,
            endIndent: size.width * 0.4,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
