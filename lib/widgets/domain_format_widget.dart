import 'package:flutter/material.dart';

class DomainFormatWidget extends StatelessWidget {
  const DomainFormatWidget({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            '$value',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
