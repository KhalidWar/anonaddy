import 'domain_data_model.dart';

class DomainModel {
  const DomainModel({this.domainDataList});

  final List<DomainDataModel>? domainDataList;

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<DomainDataModel> aliasDataList =
        list.map((i) => DomainDataModel.fromJson(i)).toList();

    return DomainModel(
      domainDataList: aliasDataList,
    );
  }
}
