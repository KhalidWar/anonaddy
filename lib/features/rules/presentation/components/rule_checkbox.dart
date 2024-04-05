import 'package:flutter/material.dart';

class RuleCheckbox extends StatelessWidget {
  const RuleCheckbox({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: value,
      labelPadding: const EdgeInsets.all(0),
      label: Text(title),
      onSelected: onChanged,
    );
  }
}
