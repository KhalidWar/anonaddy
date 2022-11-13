import 'package:anonaddy/models/username/username.dart';
import 'package:anonaddy/notifiers/usernames/usernames_screen_notifier.dart';
import 'package:anonaddy/notifiers/usernames/usernames_screen_state.dart';
import 'package:anonaddy/screens/account_tab/usernames/username_default_recipient.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/created_at_widget.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/offline_banner.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/shared_components/update_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernamesScreen extends ConsumerStatefulWidget {
  const UsernamesScreen({Key? key, required this.username}) : super(key: key);
  final Username username;

  static const routeName = 'usernameDetailedScreen';

  @override
  ConsumerState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernamesScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(usernamesScreenStateNotifier.notifier)
        .fetchSpecificUsername(widget.username.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer(
        builder: (context, ref, _) {
          final usernameState = ref.watch(usernamesScreenStateNotifier);

          switch (usernameState.status) {
            case UsernamesScreenStatus.loading:
              return const Center(child: PlatformLoadingIndicator());

            case UsernamesScreenStatus.loaded:
              return buildListView(context, usernameState);

            case UsernamesScreenStatus.failed:
              final error = usernameState.errorMessage;
              return LottieWidget(
                lottie: LottieImages.errorCone,
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

    final username = usernameState.username;
    final usernameStateProvider =
        ref.read(usernamesScreenStateNotifier.notifier);

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
      physics: const ClampingScrollPhysics(),
      children: [
        if (usernameState.isOffline) const OfflineBanner(),
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
          title: username.description.isEmpty
              ? AppStrings.noDescription
              : username.description,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Username description',
          leadingIconData: Icons.comment_outlined,
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
          trailingIconOnPress: () => updateDescriptionDialog(context, username),
        ),
        AliasDetailListTile(
          title:
              username.active ? 'Username is active' : 'Username is inactive',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Activity',
          leadingIconData: Icons.toggle_on_outlined,
          trailing:
              buildSwitch(usernameState.activeSwitchLoading, username.active),
          trailingIconOnPress: () => toggleActivity(),
        ),
        AliasDetailListTile(
          title: username.catchAll ? 'Enabled' : 'Disabled',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Catch All',
          leadingIconData: Icons.repeat,
          trailing: buildSwitch(
              usernameState.catchAllSwitchLoading, username.catchAll),
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
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        buildUpdateDefaultRecipient(context, username),
                  ),
                ],
              ),
            ),
            if (username.defaultRecipient == null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('No default recipient found'),
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
            if (username.aliases.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('No aliases found'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: username.aliases.length,
                itemBuilder: (context, index) {
                  return AliasListTile(
                    alias: username.aliases[index],
                  );
                },
              ),
          ],
        ),
        Divider(height: size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CreatedAtWidget(
              label: 'Created at',
              dateTime: username.createdAt.toString(),
            ),
            CreatedAtWidget(
              label: 'Updated at',
              dateTime: username.updatedAt.toString(),
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
        switchLoading ? const PlatformLoadingIndicator(size: 20) : Container(),
        PlatformSwitch(
          value: switchValue,
          onChanged: (toggle) {},
        ),
      ],
    );
  }

  Future updateDescriptionDialog(BuildContext context, Username username) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UpdateDescriptionWidget(
          description: username.description,
          updateDescription: (description) {
            ref
                .read(usernamesScreenStateNotifier.notifier)
                .updateUsernameDescription(username, description);
          },
          removeDescription: () {
            ref
                .read(usernamesScreenStateNotifier.notifier)
                .updateUsernameDescription(username, '');
          },
        );
      },
    );
  }

  Future buildUpdateDefaultRecipient(BuildContext context, Username username) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UsernameDefaultRecipientScreen(username: username);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    void deleteUsername() {
      PlatformAware.platformDialog(
        context: context,
        child: PlatformAlertDialog(
          title: 'Delete Username',
          content: AnonAddyString.deleteUsernameConfirmation,
          method: () async {
            await ref
                .read(usernamesScreenStateNotifier.notifier)
                .deleteUsername(widget.username);

            /// Dismisses this dialog
            if (mounted) Navigator.pop(context);

            /// Dismisses [UsernamesScreen] after deletion
            if (mounted) Navigator.pop(context);
          },
        ),
      );
    }

    return CustomAppBar(
      title: 'Additional Username',
      leadingOnPress: () => Navigator.pop(context),
      showTrailing: true,
      trailingLabel: 'Delete Username',
      trailingOnPress: (choice) => deleteUsername(),
    );
  }
}
