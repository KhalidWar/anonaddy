import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

final fabVisibilityStateNotifier =
    StateNotifierProvider.autoDispose<FabVisibilityState, bool>((ref) {
  final fabStateProvider = ref.read(fabVisibilityStateProvider);

  ref.onDispose(() {
    fabStateProvider.aliasController.dispose();
    fabStateProvider.searchController.dispose();
  });

  return fabStateProvider;
});

class FabVisibilityState extends StateNotifier<bool> {
  FabVisibilityState(ScrollController aliasTabController, searchTabController)
      : aliasController = aliasTabController,
        searchController = searchTabController,
        super(true) {
    addListeners(aliasController);
    addListeners(searchController);
  }

  late final ScrollController aliasController;
  late final ScrollController searchController;

  void showFab() {
    if (state == false) state = true;
  }

  void addListeners(ScrollController controller) {
    controller.addListener(() {
      switch (controller.position.userScrollDirection) {
        case ScrollDirection.idle:
          state = true;
          break;
        case ScrollDirection.forward:
          state = true;
          break;
        case ScrollDirection.reverse:
          state = false;
          break;
      }
    });
  }
}
