import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/shared_components/constants/official_anonaddy_strings.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:flutter/material.dart';

class DeletedAliasesScreen extends StatelessWidget {
  const DeletedAliasesScreen(this.aliasDataModel);

  final List<Alias> aliasDataModel;

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
                    Text(kDeleteAliasString),
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

  PreferredSizeWidget buildAppBar(BuildContext context) {
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
}
