class ApiToken {
  const ApiToken({
    required this.name,
    required this.createdAt,
    this.expiresAt,
  });

  final String name;
  final DateTime createdAt;
  final DateTime? expiresAt;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
    };
  }

  factory ApiToken.fromMap(Map<String, dynamic> map) {
    return ApiToken(
      name: map['name'] as String,
      createdAt: map['created_at'] as DateTime,
      expiresAt: map['expires_at'] as DateTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiToken &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'ApiToken{name: $name, createdAt: $createdAt, expiresAt: $expiresAt}';
  }
}

extension ApiTokenExtension on ApiToken {
  bool get isExpired {
    return expiresAt != null && expiresAt!.isBefore(DateTime.now());
  }
}
