import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_default_recipient.dart';
import 'package:anonaddy/screens/alias_tab/components/alias_tab_widget_keys.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/list_tiles/list_tiles_exports.dart';
import 'package:anonaddy/shared_components/pie_chart/pie_chart_exports.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/shared_components/shared_components_exports.dart';
import 'package:anonaddy/state_management/alias_state/alias_state_export.dart';
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
      appBar: buildAppBar(context),
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
    final alias = aliasState.alias!;
    final isToggleLoading = aliasState.isToggleLoading!;
    final deleteAliasLoading = aliasState.deleteAliasLoading!;
    final size = MediaQuery.of(context).size;

    final isAliasDeleted = alias.deletedAt != null;

    return ListView(
      key: AliasTabWidgetKeys.aliasScreenBodyListView,
      physics: const ClampingScrollPhysics(),
      children: [
        if (aliasState.isOffline!) const OfflineBanner(),
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
          trailingIconOnPress: () => buildSendFromDialog(context, alias),
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
          title: alias.description ?? AppStrings.noDescription,
          subtitle: AppStrings.description,
          trailingIconData: Icons.edit_outlined,
          trailingIconOnPress: () => updateDescriptionDialog(context, alias),
        ),
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
          trailingIconOnPress: () =>
              buildDeleteOrRestoreAliasDialog(context, alias),
        ),
        if (alias.recipients == null)
          Container()
        else
          Column(
            children: [
              Divider(height: size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Default Recipient${alias.recipients!.length >= 2 ? 's' : ''}',
                      key: AliasTabWidgetKeys.aliasScreenDefaultRecipient,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          buildUpdateDefaultRecipient(context, alias),
                    ),
                  ],
                ),
              ),
              if (alias.recipients!.isNotEmpty)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  child: Column(
                    children: [
                      Text(
                        'To manage recipients, go to Recipients under Account tab.',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
                ),
              if (alias.recipients!.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  child: Row(
                    children: const [
                      Text(AppStrings.noDefaultRecipientSet),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alias.recipients!.length,
                  itemBuilder: (context, index) {
                    final recipients = alias.recipients;
                    return IgnorePointer(
                      child: RecipientListTile(
                        recipient: recipients![index],
                      ),
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

  Future buildUpdateDefaultRecipient(BuildContext context, Alias alias) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
        ),
      ),
      builder: (context) {
        return AliasDefaultRecipientScreen(alias: alias);
      },
    );
  }

  void buildDeleteOrRestoreAliasDialog(BuildContext context, Alias alias) {
    final isDeleted = alias.deletedAt != null;

    /// Display platform appropriate dialog
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: '${isDeleted ? 'Restore' : 'Delete'} Alias',
        content: isDeleted
            ? AnonAddyString.restoreAliasConfirmation
            : AnonAddyString.deleteAliasConfirmation,
        method: () async {
          /// Dismisses [platformDialog]
          Navigator.pop(context);

          /// Delete [alias] if it's available or restore it if it's deleted
          isDeleted
              ? await ref
                  .read(aliasScreenStateNotifier.notifier)
                  .restoreAlias(alias.id)
              : await ref
                  .read(aliasScreenStateNotifier.notifier)
                  .deleteAlias(alias.id);

          /// Dismisses [AliasScreen] if [alias] is deleted
          if (!isDeleted && mounted) Navigator.pop(context);
        },
      ),
    );
  }

  Future buildSendFromDialog(BuildContext context, Alias alias) {
    final sendFromFormKey = GlobalKey<FormState>();
    String destinationEmail = '';

    Future<void> generateAddress() async {
      if (sendFromFormKey.currentState!.validate()) {
        await ref
            .read(aliasScreenStateNotifier.notifier)
            .sendFromAlias(alias.email, destinationEmail);
        Navigator.pop(context);
      }
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        final size = MediaQuery.of(context).size;

        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetHeader(
                headerLabel: AppStrings.sendFromAlias,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(AppStrings.sendFromAliasString),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      enabled: false,
                      decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                        hintText: alias.email,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Email destination',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Form(
                      key: sendFromFormKey,
                      child: TextFormField(
                        autofocus: true,
                        validator: (input) =>
                            FormValidator.validateEmailField(input!),
                        onChanged: (input) => destinationEmail = input,
                        onFieldSubmitted: (toggle) => generateAddress(),
                        decoration: AppTheme.kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter email...',
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      AppStrings.sendFromAliasNote,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        child: const Text('Generate address'),
                        onPressed: () => generateAddress(),
                      ),
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

  Future updateDescriptionDialog(BuildContext context, Alias alias) {
    final aliasScreenNotifier = ref.read(aliasScreenStateNotifier.notifier);
    final descriptionFormKey = GlobalKey<FormState>();
    String newDescription = '';

    Future<void> updateDescription() async {
      if (descriptionFormKey.currentState!.validate()) {
        await aliasScreenNotifier.editDescription(alias, newDescription);
        if (mounted) Navigator.pop(context);
      }
    }

    Future<void> removeDescription() async {
      await aliasScreenNotifier.editDescription(alias, '');
      Navigator.pop(context);
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UpdateDescriptionWidget(
          description: alias.description,
          descriptionFormKey: descriptionFormKey,
          updateDescription: updateDescription,
          inputOnChanged: (input) => newDescription = input,
          removeDescription: removeDescription,
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    Future forgetOnPress() async {
      PlatformAware.platformDialog(
        context: context,
        child: PlatformAlertDialog(
          title: AppStrings.forgetAlias,
          content: AnonAddyString.forgetAliasConfirmation,
          method: () async {
            await ref
                .read(aliasScreenStateNotifier.notifier)
                .forgetAlias(widget.alias.id);

            ref.read(aliasTabStateNotifier.notifier).refreshAliases();

            /// Dismisses [platformDialog]
            if (mounted) Navigator.pop(context);

            /// Dismisses [AliasScreen] after forgetting [alias]
            if (mounted) Navigator.pop(context);
          },
        ),
      );
    }

    return CustomAppBar(
      key: AliasTabWidgetKeys.aliasScreenAppBar,
      title: 'Alias',
      leadingOnPress: () {
        ref.read(aliasTabStateNotifier.notifier).refreshAliases();
        Navigator.pop(context);
      },
      showTrailing: true,
      trailingLabel: 'Forget Alias',
      trailingOnPress: (choice) => forgetOnPress(),
    );
  }
}
