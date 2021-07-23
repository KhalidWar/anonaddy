import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class AliasCreatedAtWidget extends StatelessWidget {
  const AliasCreatedAtWidget(
      {Key? key, required this.label, required this.dateTime})
      : super(key: key);

  final String label;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(label),
          SizedBox(width: 5),
          Text(
            NicheMethod().fixDateTime(dateTime).toString(),
          ),
        ],
      ),
    );
  }
}
