class FormValidator {
  String accessTokenValidator(String input) {
    if (input.isEmpty || input == null) {
      return 'Please Enter Access Token';
    }
    return null;
  }

  String searchValidator(String input) {
    if (input.isEmpty || input == null) {
      return 'Field can not be empty';
    }
    return null;
  }
}
