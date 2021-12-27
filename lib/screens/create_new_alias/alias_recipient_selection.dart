import 'package:anonaddy/screens/create_new_alias/components/recipients_tile.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/recipients_note.dart';

class AliasRecipientSelection extends StatelessWidget {
  const AliasRecipientSelection();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, controller) {
        final size = MediaQuery.of(context).size;

        return Consumer(builder: (context, watch, _) {
          final createAliasState = watch(createAliasStateNotifier);
          final verifiedRecipients = createAliasState.verifiedRecipients!;

          final createAliasNotifier =
              context.read(createAliasStateNotifier.notifier);

          return Column(
            children: [
              BottomSheetHeader(headerLabel: 'Select Default Recipients'),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  controller: controller,
                  physics: BouncingScrollPhysics(),
                  children: [
                    if (verifiedRecipients.isEmpty)
                      Center(
                        child: Text(
                          'No recipients found',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: verifiedRecipients.length,
                        itemBuilder: (context, index) {
                          final verifiedRecipient = verifiedRecipients[index];
                          return RecipientsTile(
                            email: verifiedRecipient.email,
                            isSelected: createAliasNotifier
                                .isRecipientSelected(verifiedRecipient),
                            onPress: () => createAliasNotifier
                                .toggleRecipient(verifiedRecipient),
                          );
                        },
                      ),
                    const RecipientsNote(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text(
                      createAliasState.selectedRecipients!.isNotEmpty
                          ? 'Clear'
                          : 'Cancel',
                    ),
                    onPressed: () {
                      context
                          .read(createAliasStateNotifier.notifier)
                          .clearSelectedRecipients();
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    child: Text('Done'),
                    onPressed: () {
                      context
                          .read(createAliasStateNotifier.notifier)
                          .setSelectedRecipients();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          );
        });
      },
    );
  }
}
