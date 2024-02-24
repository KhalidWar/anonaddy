import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:flutter/material.dart';

class AliasScreenRecipients extends StatelessWidget {
  const AliasScreenRecipients({
    Key? key,
    required this.recipients,
    required this.onPressed,
  }) : super(key: key);

  final List<Recipient> recipients;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
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
            padding: EdgeInsets.symmetric(horizontal: 10),
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
                    arguments: recipient,
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
