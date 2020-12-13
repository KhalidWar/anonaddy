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

  String customFieldInput(String input) {
    if (input.isEmpty || input == null) {
      return 'Custom Alias not available for shared domains';
    }
    return null;
  }
}
