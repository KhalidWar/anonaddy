import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/search/search_history/search_history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchService extends SearchDelegate {
  SearchService(this.searchAliasList);
  List<Alias> searchAliasList;

  void _searchAliases(List<Alias> resultsList) {
    searchAliasList.forEach((element) {
      final filterByEmail =
          element.email.toLowerCase().contains(query.toLowerCase());

      if (element.description == null) {
        if (filterByEmail) {
          resultsList.add(element);
        }
      } else {
        final filterByDescription =
            element.description!.toLowerCase().contains(query.toLowerCase());

        if (filterByEmail || filterByDescription) {
          resultsList.add(element);
        }
      }
    });
  }

  Widget _buildResult(List<Alias> resultsList) {
    if (query.isEmpty)
      return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 20),
        child: Text(kSearchAliasByEmailOrDesc),
      );
    else if (resultsList.isEmpty)
      return LottieWidget(
        lottie: 'assets/lottie/empty.json',
        lottieHeight: 150,
      );
    else
      return Scrollbar(
        child: ListView.builder(
          itemCount: resultsList.length,
          itemBuilder: (context, index) {
            final alias = resultsList[index];
            return InkWell(
              child: IgnorePointer(
                child: AliasListTile(aliasData: alias),
              ),
              onTap: () {
                context
                    .read(searchHistoryStateNotifier.notifier)
                    .addAliasToSearchHistory(alias);
                Navigator.pushNamed(
                  context,
                  AliasScreen.routeName,
                  arguments: alias,
                );
              },
            );
          },
        ),
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
    final resultsList = <Alias>[];

    _searchAliases(resultsList);
    return _buildResult(resultsList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final resultsList = <Alias>[];

    _searchAliases(resultsList);
    return _buildResult(resultsList);
  }
}
