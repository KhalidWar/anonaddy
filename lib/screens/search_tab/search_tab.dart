import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class SearchTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aliasManager = context.read(aliasStateManagerProvider);
    final recentSearch = aliasManager.recentSearchesList;
    final availableAliasList = aliasManager.availableAliasList;
    final deletedAliasList = aliasManager.deletedAliasList;

    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: InkWell(
              child: IgnorePointer(
                child: TextFormField(
                  decoration: kTextFormFieldDecoration.copyWith(
                    hintText: kSearchHintText,
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              onTap: () {
                showSearch(
                  context: context,
                  delegate: SearchService([
                    ...availableAliasList,
                    ...deletedAliasList,
                  ]),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.082,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search History',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(),
                if (recentSearch == null)
                  buildEmptyListWidget()
                else if (recentSearch.isEmpty)
                  buildEmptyListWidget()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recentSearch.length,
                    itemBuilder: (context, index) {
                      return AliasListTile(aliasData: recentSearch[index]);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmptyListWidget() {
    return Text('Nothing to see here.');
  }
}
