import 'package:anonaddy/common/constants/anonaddy_string.dart';
import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/error_message_widget.dart';
import 'package:anonaddy/common/shimmer_effects/shimmering_list_tile.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:anonaddy/features/account/presentation/controller/account_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/components/add_new_username.dart';
import 'package:anonaddy/features/usernames/presentation/controller/usernames_notifier.dart';
import 'package:anonaddy/features/usernames/presentation/username_list_tile.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@RoutePage(name: 'UsernamesTabRoute')
class UsernamesTab extends ConsumerWidget {
  const UsernamesTab({super.key});

  void addNewUsername(BuildContext context, WidgetRef ref) {
    final accountState = ref.read(accountNotifierProvider).value;
    if (accountState == null) return;

    /// Draws UI for adding new username
    Future<void> buildAddNewUsername(BuildContext context) async {
      await WoltModalSheet.show(
        context: context,
        pageListBuilder: (context) {
          return [
            Utilities.buildWoltModalSheetSubPage(
              context,
              topBarTitle: AppStrings.addNewUsername,
              child: const AddNewUsername(),
            ),
          ];
        },
      );
    }

    if (accountState.isSelfHosted) {
      buildAddNewUsername(context);
    } else {
      accountState.hasUsernamesReachedLimit
          ? Utilities.showToast(AddyString.reachedUsernameLimit)
          : buildAddNewUsername(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernamesAsync = ref.watch(usernamesNotifierProvider);

    return usernamesAsync.when(
      data: (usernames) {
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            usernames.isEmpty
                ? const ListTile(
                    title: Center(
                      child: Text(AppStrings.noAdditionalUsernamesFound),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: usernames.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return UsernameListTile(username: usernames[index]);
                    },
                  ),
            TextButton(
              child: const Text(AppStrings.addNewUsername),
              onPressed: () => addNewUsername(context, ref),
            ),
          ],
        );
      },
      error: (error, stack) {
        return ErrorMessageWidget(message: error.toString());
      },
      loading: () {
        return const ShimmeringListTile();
      },
    );
  }
}
