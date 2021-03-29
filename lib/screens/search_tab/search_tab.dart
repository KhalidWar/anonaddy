import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class SearchTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final recentSearch =
        context.read(aliasStateManagerProvider).recentSearchesList;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: TextFormField(
                enabled: false,
                decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Search',
                ),
              ),
              onTap: () {
                final aliasManager = context.read(aliasStateManagerProvider);
                showSearch(
                  context: context,
                  delegate: SearchService([
                    ...aliasManager.availableAliasList,
                    ...aliasManager.deletedAliasList,
                  ]),
                );
              },
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              'Recent Search',
              style: Theme.of(context).textTheme.headline6,
            ),
            if (recentSearch == null)
              Text('No Recent Search Found')
            else if (recentSearch.isEmpty)
              Text('No Recent Search Found')
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
    );
  }
}
