import 'package:animations/animations.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/shared_components/update_description_widget.dart';
import 'package:anonaddy/state_management/usernames/usernames_screen_notifier.dart';
import 'package:anonaddy/state_management/usernames/usernames_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernamesScreen extends StatefulWidget {
  const UsernamesScreen({required this.username});
  final Username username;

  static const routeName = 'usernameDetailedScreen';

  @override
  State<UsernamesScreen> createState() => _UsernamesScreenState();
}

class _UsernamesScreenState extends State<UsernamesScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read(usernamesScreenStateNotifier.notifier)
        .fetchUsername(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer(
        builder: (context, watch, _) {
          final usernameState = watch(usernamesScreenStateNotifier);

          switch (usernameState.status) {
            case UsernamesScreenStatus.loading:
              return Center(child: PlatformLoadingIndicator());

            case UsernamesScreenStatus.loaded:
              return buildListView(context, usernameState);

            case UsernamesScreenStatus.failed:
              final error = usernameState.errorMessage!;
              return LottieWidget(
                lottie: 'assets/lottie/errorCone.json',
                label: error,
              );
          }
        },
      ),
    );
  }

  ListView buildListView(
      BuildContext context, UsernamesScreenState usernameState) {
    final size = MediaQuery.of(context).size;

    final username = usernameState.username!;
    final usernameStateProvider =
        context.read(usernamesScreenStateNotifier.notifier);

    Future<void> toggleActivity() async {
      username.active
          ? await usernameStateProvider.deactivateUsername(username)
          : await usernameStateProvider.activateUsername(username);
    }

    Future<void> toggleCatchAll() async {
      username.catchAll
          ? await usernameStateProvider.deactivateCatchAll(username)
          : await usernameStateProvider.activateCatchAll(username);
    }

    return ListView(
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
          trailingIconOnPress: () => updateDescriptionDialog(context, username),
        ),
        AliasDetailListTile(
          title:
              username.active ? 'Username is active' : 'Username is inactive',
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Activity',
          leadingIconData: Icons.toggle_on_outlined,
          trailing:
              buildSwitch(usernameState.activeSwitchLoading!, username.active),
          trailingIconOnPress: () => toggleActivity(),
        ),
        AliasDetailListTile(
          title: username.catchAll ? 'Enabled' : 'Disabled',
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Catch All',
          leadingIconData: Icons.repeat,
          trailing: buildSwitch(
              usernameState.catchAllSwitchLoading!, username.catchAll),
          trailingIconOnPress: () => toggleCatchAll(),
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
    );
  }

  Widget buildSwitch(bool switchLoading, switchValue) {
    return Row(
      children: [
        switchLoading ? PlatformLoadingIndicator(size: 20) : Container(),
        PlatformSwitch(
          value: switchValue,
          onChanged: (toggle) {},
        ),
      ],
    );
  }

  Future updateDescriptionDialog(BuildContext context, Username username) {
    final usernameNotifier =
        context.read(usernamesScreenStateNotifier.notifier);
    final formKey = GlobalKey<FormState>();
    String newDescription = '';

    Future<void> updateDescription() async {
      if (formKey.currentState!.validate()) {
        await usernameNotifier.editDescription(username, newDescription);
        Navigator.pop(context);
      }
    }

    Future<void> removeDescription() async {
      await usernameNotifier.editDescription(username, '');
      Navigator.pop(context);
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UpdateDescriptionWidget(
          description: username.description,
          descriptionFormKey: formKey,
          inputOnChanged: (input) => newDescription = input,
          updateDescription: updateDescription,
          removeDescription: removeDescription,
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
    Future<void> deleteUsername() async {
      await context
          .read(usernamesScreenStateNotifier.notifier)
          .deleteUsername(widget.username);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return AppBar(
      title: Text('Additional Username', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(
          PlatformAware.isIOS() ? CupertinoIcons.back : Icons.arrow_back,
        ),
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
                return PlatformAlertDialog(
                  content: kDeleteUsernameConfirmation,
                  method: deleteUsername,
                  title: 'Delete Username',
                );
              },
            );
          },
        ),
      ],
    );
  }
}