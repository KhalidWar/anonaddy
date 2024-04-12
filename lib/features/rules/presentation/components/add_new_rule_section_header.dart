import 'package:flutter/material.dart';

class AddNewRuleSectionHeader extends StatelessWidget {
  const AddNewRuleSectionHeader({
    super.key,
    required this.title,
    this.onPress,
  });

  final String title;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onPress != null)
          TextButton(
            onPressed: onPress,
            child: const Text('Add'),
          ),
      ],
    );
  }
}
