import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/screens/settings_tab/more_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../constants.dart';

class UpdateAliasRecipient extends StatefulWidget {
  const UpdateAliasRecipient({Key key, this.aliasDataModel}) : super(key: key);

  final AliasDataModel aliasDataModel;

  @override
  _UpdateAliasRecipientState createState() => _UpdateAliasRecipientState();
}

class _UpdateAliasRecipientState extends State<UpdateAliasRecipient> {
  final verifiedRecipients = <RecipientDataModel>[];
  final selectedRecipientsID = <String>[];

  // todo fix selection issue
  bool checkBoxValue;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final allRecipients = context.read(recipientStreamProvider).data.value;
    final aliasRecipients = widget.aliasDataModel.recipients;

    for (RecipientDataModel recipient in allRecipients.recipientDataList) {
      if (recipient.emailVerifiedAt != null) verifiedRecipients.add(recipient);
    }

    bool isDefaultRecipient(String verifiedRecipientEmail) {
      for (RecipientDataModel aliasRecipient in aliasRecipients) {
        if (aliasRecipient.email == verifiedRecipientEmail) {
          selectedRecipientsID.add(aliasRecipient.id);
          return true;
        }
      }
      return false;
    }

    isDefault(String input) {
      if (widget.aliasDataModel.email == input) {
        return true;
      }
      return false;
    }

    editRecipient() {
      // editAliasRecipient(context, aliasDataModel.aliasID, selectedRecipientsID);
    }

    return Column(
      children: [
        Divider(
          thickness: 3,
          indent: size.width * 0.4,
          endIndent: size.width * 0.4,
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          ' Update Alias Recipients',
          style: Theme.of(context).textTheme.headline6,
        ),
        Divider(thickness: 1),
        SizedBox(height: size.height * 0.01),
        Text(kUpdateAliasRecipients),
        SizedBox(height: size.height * 0.01),
        if (verifiedRecipients.isEmpty)
          Text('No recipients found')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: verifiedRecipients.length,
            itemBuilder: (context, index) {
              checkBoxValue =
                  isDefaultRecipient(verifiedRecipients[index].email);

              return ListTile(
                horizontalTitleGap: 0,
                tileColor: checkBoxValue ??
                        isDefaultRecipient(verifiedRecipients[index].email)
                    ? Colors.green
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(verifiedRecipients[index].email),
                onTap: () {
                  setState(() {
                    // checkBoxValue =
                    //     isDefaultRecipient(verifiedRecipients[index].email);
                    checkBoxValue = !checkBoxValue;
                    print(checkBoxValue);
                  });
                },
              );
            },
          ),
        RaisedButton(
          child: Text('Update'),
          onPressed: () => editRecipient(),
        ),
      ],
    );
  }
}
