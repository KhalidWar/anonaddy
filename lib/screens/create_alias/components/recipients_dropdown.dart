import 'package:anonaddy/screens/create_alias/components/create_alias_card.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientsDropdown extends StatelessWidget {
  const RecipientsDropdown({Key? key, required this.onPress}) : super(key: key);
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final recipients = watch(createAliasStateNotifier).selectedRecipients!;

        return CreateAliasCard(
          header: 'Recipients',
          subHeader: '',
          child: recipients.isEmpty
              ? Text(
                  'Select recipient(s) (optional)...',
                  style: Theme.of(context).textTheme.caption,
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipients.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 5),
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
                ),
          onPress: onPress,
        );
      },
    );
  }
}
