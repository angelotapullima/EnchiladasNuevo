import 'dart:async';
import 'dart:io';

import 'package:enchiladasapp/src/api/token_api.dart';
import 'package:enchiladasapp/src/models/ReceivedNotification.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart' as main;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> showNotificationWithIconBadge(ReceivedNotification notification) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('icon badge channel', 'icon badge name', 'icon badge description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, '${notification.title}', '${notification.body}', platformChannelSpecifics,
      payload: notification.payload);
}

class FirebaseInstance {
  void initConfig() async {
    await PushNotificationService.initializeApp();
    //await PushNotificationService.initializeApp();

    notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(id: id, title: title, body: body, payload: payload),
          );
        });
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }
}

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<String> _messageStreamController = new StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //aplicacion minimizada
    print('_backgroundHandler');
    print(message.data);
    //_messageStreamController.add(message.data.toString());
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //primer plano  app abierta
    print('_onMessageHandler');
    print(message.data);

    String title;
    String body;
    if (Platform.isAndroid) {
      title = message.notification.title;
      body = message.notification.title;
    } else {
      title = message.notification.title;
      body = message.notification.body;
    }

    ReceivedNotification notification = ReceivedNotification();
    notification.title = title;
    notification.body = body;
    notification.payload = message.data.toString();
    showNotificationWithIconBadge(notification);

    NotificationModel notificationModel = NotificationModel();
    notificationModel.tipo = message.data['tipo'];
    notificationModel.contenido = message.data['Contenido'];
    notificationModel.id = message.data['id'];

    //_messageStreamController.add(message.data.toString());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //aplicacion terminada
    print('_onMessageOpenApp');
    print(message.data);
    //_messageStreamController.add(message.data.toString());
  }

  static Future initializeApp() async {
    final tokenApi = TokenApi();
    final preferences = Preferences();
    // Push Notification
    await Firebase.initializeApp();

    messaging.requestPermission();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    print('initialMessage $initialMessage');

    token = await FirebaseMessaging.instance.getToken();
    tokenApi.enviarToken(token);
    preferences.token = token;
    print('Token Firebase: ${preferences.token}');

    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notification
  }

  static closeStreams() {
    _messageStreamController.close();
  }
}

class NotificationModel {
  String tipo;
  String contenido;
  String id;

  NotificationModel({
    this.tipo,
    this.contenido,
    this.id,
  });
}

/*
class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  final tokenApi = TokenApi();
  Stream<String> get mensajesPush => _mensajesStreamController.stream;

  initNotification() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      tokenApi.enviarToken(token);
      print('=====FCM TOKEN=====');
      print(token);
    });

    _firebaseMessaging.configure(onMessage: (info) async {
      print('=====On Message========');

      String argumento;
      String title;
      String body;
      if (Platform.isAndroid) {
        argumento = info['data']['id_pedido'];

        title = info['notification']['title'];
        body = info['notification']['body'];
      } else {
        argumento = info['id_pedido'];

        title = info['notification']['title'];
        body = info['notification']['body'];
      }

      ReceivedNotification notification = ReceivedNotification();
      notification.title = title;
      notification.body = body;
      notification.payload = argumento;
      showNotificationWithIconBadge(notification);

      //_mensajesStreamController.sink.add(event)
    }, onLaunch: (info) async {
      print('===== onLaunch========');
      String argumento;
      if (Platform.isAndroid) { 
        argumento = info['data']['id_pedido'];
      } else {
        argumento = info['id_pedido'];
      }

      _mensajesStreamController.sink.add(argumento);
    }, onResume: (info) async {
      print('=====onResume========');
      String argumento;
      if (Platform.isAndroid) {
        argumento = info['data']['id_pedido'];
      } else {
        argumento = info['id_pedido'];
      }

      _mensajesStreamController.sink.add(argumento);
    });
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}*/
