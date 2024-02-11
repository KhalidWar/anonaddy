import 'package:flutter/material.dart';

class AlertHeader extends StatelessWidget {
  const AlertHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const Divider(),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.caption,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
