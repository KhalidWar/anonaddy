import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lifecycleStateManagerProvider =
    ChangeNotifierProvider((ref) => LifecycleStateManager());

class LifecycleStateManager extends ChangeNotifier {
  LifecycleStateManager({this.isAppInForeground = true});

  bool isAppInForeground;

  void setForegroundState(bool input) {
    isAppInForeground = input;
    notifyListeners();
  }
}
