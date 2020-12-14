import 'package:anonaddy/models/username/username_data_model.dart';

class UsernameModel {
  const UsernameModel({this.usernameDataList});

  final List<UsernameDataModel> usernameDataList;

  factory UsernameModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<UsernameDataModel> usernameDataList =
        list.map((i) => UsernameDataModel.fromJson(i)).toList();

    return UsernameModel(
      usernameDataList: usernameDataList,
    );
  }
}
