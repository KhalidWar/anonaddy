import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    this.title,
    required this.subtitle,
    required this.icon,
  });

  final String? title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
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
