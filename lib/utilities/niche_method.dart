import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class NicheMethod {
  String fixDateTime(dynamic input) {
    if (input.runtimeType == DateTime) {
      return '${input.month}/${input.day}/${input.year.toString().substring(2)} ${input.hour}:${input.minute}';
    } else {
      return '$input';
    }
  }

  String isUnlimited(dynamic input, String unit) {
    if (input == 0) {
      return 'unlimited';
    } else {
      return '$input $unit';
    }
  }

  Future<void> showToast(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }

  Future launchURL(String url) async {
    await launch(url).catchError((error, stackTrace) {
      throw showToast(error.toString());
    });
  }
}
