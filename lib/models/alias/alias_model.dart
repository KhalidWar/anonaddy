import 'alias_data_model.dart';

class AliasModel {
  const AliasModel({this.aliasDataList});

  final List<AliasDataModel> aliasDataList;

  factory AliasModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<AliasDataModel> aliasDataList =
        list.map((i) => AliasDataModel.fromJsonAliasData(i)).toList();

    return AliasModel(
      aliasDataList: aliasDataList,
    );
  }
}
