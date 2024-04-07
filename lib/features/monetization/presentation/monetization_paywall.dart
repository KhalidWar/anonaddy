import 'dart:ui';

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
    this.loadingWidget,
  });

  final Widget child;
  final Widget? loadingWidget;

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
          return Stack(
            fit: StackFit.loose,
            children: [
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: IgnorePointer(child: widget.child),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: PlatformButton(
                    child: Text(
                      'Show Paywall',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPress: () => ref
                        .read(monetizationNotifierProvider.notifier)
                        .showPaywall(),
                  ),
                ),
              ),
            ],
          );
        }

        return widget.child;
      },
      error: (_, __) => const ErrorMessageWidget(
        message: AppStrings.failedToLoadSubscriptionData,
      ),
      loading: () {
        return widget.loadingWidget ?? const RecipientsShimmerLoading();
      },
    );
  }
}
