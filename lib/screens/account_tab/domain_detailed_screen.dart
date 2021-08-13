import 'package:animations/animations.dart';
import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/screens/account_tab/domain_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainDetailedScreen extends ConsumerWidget {
  DomainDetailedScreen({Key? key, required this.domain}) : super(key: key);
  final Domain domain;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final domainProvider = watch(domainStateManagerProvider);
    final domain = domainProvider.domain;

    final activeSwitchLoading = domainProvider.activeSwitchLoading;
    final catchAllSwitchLoading = domainProvider.catchAllSwitchLoading;
    final toggleActivity = domainProvider.toggleActivity;
    final toggleCatchAll = domainProvider.toggleCatchAll;

    final size = MediaQuery.of(context).size;
    final textEditingController = TextEditingController();

    return Scaffold(
      appBar: buildAppBar(context, domain.id),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(size.height * 0.01),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: size.height * 0.035,
                  ),
                  SizedBox(width: size.width * 0.02),
                  Text(
                    domain.domain,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(height: size.height * 0.02),
            AliasDetailListTile(
              title: domain.description ?? kNoDescription,
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Domain description',
              leadingIconData: Icons.comment,
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              trailingIconOnPress: () => buildEditDescriptionDialog(
                  context, textEditingController, domain),
            ),
            AliasDetailListTile(
              title: domain.active ? 'Domain is active' : 'Domain is inactive',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Activity',
              leadingIconData: Icons.toggle_off_outlined,
              trailing: buildSwitch(activeSwitchLoading, domain.active),
              trailingIconOnPress: () => toggleActivity(context, domain.id),
            ),
            AliasDetailListTile(
              title: domain.catchAll ? 'Enabled' : 'Disabled',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Catch All',
              leadingIconData: Icons.repeat,
              trailing: buildSwitch(catchAllSwitchLoading, domain.catchAll),
              trailingIconOnPress: () => toggleCatchAll(context, domain.id),
            ),
            if (domain.domainVerifiedAt == null)
              buildUnverifiedEmailWarning(size, kUnverifiedDomainWarning),
            // Divider(height: size.height * 0.02),
            if (domain.domainMxValidatedAt == null)
              buildUnverifiedEmailWarning(size, kInvalidDomainMXWarning),
            Divider(height: size.height * 0.02),
            // if (domain.domainSendingVerifiedAt == null)
            //   buildUnverifiedEmailWarning(size, kUnverifiedDomainNote),
            // Divider(height: size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Default Recipient',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            buildUpdateDefaultRecipient(context, domain),
                      ),
                    ],
                  ),
                ),
                if (domain.defaultRecipient == null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('No default recipient found'),
                  )
                else
                  RecipientListTile(
                    recipientDataModel: domain.defaultRecipient!,
                  ),
              ],
            ),
            Divider(height: size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  child: Row(
                    children: [
                      Text(
                        'Associated Aliases',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Container(height: 36),
                    ],
                  ),
                ),
                if (domain.aliases!.isEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('No aliases found'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: domain.aliases!.length,
                    itemBuilder: (context, index) {
                      return AliasListTile(
                        aliasData: domain.aliases![index],
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
                  dateTime: domain.createdAt,
                ),
                AliasCreatedAtWidget(
                  label: 'Updated:',
                  dateTime: domain.updatedAt,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch(bool switchLoading, bool switchValue) {
    final customLoading = CustomLoadingIndicator().customLoadingIndicator();
    return Row(
      children: [
        switchLoading ? customLoading : Container(),
        Switch.adaptive(
          value: switchValue,
          onChanged: (toggle) {},
        ),
      ],
    );
  }

  Future buildEditDescriptionDialog(BuildContext context,
      TextEditingController textEditingController, Domain domain) {
    void editDesc() {
      context.read(domainStateManagerProvider).editDescription(
          context, domain.id, textEditingController.text.trim());
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

        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetHeader(headerLabel: 'Update Description'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kUpdateDescriptionString),
                    SizedBox(height: size.height * 0.015),
                    Form(
                      key: context
                          .read(domainStateManagerProvider)
                          .descriptionFormKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingController,
                        validator: (input) =>
                            FormValidator().validateDescriptionField(input!),
                        onFieldSubmitted: (toggle) => editDesc(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: domain.description ?? kNoDescription,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text('Update Description'),
                      onPressed: () => editDesc(),
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

  Future buildUpdateDefaultRecipient(BuildContext context, Domain domain) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBottomSheetBorderRadius),
        ),
      ),
      builder: (context) {
        return DomainDefaultRecipient(domain);
      },
    );
  }

  AppBar buildAppBar(BuildContext context, String domainID) {
    final isIOS = TargetedPlatform().isIOS();
    final confirmationDialog = ConfirmationDialog();

    Future<void> deleteDomain() async {
      await context
          .read(domainStateManagerProvider)
          .deleteDomain(context, domainID);
    }

    return AppBar(
      title: Text('Domain', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return ['Delete Domain'].map((String choice) {
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
                        kDeleteDomainConfirmation,
                        deleteDomain,
                        'Delete Domain')
                    : confirmationDialog.androidAlertDialog(
                        context,
                        kDeleteDomainConfirmation,
                        deleteDomain,
                        'Delete Domain');
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildUnverifiedEmailWarning(Size size, String label) {
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
              label,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
