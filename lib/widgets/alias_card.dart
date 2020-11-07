import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'alias_list_tile.dart';
import 'no_aliases_found_widget.dart';

class AliasCard extends StatefulWidget {
  const AliasCard({
    Key key,
    this.aliasDataList,
  }) : super(key: key);

  final List<AliasDataModel> aliasDataList;

  @override
  _AliasCardState createState() => _AliasCardState();
}

class _AliasCardState extends State<AliasCard> {
  bool isLoading = false;

  void deleteAlias(dynamic aliasID) async {
    setState(() => isLoading = true);
    dynamic deleteResult =
        await serviceLocator<APIService>().deleteAlias(aliasID: aliasID);
    if (deleteResult == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong. Could not delete alias.')));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Alias Successfully Deleted!')));
    }
  }

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
          isLoading ? LinearProgressIndicator() : Container(),
          widget.aliasDataList.isEmpty
              ? NoAliasesFoundWidget()
              : ListView.builder(
                  itemCount: widget.aliasDataList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: Key(widget.aliasDataList[index].toString()),
                      actionPane: SlidableStrechActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          color: Colors.red,
                          iconWidget: Icon(
                            Icons.delete,
                            size: 35,
                            color: Colors.white,
                          ),
                          onTap: () =>
                              deleteAlias(widget.aliasDataList[index].aliasID),
                        ),
                      ],
                      child: AliasListTile(
                          aliasModel: widget.aliasDataList[index]),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
