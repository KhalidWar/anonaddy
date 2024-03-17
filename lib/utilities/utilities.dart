import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class Utilities {
  static String formatDateTime(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) return '';

    final locale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMd(locale.toLanguageTag())..add_jm();
    final formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  static copyOnTap(String input) async {
    try {
      await Clipboard.setData(ClipboardData(text: input));
      showToast(ToastMessage.copiedToClipboard);
    } catch (_) {
      showToast(ToastMessage.failedToCopy);
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

  static String correctAliasString(String? input) {
    switch (input) {
      case 'random_characters':
        return 'Random Characters';
      case 'random_words':
        return 'Random Words';
      case 'custom':
        return 'Custom';
      case 'uuid':
        return 'UUID';
      default:
        return 'No default Alias selected';
    }
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return '?';
    final firstLetter = input[0];
    return input.replaceFirst(firstLetter, firstLetter.toUpperCase());
  }

  /// Adds list elements together and returns the total.
  static int reduceListElements(List<int> list) {
    if (list.isEmpty) {
      return 0;
    } else {
      final total = list.reduce((value, element) => value + element);
      return total;
    }
  }

  static WoltModalSheetPage buildWoltModalSheetSubPage(
    BuildContext context, {
    required String topBarTitle,
    required Widget child,
    bool showLeading = true,
    Function()? leadingWidgetOnPress,
    String? pageTitle,
    Widget? stickyActionBar,
    Color? sabGradientColor,
  }) {
    assert(!(showLeading && leadingWidgetOnPress == null));

    return WoltModalSheetPage(
      topBarTitle: Text(
        topBarTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      sabGradientColor: sabGradientColor,
      isTopBarLayerAlwaysVisible: true,
      stickyActionBar: stickyActionBar,
      pageTitle: pageTitle == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                pageTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
      leadingNavBarWidget: showLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: leadingWidgetOnPress,
            )
          : null,
      child: child,
    );
  }
}
