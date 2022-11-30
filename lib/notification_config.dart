import 'package:awesome_notifications/awesome_notifications.dart';

import 'main.dart';

Future<void> createInstantNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(10),
      channelKey: instantNotification,
      title: '${Emojis.hand_pinching_hand} Instant notification title',
      body: '${Emojis.activites_admission_tickets} Instant notification body',
    ),
  );
  return Future.value();
}

Future<void> createInstantNotificationWithBigPicture() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(10),
      channelKey: instantNotificationWithBigPicture,
      title:
          '${Emojis.hand_pinching_hand} Instant notification with big picture title',
      body:
          '${Emojis.activites_admission_tickets} Instant notification with big picture body',
      bigPicture: 'asset://assets/img.png',
      notificationLayout: NotificationLayout.BigPicture,
    ),
  );
  return Future.value();
}

Future<void> createInstantNotificationWithCustomSound() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(10),
      channelKey: instantNotificationWithCustomSound,
      title:
          '${Emojis.hand_pinching_hand} Instant notification with custom sound title',
      body:
          '${Emojis.activites_admission_tickets} Instant notification with custom sound body',
    ),
  );
  return Future.value();
}

Future<void> createActionNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(10),
      channelKey: instantNotificationWithActionNotification,
      title:
          '${Emojis.hand_pinching_hand} Instant notification with action button title',
      body:
          '${Emojis.activites_admission_tickets} Instant notification with action button body',
    ),
    actionButtons: [
      NotificationActionButton(key: 'mark_as_done', label: 'Mark as done'),
      NotificationActionButton(key: 'reply', label: 'Reply'),
    ],
  );
  return Future.value();
}

Future<void> createScheduledNotification() async {
  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(10),
        channelKey: scheduledNotification,
        title: '${Emojis.hand_pinching_hand} Instant notification title',
        body: '${Emojis.activites_admission_tickets} Instant notification body',
      ),
      schedule: NotificationInterval(
          interval: 60, timeZone: localTimeZone, repeats: true));
  return Future.value();
}

Future<void> cancelNotifications({required int id}) async {
  await AwesomeNotifications().cancel(id);
  return Future.value();
}

Future<void> cancelAllNotifications() async {
  await AwesomeNotifications().cancelAll();
  return Future.value();
}

Future<void> cancelAllScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
  return Future.value();
}
