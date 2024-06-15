import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/created_at_widget.dart';
import 'package:anonaddy/common/custom_app_bar.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/common/offline_banner.dart';
import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/common/update_description_widget.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/associated_aliases/presentation/associated_aliases.dart';
import 'package:anonaddy/features/router/app_router.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:anonaddy/features/usernames/presentation/components/alias_detail_list_tile.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_screen_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_screen_state.dart';
import 'package:anonaddy/features/usernames/presentation/username_default_recipient.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'UsernamesScreenRoute')
class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  ConsumerState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(usernamesScreenNotifierProvider(widget.id).notifier)
        .fetchSpecificUsername(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer(
        builder: (context, ref, _) {
          final usernameAsync =
              ref.watch(usernamesScreenNotifierProvider(widget.id));

          return usernameAsync.when(
            data: (usernameState) {
              return buildListView(context, usernameState);
            },
            error: (error, stack) {
              return ErrorMessageWidget(message: error.toString());
            },
            loading: () {
              return const Center(child: PlatformLoadingIndicator());
            },
          );
        },
      ),
    );
  }

  ListView buildListView(
    BuildContext context,
    UsernamesScreenState usernameState,
  ) {
    final size = MediaQuery.of(context).size;

    final username = usernameState.username;
    final usernameStateProvider =
        ref.read(usernamesScreenNotifierProvider(widget.id).notifier);

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
        const OfflineBanner(),
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
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(height: 24),
        AliasDetailListTile(
          title: username.description == null
              ? AppStrings.noDescription
              : username.description!,
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
        const Divider(height: 24),
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
                    style: Theme.of(context).textTheme.titleLarge,
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
                onPress: () {
                  context.router.push(RecipientsScreenRoute(
                    id: username.defaultRecipient!.id,
                  ));
                },
              ),
          ],
        ),
        const Divider(height: 24),
        AssociatedAliases(
          aliasesCount: username.aliasesCount,
          params: {'username': username.id},
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CreatedAtWidget(
              label: 'Created at',
              dateTime: username.createdAt,
            ),
            CreatedAtWidget(
              label: 'Updated at',
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
        switchLoading ? const PlatformLoadingIndicator(size: 20) : Container(),
        PlatformSwitch(
          value: switchValue,
          onChanged: (toggle) {},
        ),
      ],
    );
  }

  Future updateDescriptionDialog(
    BuildContext context,
    Username username,
  ) async {
    await WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) {
        return [
          Utilities.buildWoltModalSheetSubPage(
            context,
            topBarTitle: AppStrings.updateDescriptionTitle,
            child: UpdateDescriptionWidget(
              description: username.description,
              updateDescription: (description) {
                ref
                    .read(usernamesScreenNotifierProvider(widget.id).notifier)
                    .updateUsernameDescription(username, description);
              },
              removeDescription: () {
                ref
                    .read(usernamesScreenNotifierProvider(widget.id).notifier)
                    .updateUsernameDescription(username, '');
              },
            ),
          ),
        ];
      },
    );
  }

  Future buildUpdateDefaultRecipient(
    BuildContext context,
    Username username,
  ) async {
    await WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) {
        return [
          Utilities.buildWoltModalSheetSubPage(
            context,
            topBarTitle: 'Update Default Recipient',
            pageTitle: AddyString.updateUsernameDefaultRecipient,
            child: UsernameDefaultRecipientScreen(username: username),
          ),
        ];
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    void deleteUsername() {
      PlatformAware.platformDialog(
        context: context,
        child: PlatformAlertDialog(
          title: 'Delete Username',
          content: AddyString.deleteUsernameConfirmation,
          method: () async {
            await ref
                .read(usernamesScreenNotifierProvider(widget.id).notifier)
                .deleteUsername(widget.id);

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
