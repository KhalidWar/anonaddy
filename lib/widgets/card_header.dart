import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({Key key, this.label}) : super(key: key);
  final String label;
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
        label,
        style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
