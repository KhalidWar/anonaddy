import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/models/recipient/recipient.dart';
import 'package:anonaddy/screens/account_tab/recipients/components/recipient_add_pgp_key.dart';
import 'package:anonaddy/screens/account_tab/recipients/components/recipient_screen_actions_list_tile.dart';
import 'package:anonaddy/screens/account_tab/recipients/components/recipient_screen_trailing_loading_switch.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/alias_created_at_widget.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/lottie_images.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/offline_banner.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_state.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class RecipientsScreen extends ConsumerStatefulWidget {
  const RecipientsScreen({Key? key, required this.recipient}) : super(key: key);
  final Recipient recipient;

  static const routeName = 'recipientDetailedScreen';

  @override
  ConsumerState createState() => _RecipientsScreenState();
}

class _RecipientsScreenState extends ConsumerState<RecipientsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipientScreenStateNotifier.notifier)
          .fetchRecipient(widget.recipient);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Recipient',
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: true,
        trailingLabel: 'Delete Recipient',
        trailingOnPress: (choice) {
          PlatformAware.platformDialog(
            context: context,
            child: PlatformAlertDialog(
              title: 'Delete Recipient',
              content: AnonAddyString.deleteRecipientConfirmation,
              method: () async {
                await ref
                    .read(recipientScreenStateNotifier.notifier)
                    .removeRecipient(widget.recipient);

                /// Dismisses this dialog
                if (mounted) Navigator.pop(context);

                /// Dismisses [RecipientScreen] after recipient deletion
                if (mounted) Navigator.pop(context);
              },
            ),
          );
        },
      ),
      body: Consumer(
        builder: (context, watch, _) {
          final recipientScreenState = ref.watch(recipientScreenStateNotifier);

          switch (recipientScreenState.status) {
            case RecipientScreenStatus.loading:
              return const Center(child: PlatformLoadingIndicator());

            case RecipientScreenStatus.loaded:
              return buildListView(context, recipientScreenState);

            case RecipientScreenStatus.failed:
              final error = recipientScreenState.errorMessage;
              return LottieWidget(
                lottie: LottieImages.errorCone,
                label: error,
              );
          }
        },
      ),
    );
  }

  Widget buildListView(
      BuildContext context, RecipientScreenState recipientScreenState) {
    final recipient = recipientScreenState.recipient;

    final recipientProvider = ref.read(recipientScreenStateNotifier.notifier);
    final size = MediaQuery.of(context).size;

    final List<int> forwardedList = [];
    final List<int> blockedList = [];
    final List<int> repliedList = [];
    final List<int> sentList = [];

    if (recipient.aliases.isNotEmpty) {
      for (Alias alias in recipient.aliases) {
        forwardedList.add(alias.emailsForwarded);
        blockedList.add(alias.emailsBlocked);
        repliedList.add(alias.emailsReplied);
        sentList.add(alias.emailsSent);
      }
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        if (recipientScreenState.isOffline) const OfflineBanner(),
        if (recipient.aliases.isEmpty || recipient.emailVerifiedAt.isEmpty)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: SvgPicture.asset(
              'assets/images/envelope.svg',
              height: size.height * 0.22,
            ),
          )
        else
          AliasScreenPieChart(
            emailsForwarded: NicheMethod.reduceListElements(forwardedList),
            emailsBlocked: NicheMethod.reduceListElements(blockedList),
            emailsReplied: NicheMethod.reduceListElements(repliedList),
            emailsSent: NicheMethod.reduceListElements(sentList),
          ),
        Divider(height: size.height * 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
          child: Text('Actions', style: Theme.of(context).textTheme.headline6),
        ),
        RecipientScreenActionsListTile(
          leadingIconData: Icons.email_outlined,
          title: recipient.email,
          subtitle: 'Recipient Email',
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => NicheMethod.copyOnTap(recipient.email),
          ),
        ),
        RecipientScreenActionsListTile(
          leadingIconData: Icons.fingerprint_outlined,
          title: recipient.fingerprint.isEmpty
              ? 'No fingerprint found'
              : recipient.fingerprint,
          subtitle: 'GPG Key Fingerprint',
          trailing: recipient.fingerprint.isEmpty
              ? IconButton(
                  icon: const Icon(Icons.add_circle_outline_outlined),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                AppTheme.kBottomSheetBorderRadius)),
                      ),
                      builder: (context) =>
                          RecipientAddPgpKey(recipient: recipient),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () => buildRemovePGPKeyDialog(context, recipient),
                ),
        ),
        RecipientScreenActionsListTile(
          leadingIconData:
              recipient.shouldEncrypt ? Icons.lock : Icons.lock_open,
          leadingIconColor: recipient.shouldEncrypt ? Colors.green : null,
          title: recipient.shouldEncrypt ? 'Encrypted' : 'Not Encrypted',
          subtitle: 'Encryption',
          trailing: recipient.fingerprint.isEmpty
              ? Container()
              : RecipientScreenTrailingLoadingSwitch(
                  isLoading: recipientScreenState.isEncryptionToggleLoading,
                  switchValue: recipientScreenState.recipient.shouldEncrypt,
                  onPress: (toggle) async {
                    recipient.shouldEncrypt
                        ? await recipientProvider.disableEncryption(recipient)
                        : await recipientProvider.enableEncryption(recipient);
                  },
                ),
        ),
        recipient.emailVerifiedAt.isEmpty
            ? RecipientScreenActionsListTile(
                leadingIconData: Icons.verified_outlined,
                title: recipient.emailVerifiedAt.isEmpty ? 'No' : 'Yes',
                subtitle: 'Is Email Verified?',
                trailing: TextButton(
                  child: const Text('Verify now!'),
                  onPressed: () {},
                ),
              )
            : Container(),
        if (recipient.aliases.isEmpty)
          Container()
        else if (recipient.emailVerifiedAt.isEmpty)
          buildUnverifiedEmailWarning(size)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: size.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
                child: Text('Aliases',
                    style: Theme.of(context).textTheme.headline6),
              ),
              SizedBox(height: size.height * 0.01),
              if (recipient.aliases.isEmpty)
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.01),
                    child: const Text('No aliases found'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipient.aliases.length,
                  itemBuilder: (context, index) {
                    return AliasListTile(
                      alias: recipient.aliases[index],
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
              dateTime: recipient.createdAt.toString(),
            ),
            AliasCreatedAtWidget(
              label: 'Updated:',
              dateTime: recipient.updatedAt.toString(),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.03),
      ],
    );
  }

  Container buildUnverifiedEmailWarning(Size size) {
    return Container(
      height: size.height * 0.05,
      width: double.infinity,
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined, color: Colors.black),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              AppStrings.unverifiedRecipientNote,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(),
        ],
      ),
    );
  }

  void buildRemovePGPKeyDialog(BuildContext context, Recipient recipient) {
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: 'Remove Public Key',
        content: AnonAddyString.removeRecipientPublicKeyConfirmation,
        method: () async {
          await ref
              .read(recipientScreenStateNotifier.notifier)
              .removePublicGPGKey(recipient);

          /// Dismisses this dialog
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }
}
