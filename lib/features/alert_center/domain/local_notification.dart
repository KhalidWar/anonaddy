class LocalNotification {
  LocalNotification({
    required this.title,
    required this.subtitle,
    required this.dismissable,
    this.payload,
  });

  final String title;
  final String subtitle;
  final bool dismissable;
  final String? payload;
}
