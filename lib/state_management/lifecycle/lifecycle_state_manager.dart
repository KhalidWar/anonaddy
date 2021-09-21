import 'dart:developer';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final lifecycleStateNotifier =
    StateNotifierProvider<LifecycleState, LifecycleStatus>((ref) {
  return LifecycleState();
});

enum LifecycleStatus { foreground, background }

class LifecycleState extends StateNotifier<LifecycleStatus> {
  LifecycleState() : super(LifecycleStatus.foreground);

  void setLifecycleState(AppLifecycleState status) {
    log('AppLifecycleState: ' + state.toString());

    if (status == AppLifecycleState.resumed) {
      state = LifecycleStatus.foreground;
    } else {
      state = LifecycleStatus.background;
    }
  }
}
