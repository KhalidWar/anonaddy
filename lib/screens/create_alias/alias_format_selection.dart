import 'package:anonaddy/notifiers/create_alias/create_alias_notifier.dart';
import 'package:anonaddy/notifiers/create_alias/create_alias_state.dart';
import 'package:anonaddy/shared_components/bottom_sheet_header.dart';
import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasFormatSelection extends ConsumerWidget {
  const AliasFormatSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aliasFormatList =
        ref.read(createAliasStateNotifier).aliasFormatList ??
            CreateAliasState.paidTierNoSharedDomain;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BottomSheetHeader(headerLabel: 'Select Alias Format'),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                controller: controller,
                physics: const BouncingScrollPhysics(),
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: aliasFormatList.length,
                      itemBuilder: (context, index) {
                        final format = aliasFormatList[index];
                        return ListTile(
                          dense: true,
                          selectedTileColor: AppColors.accentColor,
                          horizontalTitleGap: 0,
                          title: Text(
                            Utilities.correctAliasString(format),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          onTap: () {
                            ref
                                .read(createAliasStateNotifier.notifier)
                                .setAliasFormat(format);
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
