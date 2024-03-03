import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/alias_default_recipient.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_screen_list_tile.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_screen_recipients.dart';
import 'package:anonaddy/features/aliases/presentation/components/send_from_widget.dart';
import 'package:anonaddy/features/aliases/presentation/controller/alias_screen_notifier.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/shared_components/shared_components_exports.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AliasScreen extends ConsumerStatefulWidget {
  const AliasScreen({
    super.key,
    required this.aliasId,
  });
  final String aliasId;

  static const routeName = 'aliasDetailedScreen';

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
  final sendFromFormKey = GlobalKey<FormState>();

  Future<void> showSendFromDialog(Alias alias) async {
    await WoltModalSheet.show(
      context: context,
      onModalDismissedWithBarrierTap: Navigator.of(context).pop,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage.withSingleChild(
            topBarTitle: Text(
              AppStrings.sendFromAlias,
              style: Theme.of(modalSheetContext).textTheme.titleMedium,
            ),
            isTopBarLayerAlwaysVisible: true,
            pageTitle: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppStrings.sendFromAliasString,
                style: Theme.of(modalSheetContext).textTheme.bodySmall,
              ),
            ),
            stickyActionBar: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: PlatformButton(
                child: const Text(
                  'Generate address',
                  style: TextStyle(color: Colors.black),
                ),
                onPress: () async {
                  await generateSendFromAddress(
                    modalSheetContext,
                    alias: alias,
                  );
                },
              ),
            ),
            child: SendFromWidget(
              email: alias.email,
              formKey: sendFromFormKey,
              onFieldSubmitted: (value) async {
                await generateSendFromAddress(
                  modalSheetContext,
                  alias: alias,
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Future<void> generateSendFromAddress(
    BuildContext context, {
    required Alias alias,
  }) async {
    if (sendFromFormKey.currentState!.validate()) {
      await ref
          .read(aliasScreenNotifierProvider(alias.id).notifier)
          .sendFromAlias(alias.email)
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final aliasNotifier =
        ref.watch(aliasScreenNotifierProvider(widget.aliasId));

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
                    .read(aliasScreenNotifierProvider(widget.aliasId).notifier)
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
              if (aliasState.isOffline) const OfflineBanner(),
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
                  onPressed: () => showSendFromDialog(aliasState.alias),
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
                        WoltModalSheetPage.withSingleChild(
                          backgroundColor: isDark ? Colors.black : Colors.white,
                          sabGradientColor:
                              isDark ? Colors.black : Colors.white,
                          topBarTitle: Text(
                            'Default Recipient${aliasState.alias.recipients.length >= 2 ? 's' : ''}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          isTopBarLayerAlwaysVisible: true,
                          enableDrag: true,
                          child: AliasDefaultRecipientScreen(
                            aliasId: aliasState.alias.id,
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
          return ErrorMessageWidget(
            key: AliasScreen.aliasScreenLottieWidget,
            message: error.toString(),
          );
        },
        loading: () {
          return ListView(
            children: const [
              AliasScreenPieChart(
                emailsForwarded: 0,
                emailsBlocked: 0,
                emailsReplied: 0,
                emailsSent: 0,
              ),
              const Divider(height: 24),
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
