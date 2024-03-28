import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_screen_notifier.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomainDefaultRecipient extends ConsumerStatefulWidget {
  const DomainDefaultRecipient({
    Key? key,
    required this.domain,
  }) : super(key: key);
  final Domain domain;

  @override
  ConsumerState createState() => _DomainDefaultRecipientState();
}

class _DomainDefaultRecipientState
    extends ConsumerState<DomainDefaultRecipient> {
  final _verifiedRecipients = <Recipient>[];
  Recipient? selectedRecipient;

  late double initialChildSize;
  late double maxChildSize;

  void _toggleRecipient(Recipient verifiedRecipient) {
    if (selectedRecipient == null) {
      selectedRecipient = verifiedRecipient;
    } else {
      if (verifiedRecipient.email == selectedRecipient!.email) {
        selectedRecipient = null;
      } else {
        selectedRecipient = verifiedRecipient;
      }
    }
  }

  bool _isDefaultRecipient(Recipient verifiedRecipient) {
    if (selectedRecipient == null) {
      return false;
    } else {
      if (verifiedRecipient.email == selectedRecipient!.email) {
        return true;
      }
      return false;
    }
  }

  void _setVerifiedRecipients() {
    final recipients = ref.read(recipientsNotifierProvider).value!;
    final verifiedRecipients =
        recipients.where((recipient) => recipient.isVerified).toList();
    _verifiedRecipients.addAll(verifiedRecipients);
  }

  void _setDefaultRecipient() {
    final defaultRecipient = widget.domain.defaultRecipient;
    for (Recipient verifiedRecipient in _verifiedRecipients) {
      if (defaultRecipient == null) {
        selectedRecipient = null;
      } else {
        if (defaultRecipient.email == verifiedRecipient.email) {
          selectedRecipient = verifiedRecipient;
        }
      }
    }
  }

  Future<void> updateDefaultRecipient() async {
    await ref
        .read(domainsScreenStateNotifier(widget.domain.id).notifier)
        .updateDomainDefaultRecipients(widget.domain.id, selectedRecipient?.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _setVerifiedRecipients();
    _setDefaultRecipient();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        if (_verifiedRecipients.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text('No recipients found'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _verifiedRecipients.length,
            itemBuilder: (context, index) {
              final verifiedRecipient = _verifiedRecipients[index];
              return ListTile(
                selected: _isDefaultRecipient(verifiedRecipient),
                selectedTileColor: AppColors.accentColor,
                horizontalTitleGap: 0,
                title: Text(
                  verifiedRecipient.email,
                  style: TextStyle(
                    color: _isDefaultRecipient(verifiedRecipient)
                        ? Colors.black
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _toggleRecipient(verifiedRecipient);
                  });
                },
              );
            },
          ),
        const Divider(height: 0),
        const SizedBox(height: 16),
        Text(
          AppStrings.updateAliasRecipientNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: PlatformButton(
            child: Consumer(
              builder: (context, ref, _) {
                final isLoading = ref
                    .watch(domainsScreenStateNotifier(widget.domain.id))
                    .value!
                    .updateRecipientLoading;

                return isLoading
                    ? const PlatformLoadingIndicator()
                    : const Text(
                        'Update Default Recipient',
                        style: TextStyle(color: Colors.black),
                      );
              },
            ),
            onPress: () async => await updateDefaultRecipient(),
          ),
        ),
      ],
    );
  }
}
