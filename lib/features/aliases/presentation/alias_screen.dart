import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/created_at_widget.dart';
import 'package:anonaddy/common/custom_app_bar.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/offline_banner.dart';
import 'package:anonaddy/common/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/common/update_description_widget.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/alias_default_recipient.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_screen_list_tile.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_screen_recipients.dart';
import 'package:anonaddy/features/aliases/presentation/components/send_from_widget.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/default_recipient/default_recipient_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'AliasScreenRoute')
class AliasScreen extends ConsumerStatefulWidget {
  const AliasScreen({
    super.key,
    required this.id,
  });

  final String id;

  static const aliasScreenScaffold = Key('aliasScreenScaffold');
  static const aliasScreenAppBar = Key('aliasScreenAppBar');
  static const aliasScreenLoadingIndicator = Key('aliasScreenLoadingIndicator');
  static const aliasScreenLottieWidget = Key('aliasScreenLottieWidget');
  static const aliasScreenBodyListView = Key('aliasScreenBodyListView');
  static const aliasScreenDefaultRecipient = Key('aliasScreenDefaultRecipient');

  @override
  ConsumerState createState() => _AliasScreenState();
}

class _AliasScreenState extends ConsumerState<AliasScreen> {
  @override
  Widget build(BuildContext context) {
    final aliasNotifier = ref.watch(aliasScreenNotifierProvider(widget.id));

    return Scaffold(
      key: AliasScreen.aliasScreenScaffold,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        key: AliasScreen.aliasScreenAppBar,
        title: 'Alias',
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: true,
        trailingLabel: 'Forget Alias',
        trailingOnPress: (choice) {
          PlatformAware.platformDialog(
            context: context,
            child: PlatformAlertDialog(
              title: AppStrings.forgetAlias,
              content: AddyString.forgetAliasConfirmation,
              method: () async {
                await ref
                    .read(aliasScreenNotifierProvider(widget.id).notifier)
                    .forgetAlias()
                    .then((_) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ),
          );
        },
      ),
      body: aliasNotifier.when(
        data: (aliasState) {
          final isAliasDeleted = aliasState.alias.isDeleted;

          return ListView(
            key: AliasScreen.aliasScreenBodyListView,
            physics: const ClampingScrollPhysics(),
            children: [
              const OfflineBanner(),
              AliasScreenPieChart(
                emailsForwarded: aliasState.alias.emailsForwarded,
                emailsBlocked: aliasState.alias.emailsBlocked,
                emailsReplied: aliasState.alias.emailsReplied,
                emailsSent: aliasState.alias.emailsSent,
              ),
              const Divider(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  AppStrings.actions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              AliasScreenListTile(
                leadingIconData: Icons.alternate_email,
                title: aliasState.alias.email,
                subtitle: 'Email',
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => Utilities.copyOnTap(aliasState.alias.email),
                ),
              ),
              AliasScreenListTile(
                leadingIconData: Icons.mail_outline,
                title: 'Send email from this alias',
                subtitle: 'Send from',
                trailing: IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: () async {
                    await WoltModalSheet.show(
                      context: context,
                      onModalDismissedWithBarrierTap: Navigator.of(context).pop,
                      pageListBuilder: (modalSheetContext) {
                        return [
                          Utilities.buildWoltModalSheetSubPage(
                            context,
                            topBarTitle: AppStrings.sendFromAlias,
                            pageTitle: AppStrings.sendFromAliasString,
                            child: SendFromWidget(
                              email: aliasState.alias.email,
                              onSubmitted: (value) async {
                                await ref
                                    .read(aliasScreenNotifierProvider(
                                            aliasState.alias.id)
                                        .notifier)
                                    .sendFromAlias(value)
                                    .then((_) {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ),
                        ];
                      },
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
                                AddyString.restoreBeforeActivate)
                            : aliasState.alias.active
                                ? await ref
                                    .read(aliasScreenNotifierProvider(
                                            aliasState.alias.id)
                                        .notifier)
                                    .deactivateAlias()
                                : await ref
                                    .read(aliasScreenNotifierProvider(
                                            aliasState.alias.id)
                                        .notifier)
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
                  onPressed: () async {
                    await WoltModalSheet.show(
                      context: context,
                      pageListBuilder: (context) {
                        return [
                          Utilities.buildWoltModalSheetSubPage(
                            context,
                            topBarTitle: AppStrings.updateDescriptionTitle,
                            child: UpdateDescriptionWidget(
                              description: aliasState.alias.description,
                              updateDescription: (description) async {
                                await ref
                                    .read(aliasScreenNotifierProvider(
                                            aliasState.alias.id)
                                        .notifier)
                                    .editDescription(description);
                              },
                              removeDescription: () async {
                                await ref
                                    .read(aliasScreenNotifierProvider(
                                            aliasState.alias.id)
                                        .notifier)
                                    .editDescription('');
                              },
                            ),
                          ),
                        ];
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
                  trailing: const SizedBox.shrink(),
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
                          ? const Icon(
                              Icons.restore_outlined,
                              color: Colors.green,
                            )
                          : const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        /// Display platform appropriate dialog
                        PlatformAware.platformDialog(
                          context: context,
                          child: PlatformAlertDialog(
                            title:
                                '${isAliasDeleted ? 'Restore' : 'Delete'} Alias',
                            content: isAliasDeleted
                                ? AddyString.restoreAliasConfirmation
                                : AddyString.deleteAliasConfirmation,
                            method: () async {
                              /// Dismisses [platformDialog]
                              Navigator.pop(context);

                              /// Delete [alias] if it's available or restore it if it's deleted
                              isAliasDeleted
                                  ? await ref
                                      .read(aliasScreenNotifierProvider(
                                              aliasState.alias.id)
                                          .notifier)
                                      .restoreAlias()
                                  : await ref
                                      .read(aliasScreenNotifierProvider(
                                              aliasState.alias.id)
                                          .notifier)
                                      .deleteAlias()
                                      .then((value) {
                                      /// Dismisses [AliasScreen] if [alias] is deleted
                                      Navigator.pop(context);
                                    }).catchError((_) {});
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              AliasScreenRecipients(
                recipients: aliasState.alias.recipients,
                onPressed: () async {
                  await WoltModalSheet.show(
                    context: context,
                    onModalDismissedWithBarrierTap: Navigator.of(context).pop,
                    pageListBuilder: (modalSheetContext) {
                      return [
                        Utilities.buildWoltModalSheetSubPage(
                          context,
                          topBarTitle: 'Default Recipients',
                          pageTitle:
                              '${AppStrings.updateAliasRecipientNote}\n\n${AddyString.updateAliasRecipients}',
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 76),
                            child: AliasDefaultRecipientScreen(
                              aliasId: aliasState.alias.id,
                            ),
                          ),
                          stickyActionBar: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: PlatformButton(
                              onPress: () => ref
                                  .read(defaultRecipientNotifierProvider(
                                          widget.id)
                                      .notifier)
                                  .updateAliasDefaultRecipient()
                                  .whenComplete(() => Navigator.pop(context)),
                              child: Consumer(
                                builder: (context, ref, _) {
                                  final defaultRecipientAsync = ref.watch(
                                      defaultRecipientNotifierProvider(
                                          widget.id));

                                  return defaultRecipientAsync.when(
                                    data: (defaultRecipientState) {
                                      return defaultRecipientState.isCTALoading
                                          ? const PlatformLoadingIndicator()
                                          : const Text('Update Recipients');
                                    },
                                    loading: () =>
                                        const PlatformLoadingIndicator(),
                                    error: (error, _) => ErrorMessageWidget(
                                      message: error.toString(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                  );
                },
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CreatedAtWidget(
                    label: 'Created',
                    dateTime: aliasState.alias.createdAt,
                  ),
                  aliasState.alias.isDeleted
                      ? CreatedAtWidget(
                          label: 'Deleted',
                          dateTime: aliasState.alias.deletedAt,
                        )
                      : CreatedAtWidget(
                          label: 'Updated',
                          dateTime: aliasState.alias.updatedAt,
                        ),
                ],
              ),
            ],
          );
        },
        error: (error, stack) {
          return ListView(
            children: [
              const OfflineBanner(),
              const AliasScreenPieChart(
                emailsForwarded: 0,
                emailsBlocked: 0,
                emailsReplied: 0,
                emailsSent: 0,
              ),
              const Divider(height: 24),
              Center(
                child: ErrorMessageWidget(
                  key: AliasScreen.aliasScreenLottieWidget,
                  message: error.toString(),
                ),
              ),
            ],
          );
        },
        loading: () {
          return ListView(
            children: const [
              OfflineBanner(),
              AliasScreenPieChart(
                emailsForwarded: 0,
                emailsBlocked: 0,
                emailsReplied: 0,
                emailsSent: 0,
              ),
              Divider(height: 24),
              Center(
                child: PlatformLoadingIndicator(
                  key: AliasScreen.aliasScreenLoadingIndicator,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
