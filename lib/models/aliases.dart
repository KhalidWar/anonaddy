class Aliases {
  Aliases({
    this.emailDescription,
    this.isAliasActive,
    this.email,
    this.createdAt,
  });

  bool isAliasActive;
  final String email;
  final String createdAt;
  final String emailDescription;

  void toggleAliasActivity() {
    isAliasActive = !isAliasActive;
  }
}
