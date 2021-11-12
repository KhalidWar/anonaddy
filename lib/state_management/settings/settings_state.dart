class SettingsState {
  SettingsState({required this.isAutoCopy, required this.isDarkTheme});

  bool? isAutoCopy;
  bool? isDarkTheme;

  static SettingsState initial() {
    return SettingsState(isAutoCopy: false, isDarkTheme: false);
  }

  SettingsState copyWith({
    bool? isAutoCopy,
    bool? isDarkTheme,
  }) {
    return SettingsState(
      isAutoCopy: isAutoCopy ?? this.isAutoCopy,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }

  @override
  String toString() {
    return 'SettingsState{isAutoCopy: $isAutoCopy, isDarkTheme: $isDarkTheme}';
  }
}
