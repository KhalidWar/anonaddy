import 'package:flutter/material.dart';

class PopScopeDialog extends StatelessWidget {
  const PopScopeDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure to want exit?'),
      actions: [
        RaisedButton(
          child: Text('Yes'),
          onPressed: () => Navigator.pop(context, true),
        ),
        RaisedButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
