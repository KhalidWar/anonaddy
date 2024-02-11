import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
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
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipient.email),
                recipient.emailVerifiedAt.isEmpty
                    ? Text(
                        AppStrings.unverified,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Colors.red),
                      )
                    : Text(
                        AppStrings.verified,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Colors.green),
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
