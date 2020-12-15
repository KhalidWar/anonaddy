class DateTimeFixer {
  String fixDateTime(dynamic input) {
    if (input.runtimeType == DateTime) {
      return '${input.month}/${input.day}/${input.year.toString().substring(2)} ${input.hour}:${input.minute}';
    } else {
      return '$input';
    }
  }
}
