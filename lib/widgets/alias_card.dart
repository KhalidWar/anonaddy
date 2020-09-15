import 'package:flutter/material.dart';

import '../constants.dart';

class AliasCard extends StatelessWidget {
  const AliasCard({
    Key key,
    this.child,
    this.aliasCount,
    this.aliasLimit,
  }) : super(key: key);

  final int aliasCount, aliasLimit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aliases'.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      Text('Aliases'),
                      Text('$aliasCount / $aliasLimit'),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 1, color: kAppBarColor),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
