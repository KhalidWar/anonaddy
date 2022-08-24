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
    final size = MediaQuery.of(context).size;

    final recipientScreenState = ref.watch(recipientScreenStateNotifier);

    if (recipientScreenState.recipient.emailVerifiedAt.isEmpty) {
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
    return Container();
  }
}
