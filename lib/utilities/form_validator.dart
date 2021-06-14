class FormValidator {
  String accessTokenValidator(String input) {
    if (input.isEmpty || input == null) {
      return 'Provide a valid Access Token';
    }
    return null;
  }

  String validateDescriptionField(String input) {
    if (input.isEmpty || input == null) {
      return 'Provide a description';
    }
    return null;
  }

  String validatePGPKeyField(String input) {
    if (input.isEmpty || input == null) {
      return 'Provide a PGP Key';
    }
    return null;
  }

  String validateSearchField(String input) {
    if (input.isEmpty || input == null) {
      return 'Field can not be empty';
    }
    return null;
  }

  String validateUsernameInput(String input) {
    if (input.isEmpty || input == null) {
      return ' Username is required';
    }
    return null;
  }

  String validateCustomField(String input) {
    if (input.isEmpty || input == null) {
      return 'Custom Alias not available for shared domains';
    }
    return null;
  }

  String validateRecipientEmail(String input) {
    final emailPattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(emailPattern);

    if (input.isEmpty || input == null) {
      return 'Field can not be empty';
    } else if (!regExp.hasMatch(input)) {
      return 'Please enter a valid email';
    } else {
      return null;
    }
  }

  String validateLocalPart(String input) {
    // final anonAddyPattern =
    //     r'(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))\$/)';

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
