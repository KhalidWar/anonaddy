import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/alias_list_tile.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class SearchTab extends StatelessWidget {
  final searchHistory = FutureProvider<List<AliasDataModel>>((ref) async {
    return await ref.read(storageProvider).loadData();
  });

  @override
  Widget build(BuildContext context) {
    final aliasManager = context.read(aliasStateManagerProvider);
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
                Consumer(
                  builder: (_, watch, __) {
                    final search = watch(searchHistory);
                    return search.when(
                      loading: () => LoadingIndicator(),
                      data: (data) {
                        if (data.isEmpty)
                          return buildEmptyListWidget();
                        else
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return AliasListTile(aliasData: data[index]);
                            },
                          );
                      },
                      error: (error, stackTrace) => Text(error),
                    );
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
