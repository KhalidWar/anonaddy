class FormValidator {
  //todo unify and consolidate all methods into customValidator
  String customValidator(String input, String errorText) {
    if (input.isEmpty || input == null) {
      return errorText;
    }
    return null;
  }

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

  String validateLocalPart(String input) {
    final emailPattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final anonAddyPattern =
        r'(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))\$/)';

    // todo fix pattern validation
    final regExp = RegExp('');

    if (input.isEmpty) {
      return 'Provide a valid local part';
    } else if (!regExp.hasMatch(input)) {
      return 'Invalid alias local part';
    } else {
      return null;
    }
  }
}
