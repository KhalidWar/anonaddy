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
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          IgnorePointer(
            child: Checkbox.adaptive(
              value: value,
              onChanged: onChanged,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
