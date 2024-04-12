class LocalNotification {
  LocalNotification({
    required this.title,
    required this.subtitle,
    required this.payload,
    required this.dismissable,
  });

  final String title;
  final String subtitle;
  final String payload;
  final bool dismissable;
}
