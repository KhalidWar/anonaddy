enum BannerLocation {
  top('Top'),
  bottom('Bottom'),
  off('Off');

  const BannerLocation(this.value);
  final String value;
}

enum RuleActionType {
  subject('replace the subject with'),
  displayFrom('replace the "from name" with'),
  encryption('turn PGP encryption off'),
  banner('set the banner information location to'),
  block('block the email');

  const RuleActionType(this.value);
  final String? value;
}

abstract class RuleAction {
  const RuleAction({required this.type});
  final RuleActionType type;

  factory RuleAction.fromJson(Map<String, dynamic> json) {
    final type =
        RuleActionType.values.firstWhere((e) => e.name == json['type']);
    switch (type) {
      case RuleActionType.subject:
        return RuleActionSubject(value: json['value'] as String);
      case RuleActionType.displayFrom:
        return RuleActionDisplayFrom(value: json['value'] as String);
      case RuleActionType.encryption:
        return RuleActionEncryption(value: json['value'] as bool);
      case RuleActionType.banner:
        return RuleActionBanner(
          bannerLocation:
              BannerLocation.values.firstWhere((e) => e.name == json['value']),
        );
      case RuleActionType.block:
        return RuleActionBlock(value: json['value'] as bool);
    }
  }

  Map<String, dynamic> toMap();
}

class RuleActionSubject extends RuleAction {
  const RuleActionSubject({
    super.type = RuleActionType.subject,
    required this.value,
  });

  final String value;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'value': value,
    };
  }
}

class RuleActionDisplayFrom extends RuleAction {
  RuleActionDisplayFrom({
    super.type = RuleActionType.displayFrom,
    required this.value,
  });

  final String value;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'value': value,
    };
  }
}

class RuleActionEncryption extends RuleAction {
  RuleActionEncryption({
    super.type = RuleActionType.encryption,
    this.value = false,
  });

  final bool value;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'value': value,
    };
  }
}

class RuleActionBanner extends RuleAction {
  RuleActionBanner({
    super.type = RuleActionType.banner,
    required this.bannerLocation,
  });

  final BannerLocation bannerLocation;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'value': bannerLocation.name,
    };
  }
}

class RuleActionBlock extends RuleAction {
  RuleActionBlock({
    super.type = RuleActionType.block,
    required this.value,
  });

  final bool value;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'value': value,
    };
  }
}
