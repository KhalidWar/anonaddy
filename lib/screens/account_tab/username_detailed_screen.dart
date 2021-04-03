import 'package:animations/animations.dart';
import 'package:anonaddy/models/username/username_data_model.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/utilities/confirmation_dialog.dart';
import 'package:anonaddy/utilities/form_validator.dart';
import 'package:anonaddy/utilities/target_platform.dart';
import 'package:anonaddy/widgets/alias_created_at_widget.dart';
import 'package:anonaddy/widgets/alias_detail_list_tile.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/custom_loading_indicator.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class UsernameDetailedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final usernameProvider = watch(usernameStateManagerProvider);
    final username = usernameProvider.usernameModel;
    final activeSwitch = usernameProvider.activeSwitchValue;
    final activeSwitchLoading = usernameProvider.activeSwitchLoading;
    final catchAllSwitch = usernameProvider.catchAllSwitchValue;
    final catchAllSwitchLoading = usernameProvider.catchAllSwitchLoading;
    final toggleActiveAlias = usernameProvider.toggleActiveAlias;
    final toggleCatchAllAlias = usernameProvider.toggleCatchAllAlias;

    final customLoading = CustomLoadingIndicator().customLoadingIndicator();
    final textEditingController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(context, username.id),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.03),
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
            Divider(height: size.height * 0.01),
            AliasDetailListTile(
              title:
                  activeSwitch ? 'Username is active' : 'Username is inactive',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Activity',
              leadingIconData: Icons.toggle_off_outlined,
              trailing: Row(
                children: [
                  activeSwitchLoading ? customLoading : Container(),
                  Switch.adaptive(
                    value: activeSwitch,
                    onChanged: (toggle) =>
                        toggleActiveAlias(context, username.id),
                  ),
                ],
              ),
            ),
            AliasDetailListTile(
              title: catchAllSwitch ? 'Enabled' : 'Disabled',
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: 'Catch All',
              leadingIconData: Icons.repeat,
              trailing: Row(
                children: [
                  catchAllSwitchLoading ? customLoading : Container(),
                  Switch.adaptive(
                    value: catchAllSwitch,
                    onChanged: (toggle) =>
                        toggleCatchAllAlias(context, username.id),
                  ),
                ],
              ),
            ),
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
            Divider(height: 0),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'Default Recipient',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              children: [
                if (username.defaultRecipient == null)
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text('No default recipient found'),
                  )
                else
                  RecipientListTile(
                    recipientDataModel: username.defaultRecipient,
                  ),
              ],
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text('Associated Aliases',
                  style: Theme.of(context).textTheme.bodyText1),
              children: [
                username.aliases.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: Text('No aliases found'))
                    : ListView.builder(
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
            SizedBox(height: size.height * 0.02),
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
              RaisedButton(
                child: Text('Update description'),
                onPressed: () => editDesc(),
              ),
            ],
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
