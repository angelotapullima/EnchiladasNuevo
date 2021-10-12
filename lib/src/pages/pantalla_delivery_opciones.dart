import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/pages/%20categorias_por_tipo.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PantallaDeliveryOpciones extends StatelessWidget {
  const PantallaDeliveryOpciones({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pantallasBloc = ProviderBloc.pantalla(context);
    pantallasBloc.obtenerPantallas();
    pantallasBloc.estadoPantallaCafe();
    pantallasBloc.estadoPantallaVar();
/* 

    final categoriasApi = CategoriasApi();
    categoriasApi.obtenerAmbos(context); */

    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: Colors.black12,
              image: new DecorationImage(
                image: new ExactAssetImage('assets/ladrillos.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.ip(1),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: responsive.hp(12),
                    ),
                    Text(
                      'Elige una Opción',
                      style: TextStyle(color: Colors.white, fontSize: responsive.ip(3.8), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: responsive.ip(16),
                        child: Image.asset('assets/logo_enchilada.png'),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    StreamBuilder(
                      stream: pantallasBloc.estadoVarStream,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data) {
                            return GestureDetector(
                              child: Container(
                                width: double.infinity,
                                height: responsive.ip(16),
                                child: Image.asset('assets/var.png'),
                              ),
                              onTap: () {


                        Navigator.pushNamed(context, '/');

                                /* Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 400),
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return CategoriasPorTipo(
                                        nombreTipo: 'Var 247',
                                        tipo: '4',
                                      );
                                      //return DetalleProductitos(productosData: productosData);
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                ); */
                                //Navigator.pushNamed(context, 'market');
                              },
                            );
                          } else {
                            return Container(
                              height: responsive.ip(16),
                            );
                          }
                        } else {
                          return Container(
                            height: responsive.ip(16),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: responsive.hp(2),
                    ),
                    StreamBuilder(
                        stream: pantallasBloc.estadoCafeStream,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data) {
                              return GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  height: responsive.ip(16),
                                  child: Image.asset('assets/cafe_247.png'),
                                ),
                                onTap: () {


                        Navigator.pushNamed(context, '/');
                                 /*  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 400),
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return CategoriasPorTipo(
                                            nombreTipo: 'Café 247',
                                            tipo: '3',
                                          );
                                          //return DetalleProductitos(productosData: productosData);
                                        },
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      )); */
                                },
                              );
                            } else {
                              return Container(
                                height: responsive.ip(16),
                              );
                            }
                          } else {
                            return Container(
                              height: responsive.ip(16),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
