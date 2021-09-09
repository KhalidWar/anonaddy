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

  @override
  void initState() {
    super.initState();
    _setVerifiedRecipients();
    _setDefaultRecipients();
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
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
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
                    final isLoading =
                        watch(aliasStateManagerProvider).updateRecipientLoading;
                    return isLoading
                        ? CircularProgressIndicator(color: kPrimaryColor)
                        : Text('Update Recipients');
                  },
                ),
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
