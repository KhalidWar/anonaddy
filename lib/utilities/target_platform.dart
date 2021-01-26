import 'dart:io';

class TargetedPlatform {
  bool isIOS() {
    /// un-comment return statement to emulate iOS device and
    /// show all iOS widgets instead Android's.
    // return true;
    return Platform.isIOS;
  }
}
