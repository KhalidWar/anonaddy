class AliasModel {
  AliasModel({
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
}
