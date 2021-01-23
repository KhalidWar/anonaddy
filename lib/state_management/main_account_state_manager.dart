import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';

final mainAccountProvider =
    ChangeNotifierProvider((ref) => MainAccountStateManager());

class MainAccountStateManager extends ChangeNotifier {
  String accountUsername;
}
