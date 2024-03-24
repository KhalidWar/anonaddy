import 'package:anonaddy/features/aliases/presentation/controller/fab_visibility_state.dart';
import 'package:anonaddy/features/create_alias/presentation/components/create_alias_error_widget.dart';
import 'package:anonaddy/features/create_alias/presentation/components/create_alias_tile.dart';
import 'package:anonaddy/features/create_alias/presentation/components/select_recipient_tile.dart';
import 'package:anonaddy/features/create_alias/presentation/controller/create_alias_notifier.dart';
import 'package:anonaddy/features/create_alias/presentation/controller/create_alias_state.dart';
import 'package:anonaddy/features/home/presentation/components/animated_fab.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_scroll_bar.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class CreateAlias extends ConsumerStatefulWidget {
  const CreateAlias({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _CreateAliasFABState();
}

class _CreateAliasFABState extends ConsumerState<CreateAlias> {
  final pageIndexNotifier = ValueNotifier(0);

  void resetPageIndex() {
    pageIndexNotifier.value = 0;
  }

  /// Creates alias with selected parameters.
  void createAlias() {
    /// initiate create alias method
    ref
        .read(createAliasNotifierProvider.notifier)
        .createNewAlias()

        /// [rootContext] is used to dismiss the whole sheet
        /// after alias is created.
        .then((value) => Navigator.pop(context))

        /// Errors are shown as Toast Messages. This is only to
        /// stop framework from throwing errors.
        .catchError((error) => null);
  }

  @override
  Widget build(BuildContext context) {
    final showFab = ref.watch(fabVisibilityStateNotifier);

    return AnimatedFab(
      showFab: showFab,
      child: FloatingActionButton(
        key: const Key('homeScreenFAB'),
        child: const Icon(Icons.add),
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            onModalDismissedWithDrag: resetPageIndex,
            onModalDismissedWithBarrierTap: () {
              Navigator.of(context).pop();
              resetPageIndex();
            },
            pageIndexNotifier: pageIndexNotifier,
            pageListBuilder: (modalSheetContext) {
              return [
                buildNewCreateAliasModal(modalSheetContext),
                buildSelectAliasDomain(modalSheetContext),
                buildSelectAliasFormat(modalSheetContext),
                buildSelectAliasLocalPart(modalSheetContext),
                buildSelectAliasRecipient(modalSheetContext),
                buildAliasDescription(modalSheetContext),
              ];
            },
          );
        },
      ),
    );
  }

  WoltModalSheetPage buildNewCreateAliasModal(BuildContext modalSheetContext) {
    return WoltModalSheetPage(
      topBarTitle: Text(
        'Create New Alias',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      isTopBarLayerAlwaysVisible: true,
      enableDrag: true,
      stickyActionBar: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Consumer(
          builder: (context, ref, _) {
            final createAliasNotifier = ref.watch(createAliasNotifierProvider);

            return createAliasNotifier.when(
              data: (createAliasState) {
                final isConfirmButtonLoading =
                    createAliasState.isConfirmButtonLoading;

                return PlatformButton(
                  onPress: isConfirmButtonLoading ? () {} : createAlias,
                  child: isConfirmButtonLoading
                      ? const PlatformLoadingIndicator()
                      : const Text(
                          AppStrings.createAliasTitle,
                          style: TextStyle(color: Colors.black),
                        ),
                );
              },
              error: (_, __) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final createAliasState = ref.watch(createAliasNotifierProvider);

          return createAliasState.when(
            data: (createAliasState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Other aliases e.g. alias@${createAliasState.account.username}.anonaddy.com or .me can also be created automatically when they receive their first email.',
                      style: Theme.of(modalSheetContext).textTheme.bodySmall,
                    ),
                  ),
                  CreateAliasTile(
                    title: createAliasState.selectedAliasDomain ??
                        'No default selected',
                    iconData: Icons.dns_outlined,
                    subtitle: 'Alias Domain',
                    onPress: () =>
                        pageIndexNotifier.value = pageIndexNotifier.value + 1,
                  ),
                  CreateAliasTile(
                    title: createAliasState.selectedAliasFormat == null
                        ? 'No default selected'
                        : Utilities.correctAliasString(
                            createAliasState.selectedAliasFormat),
                    iconData: Icons.alternate_email_outlined,
                    subtitle: 'Alias Format',
                    onPress: () =>
                        pageIndexNotifier.value = pageIndexNotifier.value + 2,
                  ),
                  if (createAliasState.showLocalPart)
                    CreateAliasTile(
                      title: createAliasState.localPart.isEmpty
                          ? 'Enter local part...'
                          : createAliasState.localPart,
                      iconData: Icons.alternate_email_outlined,
                      subtitle: 'Alias Local Part',
                      onPress: () =>
                          pageIndexNotifier.value = pageIndexNotifier.value + 3,
                    ),
                  CreateAliasTile(
                    title: createAliasState.selectedRecipients.map((e) {
                          return e.email;
                        }).join(', ') +
                        (createAliasState.selectedRecipients.isNotEmpty
                            ? ' (${createAliasState.selectedRecipients.length})'
                            : 'Select recipient(s) (optional)...'),
                    iconData: Icons.email_outlined,
                    subtitle: 'Recipients',
                    onPress: () =>
                        pageIndexNotifier.value = pageIndexNotifier.value + 4,
                  ),
                  CreateAliasTile(
                    title: createAliasState.description.isEmpty
                        ? 'Enter description (optional)...'
                        : createAliasState.description,
                    iconData: Icons.comment_outlined,
                    subtitle: 'Description',
                    onPress: () =>
                        pageIndexNotifier.value = pageIndexNotifier.value + 5,
                  ),
                  const SizedBox(height: 85),
                ],
              );
            },
            error: (error, _) {
              return CreateAliasErrorWidget(message: error.toString());
            },
            loading: () => SizedBox(
              height: MediaQuery.of(modalSheetContext).size.height * .4,
              width: double.infinity,
              child: const Center(
                child: PlatformLoadingIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  WoltModalSheetPage buildSelectAliasDomain(BuildContext modalSheetContext) {
    return Utilities.buildWoltModalSheetSubPage(
      context,
      showLeading: true,
      topBarTitle: 'Select Alias Domain',
      leadingWidgetOnPress: resetPageIndex,
      child: Consumer(
        builder: (context, ref, child) {
          final createAliasNotifier = ref.watch(createAliasNotifierProvider);

          return createAliasNotifier.when(
            data: (createAliasState) {
              return PlatformScrollbar(
                child: createAliasState.domains.isEmpty
                    ? const CreateAliasErrorWidget(
                        message: 'No alias domain found',
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: createAliasState.domains.length,
                        itemBuilder: (context, index) {
                          final domain = createAliasState.domains[index];
                          return ListTile(
                            title: Text(domain, textAlign: TextAlign.center),
                            onTap: () {
                              ref
                                  .read(createAliasNotifierProvider.notifier)
                                  .setAliasDomain(domain);
                              resetPageIndex();
                            },
                          );
                        },
                      ),
              );
            },
            error: (error, _) {
              return CreateAliasErrorWidget(message: error.toString());
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  WoltModalSheetPage buildSelectAliasFormat(BuildContext modalSheetContext) {
    return Utilities.buildWoltModalSheetSubPage(
      context,
      showLeading: true,
      topBarTitle: 'Select Alias Format',
      leadingWidgetOnPress: resetPageIndex,
      child: Consumer(
        builder: (context, ref, _) {
          final createAliasNotifier = ref.watch(createAliasNotifierProvider);

          return createAliasNotifier.when(
            data: (createAliasState) {
              return createAliasState.aliasFormatList.isEmpty
                  ? const CreateAliasErrorWidget(
                      message: 'No alias format found',
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: createAliasState.aliasFormatList.length,
                      itemBuilder: (context, index) {
                        final aliasFormat =
                            createAliasState.aliasFormatList[index];
                        return ListTile(
                          selectedTileColor: AppColors.accentColor,
                          title: Text(
                            Utilities.correctAliasString(aliasFormat),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            ref
                                .read(createAliasNotifierProvider.notifier)
                                .setAliasFormat(aliasFormat);
                            resetPageIndex();
                          },
                        );
                      },
                    );
            },
            error: (error, _) {
              return CreateAliasErrorWidget(message: error.toString());
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  WoltModalSheetPage buildSelectAliasLocalPart(BuildContext modalSheetContext) {
    return Utilities.buildWoltModalSheetSubPage(
      context,
      showLeading: true,
      topBarTitle: 'Enter Local Part',
      leadingWidgetOnPress: resetPageIndex,
      child: Consumer(
        builder: (context, ref, _) {
          ref.watch(createAliasNotifierProvider);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppStrings.createAliasCustomFieldNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (input) {
                    ref
                        .read(createAliasNotifierProvider.notifier)
                        .setLocalPart(input);
                    resetPageIndex();
                  },
                  decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                    hintText: AppStrings.localPartFieldHint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  WoltModalSheetPage buildSelectAliasRecipient(BuildContext modalSheetContext) {
    return Utilities.buildWoltModalSheetSubPage(
      context,
      showLeading: true,
      topBarTitle: 'Select Default Recipients',
      pageTitle: AppStrings.updateAliasRecipientNote,
      leadingWidgetOnPress: resetPageIndex,
      child: Consumer(
        builder: (context, ref, _) {
          final createAliasNotifier = ref.watch(createAliasNotifierProvider);

          return createAliasNotifier.when(
            skipLoadingOnRefresh: false,
            skipLoadingOnReload: false,
            data: (createAliasState) {
              return createAliasState.verifiedRecipients.isEmpty
                  ? const CreateAliasErrorWidget(
                      message: 'No recipients found',
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: createAliasState.verifiedRecipients.length,
                      itemBuilder: (context, index) {
                        final verifiedRecipient =
                            createAliasState.verifiedRecipients[index];
                        final isSelected = ref
                            .read(createAliasNotifierProvider.notifier)
                            .isRecipientSelected(verifiedRecipient);

                        return SelectRecipientTile(
                          isSelected: isSelected,
                          verifiedRecipient: verifiedRecipient,
                          onPress: () => ref
                              .read(createAliasNotifierProvider.notifier)
                              .toggleRecipient(verifiedRecipient),
                        );
                      },
                    );
            },
            error: (error, _) {
              return CreateAliasErrorWidget(message: error.toString());
            },
            loading: () => const Center(child: PlatformLoadingIndicator()),
          );
        },
      ),
    );
  }

  WoltModalSheetPage buildAliasDescription(BuildContext modalSheetContext) {
    return Utilities.buildWoltModalSheetSubPage(
      context,
      showLeading: true,
      topBarTitle: 'Enter Description',
      pageTitle:
          'A unique word or two that describe alias. You can also search for aliases by their description.',
      leadingWidgetOnPress: resetPageIndex,
      child: Consumer(
        builder: (context, ref, _) {
          ref.watch(createAliasNotifierProvider);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (input) {
                ref
                    .read(createAliasNotifierProvider.notifier)
                    .setDescription(input);
                resetPageIndex();
              },
              decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                hintText: AppStrings.descriptionFieldHint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          );
        },
      ),
    );
  }
}
