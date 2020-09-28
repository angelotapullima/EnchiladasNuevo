import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/utils/auth.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:permission_handler/permission_handler.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin {
  Future<void> _request() async {
    final PermissionStatus status =
        await Permission.locationWhenInUse.request();

    print('permisos $status');
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    _request();
    final categoriasApi = CategoriasApi();

    final configuracionApi = ConfiguracionApi();
    final preferences = Preferences();

    if (preferences.estadoCarga == null || preferences.estadoCarga == '0') {
      await categoriasApi.obtenerAmbos();

      await configuracionApi.configuracion();

      preferences.estadoCarga = '1';
    } else {
      categoriasApi.obtenerAmbos();

      configuracionApi.configuracion();
    }

    Auth.instance.user.then((FirebaseUser user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, 'desicion');
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('assets/ladrillos.png'),
              fit: BoxFit.cover,
            )
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
              child: Image(
                image: AssetImage('assets/logo_enchilada.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }
}
