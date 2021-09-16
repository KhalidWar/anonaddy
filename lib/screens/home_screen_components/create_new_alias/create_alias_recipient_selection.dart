import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAliasRecipientSelection extends StatefulWidget {
  @override
  _CreateAliasRecipientSelectionState createState() =>
      _CreateAliasRecipientSelectionState();
}

class _CreateAliasRecipientSelectionState
    extends State<CreateAliasRecipientSelection> {
  final _verifiedRecipients = <Recipient>[];
  final _selectedRecipients = <Recipient>[];

  void _setDefaultRecipients() {
    final allRecipients =
        context.read(recipientsProvider).data!.value.recipients;
    for (Recipient recipient in allRecipients) {
      if (recipient.emailVerifiedAt != null) {
        _verifiedRecipients.add(recipient);
      }
    }
  }

  bool _isRecipientSelected(Recipient verifiedRecipient) {
    if (_selectedRecipients.contains(verifiedRecipient)) {
      return true;
    }
    return false;
  }

  void _toggleRecipient(Recipient verifiedRecipient) {
    if (_selectedRecipients.contains(verifiedRecipient)) {
      _selectedRecipients
          .removeWhere((element) => element.email == verifiedRecipient.email);
    } else {
      _selectedRecipients.add(verifiedRecipient);
    }
    setState(() {});
  }

  @override
  void initState() {
    _setDefaultRecipients();
    super.initState();
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
            BottomSheetHeader(headerLabel: 'Select Default Recipients'),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: controller,
                physics: BouncingScrollPhysics(),
                children: [
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
                          selected: _isRecipientSelected(verifiedRecipient),
                          selectedTileColor: kAccentColor,
                          horizontalTitleGap: 0,
                          title: Text(
                            verifiedRecipient.email,
                            style: TextStyle(
                              color: _isRecipientSelected(verifiedRecipient)
                                  ? Colors.black
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                            ),
                          ),
                          onTap: () => _toggleRecipient(verifiedRecipient),
                        );
                      },
                    ),
                  buildNote(size),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Text('Done'),
                onPressed: () {
                  context
                      .read(aliasStateManagerProvider)
                      .setCreateAliasRecipients = _selectedRecipients;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Padding buildNote(Size size) {
    return Padding(
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
    );
  }
}
