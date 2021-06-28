import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/screens/alias_tab/alias_detailed_screen.dart';
import 'package:anonaddy/services/data_storage/search_history_storage.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchService extends SearchDelegate {
  SearchService(this.searchAliasList);
  final List<AliasDataModel> searchAliasList;

  void _searchAliases(List<AliasDataModel> resultAliasList) {
    searchAliasList.forEach((element) {
      final filterByEmail =
          element.email.toLowerCase().contains(query.toLowerCase());
      final filterByDescription =
          element.emailDescription.toLowerCase().contains(query.toLowerCase());

      if (filterByEmail || filterByDescription) {
        resultAliasList.add(element);
      }
    });
  }

  Widget _buildResult(List<AliasDataModel> resultAliasList) {
    if (query.isEmpty)
      return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 20),
        child: Text(kSearchAliasByEmailOrDesc),
      );
    else if (resultAliasList.isEmpty)
      return LottieWidget(
        lottie: 'assets/lottie/empty.json',
        lottieHeight: 150,
      );
    else
      return ListView.builder(
        itemCount: resultAliasList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: IgnorePointer(
              child: AliasListTile(aliasData: resultAliasList[index]),
            ),
            onTap: () {
              SearchHistoryStorage.getAliasBoxes().add(resultAliasList[index]);
              context.read(aliasStateManagerProvider).aliasDataModel =
                  resultAliasList[index];
              Navigator.push(context, CustomPageRoute(AliasDetailScreen()));
            },
          );
        },
      );
  }

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
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<AliasDataModel> resultAliasList = [];

    _searchAliases(resultAliasList);
    return _buildResult(resultAliasList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<AliasDataModel> resultAliasList = [];

    _searchAliases(resultAliasList);
    return _buildResult(resultAliasList);
  }
}
