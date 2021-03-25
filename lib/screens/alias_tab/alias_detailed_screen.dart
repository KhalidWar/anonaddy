import 'package:animations/animations.dart';
import 'package:anonaddy/constants.dart';
import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_default_recipient.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:anonaddy/widgets/alias_created_at_widget.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/alias_pie_chart.dart';
import 'package:anonaddy/widgets/custom_app_bar.dart';
import 'package:anonaddy/widgets/custom_loading_indicator.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
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
    final switchValue = aliasDataProvider.switchValue;
    final toggleAlias = aliasDataProvider.toggleAlias;
    final isToggleLoading = aliasDataProvider.isToggleLoading;
    final copyOnTap = aliasDataProvider.copyToClipboard;
    final deleteOrRestoreAlias = aliasDataProvider.deleteOrRestoreAlias;
    final editDescription = aliasDataProvider.editDescription;

    final _textEditingController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AliasPieChart(aliasDataModel: aliasDataModel),
            Divider(height: 20),
            AliasCreatedAtWidget(
              label: 'Created at:',
              dateTime: aliasDataModel.createdAt,
              iconData: Icons.access_time_outlined,
            ),
            SizedBox(height: 6),
            aliasDataModel.deletedAt == null
                ? AliasCreatedAtWidget(
                    label: 'Updated at:',
                    dateTime: aliasDataModel.updatedAt,
                    iconData: Icons.av_timer_outlined,
                  )
                : AliasCreatedAtWidget(
                    label: 'Deleted at:',
                    dateTime: aliasDataModel.deletedAt,
                    iconData: Icons.auto_delete_outlined,
                  ),
            Divider(height: 10),
            AliasDetailListTile(
              leadingIconData: Icons.alternate_email,
              title: aliasDataModel.email,
              subtitle: 'Email',
              trailingIconData: Icons.copy,
              trailingIconOnPress: () => copyOnTap(aliasDataModel.email),
            ),
            AliasDetailListTile(
              leadingIconData: Icons.flaky_outlined,
              title: 'Alias is ${switchValue ? 'active' : 'inactive'}',
              subtitle: 'Activity',
              trailing: Row(
                children: [
                  isToggleLoading
                      ? CustomLoadingIndicator().customLoadingIndicator()
                      : Container(),
                  Switch.adaptive(
                    value: switchValue,
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
            Divider(height: 0),
            if (aliasDataModel.recipients == null)
              Container()
            else
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Default recipient${aliasDataModel.recipients.length >= 2 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodyText1,
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
                      child: Row(children: [Text('No recipients found')]),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
              RaisedButton(
                child: Text('Update'),
                onPressed: () => editDesc(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    final customAppBar = CustomAppBar();

    return customAppBar.androidAppBar(context, 'Alias');

    //todo fix CupertinoNavigationBar causing build failure
    // return isIOS
    //     ? customAppBar.iOSAppBar(context, 'Alias')
    //     : customAppBar.androidAppBar(context, 'Alias');
  }
}
