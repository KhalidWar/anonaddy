import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasFormatSelection extends StatelessWidget {
  const AliasFormatSelection({required this.aliasFormatList});
  final List<String> aliasFormatList;

  @override
  Widget build(BuildContext context) {
    final aliasStateProvider = context.read(aliasStateManagerProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    int aliasFormatIndex = 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BottomSheetHeader(headerLabel: 'Select Alias Format'),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 50,
            diameterRatio: 10,
            squeeze: 1,
            selectionOverlay: Container(),
            useMagnifier: false,
            backgroundColor: Colors.transparent,
            onSelectedItemChanged: (index) {
              aliasFormatIndex = index;
            },
            children: aliasFormatList.map<Widget>((value) {
              return Text(
                aliasStateProvider.correctAliasString(value)!,
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
            onPressed: () {
              aliasStateProvider.setAliasFormat =
                  aliasFormatList[aliasFormatIndex];
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
