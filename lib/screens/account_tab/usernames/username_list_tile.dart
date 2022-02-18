import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/usernames/usernames_screen.dart';
import 'package:flutter/material.dart';

import '../../../shared_components/constants/ui_strings.dart';

class UsernameListTile extends StatelessWidget {
  const UsernameListTile({Key? key, required this.username}) : super(key: key);
  final Username username;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle_outlined),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username.username),
                SizedBox(height: 2),
                Text(
                  username.description ?? kNoDescription,
                  style: TextStyle(color: Colors.grey),
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
          arguments: username,
        );
      },
    );
  }
}
