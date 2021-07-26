import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasDomainSelection extends StatelessWidget {
  const AliasDomainSelection(
      {required this.aliasFormatList, required this.domainOptions});
  final List<String> aliasFormatList;
  final DomainOptions domainOptions;

  @override
  Widget build(BuildContext context) {
    final aliasStateProvider = context.read(aliasStateManagerProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    int aliasDomainIndex = 0;

    void setAliasDomain() {
      final selectedDomain = domainOptions.domains[aliasDomainIndex];
      aliasStateProvider.setAliasDomain = selectedDomain;
      if (aliasStateProvider.sharedDomains.contains(selectedDomain)) {
        aliasStateProvider.setAliasFormat = aliasFormatList[0];
      } else {
        aliasStateProvider.setAliasFormat = domainOptions.defaultAliasFormat;
      }
      Navigator.pop(context);
    }

    return Column(
      children: [
        BottomSheetHeader(headerLabel: 'Select Alias Domain'),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 50,
            diameterRatio: 10,
            squeeze: 1,
            selectionOverlay: Container(),
            backgroundColor: Colors.transparent,
            onSelectedItemChanged: (index) {
              aliasDomainIndex = index;
            },
            children: domainOptions.domains.map<Widget>((value) {
              return Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : null,
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(),
            child: Text('Done'),
            onPressed: () => setAliasDomain(),
          ),
        ),
      ],
    );
  }
}
