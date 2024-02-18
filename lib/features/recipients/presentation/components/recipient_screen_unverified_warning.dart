import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientScreenUnverifiedWarning extends ConsumerWidget {
  const RecipientScreenUnverifiedWarning({
    Key? key,
    required this.recipientId,
  }) : super(key: key);

  final String recipientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipientScreenAsync =
        ref.watch(recipientScreenNotifierProvider(recipientId));

    return recipientScreenAsync.when(
      data: (recipientScreenState) {
        final recipient = recipientScreenState.recipient;

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
                      .read(
                          recipientScreenNotifierProvider(recipientId).notifier)
                      .resendVerificationEmail(),
                ),
              ],
            ),
          );
        }
        return Container();
      },
      error: (error, stack) => Container(),
      loading: () => Container(),
    );
  }
}
