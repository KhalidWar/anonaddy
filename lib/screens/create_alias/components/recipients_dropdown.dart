import 'package:anonaddy/notifiers/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/screens/create_alias/components/create_alias_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientsDropdown extends StatelessWidget {
  const RecipientsDropdown({Key? key, required this.onPress}) : super(key: key);
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final recipients =
            ref.watch(createAliasNotifierProvider).value!.selectedRecipients;

        return CreateAliasCard(
          header: 'Recipients',
          subHeader: 'Default recipient(s) for alias.',
          onPress: onPress,
          child: recipients.isEmpty
              ? Text(
                  'Select recipient(s) (optional)...',
                  style: Theme.of(context).textTheme.caption,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: recipients.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemBuilder: (context, index) {
                    final recipient = recipients[index];
                    return Text(
                      recipient.email,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                    );
                  },
                ),
        );
      },
    );
  }
}
