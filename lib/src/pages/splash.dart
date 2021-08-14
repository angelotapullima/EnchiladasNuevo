import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/configuracion_api.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'dart:ui';

import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final categoriasApi = CategoriasApi();

      final configuracionApi = ConfiguracionApi();
      final preferences = Preferences();
      final usuarioDatabase = UsuarioDatabase();

      if (preferences.estadoCargaInicial == null || preferences.estadoCargaInicial == '0') {
        //await categoriasApi.obtenerAmbos(context);

        await configuracionApi.configuracion();

        preferences.estadoCargaInicial = '1';
      } else {
        //categoriasApi.obtenerAmbos(context);

        configuracionApi.configuracion();
      }

      final user = await usuarioDatabase.obtenerUsUario();
      if (user.length > 0) {
        Navigator.pushReplacementNamed(context, 'desicion');
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final porcentajeBloc = ProviderBloc.porcentaje(context);
    porcentajeBloc.changePorcentaje(0);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                image: AssetImage('assets/ladrillos.png'),
                fit: BoxFit.cover,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(10)),
                child: Image(
                  image: AssetImage('assets/logo_enchilada.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: responsive.hp(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NutsActivityIndicator(
                      radius: 10,
                      activeColor: Colors.white,
                      inactiveColor: Colors.redAccent,
                      tickCount: 11,
                      startRatio: 0.55,
                      animationDuration: Duration(milliseconds: 2003),
                    ),
                    SizedBox(
                      height: responsive.hp(.5),
                    ),
                    StreamBuilder(
                        stream: porcentajeBloc.procentajeStream,
                        builder: (context, snapshot) {
                          double porcentaje2 = porcentajeBloc.procentaje;
                          int porcentaje = 0;
                          if (porcentaje2 != null) {
                            porcentaje = porcentaje2.toInt();
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Estamos cargando nuestros platos',
                                style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.white),
                              ),
                              SizedBox(
                                width: responsive.wp(3),
                              ),
                              Text(
                                '$porcentaje%',
                                style: TextStyle(fontSize: responsive.ip(1.8), color: Colors.white),
                              ),
                            ],
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
