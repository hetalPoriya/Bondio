import 'dart:developer';
import 'dart:io';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:bondio/controller/controller.dart';
import 'package:bondio/route_helper/route_helper.dart';
import 'package:bondio/screens/chat/chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void convertLocalToDetroit() async {
  tz.initializeTimeZones();
  final String locationName = await FlutterNativeTimezone.getLocalTimezone();
  SharedPrefClass.setString(SharedPrefStrings.locationName, locationName);
  // DateTime indiaTime = DateTime.now(); //Emulator time is India time
  // final detroitTime =
  //     new tz.TZDateTime.from(indiaTime, tz.getLocation(locationName));
  // print('Local India Time: ' + indiaTime.toString());
  // print('Detroit Time: ' + detroitTime.toString());

  // Local India Time: 2023-07-07 10:08:19.583495
  // I/flutter ( 3844): Detroit Time: 2023-07-07 10:08:19.583495+0530
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SharedPrefClass.getInstance();
  await ChatWidget.getUserInfo();
  tz.initializeTimeZones();
  final String locationName = await FlutterNativeTimezone.getLocalTimezone();
  SharedPrefClass.setString(SharedPrefStrings.locationName, locationName);
  runApp(MyApp());
// runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HomeController homeController = Get.put(HomeController());
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bondio',
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        getPages: RouteHelper.getPages,
        initialRoute: RouteHelper.splashScreen,
      );
    }));
  }

  getNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
              alert: true,
              announcement: false,
              badge: true,
              carPlay: false,
              criticalAlert: false,
              sound: true,
              provisional: false);
    }
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //     requestAlertPermission: false,
    //     requestBadgePermission: false,
    //     requestSoundPermission: false,
    //     onDidReceiveLocalNotification: (
    //         int id,
    //         String? title,
    //         String? body,
    //         String? payload,
    //         ) async {
    //       print(title);
    //     });
    // const MacOSInitializationSettings initializationSettingsMacOS =
    // MacOSInitializationSettings(
    //   requestAlertPermission: false,
    //   requestBadgePermission: false,
    //   requestSoundPermission: false,
    // );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      playSound: true,
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
              channelDescription: channel.description,
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Message clicked!');
    });
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('background message ${message.notification?.body}');
}