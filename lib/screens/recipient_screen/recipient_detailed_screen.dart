import 'package:animations/animations.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/alias_list_tile.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class RecipientDetailedScreen extends ConsumerWidget {
  const RecipientDetailedScreen({this.recipientData});
  final RecipientDataModel recipientData;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recipientStateProvider = watch(recipientStateManagerProvider);
    final isLoading = recipientStateProvider.isLoading;

    final recipientProvider = context.read(recipientStateManagerProvider);
    final toggleEncryption = recipientProvider.toggleEncryption;
    final verifyEmail = recipientProvider.verifyEmail;

    final copyOnTap = NicheMethod().copyOnTap;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 50),
                child: SvgPicture.asset(
                  'assets/images/envelope.svg',
                  height: size.height * 0.2,
                ),
              ),
            ),
            Divider(height: size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
              child:
                  Text('Actions', style: Theme.of(context).textTheme.headline6),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.email_outlined,
              title: recipientData.email,
              subtitle: 'Recipient Email',
              trailing: IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => copyOnTap(recipientData.email),
              ),
              trailingIconOnPress: () => copyOnTap(recipientData.email),
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
                      onPressed: () =>
                          buildAddPGPKeyDialog(context, recipientData),
                    )
                  : IconButton(
                      icon: Icon(Icons.delete_outline_outlined,
                          color: Colors.red),
                      onPressed: () => buildRemovePGPKeyDialog(context),
                    ),
              trailingIconOnPress: recipientData.fingerprint == null
                  ? () => buildAddPGPKeyDialog(context, recipientData)
                  : () => buildRemovePGPKeyDialog(context),
            ),
            AliasDetailListTile(
              leadingIconData:
                  recipientData.shouldEncrypt ? Icons.lock : Icons.lock_open,
              leadingIconColor:
                  recipientData.shouldEncrypt ? Colors.green : null,
              title:
                  '${recipientData.shouldEncrypt ? 'Encrypted' : 'Not Encrypted'}',
              subtitle: 'Encryption',
              trailing: recipientData.fingerprint == null
                  ? Container()
                  : buildSwitch(isLoading),
              trailingIconOnPress: () =>
                  toggleEncryption(context, recipientData.id),
            ),
            recipientData.emailVerifiedAt == null
                ? AliasDetailListTile(
                    leadingIconData: Icons.verified_outlined,
                    title: recipientData.emailVerifiedAt == null ? 'No' : 'Yes',
                    subtitle: 'Is Email Verified?',
                    trailing: TextButton(
                        child: Text('Verify now!'), onPressed: () {}),
                    trailingIconOnPress: () =>
                        verifyEmail(context, recipientData.id),
                  )
                : Container(),
            if (recipientData.aliases == null)
              Container()
            else if (recipientData.emailVerifiedAt == null)
              buildUnverifiedEmailWarning(size)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: size.height * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.01),
                    child: Text('Aliases',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  SizedBox(height: size.height * 0.01),
                  if (recipientData.aliases.isEmpty)
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.01),
                        child: Text('No aliases found'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recipientData.aliases.length,
                      itemBuilder: (context, index) {
                        return AliasListTile(
                          aliasData: recipientData.aliases[index],
                        );
                      },
                    ),
                ],
              ),
            Divider(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AliasCreatedAtWidget(
                  label: 'Created:',
                  dateTime: recipientData.createdAt,
                ),
                AliasCreatedAtWidget(
                  label: 'Updated:',
                  dateTime: recipientData.updatedAt,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }

  Row buildSwitch(bool isLoading) {
    return Row(
      children: [
        isLoading
            ? CustomLoadingIndicator().customLoadingIndicator()
            : Container(),
        Switch.adaptive(
          value: recipientData.shouldEncrypt,
          onChanged: (toggle) {},
        ),
      ],
    );
  }

  Container buildUnverifiedEmailWarning(Size size) {
    return Container(
      height: size.height * 0.05,
      width: double.infinity,
      color: Colors.amber,
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: Colors.black),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              kUnverifiedRecipient,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(),
        ],
      ),
    );
  }

  Future buildRemovePGPKeyDialog(BuildContext context) {
    final confirmationDialog = ConfirmationDialog();
    final isIOS = TargetedPlatform().isIOS();

    void removePublicKey() {
      context
          .read(recipientStateManagerProvider)
          .removePublicGPGKey(context, recipientData.id);
    }

    return showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? confirmationDialog.iOSAlertDialog(
                context,
                kRemoveRecipientPublicKeyBody,
                removePublicKey,
                'Remove Public Key')
            : confirmationDialog.androidAlertDialog(
                context,
                kRemoveRecipientPublicKeyBody,
                removePublicKey,
                'Remove Public Key');
      },
    );
  }

  Future buildAddPGPKeyDialog(
      BuildContext context, RecipientDataModel recipientData) {
    final _texEditingController = TextEditingController();

    void addPublicKey() {
      context.read(recipientStateManagerProvider).addPublicGPGKey(
          context, recipientData.id, _texEditingController.text);
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final pgpKeyFormKey =
            context.read(recipientStateManagerProvider).pgpKeyFormKey;

        return SingleChildScrollView(
          child: Column(
            children: [
              BottomSheetHeader(headerLabel: 'Add GPG Key'),
              Container(
                height: size.height * 0.25,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kEnterPublicKeyData),
                    Form(
                      key: pgpKeyFormKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: _texEditingController,
                        validator: (input) =>
                            FormValidator().validatePGPKeyField(input),
                        minLines: 4,
                        maxLines: 5,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (submit) => addPublicKey(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          contentPadding: EdgeInsets.all(5),
                          hintText: kPublicGPGKeyHintText,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text('Add Key'),
                      onPressed: () => addPublicKey(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    final confirmationDialog = ConfirmationDialog();
    final isIOS = TargetedPlatform().isIOS();

    void remove() {
      context
          .read(recipientStateManagerProvider)
          .removeRecipient(context, recipientData.id);
      Navigator.pop(context);
    }

    return AppBar(
      title: Text('Recipient', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return ['Delete recipient'].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: (String choice) {
            showModal(
              context: context,
              builder: (context) {
                return isIOS
                    ? confirmationDialog.iOSAlertDialog(context,
                        kDeleteRecipientDialogText, remove, 'Delete recipient')
                    : confirmationDialog.androidAlertDialog(context,
                        kDeleteRecipientDialogText, remove, 'Delete recipient');
              },
            );
          },
        ),
      ],
    );
  }
}
