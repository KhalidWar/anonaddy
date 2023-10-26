import 'package:anonaddy/notifiers/account/account_notifier.dart';
import 'package:anonaddy/notifiers/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/notifiers/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/screens/create_alias/create_alias.dart';
import 'package:anonaddy/screens/home_screen/components/animated_fab.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateAliasFAB extends ConsumerStatefulWidget {
  const CreateAliasFAB({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _CreateAliasFABState();
}

class _CreateAliasFABState extends ConsumerState<CreateAliasFAB> {
  @override
  void initState() {
    super.initState();

    /// Pre-loads [DomainOptions] data for [CreateAlias]
    ref.read(domainOptionsNotifier.notifier).fetchDomainOption();
  }

  @override
  Widget build(BuildContext context) {
    final showFab = ref.watch(fabVisibilityStateNotifier);

    return AnimatedFab(
      showFab: showFab,
      child: FloatingActionButton(
        key: const Key('homeScreenFAB'),
        child: const Icon(Icons.add),
        onPressed: () {
          final accountState = ref.read(accountNotifierProvider);

          accountState.when(
            data: (data) => showCupertinoModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTheme.kBottomSheetBorderRadius),
                ),
              ),
              builder: (context) => const CreateAlias(),
            ),
            error: (err, stack) =>
                Utilities.showToast(AppStrings.loadAccountDataFailed),
            loading: () => Utilities.showToast(AppStrings.loadingText),
          );
        },
      ),
    );
  }
}
