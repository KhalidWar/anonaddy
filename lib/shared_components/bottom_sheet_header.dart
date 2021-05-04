import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({Key key, this.headerLabel}) : super(key: key);
  final String headerLabel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Divider(
          thickness: 3,
          indent: size.width * 0.4,
          endIndent: size.width * 0.4,
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          headerLabel,
          style: Theme.of(context).textTheme.headline6,
        ),
        Divider(thickness: 1),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}
