import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/state_management/domains/domains_screen_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainDefaultRecipient extends ConsumerStatefulWidget {
  const DomainDefaultRecipient({
    Key? key,
    required this.domain,
  }) : super(key: key);
  final Domain domain;

  @override
  ConsumerState createState() => _DomainDefaultRecipientState();
}

class _DomainDefaultRecipientState
    extends ConsumerState<DomainDefaultRecipient> {
  final _verifiedRecipients = <Recipient>[];
  Recipient? selectedRecipient;

  late double initialChildSize;
  late double maxChildSize;

  void _toggleRecipient(Recipient verifiedRecipient) {
    if (selectedRecipient == null) {
      selectedRecipient = verifiedRecipient;
    } else {
      if (verifiedRecipient.email == selectedRecipient!.email) {
        selectedRecipient = null;
      } else {
        selectedRecipient = verifiedRecipient;
      }
    }
  }

  bool _isDefaultRecipient(Recipient verifiedRecipient) {
    if (selectedRecipient == null) {
      return false;
    } else {
      if (verifiedRecipient.email == selectedRecipient!.email) {
        return true;
      }
      return false;
    }
  }

  void _setVerifiedRecipients() {
    final recipientTabState = ref.read(recipientTabStateNotifier);
    if (recipientTabState.status == RecipientTabStatus.loaded) {
      final allRecipients = recipientTabState.recipients!;
      for (Recipient recipient in allRecipients) {
        if (recipient.emailVerifiedAt != null) {
          _verifiedRecipients.add(recipient);
        }
      }
    }
  }

  void _setDefaultRecipient() {
    final defaultRecipient = widget.domain.defaultRecipient;
    for (Recipient verifiedRecipient in _verifiedRecipients) {
      if (defaultRecipient == null) {
        selectedRecipient = null;
      } else {
        if (defaultRecipient.email == verifiedRecipient.email) {
          selectedRecipient = verifiedRecipient;
        }
      }
    }
  }

  void _setScrollSheetSizes() {
    setState(() {
      if (_verifiedRecipients.length <= 3) {
        initialChildSize = 0.5;
        maxChildSize = 0.6;
      } else if (_verifiedRecipients.length > 3 &&
          _verifiedRecipients.length <= 6) {
        initialChildSize = 0.55;
        maxChildSize = 0.7;
      } else {
        initialChildSize = 0.7;
        maxChildSize = 0.9;
      }
    });
  }

  Future<void> updateDefaultRecipient() async {
    await ref
        .read(domainsScreenStateNotifier.notifier)
        .updateDomainDefaultRecipients(
          widget.domain.id,
          selectedRecipient == null ? '' : selectedRecipient!.id,
        );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _setVerifiedRecipients();
    _setDefaultRecipient();
    _setScrollSheetSizes();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialChildSize,
      minChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      builder: (context, controller) {
        return Stack(
          children: [
            ListView(
              controller: controller,
              children: [
                Column(
                  children: [
                    const BottomSheetHeader(
                      headerLabel: 'Update Default Recipient',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const Text(
                              AnonAddyString.updateDomainDefaultRecipient),
                          SizedBox(height: size.height * 0.01),
                          Consumer(
                            builder: (_, watch, __) {
                              final isLoading = ref
                                  .watch(domainsScreenStateNotifier)
                                  .updateRecipientLoading!;
                              return isLoading
                                  ? const LinearProgressIndicator(
                                      color: AppColors.accentColor)
                                  : const Divider(height: 0);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                if (_verifiedRecipients.isEmpty)
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
                    itemCount: _verifiedRecipients.length,
                    itemBuilder: (context, index) {
                      final verifiedRecipient = _verifiedRecipients[index];
                      return ListTile(
                        selected: _isDefaultRecipient(verifiedRecipient),
                        selectedTileColor: AppColors.accentColor,
                        horizontalTitleGap: 0,
                        title: Text(
                          verifiedRecipient.email,
                          style: TextStyle(
                            color: _isDefaultRecipient(verifiedRecipient)
                                ? Colors.black
                                : Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _toggleRecipient(verifiedRecipient);
                          });
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
                      const Text(AppStrings.updateAliasRecipientNote),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: const Text('Update Default Recipients'),
                onPressed: () => updateDefaultRecipient(),
              ),
            ),
          ],
        );
      },
    );
  }
}
