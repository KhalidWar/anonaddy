import 'package:animations/animations.dart';
import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/recipient/recipient_data_model.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
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
  RecipientDetailedScreen({this.recipientData});
  final RecipientDataModel recipientData;

  int calculateTotal(List<int> list) {
    if (list.isEmpty) {
      return 0;
    } else {
      final total = list.reduce((value, element) => value + element);
      return total;
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recipientStateProvider = watch(recipientStateManagerProvider);
    final isLoading = recipientStateProvider.isLoading;

    final recipientProvider = context.read(recipientStateManagerProvider);
    final toggleEncryption = recipientProvider.toggleEncryption;
    final verifyEmail = recipientProvider.verifyEmail;

    final size = MediaQuery.of(context).size;

    final List<int> forwardedList = [];
    final List<int> blockedList = [];
    final List<int> repliedList = [];
    final List<int> sentList = [];
    if (recipientData.aliases != null) {
      for (AliasDataModel alias in recipientData.aliases) {
        forwardedList.add(alias.emailsForwarded);
        blockedList.add(alias.emailsBlocked);
        repliedList.add(alias.emailsReplied);
        sentList.add(alias.emailsSent);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipientData.aliases == null ||
                recipientData.emailVerifiedAt == null)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 40),
                child: SvgPicture.asset(
                  'assets/images/envelope.svg',
                  height: size.height * 0.22,
                ),
              )
            else
              AliasScreenPieChart(
                emailsForwarded: calculateTotal(forwardedList),
                emailsBlocked: calculateTotal(blockedList),
                emailsReplied: calculateTotal(repliedList),
                emailsSent: calculateTotal(sentList),
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
              trailing: IconButton(icon: Icon(Icons.copy), onPressed: () {}),
              trailingIconOnPress: () =>
                  NicheMethod().copyOnTap(recipientData.email),
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
                      onPressed: () {})
                  : IconButton(
                      icon: Icon(Icons.delete_outline_outlined,
                          color: Colors.red),
                      onPressed: () {}),
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
              trailingIconOnPress: recipientData.fingerprint == null
                  ? null
                  : () => toggleEncryption(context, recipientData.id),
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
              kUnverifiedRecipientNote,
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
                kRemoveRecipientPublicKeyConfirmation,
                removePublicKey,
                'Remove Public Key')
            : confirmationDialog.androidAlertDialog(
                context,
                kRemoveRecipientPublicKeyConfirmation,
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
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final pgpKeyFormKey =
            context.read(recipientStateManagerProvider).pgpKeyFormKey;

        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetHeader(headerLabel: 'Add GPG Key'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Text(kAddPublicKeyNote),
                    SizedBox(height: size.height * 0.015),
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
                          hintText: kPublicKeyFieldHint,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text('Add Key'),
                      onPressed: () => addPublicKey(),
                    ),
                    SizedBox(height: size.height * 0.015),
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
            return ['Delete Recipient'].map((String choice) {
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
                    ? confirmationDialog.iOSAlertDialog(
                        context,
                        kDeleteRecipientConfirmation,
                        remove,
                        'Delete Recipient')
                    : confirmationDialog.androidAlertDialog(
                        context,
                        kDeleteRecipientConfirmation,
                        remove,
                        'Delete Recipient');
              },
            );
          },
        ),
      ],
    );
  }
}
