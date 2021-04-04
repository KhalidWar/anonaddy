import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/shared_components/alias_list_tile.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        close(context, context.read(searchHistoryProvider).updateUI());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final aliasState = context.read(aliasStateManagerProvider);
    List<AliasDataModel> resultAliasList = [];

    searchAliasList.forEach((element) {
      if (element.email.toLowerCase().contains(query.toLowerCase()) ||
          element.emailDescription
              .toLowerCase()
              .contains(query.toLowerCase())) {
        resultAliasList.add(element);
      }
    });

    final initialList =
        query.isEmpty ? aliasState.recentSearchesList : resultAliasList;

    return ListView.builder(
      itemCount: initialList.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: IgnorePointer(
              child: AliasListTile(aliasData: initialList[index])),
          onTap: () {
            context.read(searchHistoryProvider).saveData(initialList[index]);
            aliasState.recentSearchesList.add(initialList[index]);
            aliasState.aliasDataModel = initialList[index];
            aliasState.switchValue = initialList[index].isAliasActive;
            Navigator.push(context, CustomPageRoute(AliasDetailScreen()));
          },
        );
      },
    );
  }
}
