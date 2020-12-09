import 'package:flutter/material.dart';

class DomainFormatWidget extends StatelessWidget {
  const DomainFormatWidget({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  final String label;
  final dynamic value;

  String _dateTimeFixer() {
    if (value.runtimeType == DateTime) {
      return '${value.toString().split(' ').first}';
    } else {
      return '$value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Text(
            _dateTimeFixer(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
