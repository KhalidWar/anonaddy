import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/aliases/presentation/controller/fab_visibility_state.dart';
import 'package:anonaddy/features/create_alias/presentation/create_alias.dart';
import 'package:anonaddy/features/home/presentation/components/animated_fab.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateAliasFAB extends StatelessWidget {
  const CreateAliasFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final showFab = ref.watch(fabVisibilityStateNotifier);

        return AnimatedFab(
          showFab: showFab,
          child: FloatingActionButton(
            key: const Key('homeScreenFAB'),
            child: const Icon(Icons.add),
            onPressed: () {
              final accountState = ref.read(accountNotifierProvider);

              accountState.when(
                data: (account) {
                  showCupertinoModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
                      ),
                    ),
                    builder: (context) => const CreateAlias(),
                  );
                },
                error: (err, stack) {
                  NicheMethod.showToast(AppStrings.loadAccountDataFailed);
                },
                loading: () {
                  NicheMethod.showToast(AppStrings.loadingText);
                },
              );
            },
          ),
        );
      },
    );
  }
}
