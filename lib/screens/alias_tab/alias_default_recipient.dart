import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/state_management/alias_state/default_recipient/default_recipient_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDefaultRecipientScreen extends ConsumerStatefulWidget {
  const AliasDefaultRecipientScreen({
    Key? key,
    required this.alias,
  }) : super(key: key);
  final Alias alias;

  @override
  ConsumerState createState() => _AliasDefaultRecipientScreenState();
}

class _AliasDefaultRecipientScreenState
    extends ConsumerState<AliasDefaultRecipientScreen> {
  @override
  void initState() {
    super.initState();

    /// After widgets are built, fetch recipients and display verified ones.
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
        return Consumer(builder: (context, watch, _) {
          final recipientState = ref.watch(recipientTabStateNotifier);

          switch (recipientState.status) {
            case RecipientTabStatus.loading:
              return const Center(child: PlatformLoadingIndicator());

            case RecipientTabStatus.loaded:
              return Consumer(builder: (context, watch, _) {
                final aliasScreenState =
                    ref.watch(defaultRecipientStateNotifier);
                final verifiedRecipients = aliasScreenState.verifiedRecipients!;

                return Column(
                  children: [
                    const BottomSheetHeader(
                        headerLabel: 'Update Alias Recipients'),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        controller: controller,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(AnonAddyString.updateAliasRecipients),
                          ),
                          SizedBox(height: size.height * 0.02),
                          const Divider(height: 0),
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: verifiedRecipients.length,
                              itemBuilder: (context, index) {
                                final verifiedRecipient =
                                    verifiedRecipients[index];
                                final isDefault = ref
                                    .read(
                                        defaultRecipientStateNotifier.notifier)
                                    .isRecipientDefault(verifiedRecipient);

                                return ListTile(
                                  selected: isDefault,
                                  selectedTileColor: AppColors.accentColor,
                                  horizontalTitleGap: 0,
                                  title: Text(
                                    verifiedRecipient.email,
                                    style: TextStyle(
                                      color: isDefault
                                          ? Colors.black
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color,
                                    ),
                                  ),
                                  onTap: () {
                                    ref
                                        .read(defaultRecipientStateNotifier
                                            .notifier)
                                        .toggleRecipient(verifiedRecipient);
                                  },
                                );
                              },
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 0),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  AppStrings.updateAliasRecipientNote,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        child: Consumer(
                          builder: (_, watch, __) {
                            final isLoading = ref
                                .watch(aliasScreenStateNotifier)
                                .updateRecipientLoading!;
                            return isLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  )
                                : const Text('Update Recipients');
                          },
                        ),
                        onPressed: () {
                          /// Get default recipients Ids.
                          final recipientIds = ref
                              .read(defaultRecipientStateNotifier.notifier)
                              .getRecipientIds();

                          /// Update default recipients for [widget.alias]
                          ref
                              .read(aliasScreenStateNotifier.notifier)
                              .updateAliasDefaultRecipient(
                                  widget.alias, recipientIds)
                              .whenComplete(() => Navigator.pop(context));
                        },
                      ),
                    ),
                  ],
                );
              });

            case RecipientTabStatus.failed:
              final error = recipientState.errorMessage;
              return LottieWidget(
                showLoading: true,
                lottie: LottieImages.errorCone,
                lottieHeight: size.height * 0.1,
                label: error.toString(),
              );
          }
        });
      },
    );
  }
}
