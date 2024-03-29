import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/associated_aliases/presentation/associated_aliases.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/components/recipient_add_pgp_key.dart';
import 'package:anonaddy/features/recipients/presentation/components/recipient_screen_actions_list_tile.dart';
import 'package:anonaddy/features/recipients/presentation/components/recipient_screen_trailing_loading_switch.dart';
import 'package:anonaddy/features/recipients/presentation/components/recipient_screen_unverified_warning.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:anonaddy/shared_components/constants/anonaddy_string.dart';
import 'package:anonaddy/shared_components/created_at_widget.dart';
import 'package:anonaddy/shared_components/custom_app_bar.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/offline_banner.dart';
import 'package:anonaddy/shared_components/pie_chart/alias_screen_pie_chart.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RecipientsScreen extends ConsumerStatefulWidget {
  const RecipientsScreen({
    Key? key,
    required this.recipient,
  }) : super(key: key);
  final Recipient recipient;

  static const routeName = 'recipientDetailedScreen';

  @override
  ConsumerState createState() => _RecipientsScreenState();
}

class _RecipientsScreenState extends ConsumerState<RecipientsScreen> {
  List<int> calculateEmailsForwarded(List<Alias>? aliases) {
    if (aliases == null || aliases.isEmpty) return <int>[];
    return aliases.map((alias) {
      return alias.emailsForwarded;
    }).toList();
  }

  List<int> calculateEmailsBlocked(List<Alias>? aliases) {
    if (aliases == null || aliases.isEmpty) return <int>[];
    return aliases.map((alias) {
      return alias.emailsBlocked;
    }).toList();
  }

  List<int> calculateEmailsReplied(List<Alias>? aliases) {
    if (aliases == null || aliases.isEmpty) return <int>[];
    return aliases.map((alias) {
      return alias.emailsReplied;
    }).toList();
  }

  List<int> calculateEmailsSent(List<Alias>? aliases) {
    if (aliases == null || aliases.isEmpty) return <int>[];
    return aliases.map((alias) {
      return alias.emailsSent;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recipientScreenNotifierProvider(widget.recipient.id).notifier)
          .fetchSpecificRecipient(widget.recipient);
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
              content: AddyString.deleteRecipientConfirmation,
              method: () async {
                await ref
                    .read(recipientScreenNotifierProvider(widget.recipient.id)
                        .notifier)
                    .removeRecipient();

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
        builder: (context, ref, _) {
          final recipientScreenAsync =
              ref.watch(recipientScreenNotifierProvider(widget.recipient.id));

          return recipientScreenAsync.when(
            data: (recipientScreenState) {
              final recipient = recipientScreenState.recipient;

              return ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  const OfflineBanner(),
                  RecipientScreenUnverifiedWarning(recipientId: recipient.id),
                  AliasScreenPieChart(
                    emailsForwarded: Utilities.reduceListElements(
                      calculateEmailsForwarded(recipient.aliases),
                    ),
                    emailsBlocked: Utilities.reduceListElements(
                      calculateEmailsBlocked(recipient.aliases),
                    ),
                    emailsReplied: Utilities.reduceListElements(
                      calculateEmailsReplied(recipient.aliases),
                    ),
                    emailsSent: Utilities.reduceListElements(
                      calculateEmailsSent(recipient.aliases),
                    ),
                  ),
                  const Divider(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Actions',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  RecipientScreenActionsListTile(
                    leadingIconData: Icons.email_outlined,
                    title: recipient.email,
                    subtitle: 'Recipient Email',
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => Utilities.copyOnTap(recipient.email),
                    ),
                  ),
                  RecipientScreenActionsListTile(
                    leadingIconData: Icons.reply,
                    title: recipient.canReplySend ? 'Enabled' : 'Disabled',
                    subtitle: 'Can reply/send',
                    trailing: RecipientScreenTrailingLoadingSwitch(
                      isLoading:
                          recipientScreenState.isReplySendAndSwitchLoading,
                      switchValue: recipientScreenState.recipient.canReplySend,
                      onPress: (toggle) async {
                        recipient.canReplySend
                            ? await ref
                                .read(recipientScreenNotifierProvider(
                                        widget.recipient.id)
                                    .notifier)
                                .disableReplyAndSend()
                            : await ref
                                .read(recipientScreenNotifierProvider(
                                        widget.recipient.id)
                                    .notifier)
                                .enableReplyAndSend();
                      },
                    ),
                  ),
                  const Divider(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Encryption',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  RecipientScreenActionsListTile(
                    leadingIconData: Icons.fingerprint_outlined,
                    title: recipient.fingerprint == null
                        ? 'No fingerprint found'
                        : recipient.fingerprint!,
                    subtitle: 'GPG Key Fingerprint',
                    trailing: recipient.fingerprint == null
                        ? IconButton(
                            icon: const Icon(Icons.add_circle_outline_outlined),
                            onPressed: () async {
                              await WoltModalSheet.show(
                                context: context,
                                pageListBuilder: (context) {
                                  return [
                                    Utilities.buildWoltModalSheetSubPage(
                                      context,
                                      topBarTitle: 'Add GPG Key',
                                      child: RecipientAddPgpKey(
                                        recipient: recipient,
                                      ),
                                    ),
                                  ];
                                },
                              );
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              PlatformAware.platformDialog(
                                context: context,
                                child: PlatformAlertDialog(
                                  title: 'Remove Public Key',
                                  content: AddyString
                                      .removeRecipientPublicKeyConfirmation,
                                  method: () async {
                                    await ref
                                        .read(recipientScreenNotifierProvider(
                                                widget.recipient.id)
                                            .notifier)
                                        .removePublicGPGKey();

                                    /// Dismisses this dialog
                                    if (mounted) Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  RecipientScreenActionsListTile(
                    leadingIconData:
                        recipient.shouldEncrypt ? Icons.lock : Icons.lock_open,
                    leadingIconColor:
                        recipient.shouldEncrypt ? Colors.green : null,
                    title:
                        recipient.shouldEncrypt ? 'Encrypted' : 'Not Encrypted',
                    subtitle: 'Encryption',
                    trailing: RecipientScreenTrailingLoadingSwitch(
                      isLoading: recipientScreenState.isEncryptionToggleLoading,
                      switchValue: recipientScreenState.recipient.shouldEncrypt,
                      onPress: recipient.fingerprint == null
                          ? null
                          : (toggle) async {
                              recipient.shouldEncrypt
                                  ? await ref
                                      .read(recipientScreenNotifierProvider(
                                              widget.recipient.id)
                                          .notifier)
                                      .disableEncryption()
                                  : await ref
                                      .read(recipientScreenNotifierProvider(
                                              widget.recipient.id)
                                          .notifier)
                                      .enableEncryption();
                            },
                    ),
                  ),
                  RecipientScreenActionsListTile(
                    leadingIconData: recipient.inlineEncryption
                        ? Icons.enhanced_encryption
                        : Icons.enhanced_encryption_outlined,
                    leadingIconColor:
                        recipient.inlineEncryption ? Colors.green : null,
                    title: recipient.inlineEncryption ? 'Enabled' : 'Disabled',
                    subtitle: 'PGP/Inline',
                    trailing: RecipientScreenTrailingLoadingSwitch(
                      isLoading:
                          recipientScreenState.isInlineEncryptionSwitchLoading,
                      switchValue:
                          recipientScreenState.recipient.inlineEncryption,
                      onPress: recipient.fingerprint == null
                          ? null
                          : (toggle) async {
                              recipient.inlineEncryption
                                  ? await ref
                                      .read(recipientScreenNotifierProvider(
                                              widget.recipient.id)
                                          .notifier)
                                      .disableInlineEncryption()
                                  : await ref
                                      .read(recipientScreenNotifierProvider(
                                              widget.recipient.id)
                                          .notifier)
                                      .enableInlineEncryption();
                            },
                    ),
                  ),
                  RecipientScreenActionsListTile(
                    leadingIconData: Icons.subject_outlined,
                    leadingIconColor:
                        recipient.protectedHeaders ? Colors.green : null,
                    title: recipient.protectedHeaders ? 'Enabled' : 'Disabled',
                    subtitle: 'Hide Subject',
                    trailing: RecipientScreenTrailingLoadingSwitch(
                      isLoading:
                          recipientScreenState.isProtectedHeaderSwitchLoading,
                      switchValue:
                          recipientScreenState.recipient.protectedHeaders,
                      onPress: recipient.fingerprint == null
                          ? null
                          : (toggle) async {
                              recipient.protectedHeaders
                                  ? await ref
                                      .read(recipientScreenNotifierProvider(
                                              widget.recipient.id)
                                          .notifier)
                                      .disableProtectedHeader()
                                  : await ref
                                      .read(recipientScreenNotifierProvider(
                                              widget.recipient.id)
                                          .notifier)
                                      .enableProtectedHeader();
                            },
                    ),
                  ),
                  const Divider(height: 24),
                  AssociatedAliases(
                    aliasesCount: recipient.aliasesCount,
                    params: {'recipient': recipient.id},
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CreatedAtWidget(
                        label: 'Created at',
                        dateTime: recipient.createdAt,
                      ),
                      CreatedAtWidget(
                        label: 'Updated at',
                        dateTime: recipient.updatedAt,
                      ),
                    ],
                  ),
                ],
              );
            },
            error: (error, stack) {
              return ErrorMessageWidget(message: error.toString());
            },
            loading: () {
              return ListView(
                physics: const ClampingScrollPhysics(),
                children: const [
                  OfflineBanner(),
                  AliasScreenPieChart(
                    emailsForwarded: 0,
                    emailsBlocked: 0,
                    emailsReplied: 0,
                    emailsSent: 0,
                  ),
                  Divider(height: 24),
                  Center(child: PlatformLoadingIndicator())
                ],
              );
            },
          );
        },
      ),
    );
  }
}
