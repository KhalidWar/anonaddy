import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Naming guidelines: iconName + Platform
/// For example: searchMaterial for Android and searchCupertino for iPhone
///
/// Icons guidelines:
///   1. Platform specific.
///   2. Outlined.
///
/// Consolidated all icons used in app in one place.
class AppIcons {
  /// Alert
  static const alertMaterial = Icon(Icons.error_outline);
  static const alertCupertino = Icon(CupertinoIcons.exclamationmark_triangle);

  /// Settings
  static const settingsMaterial = Icon(Icons.settings);
  static const settingCupertino = Icon(CupertinoIcons.settings);

  /// Add
  static const addMaterial = Icon(Icons.add);
  static const addCupertino = Icon(CupertinoIcons.add);

  /// Account or profile
  static const profileMaterial = Icon(Icons.account_circle_outlined);
  static const profileCupertino = Icon(CupertinoIcons.profile_circled);

  /// Aliases, email, @
  static const aliasesMaterial = Icon(Icons.alternate_email_outlined);
  static const aliasesCupertino = Icon(CupertinoIcons.at);

  /// Search
  static const searchMaterial = Icon(Icons.search_outlined);
  static const searchCupertino = Icon(CupertinoIcons.search);

  /// copy
  static const copyMaterial = Icon(Icons.copy);
  static const copyCupertino = Icon(Icons.copy);

  /// Send
  static const sendMaterial = Icon(Icons.send_outlined);
  static const sendCupertino = Icon(Icons.send_outlined);

  /// Edit
  static const editMaterial = Icon(Icons.edit_outlined);
  static const editCupertino = Icon(Icons.edit_outlined);

  /// Delete
  static const deleteMaterial = Icon(Icons.delete_outline);
  static const deleteCupertino = Icon(CupertinoIcons.delete);

  /// Email
  static const emailMaterial = Icon(Icons.email_outlined);
  static const emailCupertino = Icon(CupertinoIcons.mail);

  /// Fingerprint, security
  static const fingerprintMaterial = Icon(Icons.fingerprint_outlined);
  // static const fingerprintCupertino = Icon(CupertinoIcons.finger);

  /// Lock open
  static const lockOpenMaterial = Icon(Icons.lock_open_outlined);
  static const lockOpenCupertino = Icon(CupertinoIcons.lock_open);

  /// Lock closed
  static const lockClosedMaterial = Icon(Icons.lock);
  static const lockClosedCupertino = Icon(CupertinoIcons.lock_fill);

  /// Verified, checkmark, check,
  static const verifiedMaterial = Icon(Icons.verified_outlined);
  static const verifiedCupertino = Icon(CupertinoIcons.checkmark_seal);

  /// Speedometer, speed, bandwidth
  static const speedMaterial = Icon(Icons.speed_outlined);
  static const speedCupertino = Icon(CupertinoIcons.speedometer);

  /// DNS, server,
  static const dnsMaterial = Icon(Icons.dns_outlined);
  // static const dnsCupertino = Icon(CupertinoIcons.dns_outlined);

  /// Comment, description,
  static const commentMaterial = Icon(Icons.comment_outlined);
  // static const commentCupertino = Icon(CupertinoIcons.comment);

  /// Toggle
  static const toggleMaterial = Icon(Icons.toggle_off_outlined);
  // static const commentCupertino = Icon(CupertinoIcons.toggle);

  /// Repeat, catch all,
  static const repeatMaterial = Icon(Icons.repeat_outlined);
  static const repeatCupertino = Icon(CupertinoIcons.repeat);

  /// External link
  static const openExternalMaterial = Icon(Icons.open_in_new_outlined);
  static const openExternalCupertino = Icon(Icons.open_in_new_outlined);
}
