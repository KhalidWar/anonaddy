import 'package:anonaddy/common/constants/app_strings.dart';

class FormValidator {
  static String? requiredField(String? input) {
    final regex = RegExp(r'^\s+$');
    if (input == null || input.isEmpty || regex.hasMatch(input)) {
      return AppStrings.fieldCannotBeEmpty;
    }
    return null;
  }

  static String? validateEmailField(String? input) {
    if (input == null) return null;

    const emailPattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(emailPattern);

    if (input.isEmpty) {
      return AppStrings.fieldCannotBeEmpty;
    } else if (!regExp.hasMatch(input)) {
      return AppStrings.enterValidEmail;
    } else {
      return null;
    }
  }

  static String? validateLocalPart(String input) {
    // todo fix pattern validation
    // final anonAddyPattern =
    //     r'(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))\$/)';
    // final regExp = RegExp('');

    if (input.isEmpty) {
      return AppStrings.provideValidLocalPart;
      // } else if (!regExp.hasMatch(input)) {
      //   return 'Invalid alias local part';
    } else {
      return null;
    }
  }

  static String? validateInstanceURL(String? input) {
    if (input == null || input.isEmpty) {
      return AppStrings.providerValidUrl;
    } else {
      return null;
    }
  }

  static String? validateSearchField(String input) {
    if (input.length < 3) {
      return AppStrings.keywordMustBe3CharsLong;
    } else {
      return null;
    }
  }
}
