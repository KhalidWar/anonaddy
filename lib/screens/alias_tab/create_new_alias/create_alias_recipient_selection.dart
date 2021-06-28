import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAliasRecipientSelection extends StatefulWidget {
  @override
  _CreateAliasRecipientSelectionState createState() =>
      _CreateAliasRecipientSelectionState();
}

class _CreateAliasRecipientSelectionState
    extends State<CreateAliasRecipientSelection> {
  final verifiedRecipients = <RecipientDataModel>[];
  final selectedRecipients = <RecipientDataModel>[];

  double initialChildSize = 0.55;
  double minChildSize = 0.3;
  double maxChildSize = 0.7;

  void _setScrollSheetSizes() {
    if (verifiedRecipients.length <= 3) {
      initialChildSize = 0.5;
      maxChildSize = 0.6;
    } else if (verifiedRecipients.length > 3 &&
        verifiedRecipients.length <= 6) {
      initialChildSize = 0.55;
      maxChildSize = 0.7;
    } else {
      initialChildSize = 0.7;
      maxChildSize = 0.9;
    }
    setState(() {});
  }

  void _setDefaultRecipients() {
    final allRecipients =
        context.read(recipientsProvider).data.value.recipientDataList;
    for (RecipientDataModel recipient in allRecipients) {
      if (recipient.emailVerifiedAt != null) {
        verifiedRecipients.add(recipient);
      }
    }
  }

  bool _isRecipientSelected(RecipientDataModel verifiedRecipient) {
    if (selectedRecipients.contains(verifiedRecipient)) {
      return true;
    }
    return false;
  }

  void _toggleRecipient(RecipientDataModel verifiedRecipient) {
    if (selectedRecipients.contains(verifiedRecipient)) {
      selectedRecipients
          .removeWhere((element) => element.email == verifiedRecipient.email);
    } else {
      selectedRecipients.add(verifiedRecipient);
    }
    setState(() {});
  }

  @override
  void initState() {
    _setScrollSheetSizes();
    _setDefaultRecipients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, controller) {
        return Stack(
          children: [
            ListView(
              controller: controller,
              children: [
                BottomSheetHeader(headerLabel: 'Select Default Recipients'),
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
                      return ListTile(
                        selected: _isRecipientSelected(verifiedRecipient),
                        selectedTileColor: kAccentColor,
                        horizontalTitleGap: 0,
                        title: Text(
                          verifiedRecipient.email,
                          style: TextStyle(
                            color: _isRecipientSelected(verifiedRecipient)
                                ? Colors.black
                                : Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        onTap: () => _toggleRecipient(verifiedRecipient),
                      );
                    },
                  ),
                buildNote(size),
                SizedBox(height: size.height * 0.1),
              ],
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Text('Done'),
                onPressed: () {
                  context
                      .read(aliasStateManagerProvider)
                      .setCreateAliasRecipients = selectedRecipients;
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
          Text(kUpdateAliasRecipientNote),
        ],
      ),
    );
  }
}
