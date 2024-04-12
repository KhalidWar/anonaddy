import 'package:anonaddy/features/monetization/presentation/controller/monetization_notifier.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/error_message_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_aware_exports.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonetizationPaywall extends ConsumerStatefulWidget {
  const MonetizationPaywall({
    super.key,
    required this.child,
    this.showListTimeShimmer = true,
  });

  final Widget child;
  final bool showListTimeShimmer;

  @override
  ConsumerState createState() => _MonetizationPaywallState();
}

class _MonetizationPaywallState extends ConsumerState<MonetizationPaywall> {
  @override
  Widget build(BuildContext context) {
    final monetizationAsync = ref.watch(monetizationNotifierProvider);

    return monetizationAsync.when(
      data: (showPaywall) {
        if (showPaywall) {
          return Container(
            height: 240,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Please upgrade to unlock this premium feature.\nYour subscriptions will help us maintain and improve this app. Thank you!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 160,
                  child: PlatformButton(
                    onPress: ref
                        .read(monetizationNotifierProvider.notifier)
                        .showPaywall,
                    child: Text(
                      'Upgrade now!',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return widget.child;
      },
      error: (_, __) => const ErrorMessageWidget(
        message: AppStrings.failedToLoadSubscriptionData,
      ),
      loading: () {
        return widget.showListTimeShimmer
            ? const RecipientsShimmerLoading()
            : const SizedBox(
                height: 200,
                width: 200,
                child: PlatformLoadingIndicator(),
              );
      },
    );
  }
}
