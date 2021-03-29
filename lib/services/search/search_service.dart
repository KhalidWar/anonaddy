import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:flutter/material.dart';

class SearchService extends SearchDelegate {
  SearchService(this.searchAliasList);
  final List<AliasDataModel> searchAliasList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isEmpty
          ? Container()
          : IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<AliasDataModel> resultAliasList = [];

    searchAliasList.forEach((element) {
      if (element.email.toLowerCase().contains(query.toLowerCase()) ||
          element.emailDescription
              .toLowerCase()
              .contains(query.toLowerCase())) {
        resultAliasList.add(element);
      }
    });

    final List<AliasDataModel> initialList =
        query.isEmpty ? [] : resultAliasList;

    return ListView.builder(
      itemCount: initialList.length,
      itemBuilder: (context, index) {
        // context
        //       .read(aliasStateManagerProvider)
        //       .recentSearchesList
        //       .add(aliasData);
        return AliasListTile(aliasData: initialList[index]);
      },
    );
  }
}
