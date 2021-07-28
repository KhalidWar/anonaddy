import 'package:animations/animations.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDetailScreen extends ConsumerWidget {
  final isIOS = TargetedPlatform().isIOS();
  final confirmationDialog = ConfirmationDialog();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasDataProvider = watch(aliasStateManagerProvider);
    final aliasDataModel = aliasDataProvider.aliasDataModel;
    final toggleAlias = aliasDataProvider.toggleAlias;
    final isToggleLoading = aliasDataProvider.isToggleLoading;
    final deleteAliasLoading = aliasDataProvider.deleteAliasLoading;
    final deleteOrRestoreAlias = aliasDataProvider.deleteOrRestoreAlias;
    final editDescription = aliasDataProvider.editDescription;
    final sendFromAlias = aliasDataProvider.sendFromAlias;

    final nicheMethod = NicheMethod();
    final showToast = nicheMethod.showToast;
    final copyOnTap = nicheMethod.copyOnTap;

    final customLoading = CustomLoadingIndicator().customLoadingIndicator();
    final textEditingController = TextEditingController();
    final size = MediaQuery.of(context).size;

    final isAliasDeleted = aliasDataModel.deletedAt != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context, aliasDataModel.id, isAliasDeleted),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AliasScreenPieChart(
              emailsForwarded: aliasDataModel.emailsForwarded,
              emailsBlocked: aliasDataModel.emailsBlocked,
              emailsReplied: aliasDataModel.emailsReplied,
              emailsSent: aliasDataModel.emailsSent,
            ),
            Divider(height: size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
              child: Text(
                'Actions',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: size.height * 0.005),
            AliasDetailListTile(
              leadingIconData: Icons.alternate_email,
              title: aliasDataModel.email,
              subtitle: 'Email',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () => copyOnTap(aliasDataModel.email),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.mail_outline,
              title: 'Send email from this alias',
              subtitle: 'Send from',
              trailingIconData: Icons.send,
              trailingIconOnPress: () => buildSendFromDialog(
                  context, sendFromAlias, aliasDataModel.email),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.flaky_outlined,
              title:
                  'Alias is ${aliasDataModel.active ? 'active' : 'inactive'}',
              subtitle: 'Activity',
              trailing: Row(
                children: [
                  isToggleLoading ? customLoading : Container(),
                  Switch.adaptive(
                    value: aliasDataModel.active,
                    onChanged: isAliasDeleted ? null : (toggle) {},
                  ),
                ],
              ),
              trailingIconOnPress: () {
                isAliasDeleted
                    ? showToast(kRestoreBeforeActivate)
                    : toggleAlias(context, aliasDataModel.id);
              },
            ),
            AliasDetailListTile(
              leadingIconData: Icons.comment,
              title: aliasDataModel.description ?? 'No description',
              subtitle: 'Description',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {
                buildEditDescriptionDialog(
                  context,
                  textEditingController,
                  editDescription,
                  aliasDataModel,
                );
              },
            ),
            AliasDetailListTile(
              leadingIconData: Icons.check_circle_outline,
              title: aliasDataModel.extension,
              subtitle: 'extension',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {},
            ),
            AliasDetailListTile(
              leadingIconData: isAliasDeleted
                  ? Icons.restore_outlined
                  : Icons.delete_outline,
              title: '${isAliasDeleted ? 'Restore' : 'Delete'} Alias',
              subtitle:
                  isAliasDeleted ? kRestoreAliasSubtitle : kDeleteAliasSubtitle,
              trailing: Row(
                children: [
                  deleteAliasLoading ? customLoading : Container(),
                  IconButton(
                    icon: isAliasDeleted
                        ? Icon(Icons.restore_outlined, color: Colors.green)
                        : Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: null,
                  ),
                ],
              ),
              trailingIconOnPress: () => buildDeleteOrRestoreAliasDialog(
                  context,
                  isAliasDeleted,
                  deleteOrRestoreAlias,
                  aliasDataModel),
            ),
            if (aliasDataModel.recipients == null)
              Container()
            else
              Column(
                children: [
                  Divider(height: size.height * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Default Recipient${aliasDataModel.recipients!.length >= 2 ? 's' : ''}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => buildUpdateDefaultRecipient(
                              context, aliasDataModel),
                        ),
                      ],
                    ),
                  ),
                  if (aliasDataModel.recipients!.isEmpty)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.01),
                      child: Row(children: [Text(kNoDefaultRecipientSet)]),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: aliasDataModel.recipients!.length,
                      itemBuilder: (context, index) {
                        final recipients = aliasDataModel.recipients;
                        return RecipientListTile(
                          recipientDataModel: recipients![index],
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
                  dateTime: aliasDataModel.createdAt,
                ),
                aliasDataModel.deletedAt == null
                    ? AliasCreatedAtWidget(
                        label: 'Updated:',
                        dateTime: aliasDataModel.updatedAt,
                      )
                    : AliasCreatedAtWidget(
                        label: 'Deleted:',
                        dateTime: aliasDataModel.deletedAt!,
                      ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }

  Future buildUpdateDefaultRecipient(
      BuildContext context, Alias aliasDataModel) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return AliasDefaultRecipientScreen(aliasDataModel);
      },
    );
  }

  Future buildDeleteOrRestoreAliasDialog(BuildContext context, bool isDeleted,
      Function deleteOrRestoreAlias, Alias aliasDataModel) {
    deleteOrRestore() {
      deleteOrRestoreAlias(
        context,
        isDeleted,
        aliasDataModel.id,
      );
    }

    return showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? confirmationDialog.iOSAlertDialog(
                context,
                isDeleted
                    ? kRestoreAliasConfirmation
                    : kDeleteAliasConfirmation,
                deleteOrRestore,
                '${isDeleted ? 'Restore' : 'Delete'} Alias')
            : confirmationDialog.androidAlertDialog(
                context,
                isDeleted
                    ? kRestoreAliasConfirmation
                    : kDeleteAliasConfirmation,
                deleteOrRestore,
                '${isDeleted ? 'Restore' : 'Delete'} Alias');
      },
    );
  }

  Future buildSendFromDialog(
      BuildContext context, Function sendFromAlias, String aliasEmail) {
    final textEditingController = TextEditingController();

    final sendFromFormKey =
        context.read(aliasStateManagerProvider).sendFromFormKey;

    void generateAddress() {
      sendFromAlias(
        context,
        aliasEmail,
        textEditingController.text.trim(),
      );
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
              BottomSheetHeader(headerLabel: kSendFromAlias),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kSendFromAliasString),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      enabled: false,
                      decoration: kTextFormFieldDecoration.copyWith(
                        hintText: aliasEmail,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Email destination',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Form(
                      key: sendFromFormKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingController,
                        validator: (input) =>
                            FormValidator().validateRecipientEmail(input!),
                        onFieldSubmitted: (toggle) => generateAddress(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter email...',
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(kSendFromAliasNote),
                    SizedBox(height: size.height * 0.01),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        child: Text('Generate address'),
                        onPressed: () => generateAddress(),
                      ),
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

  Future buildEditDescriptionDialog(
      BuildContext context,
      TextEditingController _textEditingController,
      Function editDescription,
      Alias aliasDataModel) {
    final formKey = context.read(aliasStateManagerProvider).descriptionFormKey;

    void editDesc() {
      editDescription(
          context, aliasDataModel.id, _textEditingController.text.trim());
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
              BottomSheetHeader(headerLabel: kUpdateDescription),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kUpdateDescriptionString),
                    SizedBox(height: size.height * 0.015),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: _textEditingController,
                        validator: (input) =>
                            FormValidator().validateDescriptionField(input!),
                        onFieldSubmitted: (toggle) => editDesc(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText:
                              aliasDataModel.description ?? 'No description',
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text(kUpdateDescription),
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

  AppBar buildAppBar(BuildContext context, String aliasID, bool isDeleted) {
    final confirmationDialog = ConfirmationDialog();
    final isIOS = TargetedPlatform().isIOS();

    void forget() {
      context.read(aliasStateManagerProvider).forgetAlias(context, aliasID);
      Navigator.pop(context);
    }

    return AppBar(
      title: Text(
        isDeleted ? 'Alias [DELETED]' : 'Alias',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [kForgetAlias].map((String choice) {
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
                        context, kForgetAliasConfirmation, forget, kForgetAlias)
                    : confirmationDialog.androidAlertDialog(context,
                        kForgetAliasConfirmation, forget, kForgetAlias);
              },
            );
          },
        ),
      ],
    );
  }
}
