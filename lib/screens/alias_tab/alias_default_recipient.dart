import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/state_management/alias_state/default_recipient/default_recipient_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDefaultRecipientScreen extends StatefulWidget {
  const AliasDefaultRecipientScreen(this.alias);
  final Alias alias;

  @override
  _AliasDefaultRecipientScreenState createState() =>
      _AliasDefaultRecipientScreenState();
}

class _AliasDefaultRecipientScreenState
    extends State<AliasDefaultRecipientScreen> {
  @override
  void initState() {
    super.initState();

    /// After widgets are built, fetch recipients and display verified ones.
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(recipientTabStateNotifier.notifier).fetchRecipients();
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
          final recipientState = watch(recipientTabStateNotifier);

          switch (recipientState.status) {
            case RecipientTabStatus.loading:
              return Center(child: PlatformLoadingIndicator());

            case RecipientTabStatus.loaded:
              return Consumer(builder: (context, watch, _) {
                final aliasScreenState = watch(defaultRecipientStateNotifier);
                final verifiedRecipients = aliasScreenState.verifiedRecipients!;

                return Column(
                  children: [
                    BottomSheetHeader(headerLabel: 'Update Alias Recipients'),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        controller: controller,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(kUpdateAliasRecipients),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Divider(height: 0),
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
                                final verifiedRecipient =
                                    verifiedRecipients[index];
                                final isDefault = context
                                    .read(
                                        defaultRecipientStateNotifier.notifier)
                                    .isRecipientDefault(verifiedRecipient);

                                return ListTile(
                                  selected: isDefault,
                                  selectedTileColor: kAccentColor,
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
                                    context
                                        .read(defaultRecipientStateNotifier
                                            .notifier)
                                        .toggleRecipient(verifiedRecipient);
                                  },
                                );
                              },
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 0),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  kUpdateAliasRecipientNote,
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
                      padding: EdgeInsets.all(15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        child: Consumer(
                          builder: (_, watch, __) {
                            final isLoading = watch(aliasScreenStateNotifier)
                                .updateRecipientLoading!;
                            return isLoading
                                ? CircularProgressIndicator(
                                    color: kPrimaryColor)
                                : Text('Update Recipients');
                          },
                        ),
                        onPressed: () {
                          /// Get default recipients Ids.
                          final recipientIds = context
                              .read(defaultRecipientStateNotifier.notifier)
                              .getRecipientIds();

                          /// Update default recipients for [widget.alias]
                          context
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
                lottie: 'assets/lottie/errorCone.json',
                lottieHeight: size.height * 0.1,
                label: error.toString(),
              );
          }
        });
      },
    );
  }
}
