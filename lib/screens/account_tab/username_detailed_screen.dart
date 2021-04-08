import 'package:animations/animations.dart';
import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/screens/account_tab/username_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/alias_list_tile.dart';
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

class UsernameDetailedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final usernameProvider = watch(usernameStateManagerProvider);
    final username = usernameProvider.usernameModel;
    final activeSwitchLoading = usernameProvider.activeSwitchLoading;
    final catchAllSwitchLoading = usernameProvider.catchAllSwitchLoading;
    final toggleActiveAlias = usernameProvider.toggleActiveAlias;
    final toggleCatchAllAlias = usernameProvider.toggleCatchAllAlias;

    final customLoading = CustomLoadingIndicator().customLoadingIndicator();
    final textEditingController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(context, username.id),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            Divider(height: size.height * 0.01),
            AliasDetailListTile(
              title: username.description ?? 'No description',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Username description',
              leadingIconData: Icons.comment,
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => buildEditDescriptionDialog(
                    context, textEditingController, username),
              ),
            ),
            AliasDetailListTile(
              title: username.active
                  ? 'Username is active'
                  : 'Username is inactive',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Activity',
              leadingIconData: Icons.toggle_off_outlined,
              trailing: Row(
                children: [
                  activeSwitchLoading ? customLoading : Container(),
                  Switch.adaptive(
                    value: username.active,
                    onChanged: (toggle) =>
                        toggleActiveAlias(context, username.id),
                  ),
                ],
              ),
            ),
            AliasDetailListTile(
              title: username.catchAll ? 'Enabled' : 'Disabled',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Catch All',
              leadingIconData: Icons.repeat,
              trailing: Row(
                children: [
                  catchAllSwitchLoading ? customLoading : Container(),
                  Switch.adaptive(
                    value: username.catchAll,
                    onChanged: (toggle) =>
                        toggleCatchAllAlias(context, username.id),
                  ),
                ],
              ),
            ),
            Divider(height: size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                if (username.defaultRecipient == null)
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('No default recipient found'))
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
                Row(
                  children: [
                    Text(
                      'Associated Aliases',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Container(height: 36),
                  ],
                ),
                if (username.aliases.isEmpty)
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('No aliases found'))
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
                '${username.username}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: size.height * 0.02),
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

  Future buildUpdateDefaultRecipient(
      BuildContext context, UsernameDataModel username) {
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
            child: UsernameDefaultRecipientScreen(username),
          ),
        );
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
            return ['Delete username'].map((String choice) {
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
                        kDeleteUsername, deleteUsername, 'Delete username')
                    : confirmationDialog.androidAlertDialog(context,
                        kDeleteUsername, deleteUsername, 'Delete username');
              },
            );
          },
        ),
      ],
    );
  }
}
