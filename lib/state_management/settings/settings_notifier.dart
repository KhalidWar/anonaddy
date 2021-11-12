import 'package:anonaddy/services/data_storage/settings_data_storage.dart';
import 'package:anonaddy/state_management/settings/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

final settingsStateNotifier =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storage = ref.read(settingsDataStorage);
  return SettingsNotifier(settingsStorage: storage);
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier({required this.settingsStorage})
      : super(SettingsState.initial()) {
    _initState();
  }

  final SettingsDataStorage settingsStorage;

  final _autoCopyKey = 'autoCopyKey';
  final _darkThemeKey = 'darkTheme';

  Future<void> toggleTheme() async {
    state.isDarkTheme = !state.isDarkTheme!;
    await settingsStorage.saveBoolState(_darkThemeKey, state.isDarkTheme!);
    state = state.copyWith();
  }

  void toggleAutoCopy() {
    state.isAutoCopy = !state.isAutoCopy!;
    settingsStorage.saveBoolState(_autoCopyKey, state.isAutoCopy!);
    state = state.copyWith();
  }

  void _initState() async {
    final bool isDarkTheme =
        await settingsStorage.loadBoolState(_darkThemeKey) ?? false;
    final bool isAutoCopy =
        await settingsStorage.loadBoolState(_autoCopyKey) ?? false;
    state = state.copyWith(isDarkTheme: isDarkTheme, isAutoCopy: isAutoCopy);
  }
}
