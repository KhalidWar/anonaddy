import 'package:flutter/material.dart';

class PieChartIndicator extends StatelessWidget {
  const PieChartIndicator({
    super.key,
    required this.label,
    required this.color,
    required this.count,
    this.textColor,
  });

  final String label;
  final Color color;
  final Color? textColor;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(height: 12, width: 12, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
