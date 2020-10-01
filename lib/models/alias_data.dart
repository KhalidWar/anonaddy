class AliasData {
  AliasData({
    this.aliasID,
    this.emailDescription,
    this.isAliasActive,
    this.email,
    this.createdAt,
  });

  bool isAliasActive;
  final String email;
  final String createdAt;
  final String emailDescription;
  final String aliasID;

  factory AliasData.fromJson(Map<String, dynamic> json) {
    return AliasData(
      aliasID: json['id'],
      email: json['email'],
      emailDescription: json['description'] ?? 'None',
      createdAt: json['created_at'],
      isAliasActive: json['active'],
    );
  }
}
