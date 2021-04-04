import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/shared_components/alias_list_tile.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/loading_indicator.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTab extends StatelessWidget {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search History',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    TextButton(
                      child: Text('Clear'),
                      onPressed: () => context
                          .read(searchHistoryProvider)
                          .clearSearchHistory(context),
                    ),
                  ],
                ),
                Divider(),
                Consumer(
                  builder: (_, watch, __) {
                    final search = watch(searchHistoryFuture);
                    return search.when(
                      loading: () => LoadingIndicator(),
                      data: (data) {
                        if (data.isEmpty)
                          return buildEmptyListWidget();
                        else
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return AliasListTile(aliasData: data[index]);
                            },
                          );
                      },
                      error: (error, stackTrace) {
                        return LottieWidget(
                          lottie: 'assets/lottie/errorCone.json',
                          lottieHeight: size.height * 0.3,
                          label: error.toString(),
                        );
                      },
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
