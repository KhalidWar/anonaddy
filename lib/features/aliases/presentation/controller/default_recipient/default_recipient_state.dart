import 'package:anonaddy/features/recipients/domain/recipient.dart';

class DefaultRecipientState {
  const DefaultRecipientState({
    required this.verifiedRecipients,
    required this.defaultRecipients,
    required this.isCTALoading,
  });

  /// Stores extracted verified recipients since only verified
  /// recipients can be used as alias default recipients.
  final List<Recipient> verifiedRecipients;

  /// Recipients which are currently set as default for this alias, or
  /// are being toggled on and off by user before setting them as defaults.
  final List<Recipient> defaultRecipients;

  final bool isCTALoading;

  DefaultRecipientState copyWith({
    List<Recipient>? verifiedRecipients,
    List<Recipient>? defaultRecipients,
    bool? isCTALoading,
  }) {
    return DefaultRecipientState(
      verifiedRecipients: verifiedRecipients ?? this.verifiedRecipients,
      defaultRecipients: defaultRecipients ?? this.defaultRecipients,
      isCTALoading: isCTALoading ?? this.isCTALoading,
    );
  }

  @override
  String toString() {
    return 'DefaultRecipientState{verifiedRecipients: $verifiedRecipients, defaultRecipients: $defaultRecipients, isCTALoading: $isCTALoading}';
  }
}
