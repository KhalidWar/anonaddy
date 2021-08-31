import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDefaultRecipientScreen extends StatefulWidget {
  const AliasDefaultRecipientScreen(this.aliasDataModel);
  final Alias aliasDataModel;

  @override
  _AliasDefaultRecipientScreenState createState() =>
      _AliasDefaultRecipientScreenState();
}

class _AliasDefaultRecipientScreenState
    extends State<AliasDefaultRecipientScreen> {
  final _verifiedRecipients = <Recipient>[];
  final _defaultRecipients = <Recipient>[];
  final _selectedRecipientsID = <String>[];

  late double initialChildSize;
  late double maxChildSize;

  void _toggleRecipient(Recipient verifiedRecipient) {
    if (_defaultRecipients.contains(verifiedRecipient)) {
      _defaultRecipients
          .removeWhere((element) => element.email == verifiedRecipient.email);
      _selectedRecipientsID
          .removeWhere((element) => element == verifiedRecipient.id);
    } else {
      _defaultRecipients.add(verifiedRecipient);
      _selectedRecipientsID.add(verifiedRecipient.id);
    }
  }

  bool _isDefaultRecipient(Recipient verifiedRecipient) {
    for (Recipient defaultRecipient in _defaultRecipients) {
      if (defaultRecipient.email == verifiedRecipient.email) {
        return true;
      }
    }
    return false;
  }

  void _setVerifiedRecipients() {
    final allRecipients = context.read(recipientsProvider).data!.value;
    for (Recipient recipient in allRecipients.recipients) {
      if (recipient.emailVerifiedAt != null) {
        _verifiedRecipients.add(recipient);
      }
    }
  }

  void _setDefaultRecipients() {
    final aliasDefaultRecipients = widget.aliasDataModel.recipients;
    for (Recipient verifiedRecipient in _verifiedRecipients) {
      for (Recipient recipient in aliasDefaultRecipients!) {
        if (recipient.email == verifiedRecipient.email) {
          _defaultRecipients.add(recipient);
          _selectedRecipientsID.add(recipient.id);
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

  @override
  void initState() {
    super.initState();
    _setVerifiedRecipients();
    _setDefaultRecipients();
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
                    BottomSheetHeader(headerLabel: 'Update Alias Recipients'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text(kUpdateAliasRecipients),
                          SizedBox(height: size.height * 0.01),
                          Consumer(
                            builder: (_, watch, __) {
                              final isLoading = watch(aliasStateManagerProvider)
                                  .updateRecipientLoading;
                              return isLoading
                                  ? LinearProgressIndicator(color: kAccentColor)
                                  : Divider(height: 0);
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _verifiedRecipients.length,
                    itemBuilder: (context, index) {
                      final verifiedRecipient = _verifiedRecipients[index];
                      return ListTile(
                        selected: _isDefaultRecipient(verifiedRecipient),
                        selectedTileColor: kAccentColor,
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 0),
                      SizedBox(height: size.height * 0.01),
                      Text(kUpdateAliasRecipientNote),
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
                child: Text('Update Recipients'),
                onPressed: () => context
                    .read(aliasStateManagerProvider)
                    .updateAliasDefaultRecipient(
                      context,
                      widget.aliasDataModel.id,
                      _selectedRecipientsID,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
