import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/screens/account_tab/domains/domain_default_recipient.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_detail_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/shared_components/update_description_widget.dart';
import 'package:anonaddy/state_management/domains/domains_screen_notifier.dart';
import 'package:anonaddy/state_management/domains/domains_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainsScreen extends ConsumerStatefulWidget {
  const DomainsScreen({Key? key, required this.domain}) : super(key: key);
  final Domain domain;

  static const routeName = 'domainDetailedScreen';

  @override
  ConsumerState createState() => _DomainsScreenState();
}

class _DomainsScreenState extends ConsumerState<DomainsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(domainsScreenStateNotifier.notifier).fetchDomain(widget.domain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer(
        builder: (context, watch, _) {
          final domainProvider = ref.watch(domainsScreenStateNotifier);

          switch (domainProvider.status!) {
            case DomainsScreenStatus.loading:
              return const Center(child: PlatformLoadingIndicator());

            case DomainsScreenStatus.loaded:
              return buildListView(context, domainProvider);

            case DomainsScreenStatus.failed:
              final error = domainProvider.errorMessage;
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
      BuildContext context, DomainsScreenState domainProvider) {
    final size = MediaQuery.of(context).size;

    final domain = domainProvider.domain!;
    final domainNotifier = ref.read(domainsScreenStateNotifier.notifier);

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
                domain.domain,
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
          title: domain.description ?? kNoDescription,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Domain description',
          leadingIconData: Icons.comment_outlined,
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
          trailingIconOnPress: () =>
              buildEditDescriptionDialog(context, domain),
        ),
        AliasDetailListTile(
          title: domain.active ? 'Domain is active' : 'Domain is inactive',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Activity',
          leadingIconData: Icons.toggle_off_outlined,
          trailing:
              buildSwitch(domainProvider.activeSwitchLoading!, domain.active),
          trailingIconOnPress: () {
            domain.active
                ? domainNotifier.toggleOffActivity(domain.id)
                : domainNotifier.toggleOnActivity(domain.id);
          },
        ),
        AliasDetailListTile(
          title: domain.catchAll ? 'Enabled' : 'Disabled',
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          subtitle: 'Catch All',
          leadingIconData: Icons.repeat,
          trailing: buildSwitch(
              domainProvider.catchAllSwitchLoading!, domain.catchAll),
          trailingIconOnPress: () {
            domain.catchAll
                ? domainNotifier.toggleOffCatchAll(domain.id)
                : domainNotifier.toggleOnCatchAll(domain.id);
          },
        ),
        if (domain.domainVerifiedAt == null)
          buildUnverifiedEmailWarning(size, kUnverifiedDomainWarning),
        // Divider(height: size.height * 0.02),
        if (domain.domainMxValidatedAt == null)
          buildUnverifiedEmailWarning(size, kInvalidDomainMXWarning),
        Divider(height: size.height * 0.02),
        // if (domain.domainSendingVerifiedAt == null)
        //   buildUnverifiedEmailWarning(size, kUnverifiedDomainNote),
        // Divider(height: size.height * 0.02),
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
                        buildUpdateDefaultRecipient(context, domain),
                  ),
                ],
              ),
            ),
            if (domain.defaultRecipient == null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('No default recipient found'),
              )
            else
              RecipientListTile(
                recipient: domain.defaultRecipient!,
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
            if (domain.aliases!.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text('No aliases found'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: domain.aliases!.length,
                itemBuilder: (context, index) {
                  return AliasListTile(
                    aliasData: domain.aliases![index],
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
              dateTime: domain.createdAt,
            ),
            AliasCreatedAtWidget(
              label: 'Updated:',
              dateTime: domain.updatedAt,
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

  Future buildEditDescriptionDialog(BuildContext context, Domain domain) {
    final domainNotifier = ref.read(domainsScreenStateNotifier.notifier);
    final formKey = GlobalKey<FormState>();
    String newDescription = '';

    Future<void> updateDescription() async {
      if (formKey.currentState!.validate()) {
        await domainNotifier.editDescription(domain.id, newDescription);
        Navigator.pop(context);
      }
    }

    Future<void> removeDescription() async {
      await domainNotifier.editDescription(domain.id, '');
      Navigator.pop(context);
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBottomSheetBorderRadius)),
      ),
      builder: (context) {
        return UpdateDescriptionWidget(
          description: domain.description,
          descriptionFormKey: formKey,
          inputOnChanged: (input) => newDescription = input,
          updateDescription: updateDescription,
          removeDescription: removeDescription,
        );
      },
    );
  }

  Future buildUpdateDefaultRecipient(BuildContext context, Domain domain) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBottomSheetBorderRadius),
        ),
      ),
      builder: (context) {
        return DomainDefaultRecipient(domain: domain);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    Future<void> deleteDomain() async {
      await ref
          .read(domainsScreenStateNotifier.notifier)
          .deleteDomain(widget.domain.id);
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return AppBar(
      title: const Text('Domain', style: TextStyle(color: Colors.white)),
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
            return ['Delete Domain'].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: (String choice) {
            PlatformAware.platformDialog(
              context: context,
              child: PlatformAlertDialog(
                content: kDeleteDomainConfirmation,
                method: deleteDomain,
                title: 'Delete Domain',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildUnverifiedEmailWarning(Size size, String label) {
    return Container(
      height: size.height * 0.05,
      width: double.infinity,
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
