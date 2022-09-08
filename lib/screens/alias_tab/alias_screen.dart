import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_state.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_screen_list_tile.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_screen_recipients.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/screens/alias_tab/components/send_from_widget.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/shared_components/shared_components_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasScreen extends ConsumerStatefulWidget {
  const AliasScreen({Key? key, required this.alias}) : super(key: key);
  final Alias alias;

  static const routeName = 'aliasDetailedScreen';

  @override
  ConsumerState createState() => _AliasScreenState();
}

class _AliasScreenState extends ConsumerState<AliasScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetches latest data for this specific alias
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(aliasScreenStateNotifier.notifier)
          .fetchSpecificAlias(widget.alias);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: AliasTabWidgetKeys.aliasScreenScaffold,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        key: AliasTabWidgetKeys.aliasScreenAppBar,
        title: 'Alias',
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: true,
        trailingLabel: 'Forget Alias',
        trailingOnPress: (choice) {
          PlatformAware.platformDialog(
            context: context,
            child: PlatformAlertDialog(
              title: AppStrings.forgetAlias,
              content: AnonAddyString.forgetAliasConfirmation,
              method: () async {
                await ref.read(aliasScreenStateNotifier.notifier).forgetAlias();

                /// Dismisses [platformDialog]
                if (mounted) Navigator.pop(context);

                /// Dismisses [AliasScreen] after forgetting [alias]
                if (mounted) Navigator.pop(context);
              },
            ),
          );
        },
      ),
      body: Consumer(
        builder: (context, watch, _) {
          final aliasState = ref.watch(aliasScreenStateNotifier);
          final isAliasDeleted = aliasState.alias.deletedAt.isNotEmpty;

          switch (aliasState.status) {
            case AliasScreenStatus.loading:
              return ListView(
                children: const [
                  AliasScreenPieChart(
                    emailsForwarded: 0,
                    emailsBlocked: 0,
                    emailsReplied: 0,
                    emailsSent: 0,
                  ),
                  Divider(height: 20),
                  Center(
                    child: PlatformLoadingIndicator(
                      key: AliasTabWidgetKeys.aliasScreenLoadingIndicator,
                    ),
                  ),
                ],
              );

            case AliasScreenStatus.loaded:
              return ListView(
                key: AliasTabWidgetKeys.aliasScreenBodyListView,
                physics: const ClampingScrollPhysics(),
                children: [
                  if (aliasState.isOffline) const OfflineBanner(),
                  AliasScreenPieChart(
                    emailsForwarded: aliasState.alias.emailsForwarded,
                    emailsBlocked: aliasState.alias.emailsBlocked,
                    emailsReplied: aliasState.alias.emailsReplied,
                    emailsSent: aliasState.alias.emailsSent,
                  ),
                  const Divider(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      AppStrings.actions,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AliasScreenListTile(
                    leadingIconData: Icons.alternate_email,
                    title: aliasState.alias.email,
                    subtitle: 'Email',
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () =>
                          Utilities.copyOnTap(aliasState.alias.email),
                    ),
                  ),
                  AliasScreenListTile(
                    leadingIconData: Icons.mail_outline,
                    title: 'Send email from this alias',
                    subtitle: 'Send from',
                    trailing: IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                AppTheme.kBottomSheetBorderRadius,
                              ),
                            ),
                          ),
                          builder: (context) => const SendFromWidget(),
                        );
                      },
                    ),
                  ),
                  AliasScreenListTile(
                    leadingIconData: Icons.toggle_on_outlined,
                    title:
                        'Alias is ${aliasState.alias.active ? 'active' : 'inactive'}',
                    subtitle: 'Activity',
                    trailing: Row(
                      children: [
                        if (aliasState.isToggleLoading)
                          const PlatformLoadingIndicator(size: 20),
                        PlatformSwitch(
                          value: aliasState.alias.active,
                          onChanged: (toggle) async {
                            isAliasDeleted
                                ? Utilities.showToast(
                                    AnonAddyString.restoreBeforeActivate)
                                : aliasState.alias.active
                                    ? await ref
                                        .read(aliasScreenStateNotifier.notifier)
                                        .deactivateAlias()
                                    : await ref
                                        .read(aliasScreenStateNotifier.notifier)
                                        .activateAlias();
                          },
                        ),
                      ],
                    ),
                  ),
                  AliasScreenListTile(
                    leadingIconData: Icons.comment_outlined,
                    title: aliasState.alias.description.isEmpty
                        ? AppStrings.noDescription
                        : aliasState.alias.description,
                    subtitle: AppStrings.description,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                AppTheme.kBottomSheetBorderRadius,
                              ),
                            ),
                          ),
                          builder: (context) {
                            return UpdateDescriptionWidget(
                              description: aliasState.alias.description,
                              updateDescription: (description) async {
                                await ref
                                    .read(aliasScreenStateNotifier.notifier)
                                    .editDescription(description);
                              },
                              removeDescription: () async {
                                await ref
                                    .read(aliasScreenStateNotifier.notifier)
                                    .editDescription('');
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (aliasState.alias.extension.isNotEmpty)
                    AliasScreenListTile(
                      leadingIconData: Icons.check_circle_outline,
                      title: aliasState.alias.extension,
                      subtitle: 'extension',
                      trailing: Container(),
                    ),
                  AliasScreenListTile(
                    leadingIconData: isAliasDeleted
                        ? Icons.restore_outlined
                        : Icons.delete_outline,
                    title: '${isAliasDeleted ? 'Restore' : 'Delete'} Alias',
                    subtitle: isAliasDeleted
                        ? AppStrings.restoreAliasSubtitle
                        : AppStrings.deleteAliasSubtitle,
                    trailing: Row(
                      children: [
                        if (aliasState.deleteAliasLoading)
                          const PlatformLoadingIndicator(size: 20),
                        IconButton(
                          icon: isAliasDeleted
                              ? const Icon(Icons.restore_outlined,
                                  color: Colors.green)
                              : const Icon(Icons.delete_outline,
                                  color: Colors.red),
                          onPressed: () {
                            /// Display platform appropriate dialog
                            PlatformAware.platformDialog(
                              context: context,
                              child: PlatformAlertDialog(
                                title:
                                    '${isAliasDeleted ? 'Restore' : 'Delete'} Alias',
                                content: isAliasDeleted
                                    ? AnonAddyString.restoreAliasConfirmation
                                    : AnonAddyString.deleteAliasConfirmation,
                                method: () async {
                                  /// Dismisses [platformDialog]
                                  Navigator.pop(context);

                                  /// Delete [alias] if it's available or restore it if it's deleted
                                  isAliasDeleted
                                      ? await ref
                                          .read(
                                              aliasScreenStateNotifier.notifier)
                                          .restoreAlias(aliasState.alias)
                                      : await ref
                                          .read(
                                              aliasScreenStateNotifier.notifier)
                                          .deleteAlias(aliasState.alias);

                                  /// Dismisses [AliasScreen] if [alias] is deleted
                                  if (!isAliasDeleted && mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const AliasScreenRecipients(),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CreatedAtWidget(
                        label: 'Created at',
                        dateTime: aliasState.alias.createdAt,
                      ),
                      aliasState.alias.deletedAt.isEmpty
                          ? CreatedAtWidget(
                              label: 'Updated at',
                              dateTime: aliasState.alias.updatedAt,
                            )
                          : CreatedAtWidget(
                              label: 'Deleted at',
                              dateTime: aliasState.alias.deletedAt,
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );

            case AliasScreenStatus.failed:
              final error = aliasState.errorMessage;
              return LottieWidget(
                key: AliasTabWidgetKeys.aliasScreenLottieWidget,
                lottie: LottieImages.errorCone,
                label: error,
              );
          }
        },
      ),
    );
  }
}
