import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../constants.dart';
import 'alias_detailed_screen.dart';
import 'alias_list_tile.dart';

class DeletedAliasesScreen extends StatelessWidget {
  const DeletedAliasesScreen({Key key, this.aliasDataModel}) : super(key: key);

  final List<AliasDataModel> aliasDataModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aliasDataProvider = context.read(aliasStateManagerProvider);

    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kDeletedAliasText),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        Text('Total Aliases deleted'),
                        Spacer(),
                        Text(
                          '${aliasDataModel.length}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: Icon(Icons.list_alt),
                title: Text('Load full list'),
                initiallyExpanded: false,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: aliasDataModel.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          aliasDataProvider.aliasDataModel =
                              aliasDataModel[index];
                          aliasDataProvider.setSwitchValue(
                              aliasDataModel[index].isAliasActive);
                          Navigator.push(
                            context,
                            buildPageRoute(AliasDetailScreen()),
                          );
                        },
                        child: AliasListTile(
                          aliasData: aliasDataModel[index],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
      child: AppBar(
        title: Text(
          'Deleted Aliases List',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              final aliasStateManager = context.read(aliasStateManagerProvider);

              showSearch(
                context: context,
                delegate: SearchService(
                  [
                    ...aliasStateManager.availableAliasList,
                    ...aliasStateManager.deletedAliasList,
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  PageRouteBuilder buildPageRoute(Widget child) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondAnimation, child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);

        return SlideTransition(
          position: Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondAnimation) {
        return child;
      },
    );
  }
}
