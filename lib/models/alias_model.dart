import 'alias_data.dart';

class AliasModel {
  AliasModel({
    this.aliasDataList,
  });

  final List<AliasData> aliasDataList;

  factory AliasModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<AliasData> aliasDataList =
        list.map((i) => AliasData.fromJson(i)).toList();

    return AliasModel(
      aliasDataList: aliasDataList,
    );
  }
}
