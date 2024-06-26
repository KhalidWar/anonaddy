import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/features/recipients/domain/recipient.dart';
import 'package:anonaddy/features/recipients/presentation/controller/recipient_screen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipientScreenUnverifiedWarning extends ConsumerWidget {
  const RecipientScreenUnverifiedWarning({
    super.key,
    required this.recipientId,
  });

  final String recipientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipientScreenAsync =
        ref.watch(recipientScreenNotifierProvider(recipientId));

    return recipientScreenAsync.when(
      data: (recipientScreenState) {
        final recipient = recipientScreenState.recipient;

        if (!recipient.isVerified) {
          return Container(
            color: Colors.amber,
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_outlined, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.unverifiedRecipientNote,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                TextButton(
                  child: const Text('Verify!'),
                  onPressed: () => ref
                      .read(recipientScreenNotifierProvider(recipient.id)
                          .notifier)
                      .resendVerificationEmail(),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
      error: (error, stack) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
