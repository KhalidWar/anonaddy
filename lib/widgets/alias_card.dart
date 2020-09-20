import 'package:flutter/material.dart';

import '../constants.dart';

class AliasCard extends StatelessWidget {
  const AliasCard({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: kAppBarColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              'Aliases'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
