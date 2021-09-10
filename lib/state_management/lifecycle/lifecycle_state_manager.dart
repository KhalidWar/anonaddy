import 'dart:developer';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

final lifecycleStateProvider =
    StateNotifierProvider<LifecycleState, LifecycleStatus>((ref) {
  final state = ref.watch(lifecycleState);
  return state;
});

enum LifecycleStatus { foreground, background }

class LifecycleState extends StateNotifier<LifecycleStatus> {
  LifecycleState() : super(LifecycleStatus.foreground);

  void setLifecycleState(AppLifecycleState status) {
    switch (status) {
      case AppLifecycleState.resumed:
        state = LifecycleStatus.foreground;
        break;

      case AppLifecycleState.inactive:
        state = LifecycleStatus.background;
        break;

      case AppLifecycleState.paused:
        state = LifecycleStatus.background;
        break;

      case AppLifecycleState.detached:
        state = LifecycleStatus.background;
        break;
    }
    log('LifecycleStatus: ' + state.toString());
  }
}
