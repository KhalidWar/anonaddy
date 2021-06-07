import 'package:animations/animations.dart';
import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/screens/account_tab/username_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/alias_list_tile.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_loading_indicator.dart';
import 'package:anonaddy/shared_components/recipient_list_tile.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameDetailedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final usernameProvider = watch(usernameStateManagerProvider);
    final username = usernameProvider.usernameModel;
    final activeSwitchLoading = usernameProvider.activeSwitchLoading;
    final catchAllSwitchLoading = usernameProvider.catchAllSwitchLoading;
    final toggleActiveAlias = usernameProvider.toggleActiveAlias;
    final toggleCatchAllAlias = usernameProvider.toggleCatchAllAlias;

    final textEditingController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(context, username.id),
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
                    username.username,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(height: size.height * 0.02),
            AliasDetailListTile(
              title: username.description ?? 'No description',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Username description',
              leadingIconData: Icons.comment,
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              trailingIconOnPress: () => buildEditDescriptionDialog(
                  context, textEditingController, username),
            ),
            AliasDetailListTile(
              title: username.active
                  ? 'Username is active'
                  : 'Username is inactive',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Activity',
              leadingIconData: Icons.toggle_off_outlined,
              trailing: buildSwitch(activeSwitchLoading, username.active),
              trailingIconOnPress: () =>
                  toggleActiveAlias(context, username.id),
            ),
            AliasDetailListTile(
              title: username.catchAll ? 'Enabled' : 'Disabled',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Catch All',
              leadingIconData: Icons.repeat,
              trailing: buildSwitch(catchAllSwitchLoading, username.catchAll),
              trailingIconOnPress: () =>
                  toggleCatchAllAlias(context, username.id),
            ),
            Divider(height: size.height * 0.02),
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
                            buildUpdateDefaultRecipient(context, username),
                      ),
                    ],
                  ),
                ),
                if (username.defaultRecipient == null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('No default recipient found'),
                  )
                else
                  RecipientListTile(
                    recipientDataModel: username.defaultRecipient,
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
                if (username.aliases.isEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('No aliases found'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: username.aliases.length,
                    itemBuilder: (context, index) {
                      return AliasListTile(
                        aliasData: username.aliases[index],
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
                  dateTime: username.createdAt,
                ),
                AliasCreatedAtWidget(
                  label: 'Updated:',
                  dateTime: username.updatedAt,
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
      TextEditingController textEditingController, UsernameDataModel username) {
    void editDesc() {
      context.read(usernameStateManagerProvider).editDescription(
          context, username.id, textEditingController.text.trim());
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
                          .read(usernameStateManagerProvider)
                          .editDescriptionFormKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: textEditingController,
                        validator: (input) =>
                            FormValidator().validateDescriptionField(input),
                        onFieldSubmitted: (toggle) => editDesc(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: '${username.description}',
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

  Future buildUpdateDefaultRecipient(
      BuildContext context, UsernameDataModel username) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UsernameDefaultRecipientScreen(username);
      },
    );
  }

  Widget buildAppBar(BuildContext context, String usernameID) {
    final isIOS = TargetedPlatform().isIOS();
    final confirmationDialog = ConfirmationDialog();

    void deleteUsername() {
      context
          .read(usernameStateManagerProvider)
          .deleteUsername(context, usernameID);
    }

    return AppBar(
      title: Text('Additional Username', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return ['Delete Username'].map((String choice) {
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
                        kDeleteUsername, deleteUsername, 'Delete Username')
                    : confirmationDialog.androidAlertDialog(context,
                        kDeleteUsername, deleteUsername, 'Delete Username');
              },
            );
          },
        ),
      ],
    );
  }
}
