import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'alias_list_tile.dart';

class AliasCard extends StatelessWidget {
  const AliasCard({
    Key key,
    this.apiService,
    this.aliasDataList,
  }) : super(key: key);

  final APIService apiService;
  final List<AliasDataModel> aliasDataList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              'Aliases'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            itemCount: aliasDataList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Slidable(
                key: Key(aliasDataList[index].toString()),
                actionPane: SlidableStrechActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    color: Colors.red,
                    iconWidget: Icon(
                      Icons.delete,
                      size: 35,
                      color: Colors.white,
                    ),
                    onTap: () {
                      apiService.deleteAlias(
                          aliasID: aliasDataList[index].aliasID);
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Alias Successfully Deleted!'),
                        ),
                      );
                    },
                  ),
                ],
                child: AliasListTile(
                  apiDataManager: apiService,
                  aliasModel: aliasDataList[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
