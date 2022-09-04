import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/alias_screen_state.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_screen_recipients.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/screens/alias_tab/components/send_from_widget.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/list_tiles/list_tiles_exports.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_exports.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/shared_components/shared_components_exports.dart';
import 'package:anonaddy/utilities/utilities_export.dart';
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
    final size = MediaQuery.of(context).size;

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
                await ref
                    .read(aliasScreenStateNotifier.notifier)
                    .forgetAlias(widget.alias.id);

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

          switch (aliasState.status) {
            case AliasScreenStatus.loading:
              return const Center(
                child: PlatformLoadingIndicator(
                  key: AliasTabWidgetKeys.aliasScreenLoadingIndicator,
                ),
              );

            case AliasScreenStatus.loaded:
              return buildListView(context, aliasState);

            case AliasScreenStatus.failed:
              final error = aliasState.errorMessage;
              return LottieWidget(
                key: AliasTabWidgetKeys.aliasScreenLottieWidget,
                lottieHeight: size.height * 0.3,
                lottie: LottieImages.errorCone,
                label: error,
              );
          }
        },
      ),
    );
  }

  Widget buildListView(BuildContext context, AliasScreenState aliasState) {
    final alias = aliasState.alias;
    final isToggleLoading = aliasState.isToggleLoading;
    final deleteAliasLoading = aliasState.deleteAliasLoading;
    final size = MediaQuery.of(context).size;

    final isAliasDeleted = alias.deletedAt.isNotEmpty;

    return ListView(
      key: AliasTabWidgetKeys.aliasScreenBodyListView,
      physics: const ClampingScrollPhysics(),
      children: [
        if (aliasState.isOffline) const OfflineBanner(),
        AliasScreenPieChart(
          emailsForwarded: alias.emailsForwarded,
          emailsBlocked: alias.emailsBlocked,
          emailsReplied: alias.emailsReplied,
          emailsSent: alias.emailsSent,
        ),
        Divider(height: size.height * 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
          child: Text(
            AppStrings.actions,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: size.height * 0.005),
        AliasDetailListTile(
          leadingIconData: Icons.alternate_email,
          title: alias.email,
          subtitle: 'Email',
          trailingIconData: Icons.copy,
          trailingIconOnPress: () => NicheMethod.copyOnTap(alias.email),
        ),
        AliasDetailListTile(
          leadingIconData: Icons.mail_outline,
          title: 'Send email from this alias',
          subtitle: 'Send from',
          trailingIconData: Icons.send_outlined,
          trailingIconOnPress: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
              ),
              builder: (context) => const SendFromWidget(),
            );
          },
        ),
        AliasDetailListTile(
          leadingIconData: Icons.toggle_on_outlined,
          title: 'Alias is ${alias.active ? 'active' : 'inactive'}',
          subtitle: 'Activity',
          trailing: Row(
            children: [
              if (isToggleLoading) const PlatformLoadingIndicator(size: 20),
              PlatformSwitch(
                value: alias.active,
                onChanged: isAliasDeleted ? null : (toggle) {},
              ),
            ],
          ),
          trailingIconOnPress: () async {
            isAliasDeleted
                ? NicheMethod.showToast(AnonAddyString.restoreBeforeActivate)
                : alias.active
                    ? await ref
                        .read(aliasScreenStateNotifier.notifier)
                        .deactivateAlias(alias.id)
                    : await ref
                        .read(aliasScreenStateNotifier.notifier)
                        .activateAlias(alias.id);
          },
        ),
        AliasDetailListTile(
          leadingIconData: Icons.comment_outlined,
          title: alias.description.isEmpty
              ? AppStrings.noDescription
              : alias.description,
          subtitle: AppStrings.description,
          trailingIconData: Icons.edit_outlined,
          trailingIconOnPress: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
              ),
              builder: (context) {
                return UpdateDescriptionWidget(
                  description: alias.description,
                  updateDescription: (description) async {
                    await ref
                        .read(aliasScreenStateNotifier.notifier)
                        .editDescription(alias, description);
                  },
                  removeDescription: () async {
                    await ref
                        .read(aliasScreenStateNotifier.notifier)
                        .editDescription(alias, '');
                  },
                );
              },
            );
          },
        ),
        if (alias.extension.isNotEmpty)
          AliasDetailListTile(
            leadingIconData: Icons.check_circle_outline,
            title: alias.extension,
            subtitle: 'extension',
            trailingIconData: Icons.edit_outlined,
            trailingIconOnPress: () {},
          ),
        AliasDetailListTile(
          leadingIconData:
              isAliasDeleted ? Icons.restore_outlined : Icons.delete_outline,
          title: '${isAliasDeleted ? 'Restore' : 'Delete'} Alias',
          subtitle: isAliasDeleted
              ? AppStrings.restoreAliasSubtitle
              : AppStrings.deleteAliasSubtitle,
          trailing: Row(
            children: [
              if (deleteAliasLoading) const PlatformLoadingIndicator(size: 20),
              IconButton(
                icon: isAliasDeleted
                    ? const Icon(Icons.restore_outlined, color: Colors.green)
                    : const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: null,
              ),
            ],
          ),
          trailingIconOnPress: () {
            /// Display platform appropriate dialog
            PlatformAware.platformDialog(
              context: context,
              child: PlatformAlertDialog(
                title: '${isAliasDeleted ? 'Restore' : 'Delete'} Alias',
                content: isAliasDeleted
                    ? AnonAddyString.restoreAliasConfirmation
                    : AnonAddyString.deleteAliasConfirmation,
                method: () async {
                  /// Dismisses [platformDialog]
                  Navigator.pop(context);

                  /// Delete [alias] if it's available or restore it if it's deleted
                  isAliasDeleted
                      ? await ref
                          .read(aliasScreenStateNotifier.notifier)
                          .restoreAlias(alias)
                      : await ref
                          .read(aliasScreenStateNotifier.notifier)
                          .deleteAlias(alias);

                  /// Dismisses [AliasScreen] if [alias] is deleted
                  if (!isAliasDeleted && mounted) Navigator.pop(context);
                },
              ),
            );
          },
        ),
        const AliasScreenRecipients(),
        Divider(height: size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AliasCreatedAtWidget(
              label: 'Created:',
              dateTime: alias.createdAt,
            ),
            alias.deletedAt.isEmpty
                ? AliasCreatedAtWidget(
                    label: 'Updated:',
                    dateTime: alias.updatedAt,
                  )
                : AliasCreatedAtWidget(
                    label: 'Deleted:',
                    dateTime: alias.deletedAt,
                  ),
          ],
        ),
        SizedBox(height: size.height * 0.05),
      ],
    );
  }
}
