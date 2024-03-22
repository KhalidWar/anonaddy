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
      'created_at': createdAt.toString(),
      'expires_at': expiresAt?.toString(),
    };
  }

  factory ApiToken.fromMap(Map<String, dynamic> map) {
    return ApiToken(
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at']),
      expiresAt:
          map['expires_at'] == null ? null : DateTime.parse(map['expires_at']),
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
