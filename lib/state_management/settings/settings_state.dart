class SettingsState {
  SettingsState({
    required this.isAutoCopyEnabled,
    required this.isDarkTheme,
    required this.isBiometricEnabled,
  });

  final bool isAutoCopyEnabled;
  final bool isDarkTheme;
  final bool isBiometricEnabled;

  static SettingsState initial() {
    return SettingsState(
      isAutoCopyEnabled: false,
      isDarkTheme: false,
      isBiometricEnabled: false,
    );
  }

  SettingsState copyWith({
    bool? isAutoCopyEnabled,
    bool? isDarkTheme,
    bool? isBiometricEnabled,
  }) {
    return SettingsState(
      isAutoCopyEnabled: isAutoCopyEnabled ?? this.isAutoCopyEnabled,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAutoCopyEnabled': isAutoCopyEnabled,
      'isDarkTheme': isDarkTheme,
      'isBiometricEnabled': isBiometricEnabled,
    };
  }

  factory SettingsState.fromMap(Map<String, dynamic> map) {
    return SettingsState(
      isAutoCopyEnabled: map['isAutoCopyEnabled'] as bool,
      isDarkTheme: map['isDarkTheme'] as bool,
      isBiometricEnabled: map['isBiometricEnabled'] as bool,
    );
  }

  @override
  String toString() {
    return 'SettingsState{isAutoCopyEnabled: $isAutoCopyEnabled, isDarkTheme: $isDarkTheme, isBiometricEnabled: $isBiometricEnabled}';
  }
}
