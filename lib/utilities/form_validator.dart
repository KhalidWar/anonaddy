import 'package:anonaddy/shared_components/constants/app_strings.dart';

class FormValidator {
  static String? accessTokenValidator(String input) {
    if (input.isEmpty) {
      return AppStrings.provideValidAccessToken;
    } else {
      return null;
    }
  }

  static String? validatePGPKeyField(String input) {
    if (input.isEmpty) {
      return AppStrings.providePGPKey;
    } else {
      return null;
    }
  }

  static String? requiredField(String? input) {
    if (input == null) return null;
    if (input.isEmpty) return AppStrings.fieldCannotBeEmpty;
    return null;
  }

  static String? validateEmailField(String input) {
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

  static String? validateInstanceURL(String input) {
    if (input.isEmpty) {
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
