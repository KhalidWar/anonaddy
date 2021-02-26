import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class AliasCreatedAtWidget extends StatelessWidget {
  const AliasCreatedAtWidget({Key key, this.label, this.dateTime})
      : super(key: key);

  final String label;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.access_time_outlined),
          SizedBox(width: 12),
          Text(label),
          SizedBox(width: 12),
          Text('${NicheMethod().fixDateTime(dateTime)}'),
        ],
      ),
    );
  }
}
