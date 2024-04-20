import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:flutter/material.dart';

class AliasScreenRecipients extends StatelessWidget {
  const AliasScreenRecipients({
    super.key,
    required this.recipients,
    required this.onPressed,
  });

  final List<Recipient> recipients;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Default Recipient${recipients.length >= 2 ? 's' : ''}',
                key: AliasScreen.aliasScreenDefaultRecipient,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
        if (recipients.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(AppStrings.noDefaultRecipientSet),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipients.length,
            itemBuilder: (context, index) {
              final recipient = recipients[index];
              return RecipientListTile(
                recipient: recipient,
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    RecipientsScreen.routeName,
                    arguments: recipient.id,
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
