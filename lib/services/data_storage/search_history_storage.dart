import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class SearchHistoryStorage extends ChangeNotifier {
  static Box<AliasDataModel> getAliasBoxes() {
    return Hive.box<AliasDataModel>('searchHistoryBox');
  }
}
