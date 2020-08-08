
import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/pushProvider/push_notifications.dart';
import 'package:enchiladasapp/src/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class Splash extends StatefulWidget { 

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin {

  

  @override
  void afterFirstLayout(BuildContext context) async{
    final categoriasApi = CategoriasApi();
    categoriasApi.obtenerAmbos();
    
    final configuracionApi=ConfiguracionApi();
    configuracionApi.configuracion();

    final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();

    Auth.instance.user.then((FirebaseUser user) {
      if(user!= null){
        
        Navigator.pushReplacementNamed(context, 'desicion');
      }else{
        Navigator.pushReplacementNamed(context, 'login');
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}