import 'package:animations/animations.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';

class UsernameDetailedScreen extends ConsumerWidget {
  const UsernameDetailedScreen({required this.username});
  final Username username;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final usernameProvider = watch(usernameStateManagerProvider);
    final activeSwitchLoading = usernameProvider.activeSwitchLoading;
    final catchAllSwitchLoading = usernameProvider.catchAllSwitchLoading;

    final usernameState = context.read(usernameStateManagerProvider);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
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
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(height: size.height * 0.02),
          AliasDetailListTile(
            title: username.description ?? kNoDescription,
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
            subtitle: 'Username description',
            leadingIconData: Icons.comment_outlined,
            trailing:
                IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {}),
            trailingIconOnPress: () => buildEditDescriptionDialog(context),
          ),
          AliasDetailListTile(
            title:
                username.active ? 'Username is active' : 'Username is inactive',
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
            subtitle: 'Activity',
            leadingIconData: Icons.toggle_on_outlined,
            trailing:
                buildSwitch(context, activeSwitchLoading, username.active),
            trailingIconOnPress: () =>
                usernameState.toggleActivity(context, username),
          ),
          AliasDetailListTile(
            title: username.catchAll ? 'Enabled' : 'Disabled',
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
            subtitle: 'Catch All',
            leadingIconData: Icons.repeat,
            trailing:
                buildSwitch(context, catchAllSwitchLoading, username.catchAll),
            trailingIconOnPress: () =>
                usernameState.toggleCatchAll(context, username),
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
                      icon: Icon(Icons.edit_outlined),
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
                  recipient: username.defaultRecipient!,
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
              if (username.aliases!.isEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('No aliases found'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: username.aliases!.length,
                  itemBuilder: (context, index) {
                    return AliasListTile(
                      aliasData: username.aliases![index],
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
    );
  }

  Widget buildSwitch(BuildContext context, bool switchLoading, switchValue) {
    final customLoading =
        context.read(customLoadingIndicator).customLoadingIndicator();
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

  Future buildEditDescriptionDialog(BuildContext context) {
    final usernameState = context.read(usernameStateManagerProvider);
    final formKey = GlobalKey<FormState>();

    String description = '';

    Future<void> editDesc() async {
      if (formKey.currentState!.validate()) {
        await usernameState.editDescription(context, username, description);
      }
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
                      key: formKey,
                      child: TextFormField(
                        autofocus: true,
                        validator: (input) => context
                            .read(formValidator)
                            .validateDescriptionField(input!),
                        onChanged: (input) => description = input,
                        onFieldSubmitted: (toggle) => editDesc(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: username.description ?? kNoDescription,
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

  Future buildUpdateDefaultRecipient(BuildContext context, Username username) {
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

  AppBar buildAppBar(BuildContext context) {
    final isIOS = context.read(targetedPlatform).isIOS();
    final dialog = context.read(confirmationDialog);

    Future<void> deleteUsername() async {
      await context
          .read(usernameStateManagerProvider)
          .deleteUsername(context, username);
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
                    ? dialog.iOSAlertDialog(
                        context,
                        kDeleteUsernameConfirmation,
                        deleteUsername,
                        'Delete Username')
                    : dialog.androidAlertDialog(
                        context,
                        kDeleteUsernameConfirmation,
                        deleteUsername,
                        'Delete Username');
              },
            );
          },
        ),
      ],
    );
  }
}
