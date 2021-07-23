import 'package:anonaddy/models/recipient/recipient_data_model.dart';

class RecipientModel {
  const RecipientModel({this.recipientDataList});

  final List<RecipientDataModel>? recipientDataList;

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    List list = json['data'];
    List<RecipientDataModel> recipientDataModel =
        list.map((i) => RecipientDataModel.fromJson(i)).toList();

    return RecipientModel(
      recipientDataList: recipientDataModel,
    );
  }
}
