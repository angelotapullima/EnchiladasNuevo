
import 'dart:async';
import 'dart:io';

import 'package:enchiladasapp/src/api/token_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesStreamController = StreamController<String>.broadcast();
  final tokenApi = TokenApi();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotification(){
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
        tokenApi.enviarToken(token);
        print('=====FCM TOKEN=====');
        print(token);
    });

    _firebaseMessaging.configure(


      onMessage: (info){

        print('=====On Message========');
        print(info);

        if(Platform.isAndroid){
          
        }
        //_mensajesStreamController.sink.add(event)
      },

      onLaunch: (info){
         print('===== onLaunch========');
        print(info);

        final noti = info['data']['comida'];
        print(noti);
      },
      onResume: (info){
         print('=====onResume========');
        print(info);
        final noti = info['data']['comida'];
        print(noti);
      }


    );

    dispose(){
      _mensajesStreamController?.close();
    }

  }


}