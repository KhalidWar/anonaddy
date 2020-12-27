import 'package:animations/animations.dart';
import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/state_management/recipient_state_manager.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            subtitle: 'Fingerprint',
            trailing: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () =>
                  buildFingerprintSettingDialog(context, recipientData),
            ),
          ),
          AliasDetailListTile(
            leadingIconData: encryptionSwitch ? Icons.lock : Icons.lock_open,
            title: '${encryptionSwitch ? 'Encrypted' : 'Not encrypted'}',
            subtitle: 'Should Encrypt?',
            trailing: Switch(
              value: encryptionSwitch,
              onChanged: (toggle) {
                recipientData.fingerprint == null
                    ? buildFingerprintSettingDialog(context, recipientData)
                    : toggleEncryption(context, recipientData.id);
              },
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
          Divider(height: 0),
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete),
                SizedBox(width: 10),
                Text(
                  'Delete Recipient',
                ),
              ],
            ),
            onPressed: () {},
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future buildFingerprintSettingDialog(
      BuildContext context, RecipientDataModel recipientData) {
    bool isFingerprintNull() {
      if (recipientData.fingerprint == null)
        return true;
      else
        return false;
    }

    return showModal(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Public GPG Key'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kEnterPublicKeyData),
                TextFormField(
                  minLines: 5,
                  maxLines: 8,
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: kPublicGPGKeyHintText,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          buttonPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          actions: [
            isFingerprintNull()
                ? null
                : RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Delete Current Key',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
            RaisedButton(
              child: Text('${isFingerprintNull() ? 'Add New' : 'Update'} Key'),
              onPressed: () {},
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
