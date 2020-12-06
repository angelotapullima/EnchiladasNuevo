import 'dart:async';
import 'dart:io';

import 'package:enchiladasapp/src/api/token_api.dart';
import 'package:enchiladasapp/src/models/ReceivedNotification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart' as main;

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
      main.showNotificationWithIconBadge(notification);

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
}
