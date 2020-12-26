import 'package:animations/animations.dart';
import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class RecipientDetailedScreen extends ConsumerWidget {
  RecipientDetailedScreen({this.recipientData});

  final RecipientDataModel recipientData;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            height: size.height * 0.2,
            alignment: Alignment.center,
            child: Icon(
              Icons.account_circle_outlined,
              size: size.height * 0.14,
            ),
          ),
          AliasDetailListTile(
            leadingIconData: Icons.flaky_outlined,
            title: recipientData.email,
            subtitle: 'Recipient Email',
            trailing: IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {},
            ),
          ),
          AliasDetailListTile(
            leadingIconData: Icons.access_time_outlined,
            title: recipientData.fingerprint == null
                ? 'No fingerprint found'
                : '${recipientData.fingerprint}',
            subtitle: 'Fingerprint',
            trailing: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
              // onPressed: () =>
              //     buildFingerprintSettingDialog(context, recipientData),
            ),
          ),
          AliasDetailListTile(
            leadingIconData:
                recipientData.shouldEncrypt ? Icons.lock : Icons.lock_open,
            title:
                '${recipientData.shouldEncrypt ? 'Encrypted' : 'Not encrypted'}',
            subtitle: 'Should Encrypt?',
            trailing: Switch(
              value: recipientData.shouldEncrypt,
              onChanged: (toggle) {},
              // onChanged: (toggle) {
              //   recipientData.fingerprint == null
              //       ? buildFingerprintSettingDialog(context, recipientData)
              //       : toggleEncryption();
              //       : Container();
              // },
            ),
          ),
          AliasDetailListTile(
            leadingIconData: Icons.access_time_outlined,
            title: recipientData.emailVerifiedAt == null ? 'No' : 'Yes',
            subtitle: 'Is Email Verified?',
            trailing: recipientData.emailVerifiedAt == null
                ? RaisedButton(
                    child: Text('Verify now!'),
                    onPressed: () {
                      //todo verify email
                    },
                  )
                : null,
          ),
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
                  leadingIconData: Icons.auto_delete_outlined,
                  title: recipientData.updatedAt,
                  subtitle: 'Updated at',
                ),
              )
            ],
          ),
          Divider(),
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // color: isAliasDeleted(aliasDataModel.deletedAt=true)
            //     ? Colors.green
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
          title: Text('PGP Key Management'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                minLines: 3,
                maxLines: 5,
                decoration: kTextFormFieldDecoration.copyWith(
                  hintText: kPublicGPGKeyHintText,
                ),
              ),
            ],
          ),
          actions: [
            isFingerprintNull()
                ? null
                : RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Delete GPG Key',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
            RaisedButton(
              child: Text('${isFingerprintNull() ? 'Add' : 'Update'} GPG Key'),
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
