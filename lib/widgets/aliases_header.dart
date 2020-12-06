import 'package:flutter/material.dart';

class AliasesHeader extends StatelessWidget {
  const AliasesHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        'Aliases',
        style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
