import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class NicheMethod {
  static String fixDateTime(dynamic input) {
    // if (input == null) return '';
    if (input.runtimeType == DateTime) {
      final year = input.year.toString().substring(2);
      final month = input.month;
      final day = input.day;
      final hour = input.hour;
      final min = input.minute;
      return '$month/$day/$year $hour:$min';
      // return '${input.month}/${input.day}/${input.year.toString().substring(2)} ${input.hour}:${input.minute}';
    } else {
      return '$input';
    }
  }

  static Future<void> copyOnTap(String input) async {
    try {
      await Clipboard.setData(ClipboardData(text: input));
      showToast(ToastMessage.copiedToClipboard);
    } catch (_) {
      showToast(ToastMessage.failedToCopy);
    }
  }

  static Future<String?> pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData('text/plain');
      return clipboardData?.text;
    } catch (_) {
      showToast(ToastMessage.failedToCopy);
      return null;
    }
  }

  static showToastWithContext(BuildContext context, String message) async {
    try {
      final flutterToast = FToast();
      flutterToast.init(context);
      flutterToast.showToast(
        toastDuration: const Duration(seconds: 1),
        gravity: ToastGravity.BOTTOM,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.grey[600],
          ),
          child: Text(message),
        ),
      );
    } catch (error) {
      return;
    }
  }

  static showToast(String message) async {
    try {
      await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
      );
    } catch (error) {
      return;
    }
  }

  static Future<void> launchURL(String url) async {
    try {
      await launch(url);
      // final uri = Uri();
      // await launchUrl(uri);
    } catch (_) {
      showToast(AppStrings.failedToLaunchUrl);
    }
  }

  static String correctAliasString(String input) {
    switch (input) {
      case 'random_characters':
        return 'Random Characters';
      case 'random_words':
        return 'Random Words';
      case 'custom':
        return 'Custom';
      default:
        return 'UUID';
    }
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return '?';
    final firstLetter = input[0];
    return input.replaceFirst(firstLetter, firstLetter.toUpperCase());
  }
}
