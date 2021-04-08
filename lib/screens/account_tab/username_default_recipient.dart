import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameDefaultRecipientScreen extends StatefulWidget {
  const UsernameDefaultRecipientScreen(this.username);

  final UsernameDataModel username;

  @override
  _AliasDefaultRecipientScreenState createState() =>
      _AliasDefaultRecipientScreenState();
}

class _AliasDefaultRecipientScreenState
    extends State<UsernameDefaultRecipientScreen> {
  final _verifiedRecipients = <RecipientDataModel>[];
  RecipientDataModel selectedRecipient;

  void _toggleRecipient(RecipientDataModel verifiedRecipient) {
    if (selectedRecipient == null) {
      selectedRecipient = verifiedRecipient;
    } else {
      if (verifiedRecipient.email == selectedRecipient.email) {
        selectedRecipient = null;
      } else {
        selectedRecipient = verifiedRecipient;
      }
    }
  }

  bool _isDefaultRecipient(RecipientDataModel verifiedRecipient) {
    if (selectedRecipient == null) {
      return false;
    } else {
      if (verifiedRecipient.email == selectedRecipient.email) {
        return true;
      }
      return false;
    }
  }

  void _setVerifiedRecipients() {
    final allRecipients = context.read(recipientsProvider).data.value;
    for (RecipientDataModel recipient in allRecipients.recipientDataList) {
      if (recipient.emailVerifiedAt != null) {
        _verifiedRecipients.add(recipient);
      }
    }
  }

  void _setDefaultRecipient() {
    final defaultRecipient = widget.username.defaultRecipient;
    for (RecipientDataModel verifiedRecipient in _verifiedRecipients) {
      if (defaultRecipient == null) {
        selectedRecipient = null;
      } else {
        if (defaultRecipient.email == verifiedRecipient.email) {
          selectedRecipient = verifiedRecipient;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setVerifiedRecipients();
    _setDefaultRecipient();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Divider(
          thickness: 3,
          indent: size.width * 0.4,
          endIndent: size.width * 0.4,
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          'Update Default Recipient',
          style: Theme.of(context).textTheme.headline6,
        ),
        Divider(thickness: 1, height: size.height * 0.03),
        Text(kUpdateUsernameDefaultRecipient),
        Divider(height: size.height * 0.02),
        if (_verifiedRecipients.isEmpty)
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('No recipients found',
                style: Theme.of(context).textTheme.headline6),
          )
        else
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _verifiedRecipients.length,
              itemBuilder: (context, index) {
                final verifiedRecipient = _verifiedRecipients[index];
                return ListTile(
                  selected: _isDefaultRecipient(verifiedRecipient),
                  selectedTileColor: kBlueNavyColor,
                  horizontalTitleGap: 0,
                  title: Text(verifiedRecipient.email),
                  onTap: () {
                    setState(() {
                      _toggleRecipient(verifiedRecipient);
                    });
                  },
                );
              },
            ),
          ),
        SizedBox(height: size.height * 0.02),
        ElevatedButton(
          style: ElevatedButton.styleFrom(),
          child: Text('Update Default Recipients'),
          onPressed: () =>
              context.read(usernameStateManagerProvider).updateDefaultRecipient(
                    context,
                    widget.username.id,
                    selectedRecipient == null ? '' : selectedRecipient.id,
                  ),
        ),
      ],
    );
  }
}
