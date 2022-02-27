import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/screens/account_tab/recipients/recipients_screen.dart';
import 'package:anonaddy/shared_components/constants/addymanager_string.dart';
import 'package:flutter/material.dart';

class RecipientListTile extends StatelessWidget {
  const RecipientListTile({
    Key? key,
    required this.recipient,
  }) : super(key: key);

  final Recipient recipient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.email_outlined),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient.email),
                const SizedBox(height: 2),
                recipient.emailVerifiedAt == null
                    ? const Text(
                        AddyManagerString.unverified,
                        style: TextStyle(color: Colors.red),
                      )
                    : const Text(
                        AddyManagerString.verified,
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
          RecipientsScreen.routeName,
          arguments: recipient,
        );
      },
    );
  }
}
