enum RuleConditionType {
  sender('the sender'),
  subject('the subject'),
  alias('the alias');

  const RuleConditionType(this.value);
  final String value;
}

enum RuleConditionMatch {
  contains('contains'),
  doesNotContain('does not contain'),
  isExactly('is exactly'),
  isNot('is not'),
  startsWith('starts with'),
  doesNotStartWith('does not start with'),
  endsWith('ends with'),
  doesNotEndWith('does not end with');

  const RuleConditionMatch(this.value);
  final String value;
}

class RuleCondition {
  const RuleCondition({
    required this.type,
    required this.match,
    required this.values,
  });

  final RuleConditionType type;
  final RuleConditionMatch match;
  final List<String> values;

  factory RuleCondition.fromJson(Map<String, dynamic> json) {
    return RuleCondition(
      type: RuleConditionType.values
          .firstWhere((type) => type.name == json['type'] as String),
      match: RuleConditionMatch.values
          .firstWhere((match) => match.value == json['match'] as String),
      values: (json['values'] as List).map((e) => e as String).toList(),
    );
  }
}
