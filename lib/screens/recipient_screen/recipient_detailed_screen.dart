import 'package:animations/animations.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class RecipientDetailedScreen extends ConsumerWidget {
  RecipientDetailedScreen({this.recipientData});

  final RecipientDataModel recipientData;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final recipientStateProvider = watch(recipientStateManagerProvider);
    final encryptionSwitch = recipientStateProvider.encryptionSwitch;
    final isLoading = recipientStateProvider.isLoading;
    final copyOnTap = recipientStateProvider.copyOnTap;
    final toggleEncryption = recipientStateProvider.toggleEncryption;
    final addPublicGPGKey = recipientStateProvider.addPublicGPGKey;
    final removePublicGPGKey = recipientStateProvider.removePublicGPGKey;
    final verifyEmail = recipientStateProvider.verifyEmail;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isLoading ? LinearProgressIndicator(minHeight: 6) : Container(),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SvgPicture.asset(
              'assets/images/envelope.svg',
              height: size.height * 0.25,
            ),
          ),
          AliasDetailListTile(
            leadingIconData: Icons.email_outlined,
            title: recipientData.email,
            subtitle: 'Recipient Email',
            trailing: IconButton(
              icon: Icon(Icons.copy),
              onPressed: () => copyOnTap(recipientData.email),
            ),
          ),
          AliasDetailListTile(
            leadingIconData: Icons.fingerprint_outlined,
            title: recipientData.fingerprint == null
                ? 'No fingerprint found'
                : '${recipientData.fingerprint}',
            subtitle: 'GPG Key Fingerprint',
            trailing: recipientData.fingerprint == null
                ? IconButton(
                    icon: Icon(Icons.add_circle_outline_outlined),
                    onPressed: () => buildFingerprintSettingDialog(
                        context, recipientData, addPublicGPGKey),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.red,
                    ),
                    onPressed: () =>
                        buildRemovePGPKeyDialog(context, removePublicGPGKey),
                  ),
          ),
          AliasDetailListTile(
            leadingIconData: encryptionSwitch ? Icons.lock : Icons.lock_open,
            leadingIconColor: encryptionSwitch ? Colors.green : null,
            title: '${encryptionSwitch ? 'Encrypted' : 'Not Encrypted'}',
            subtitle: 'Encryption',
            trailing: recipientData.fingerprint == null
                ? null
                : Switch(
                    value: encryptionSwitch,
                    onChanged: (toggle) =>
                        toggleEncryption(context, recipientData.id),
                  ),
          ),
          AliasDetailListTile(
            leadingIconData: Icons.verified_outlined,
            title: recipientData.emailVerifiedAt == null ? 'No' : 'Yes',
            subtitle: 'Is Email Verified?',
            trailing: recipientData.emailVerifiedAt == null
                ? RaisedButton(
                    child: Text('Verify now!'),
                    onPressed: () => verifyEmail(context, recipientData.id),
                  )
                : null,
          ),
          Divider(height: 0),
          Row(
            children: [
              Expanded(
                child: AliasDetailListTile(
                  leadingIconData: Icons.access_time_outlined,
                  title: recipientData.createdAt,
                  subtitle: 'Created At',
                ),
              ),
              Expanded(
                child: AliasDetailListTile(
                  leadingIconData: Icons.av_timer_outlined,
                  title: recipientData.updatedAt,
                  subtitle: 'Updated at',
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.04),
        ],
      ),
    );
  }

  Future buildRemovePGPKeyDialog(
      BuildContext context, Function removePublicGPGKey) {
    return showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(kRemoveRecipientPublicKey),
          content: Text(kRemoveRecipientPublicKeyBody),
          actions: [
            RaisedButton(
              color: Colors.red,
              child: Text('Remove Public Key'),
              onPressed: () => removePublicGPGKey(context, recipientData.id),
            ),
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future buildFingerprintSettingDialog(BuildContext context,
      RecipientDataModel recipientData, Function addPublicGPGKey) {
    final _texEditingController = TextEditingController();

    return showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Public GPG Key'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Text(kEnterPublicKeyData),
                SizedBox(height: 5),
                Expanded(
                  child: TextFormField(
                    controller: _texEditingController,
                    minLines: 8,
                    maxLines: 8,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: kPublicGPGKeyHintText,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlueNavyColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            RaisedButton(
              child: Text('Add New Key'),
              onPressed: () => addPublicGPGKey(
                  context, recipientData.id, _texEditingController.text),
            ),
          ],
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // brightness: Brightness.dark,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Recipient Details',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
