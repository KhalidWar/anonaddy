import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipient_detailed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

class RecipientListTile extends StatelessWidget {
  const RecipientListTile({Key? key, required this.recipient})
      : super(key: key);

  final Recipient recipient;

  @override
  Widget build(BuildContext context) {
    final recipientDataProvider = context.read(recipientStateManagerProvider);

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.email_outlined),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient.email),
                SizedBox(height: 2),
                recipient.emailVerifiedAt == null
                    ? Text(
                        'Unverified',
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(
                        'Verified',
                        style: TextStyle(color: Colors.green),
                      ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          RecipientDetailedScreen.routeName,
          arguments: recipient,
        );
      },
    );
  }
}
