import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';

class AliasFormatSelection extends StatelessWidget {
  const AliasFormatSelection({required this.aliasFormatList});
  final List<String> aliasFormatList;

  @override
  Widget build(BuildContext context) {
    final aliasStateProvider = context.read(aliasStateManagerProvider);
    final correctAliasString = context.read(nicheMethods).correctAliasString;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomSheetHeader(headerLabel: 'Select Alias Format'),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: controller,
                children: [
                  if (aliasFormatList.isEmpty)
                    Center(
                      child: Text(
                        'No alias format found',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: aliasFormatList.length,
                      itemBuilder: (context, index) {
                        final format = aliasFormatList[index];
                        return ListTile(
                          dense: true,
                          selectedTileColor: kAccentColor,
                          horizontalTitleGap: 0,
                          title: Text(
                            correctAliasString(format),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          onTap: () {
                            aliasStateProvider.setAliasFormat = format;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
