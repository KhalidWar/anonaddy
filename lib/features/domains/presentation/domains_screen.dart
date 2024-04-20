import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/created_at_widget.dart';
import 'package:anonaddy/common/custom_app_bar.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/common/platform_aware_widgets/dialogs/platform_alert_dialog.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_aware.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_switch.dart';
import 'package:anonaddy/common/update_description_widget.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/aliases/presentation/components/alias_screen_list_tile.dart';
import 'package:anonaddy/features/associated_aliases/presentation/associated_aliases.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_screen_notifier.dart';
import 'package:anonaddy/features/domains/presentation/domain_default_recipient.dart';
import 'package:anonaddy/features/recipients/presentation/recipients_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DomainsScreen extends ConsumerStatefulWidget {
  const DomainsScreen({
    super.key,
    required this.domain,
  });

  final Domain domain;

  static const routeName = 'domainDetailedScreen';

  @override
  ConsumerState createState() => _DomainsScreenState();
}

class _DomainsScreenState extends ConsumerState<DomainsScreen> {
  Future<void> deleteDomain() async {
    PlatformAware.platformDialog(
      context: context,
      child: PlatformAlertDialog(
        title: 'Delete Domain',
        content: AddyString.deleteDomainConfirmation,
        method: () async {
          await ref
              .read(domainsScreenStateNotifier(widget.domain.id).notifier)
              .deleteDomain(widget.domain.id);
          if (mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(domainsScreenStateNotifier(widget.domain.id).notifier)
          .fetchDomain(widget.domain);
    });
  }

  @override
  Widget build(BuildContext context) {
    final domainsAsync =
        ref.watch(domainsScreenStateNotifier(widget.domain.id));

    final domainNotifier =
        ref.read(domainsScreenStateNotifier(widget.domain.id).notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Domain',
        leadingOnPress: () => Navigator.pop(context),
        showTrailing: true,
        trailingLabel: 'Delete Domain',
        trailingOnPress: (choice) => deleteDomain(),
      ),
      body: domainsAsync.when(
        data: (domainsState) {
          final domain = domainsState.domain;

          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle_outlined),
                    const SizedBox(width: 12),
                    Text(
                      domain.domain,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (domain.isVerified)
                buildUnverifiedEmailWarning(AppStrings.unverifiedDomainWarning),
              if (domain.isMXValidated)
                buildUnverifiedEmailWarning(AppStrings.invalidDomainMXWarning),
              const Divider(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  AppStrings.actions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              AliasScreenListTile(
                leadingIconData: Icons.comment_outlined,
                title: domain.hasDescription
                    ? domain.description!
                    : AppStrings.noDescription,
                subtitle: 'Domain description',
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
                              description: domain.description,
                              updateDescription: (description) async {
                                await ref
                                    .read(domainsScreenStateNotifier(
                                            widget.domain.id)
                                        .notifier)
                                    .editDescription(domain.id, description);
                              },
                              removeDescription: () async {
                                await ref
                                    .read(domainsScreenStateNotifier(
                                            widget.domain.id)
                                        .notifier)
                                    .editDescription(domain.id, '');
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
                    domain.active ? 'Domain is active' : 'Domain is inactive',
                subtitle: 'Activity',
                trailing: Row(
                  children: [
                    if (domainsState.activeSwitchLoading)
                      const PlatformLoadingIndicator(size: 20),
                    PlatformSwitch(
                      value: domain.active,
                      onChanged: (toggle) async {
                        domain.active
                            ? await domainNotifier.deactivateDomain(domain.id)
                            : await domainNotifier.activateDomain(domain.id);
                      },
                    ),
                  ],
                ),
              ),
              AliasScreenListTile(
                leadingIconData: Icons.repeat,
                title: domain.catchAll ? 'Enabled' : 'Disabled',
                subtitle: 'Catch All',
                trailing: Row(
                  children: [
                    if (domainsState.catchAllSwitchLoading)
                      const PlatformLoadingIndicator(size: 20),
                    PlatformSwitch(
                      value: domain.catchAll,
                      onChanged: (toggle) async {
                        domain.catchAll
                            ? await domainNotifier.deactivateCatchAll(domain.id)
                            : await domainNotifier.activateCatchAll(domain.id);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          'Default Recipient',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () async {
                            await WoltModalSheet.show(
                              context: context,
                              pageListBuilder: (context) {
                                return [
                                  Utilities.buildWoltModalSheetSubPage(
                                    context,
                                    topBarTitle: 'Update Default Recipient',
                                    pageTitle:
                                        AddyString.updateDomainDefaultRecipient,
                                    child: DomainDefaultRecipient(
                                      domain: domain,
                                    ),
                                  ),
                                ];
                              },
                            );
                          },
                          // buildUpdateDefaultRecipient(context, domain),
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
                      onPress: () {
                        Navigator.pushNamed(
                          context,
                          RecipientsScreen.routeName,
                          arguments: domain.defaultRecipient!.id,
                        );
                      },
                    ),
                ],
              ),
              const Divider(height: 24),
              AssociatedAliases(
                aliasesCount: domain.aliasesCount,
                params: {'domain': domain.id},
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CreatedAtWidget(
                    label: 'Created at',
                    dateTime: domain.createdAt,
                  ),
                  CreatedAtWidget(
                    label: 'Updated at',
                    dateTime: domain.updatedAt,
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, _) {
          return ErrorMessageWidget(message: error.toString());
        },
        loading: () {
          return const Center(child: PlatformLoadingIndicator());
        },
      ),
    );
  }

  Widget buildUnverifiedEmailWarning(String label) {
    return Container(
      width: double.infinity,
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_outlined, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
