import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';

class AliasCreatedAtWidget extends StatelessWidget {
  const AliasCreatedAtWidget({
    super.key,
    required this.label,
    required this.dateTime,
  });

  final String label;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 5),
          Text(
            NicheMethod.fixDateTime(dateTime),
          ),
        ],
      ),
    );
  }
}
