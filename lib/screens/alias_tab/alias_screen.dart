import 'package:animations/animations.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

class AliasScreen extends StatefulWidget {
  const AliasScreen(this.alias);
  final Alias alias;

  static const routeName = 'aliasDetailedScreen';

  @override
  State<AliasScreen> createState() => _AliasScreenState();
}

class _AliasScreenState extends State<AliasScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read(aliasScreenStateNotifier.notifier)
        .fetchAliases(widget.alias.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: Consumer(
        builder: (context, watch, _) {
          final aliasState = watch(aliasScreenStateNotifier);

          switch (aliasState.status!) {
            case AliasScreenStatus.loading:
              return Center(
                child: context
                    .read(customLoadingIndicator)
                    .customLoadingIndicator(),
              );

            case AliasScreenStatus.loaded:
              return buildListView(context, aliasState);

            case AliasScreenStatus.failed:
              final error = aliasState.errorMessage;
              return LottieWidget(
                lottie: 'assets/lottie/errorCone.json',
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

    final nicheMethod = context.read(nicheMethods);

    final customLoading =
        context.read(customLoadingIndicator).customLoadingIndicator();

    final isAliasDeleted = alias.deletedAt != null;

    return ListView(
      children: [
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
            'Actions',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: size.height * 0.005),
        AliasDetailListTile(
          leadingIconData: Icons.alternate_email,
          title: alias.email,
          subtitle: 'Email',
          trailingIconData: Icons.copy,
          trailingIconOnPress: () => nicheMethod.copyOnTap(alias.email),
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
              if (isToggleLoading) customLoading,
              Switch.adaptive(
                value: alias.active,
                onChanged: isAliasDeleted ? null : (toggle) {},
              ),
            ],
          ),
          trailingIconOnPress: () async {
            isAliasDeleted
                ? nicheMethod.showToast(kRestoreBeforeActivate)
                : alias.active
                    ? await context
                        .read(aliasScreenStateNotifier.notifier)
                        .toggleOffAlias(alias.id)
                    : await context
                        .read(aliasScreenStateNotifier.notifier)
                        .toggleOnAlias(alias.id);
          },
        ),
        AliasDetailListTile(
          leadingIconData: Icons.comment_outlined,
          title: alias.description ?? 'No description',
          subtitle: 'Description',
          trailingIconData: Icons.edit_outlined,
          trailingIconOnPress: () => buildEditDescriptionDialog(context, alias),
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
          subtitle:
              isAliasDeleted ? kRestoreAliasSubtitle : kDeleteAliasSubtitle,
          trailing: Row(
            children: [
              if (deleteAliasLoading) customLoading,
              IconButton(
                icon: isAliasDeleted
                    ? Icon(Icons.restore_outlined, color: Colors.green)
                    : Icon(Icons.delete_outline, color: Colors.red),
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
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () =>
                          buildUpdateDefaultRecipient(context, alias),
                    ),
                  ],
                ),
              ),
              if (alias.recipients!.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                  child: Row(children: [Text(kNoDefaultRecipientSet)]),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: alias.recipients!.length,
                  itemBuilder: (context, index) {
                    final recipients = alias.recipients;
                    return RecipientListTile(
                      recipient: recipients![index],
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
            alias.deletedAt == null
                ? AliasCreatedAtWidget(
                    label: 'Updated:',
                    dateTime: alias.updatedAt,
                  )
                : AliasCreatedAtWidget(
                    label: 'Deleted:',
                    dateTime: alias.deletedAt!,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBottomSheetBorderRadius),
        ),
      ),
      builder: (context) {
        return AliasDefaultRecipientScreen(alias);
      },
    );
  }

  Future buildDeleteOrRestoreAliasDialog(BuildContext context, Alias alias) {
    final isIOS = context.read(targetedPlatform).isIOS();
    final dialog = context.read(confirmationDialog);
    final isDeleted = alias.deletedAt != null;

    Future<void> deleteOrRestore() async {
      Navigator.pop(context);
      isDeleted
          ? await context
              .read(aliasScreenStateNotifier.notifier)
              .restoreAlias(alias.id)
          : await context
              .read(aliasScreenStateNotifier.notifier)
              .deleteAlias(alias.id);

      if (!isDeleted) Navigator.pop(context);
    }

    return showModal(
      context: context,
      builder: (context) {
        return isIOS
            ? dialog.iOSAlertDialog(
                context,
                isDeleted
                    ? kRestoreAliasConfirmation
                    : kDeleteAliasConfirmation,
                deleteOrRestore,
                '${isDeleted ? 'Restore' : 'Delete'} Alias')
            : dialog.androidAlertDialog(
                context,
                isDeleted
                    ? kRestoreAliasConfirmation
                    : kDeleteAliasConfirmation,
                deleteOrRestore,
                '${isDeleted ? 'Restore' : 'Delete'} Alias');
      },
    );
  }

  Future buildSendFromDialog(BuildContext context, Alias alias) {
    final sendFromFormKey = GlobalKey<FormState>();
    String destinationEmail = '';

    Future<void> generateAddress() async {
      if (sendFromFormKey.currentState!.validate()) {
        await context
            .read(aliasScreenStateNotifier.notifier)
            .sendFromAlias(alias.email, destinationEmail);
        Navigator.pop(context);
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
              BottomSheetHeader(headerLabel: kSendFromAlias),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kSendFromAliasString),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      enabled: false,
                      decoration: kTextFormFieldDecoration.copyWith(
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
                        validator: (input) => context
                            .read(formValidator)
                            .validateEmailField(input!),
                        onChanged: (input) => destinationEmail = input,
                        onFieldSubmitted: (toggle) => generateAddress(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter email...',
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(kSendFromAliasNote),
                    SizedBox(height: size.height * 0.01),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        child: Text('Generate address'),
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

  Future buildEditDescriptionDialog(BuildContext context, Alias alias) {
    final aliasScreenState = context.read(aliasScreenStateNotifier.notifier);
    final descriptionFormKey = GlobalKey<FormState>();
    String newDescription = '';

    Future<void> editDesc() async {
      if (descriptionFormKey.currentState!.validate()) {
        await aliasScreenState.editDescription(alias, newDescription);
        Navigator.pop(context);
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
              BottomSheetHeader(headerLabel: kUpdateDescription),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(kUpdateDescriptionString),
                    SizedBox(height: size.height * 0.015),
                    Form(
                      key: descriptionFormKey,
                      child: TextFormField(
                        autofocus: true,
                        validator: (input) => context
                            .read(formValidator)
                            .validateDescriptionField(input!),
                        onChanged: (input) => newDescription = input,
                        onFieldSubmitted: (toggle) => editDesc(),
                        decoration: kTextFormFieldDecoration.copyWith(
                          hintText: alias.description ?? 'No description',
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              minimumSize: Size(120, size.height * 0.055),
                            ),
                            child: Text(kRemoveDescription),
                            onPressed: () async {
                              await aliasScreenState.editDescription(alias, '');
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, size.height * 0.055),
                            ),
                            child: Text(kUpdateDescription),
                            onPressed: () => editDesc(),
                          ),
                        ),
                      ],
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

  AppBar buildAppBar(BuildContext context) {
    final dialog = context.read(confirmationDialog);
    final isIOS = context.read(targetedPlatform).isIOS();

    Future<void> forget() async {
      await context
          .read(aliasScreenStateNotifier.notifier)
          .forgetAlias(widget.alias.id);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    Future forgetOnPress() async {
      Navigator.pop(context);
      showModal(
        context: context,
        builder: (context) {
          return isIOS
              ? dialog.iOSAlertDialog(
                  context, kForgetAliasConfirmation, forget, kForgetAlias)
              : dialog.androidAlertDialog(
                  context, kForgetAliasConfirmation, forget, kForgetAlias);
        },
      );
    }

    return AppBar(
      title: Text(
        'Alias',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: Icon(isIOS ? CupertinoIcons.back : Icons.arrow_back),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    BottomSheetHeader(headerLabel: 'Alias'),
                    ListTile(
                      title: Text(
                        'Forget Alias',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onTap: () => forgetOnPress(),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
