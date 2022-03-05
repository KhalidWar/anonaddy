import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/screens/home_screen/components/changelog_widget.dart';
import 'package:anonaddy/services/changelog_service/changelog_service.dart';
import 'package:anonaddy/services/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changelogStateNotifier = StateNotifierProvider((ref) {
  return ChangelogNotifier(
    changelogService: ref.read(changelogService),
  );
});

class ChangelogNotifier extends StateNotifier {
  ChangelogNotifier({required this.changelogService}) : super(null);
  final ChangelogService changelogService;

  /// Show [ChangelogWidget] if app has been updated
  Future<void> showChangelogWidget(BuildContext context) async {
    final isUpdated = await _hasChangelogStatusChanged();
    if (isUpdated) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTheme.kBottomSheetBorderRadius)),
        ),
        builder: (context) => const ChangelogWidget(),
      );
    }
  }

  Future<bool> _hasChangelogStatusChanged() async {
    final data = await changelogService.getChangelogStatus();
    final isUpdated = data == null || data == 'true';
    return isUpdated;
  }

  Future<void> markChangelogRead() async {
    await changelogService.markChangelogRead();
  }
}
