import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:anonaddy/features/usernames/presentation/usernames_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';

class UsernameListTile extends StatelessWidget {
  const UsernameListTile({Key? key, required this.username}) : super(key: key);
  final Username username;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle_outlined),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username.username),
                const SizedBox(height: 2),
                Text(
                  username.description == null
                      ? AppStrings.noDescription
                      : username.description!,
                  style: const TextStyle(color: Colors.grey),
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
