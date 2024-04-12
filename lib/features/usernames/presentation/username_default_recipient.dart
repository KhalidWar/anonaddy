import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipients_notifier.dart';
import 'package:anonaddy/features/usernames/domain/username.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_screen_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameDefaultRecipientScreen extends ConsumerStatefulWidget {
  const UsernameDefaultRecipientScreen({
    super.key,
    required this.username,
  });

  final Username username;

  @override
  ConsumerState createState() => _UsernameDefaultRecipientState();
}

class _UsernameDefaultRecipientState
    extends ConsumerState<UsernameDefaultRecipientScreen> {
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
    for (Recipient recipient in recipients) {
      if (recipient.isVerified) {
        _verifiedRecipients.add(recipient);
      }
    }
  }

  void _setDefaultRecipient() {
    final defaultRecipient = widget.username.defaultRecipient;
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
          Center(
            child: Text(
              'No recipients found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 0),
              SizedBox(height: 16),
              Text(AppStrings.updateAliasRecipientNote),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: PlatformButton(
            child: Consumer(
              builder: (context, ref, _) {
                final isLoading = ref
                    .watch(usernamesScreenNotifierProvider(widget.username.id))
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
            onPress: () async {
              await ref
                  .read(usernamesScreenNotifierProvider(widget.username.id)
                      .notifier)
                  .updateDefaultRecipient(
                      widget.username, selectedRecipient?.id);
              if (mounted) Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
