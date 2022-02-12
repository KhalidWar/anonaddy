import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/recipients_note.dart';
import 'components/recipients_tile.dart';

class AliasRecipientSelection extends ConsumerStatefulWidget {
  const AliasRecipientSelection({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AliasRecipientSelectionState();
}

class _AliasRecipientSelectionState
    extends ConsumerState<AliasRecipientSelection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ref.read(recipientTabStateNotifier.notifier).fetchRecipients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, controller) {
        return Consumer(
          builder: (context, ref, _) {
            final recipientState = ref.watch(recipientTabStateNotifier);

            switch (recipientState.status) {
              case RecipientTabStatus.loading:
                return Center(child: PlatformLoadingIndicator());

              case RecipientTabStatus.loaded:
                return Consumer(
                  builder: (context, ref, _) {
                    final createAliasState =
                        ref.watch(createAliasStateNotifier);
                    final verifiedRecipients =
                        createAliasState.verifiedRecipients!;

                    final createAliasNotifier =
                        ref.read(createAliasStateNotifier.notifier);

                    return Column(
                      children: [
                        BottomSheetHeader(
                            headerLabel: 'Select Default Recipients'),
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: verifiedRecipients.length,
                                  itemBuilder: (context, index) {
                                    final verifiedRecipient =
                                        verifiedRecipients[index];
                                    return RecipientsTile(
                                      email: verifiedRecipient.email,
                                      isSelected: createAliasNotifier
                                          .isRecipientSelected(
                                              verifiedRecipient),
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
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              child: Text(
                                createAliasState.selectedRecipients!.isNotEmpty
                                    ? 'Clear'
                                    : 'Cancel',
                              ),
                              onPressed: () {
                                ref
                                    .read(createAliasStateNotifier.notifier)
                                    .clearSelectedRecipients();
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              child: Text('Done'),
                              onPressed: () {
                                ref
                                    .read(createAliasStateNotifier.notifier)
                                    .setSelectedRecipients();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        if (PlatformAware.isIOS())
                          SizedBox(height: size.height * 0.03),
                      ],
                    );
                  },
                );

              case RecipientTabStatus.failed:
                final error = recipientState.errorMessage;
                return LottieWidget(
                  showLoading: true,
                  lottie: 'assets/lottie/errorCone.json',
                  lottieHeight: size.height * 0.1,
                  label: error.toString(),
                );
            }
          },
        );
      },
    );
  }
}
