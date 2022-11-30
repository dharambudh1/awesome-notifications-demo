import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_demo/notification_config.dart';
import 'package:flutter/material.dart';

const String instantNotification = 'instant_notification';
const String instantNotificationWithBigPicture =
    'instant_notification_with_big_picture';
const String instantNotificationWithCustomSound =
    'instant_notification_with_custom_sound';
const String instantNotificationWithActionNotification =
    'instant_notification_with_action_notification';
const String scheduledNotification = 'scheduled_notification';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://mipmap/ic_launcher',
    [
      NotificationChannel(
        playSound: true,
        channelKey: instantNotification,
        channelName: 'Instant notification',
        channelDescription: 'This is an Instant notification channel',
        defaultColor: Colors.teal,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
      NotificationChannel(
        playSound: true,
        channelKey: instantNotificationWithBigPicture,
        channelName: 'Instant notification with big picture',
        channelDescription:
            'This is an Instant notification channel with big picture',
        defaultColor: Colors.teal,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
      NotificationChannel(
        playSound: true,
        soundSource: 'resource://raw/slow_spring_board',
        channelKey: instantNotificationWithCustomSound,
        channelName: 'Instant notification with custom sound',
        channelDescription:
            'This is an Instant notification channel with custom sound',
        defaultColor: Colors.teal,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
      NotificationChannel(
        playSound: true,
        channelKey: instantNotificationWithActionNotification,
        channelName: 'Instant notification with action notification',
        channelDescription:
            'This is an Instant notification channel with action notification',
        defaultColor: Colors.red,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        playSound: true,
        channelKey: scheduledNotification,
        channelName: 'Scheduled notification',
        channelDescription: 'This is an Scheduled notification',
        defaultColor: Colors.red,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Awesome notifications demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription<ReceivedNotification> createdStream;
  late StreamSubscription<ReceivedNotification> displayedStream;
  late StreamSubscription<ReceivedNotification> actionStream;
  late StreamSubscription<ReceivedNotification> dismissedStream;

  int mostRecentNotificationId = 0;

  @override
  void initState() {
    super.initState();
    initNotification();
    createdStream = createdStreamListener();
    displayedStream = displayedStreamListener();
    actionStream = actionStreamListener();
    dismissedStream = dismissedStreamListener();
  }

  @override
  void dispose() {
    createdStream.cancel();
    displayedStream.cancel();
    actionStream.cancel();
    dismissedStream.cancel();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().dismissedSink.close();
    super.dispose();
  }

  void initNotification() async {
    bool isNotificationAllowed =
        await AwesomeNotifications().isNotificationAllowed();

    if (isNotificationAllowed) {
      log("isNotificationAllowed: $isNotificationAllowed");
    } else {
      log("isNotificationAllowed: $isNotificationAllowed");

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notification'),
            content: const Text(
                'Our app requires your permission for providing you notifications.'),
            actions: [
              TextButton(
                onPressed: () {
                  log("User pressed don't allow");
                  Navigator.pop(context);
                },
                child: const Text("Don't allow"),
              ),
              TextButton(
                onPressed: () async {
                  log("User pressed allow");
                  Navigator.pop(context);
                  bool requestPermissionToSendNotifications =
                      await AwesomeNotifications()
                          .requestPermissionToSendNotifications();
                  log("requestPermissionToSendNotifications: $requestPermissionToSendNotifications");
                },
                child: const Text("Allow"),
              ),
            ],
          );
        },
      );
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Align(
                child: ElevatedButton(
                  onPressed: createInstantNotification,
                  child: Text('Instant notification'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                child: ElevatedButton(
                  onPressed: createInstantNotificationWithBigPicture,
                  child: Text('Instant notification with big picture'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                child: ElevatedButton(
                  onPressed: createInstantNotificationWithCustomSound,
                  child: Text('Instant notification with custom sound'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                child: ElevatedButton(
                  onPressed: createActionNotification,
                  child: Text('Action notification'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                child: ElevatedButton(
                  onPressed: createScheduledNotification,
                  child: Text('Scheduled notification'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'Scheduled notification will arrive continuously with the interval of 60 seconds, and it will be in Indefinitely repeated mode, it will repeat until and unless you press the Cancel all scheduled notifications button.'),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                child: ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessengerState scaffoldMessenger =
                        ScaffoldMessenger.of(context);
                    await cancelNotifications(id: mostRecentNotificationId);
                    SnackBar snackBar = const SnackBar(
                        content:
                            Text('Most recent notification is cancelled.'));
                    scaffoldMessenger.showSnackBar(snackBar);
                  },
                  child: const Text('Cancel last notifications'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                child: ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessengerState scaffoldMessenger =
                        ScaffoldMessenger.of(context);
                    await cancelAllNotifications();
                    SnackBar snackBar = const SnackBar(
                        content: Text('All notifications are cancelled.'));
                    scaffoldMessenger.showSnackBar(snackBar);
                  },
                  child: const Text('Cancel all notifications'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                child: ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessengerState scaffoldMessenger =
                        ScaffoldMessenger.of(context);
                    await cancelAllScheduledNotifications();
                    SnackBar snackBar = const SnackBar(
                        content:
                            Text('All scheduled notifications are cancelled.'));
                    scaffoldMessenger.showSnackBar(snackBar);
                  },
                  child: const Text('Cancel all scheduled notifications'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamSubscription<ReceivedNotification> createdStreamListener() {
    return AwesomeNotifications().createdStream.listen((event) {
      mostRecentNotificationId = event.id ?? 0;
      log('createdStream listen: ${event.id}');
    });
  }

  StreamSubscription<ReceivedNotification> displayedStreamListener() {
    return AwesomeNotifications().displayedStream.listen((event) {
      log('displayedStream listen: ${event.id}');
    });
  }

  StreamSubscription<ReceivedNotification> actionStreamListener() {
    return AwesomeNotifications().actionStream.listen((event) async {
      if (event.buttonKeyPressed == 'mark_as_done') {
        log('mark_as_done pressed');
        ScaffoldMessengerState scaffoldMessenger =
            ScaffoldMessenger.of(context);
        SnackBar snackBar =
            const SnackBar(content: Text('mark_as_done pressed.'));
        scaffoldMessenger.showSnackBar(snackBar);
      }
      if (event.buttonKeyPressed == 'reply') {
        log('reply pressed');
        ScaffoldMessengerState scaffoldMessenger =
            ScaffoldMessenger.of(context);
        SnackBar snackBar = const SnackBar(content: Text('reply pressed.'));
        scaffoldMessenger.showSnackBar(snackBar);
      }

      if (Platform.isIOS) {
        int badgeCount = await AwesomeNotifications().getGlobalBadgeCounter();
        badgeCount = badgeCount - 1;
        await AwesomeNotifications().setGlobalBadgeCounter(badgeCount);
      }

      log('actionStream listen: ${event.id}');
    });
  }

  StreamSubscription<ReceivedNotification> dismissedStreamListener() {
    return AwesomeNotifications().dismissedStream.listen((event) {
      log('dismissedStream listen: ${event.id}');
    });
  }
}
