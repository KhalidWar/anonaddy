import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global_providers.dart';

class AliasDomainSelection extends StatelessWidget {
  const AliasDomainSelection(
      {required this.aliasFormatList, required this.domainOptions});
  final List<String> aliasFormatList;
  final DomainOptions domainOptions;

  void setAliasDomain(BuildContext context, String selectedDomain) {
    final aliasStateProvider = context.read(aliasStateManagerProvider);
    aliasStateProvider.setAliasDomain = selectedDomain;

    if (aliasStateProvider.sharedDomains.contains(selectedDomain)) {
      aliasStateProvider.setAliasFormat = aliasFormatList[0];
    } else {
      aliasStateProvider.setAliasFormat = domainOptions.defaultAliasFormat;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomSheetHeader(headerLabel: 'Select Alias Domain'),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  shrinkWrap: true,
                  controller: controller,
                  physics: BouncingScrollPhysics(),
                  children: [
                    if (domainOptions.domains.isEmpty)
                      Center(
                        child: Text(
                          'No alias domain found',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: domainOptions.domains.length,
                        itemBuilder: (context, index) {
                          final domain = domainOptions.domains[index];
                          return ListTile(
                            dense: true,
                            selectedTileColor: kAccentColor,
                            horizontalTitleGap: 0,
                            title: Text(
                              domain,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            onTap: () => setAliasDomain(context, domain),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
          ],
        );
      },
    );
  }
}
