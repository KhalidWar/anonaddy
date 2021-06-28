import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/services/data_storage/search_history_storage.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/shared_components/list_tiles/alias_list_tile.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchTab extends StatelessWidget {
  void search(BuildContext context) {
    final aliasProvider = context.read(aliasDataStream).data;
    if (aliasProvider == null) {
      NicheMethod().showToast('Loading...');
    } else {
      showSearch(
        context: context,
        delegate: SearchService(aliasProvider.value.aliasDataList),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: InkWell(
            child: IgnorePointer(
              child: TextFormField(
                decoration: kTextFormFieldDecoration.copyWith(
                  hintText: kSearchFieldHint,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            onTap: () => search(context),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search History',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextButton(
                child: Text('Clear'),
                onPressed: () => SearchHistoryStorage.getAliasBoxes().clear(),
              ),
            ],
          ),
        ),
        Divider(height: 0),
        ValueListenableBuilder<Box<AliasDataModel>>(
          valueListenable: SearchHistoryStorage.getAliasBoxes().listenable(),
          builder: (context, box, __) {
            final aliases = box.values.toList().cast<AliasDataModel>();

            if (aliases.isEmpty)
              return Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: Row(children: [Text('Nothing to see here.')]),
              );
            else
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: aliases.length,
                  itemBuilder: (context, index) {
                    return AliasListTile(aliasData: aliases[index]);
                  },
                ),
              );
          },
        ),
      ],
    );
  }
}
