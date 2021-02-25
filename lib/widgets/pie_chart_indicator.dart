import 'package:flutter/material.dart';

class PieChartIndicator extends StatelessWidget {
  const PieChartIndicator({Key key, this.label, this.color, this.count})
      : super(key: key);

  final String label;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 12,
          color: color,
        ),
        SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 4),
        Text(
          label,
        ),
      ],
    );
  }
}
