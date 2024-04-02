enum RuleOperator {
  and('and'),
  or('or');

  const RuleOperator(this.name);
  final String name;
}
