import 'package:anonaddy/notifiers/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/notifiers/recipient/recipients_notifier.dart';
import 'package:anonaddy/screens/create_alias/components/recipients_note.dart';
import 'package:anonaddy/screens/create_alias/components/recipients_tile.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(recipientsNotifier.notifier).fetchRecipients();
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
            final recipientState = ref.watch(recipientsNotifier);

            return recipientState.when(
              data: (data) {
                return Consumer(
                  builder: (context, ref, _) {
                    final createAliasState =
                        ref.watch(createAliasNotifierProvider).value!;
                    final verifiedRecipients =
                        createAliasState.verifiedRecipients!;

                    final createAliasNotifier =
                        ref.read(createAliasNotifierProvider.notifier);

                    return Column(
                      children: [
                        const BottomSheetHeader(
                            headerLabel: 'Select Default Recipients'),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            controller: controller,
                            physics: const BouncingScrollPhysics(),
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                                // ref
                                //     .read(createAliasNotifierProvider.notifier)
                                //     .clearSelectedRecipients();
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              child: const Text('Done'),
                              onPressed: () {
                                // ref
                                //     .read(createAliasNotifierProvider.notifier)
                                //     .setSelectedRecipients();
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
              },
              error: (err, stack) {
                // final error = recipientState.errorMessage;
                final error = err.toString();
                return LottieWidget(
                  showLoading: true,
                  lottie: LottieImages.errorCone,
                  lottieHeight: size.height * 0.1,
                  label: error.toString(),
                );
              },
              loading: () {
                return const Center(child: PlatformLoadingIndicator());
              },
            );
          },
        );
      },
    );
  }
}
