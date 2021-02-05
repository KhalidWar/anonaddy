import 'package:anonaddy/models/user/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';

final mainAccountProvider =
    ChangeNotifierProvider((ref) => MainAccountStateManager());

class MainAccountStateManager extends ChangeNotifier {
  UserModel userModel;
}
