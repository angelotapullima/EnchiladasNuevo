import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with AfterLayoutMixin {
 

  @override
  void afterFirstLayout(BuildContext context) async {
    
    final categoriasApi = CategoriasApi();

    final configuracionApi = ConfiguracionApi();
    final preferences = Preferences();
    final usuarioDatabase = UsuarioDatabase();

    if (preferences.estadoCargaInicial == null || preferences.estadoCargaInicial == '0') {
      await categoriasApi.obtenerAmbos();

      await configuracionApi.configuracion();

      preferences.estadoCargaInicial = '1';
    } else {
      categoriasApi.obtenerAmbos();

      configuracionApi.configuracion();
    }

    final user = await usuarioDatabase.obtenerUsUario();
    if(user.length>0){
      Navigator.pushReplacementNamed(context, 'desicion');
    }else{

        Navigator.pushReplacementNamed(context, 'login');
    }


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
