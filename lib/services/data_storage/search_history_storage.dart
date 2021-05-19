import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/shared_components/constants/hive_constants.dart';
import 'package:hive/hive.dart';

class SearchHistoryStorage {
  static Box<AliasDataModel> getAliasBoxes() {
    return Hive.box<AliasDataModel>(kSearchHistoryBox);
  }
}
