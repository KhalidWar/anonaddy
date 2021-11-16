class FormValidator {
  String? accessTokenValidator(String input) {
    if (input.isEmpty) {
      return 'Provide a valid Access Token';
    } else {
      return null;
    }
  }

  String? validatePGPKeyField(String input) {
    if (input.isEmpty) {
      return 'Provide a PGP Key';
    } else {
      return null;
    }
  }

  String? validateUsernameInput(String input) {
    if (input.isEmpty) {
      return ' Username is required';
    } else {
      return null;
    }
  }

  String? validateEmailField(String input) {
    final emailPattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(emailPattern);

    if (input.isEmpty) {
      return 'Field can not be empty';
    } else if (!regExp.hasMatch(input)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? validateLocalPart(String input) {
    // todo fix pattern validation
    // final anonAddyPattern =
    //     r'(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))\$/)';
    // final regExp = RegExp('');

    if (input.isEmpty) {
      return 'Provide a valid local part';
      // } else if (!regExp.hasMatch(input)) {
      //   return 'Invalid alias local part';
    } else {
      return null;
    }
  }

  String? validateInstanceURL(String input) {
    if (input.isEmpty) {
      return 'Provide a valid URL';
    } else {
      return null;
    }
  }
}
