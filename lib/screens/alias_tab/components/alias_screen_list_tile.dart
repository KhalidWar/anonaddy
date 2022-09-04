import 'package:flutter/material.dart';

class AliasScreenListTile extends StatelessWidget {
  const AliasScreenListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.leadingIconData,
    required this.trailing,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final IconData leadingIconData;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        children: [
          Icon(leadingIconData),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
