import 'alias_data_model.dart';

class AliasModel {
  AliasModel({this.aliasDataList});

  final List<AliasDataModel> aliasDataList;

  factory AliasModel.fromJson(Map<String, Object> json) {
    List list = json['data'] as List;
    List<AliasDataModel> aliasDataList =
        list.map((i) => AliasDataModel.fromJson(i)).toList();

    return AliasModel(
      aliasDataList: aliasDataList,
    );
  }
}
