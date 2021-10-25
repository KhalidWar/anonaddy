import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/platform_aware_widgets/platform_alias_tab.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_notifier.dart';
import 'package:anonaddy/state_management/alias_state/alias_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/alias_shimmer_loading.dart';

class AliasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasTabState = watch(aliasTabStateNotifier);

    switch (aliasTabState.status) {
      case AliasTabStatus.loading:
        return AliasShimmerLoading();

      case AliasTabStatus.loaded:
        return const PlatformAliasTab();

      case AliasTabStatus.failed:
        final error = aliasTabState.errorMessage!;
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          label: error.toString(),
        );
    }
  }
}
