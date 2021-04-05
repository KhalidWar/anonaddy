import 'package:animations/animations.dart';
import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/alias_pie_chart.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/recipient_list_tile.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
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
    final copyOnTap = aliasDataProvider.copyToClipboard;
    final deleteOrRestoreAlias = aliasDataProvider.deleteOrRestoreAlias;
    final editDescription = aliasDataProvider.editDescription;

    final _textEditingController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AliasPieChart(aliasDataModel: aliasDataModel),
            SizedBox(height: size.height * 0.015),
            Divider(),
            AliasDetailListTile(
              leadingIconData: Icons.alternate_email,
              title: aliasDataModel.email,
              subtitle: 'Email',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () => copyOnTap(aliasDataModel.email),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.flaky_outlined,
              title:
                  'Alias is ${aliasDataModel.isAliasActive ? 'active' : 'inactive'}',
              subtitle: 'Activity',
              trailing: Row(
                children: [
                  isToggleLoading
                      ? CustomLoadingIndicator().customLoadingIndicator()
                      : Container(),
                  Switch.adaptive(
                    value: aliasDataModel.isAliasActive,
                    onChanged: (toggle) =>
                        toggleAlias(context, aliasDataModel.aliasID),
                  ),
                ],
              ),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.comment,
              title: aliasDataModel.emailDescription,
              subtitle: 'Description',
              trailingIconData: Icons.edit,
              trailingIconOnPress: () {
                buildEditDescriptionDialog(
                  context,
                  _textEditingController,
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
            aliasDataModel.deletedAt == null
                ? AliasDetailListTile(
                    leadingIconData: Icons.delete_outline,
                    title: 'Delete Alias',
                    subtitle: 'Deleted alias will reject all emails sent to it',
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        buildDeleteAliasDialog(
                          context,
                          deleteOrRestoreAlias,
                          aliasDataModel,
                        );
                      },
                    ),
                  )
                : AliasDetailListTile(
                    leadingIconData: Icons.restore_outlined,
                    title: 'Restore Alias',
                    subtitle: 'Restored alias will be able to receive emails',
                    trailing: IconButton(
                      icon: Icon(Icons.restore_outlined, color: Colors.green),
                      onPressed: () {
                        buildRestoreAliasDialog(
                          context,
                          deleteOrRestoreAlias,
                          aliasDataModel,
                        );
                      },
                    ),
                  ),
            aliasDataModel.recipients == null
                ? Container()
                : Divider(height: 10),
            if (aliasDataModel.recipients == null)
              Container()
            else
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Default recipient${aliasDataModel.recipients.length >= 2 ? 's' : ''}',
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
                  if (aliasDataModel.recipients.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:
                          Row(children: [Text('No default recipient set yet')]),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: aliasDataModel.recipients.length,
                      itemBuilder: (context, index) {
                        final recipients = aliasDataModel.recipients;
                        return RecipientListTile(
                          recipientDataModel: recipients[index],
                        );
                      },
                    ),
                ],
              ),
            Divider(height: 30),
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
                        dateTime: aliasDataModel.deletedAt,
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
      BuildContext context, AliasDataModel aliasDataModel) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: AliasDefaultRecipientScreen(aliasDataModel),
          ),
        );
      },
    );
  }

  //todo combine both delete and restore dialogs
  Future buildDeleteAliasDialog(BuildContext context,
      Function deleteOrRestoreAlias, AliasDataModel aliasDataModel) {
    deleteAlias() {
      deleteOrRestoreAlias(
        context,
        aliasDataModel.deletedAt,
        aliasDataModel.aliasID,
      );
      Navigator.pop(context);
    }

    return showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? confirmationDialog.iOSAlertDialog(
                context, kDeleteAliasConfirmation, deleteAlias, 'Delete Alias')
            : confirmationDialog.androidAlertDialog(
                context, kDeleteAliasConfirmation, deleteAlias, 'Delete Alias');
      },
    );
  }

  Future buildRestoreAliasDialog(BuildContext context,
      Function deleteOrRestoreAlias, AliasDataModel aliasDataModel) {
    restoreAlias() {
      deleteOrRestoreAlias(
        context,
        aliasDataModel.deletedAt,
        aliasDataModel.aliasID,
      );
      Navigator.pop(context);
    }

    return showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? confirmationDialog.iOSAlertDialog(
                context, kRestoreAliasText, restoreAlias, 'Restore Alias')
            : confirmationDialog.androidAlertDialog(
                context, kRestoreAliasText, restoreAlias, 'Restore Alias');
      },
    );
  }

  Future buildEditDescriptionDialog(
      BuildContext context,
      TextEditingController _textEditingController,
      Function editDescription,
      AliasDataModel aliasDataModel) {
    final formKey = context.read(aliasStateManagerProvider).descriptionFormKey;

    void editDesc() {
      editDescription(
          context, aliasDataModel.aliasID, _textEditingController.text.trim());
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
          child: Column(
            children: [
              Divider(
                thickness: 3,
                indent: size.width * 0.4,
                endIndent: size.width * 0.4,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'Update description',
                style: Theme.of(context).textTheme.headline6,
              ),
              Divider(thickness: 1),
              SizedBox(height: size.height * 0.01),
              Text('Update description for'),
              Text(
                '${aliasDataModel.email}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: size.height * 0.02),
              Form(
                key: formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: _textEditingController,
                  validator: (input) =>
                      FormValidator().validateDescriptionField(input),
                  onFieldSubmitted: (toggle) => editDesc(),
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: '${aliasDataModel.emailDescription}',
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: Text('Update description'),
                onPressed: () => editDesc(),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Alias', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
