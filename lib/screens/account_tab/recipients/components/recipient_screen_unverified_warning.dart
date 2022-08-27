import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/state_management/recipient/recipient_screen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientScreenUnverifiedWarning extends ConsumerWidget {
  const RecipientScreenUnverifiedWarning({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipient = ref.watch(recipientScreenStateNotifier).recipient;

    if (recipient.emailVerifiedAt.isEmpty) {
      return Container(
        color: Colors.amber,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppStrings.unverifiedRecipientNote,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Colors.black),
              ),
            ),
            TextButton(
              child: const Text('Verify!'),
              onPressed: () => ref
                  .read(recipientScreenStateNotifier.notifier)
                  .resendVerificationEmail(),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
