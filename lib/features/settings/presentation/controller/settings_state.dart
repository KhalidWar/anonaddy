class SettingsState {
  const SettingsState({
    required this.isAutoCopyEnabled,
    required this.isDarkTheme,
    required this.isBiometricEnabled,
    required this.showChangelog,
    required this.appVersion,
  });

  final bool isAutoCopyEnabled;
  final bool isDarkTheme;
  final bool isBiometricEnabled;
  final bool showChangelog;
  final String appVersion;

  SettingsState copyWith({
    bool? isAutoCopyEnabled,
    bool? isDarkTheme,
    bool? isBiometricEnabled,
    bool? showChangelog,
    String? appVersion,
  }) {
    return SettingsState(
      isAutoCopyEnabled: isAutoCopyEnabled ?? this.isAutoCopyEnabled,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      showChangelog: showChangelog ?? this.showChangelog,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAutoCopyEnabled': isAutoCopyEnabled,
      'isDarkTheme': isDarkTheme,
      'isBiometricEnabled': isBiometricEnabled,
      'showChangelog': showChangelog,
      'appVersion': appVersion,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      isAutoCopyEnabled: map['isAutoCopyEnabled'] as bool,
      isDarkTheme: map['isDarkTheme'] as bool,
      isBiometricEnabled: map['isBiometricEnabled'] as bool,
      showChangelog: map['showChangelog'] as bool,
      appVersion: map['appVersion'] as String,
    );
  }

  @override
  String toString() {
    return 'SettingsState{isAutoCopyEnabled: $isAutoCopyEnabled, isDarkTheme: $isDarkTheme, isBiometricEnabled: $isBiometricEnabled, showChangelog: $showChangelog, appVersion: $appVersion}';
  }
}
