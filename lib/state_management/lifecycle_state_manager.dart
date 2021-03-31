import 'package:flutter/cupertino.dart';

class LifecycleStateManager extends ChangeNotifier {
  LifecycleStateManager({this.isAppInForeground = true});

  bool isAppInForeground;

  void setForegroundState(bool input) {
    isAppInForeground = input;
    notifyListeners();
  }
}
