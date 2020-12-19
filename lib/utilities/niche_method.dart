class NicheMethod {
  String fixDateTime(dynamic input) {
    if (input.runtimeType == DateTime) {
      return '${input.month}/${input.day}/${input.year.toString().substring(2)} ${input.hour}:${input.minute}';
    } else {
      return '$input';
    }
  }

  String isUnlimited(int input, String unit) {
    if (input == 0) {
      return 'unlimited';
    } else {
      return '$input $unit';
    }
  }
}
