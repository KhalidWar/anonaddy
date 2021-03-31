import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/alias_list_tile.dart';

class DeletedAliasesScreen extends StatelessWidget {
  const DeletedAliasesScreen({Key key, this.aliasDataModel}) : super(key: key);

  final List<AliasDataModel> aliasDataModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                      return AliasListTile(
                        aliasData: aliasDataModel[index],
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
