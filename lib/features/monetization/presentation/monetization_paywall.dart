import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_button.dart';
import 'package:anonaddy/common/platform_aware_widgets/platform_loading_indicator.dart';
import 'package:anonaddy/common/shimmer_effects/shimmering_list_tile.dart';
import 'package:anonaddy/features/monetization/presentation/controller/monetization_notifier.dart';
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
            ? const ShimmeringListTile()
            : const SizedBox(
                height: 200,
                width: 200,
                child: PlatformLoadingIndicator(),
              );
      },
    );
  }
}
