import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    Key? key,
    this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  final String? title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? AppStrings.noDefaultSelected,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
