import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_screen.dart';
import 'package:flutter/material.dart';

class UsernameListTile extends StatelessWidget {
  const UsernameListTile({
    super.key,
    required this.username,
  });

  final Username username;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle_outlined),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username.username),
                Text(
                  username.description == null
                      ? AppStrings.noDescription
                      : username.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          UsernamesScreen.routeName,
          arguments: username.id,
        );
      },
    );
  }
}
