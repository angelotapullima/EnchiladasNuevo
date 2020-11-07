import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/pedido_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/utils/auth.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class MiCuentaTab extends StatefulWidget {
  @override
  _MiCuentaTabState createState() => _MiCuentaTabState();
}

class _MiCuentaTabState extends State<MiCuentaTab> {
  GlobalKey _one = GlobalKey();

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final preferences = Preferences();
    final bottomBloc = ProviderBloc.bottom(context);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: _datos(responsive, preferences, bottomBloc),
      ),),
    );
  }

  Widget getAlias(String name, Responsive responsive) {
    final List<String> tmp = name.split(" ");

    String alias = "";
    if (tmp.length > 0) {
      alias = tmp[0][0];
      if (tmp.length == 2) {
        alias += tmp[1][0];
      }
    }

    return Center(
      child: Text(
        alias,
        style: TextStyle(
          fontSize: responsive.ip(7),
        ),
      ),
    );
  }

  Widget _datos(Responsive responsive, Preferences preferences,
      BottomNaviBloc bottomBloc) {
    String email, name, foto;
    final prefs = new Preferences();

    if (prefs.email != "" && prefs.email != null) {
      name = prefs.personName;
      email = prefs.email;
      foto = prefs.foto;
    } else {
      name = 'Invitado';
      email = 'Invitado';
    }

    return StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (context, snapshot) {
          return ShowCaseWidget(
              onFinish: () {
                preferences.pantallaCuenta = '1';
              },
              autoPlay: false,
              autoPlayDelay: Duration(seconds: 7),
              autoPlayLockEnable: true,
              builder: Builder(builder: (context) {
                if (bottomBloc.page == 4) {
                  if (preferences.pantallaCuenta != "1") {
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        ShowCaseWidget.of(context).startShowCase([_one]));
                  }
                }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: responsive.hp(3.5),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: responsive.ip(4.5),
                              child: foto != null
                                  ? ClipOval(
                                      child: Image.network(
                                      foto,
                                      width: responsive.ip(9),
                                      height: responsive.ip(9),
                                      fit: BoxFit.contain,
                                    ))
                                  : getAlias(name, responsive),
                            ),
                            SizedBox(
                              width: responsive.wp(4.5),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: responsive.ip(2),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  email,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(fontSize: responsive.ip(1.8)),
                                ),
                              ],
                            )
                          ]),
                      (prefs.rol == '5')
                          ? Showcase(
                              key: _one,
                              description:
                                  'Aquí podrás ver todos los pedidos que hiciste',
                              child: _ordenes(responsive))
                          : Container(),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      (prefs.rol == '6') ? _pedidos(responsive) : Container(),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      _asistencia(responsive),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      _aplicacion(responsive),
                      Padding(
                        padding: EdgeInsets.all(responsive.ip(1.5)),
                        child: InkWell(
                          onTap: () async {
                            final pref = Preferences();
                            if (pref.email != "" && pref.email != null) {
                              //pref.clearPreferences(); 


                              pref.personName='';
                              pref.foto='';
                              pref.email='';
                              pref.token='';
                              pref.idUser='';
                              pref.rol='';
                              Auth.instance.logOut(context);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'login', (route) => false);
                            }
                            final usuarioDatabase = UsuarioDatabase();
                            await usuarioDatabase.deleteUser();

                            final direccionDatabase = DireccionDatabase();
                            await direccionDatabase.deleteDireccion();

                            final pedidoDatabase = PedidoDatabase();
                            await pedidoDatabase.deletePedido();
                            await pedidoDatabase.deleteDetallePedido();

                            final carritoDatase = CarritoDatabase();
                            carritoDatase.deleteCarritoDb();
                          },
                          child: new Container(
                            //width: 100.0,
                            height: responsive.hp(6),
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 3)
                              ],
                              color: Colors.white,
                              border: new Border.all(
                                  color: Colors.grey[300], width: 1.0),
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: new Center(
                              child: new Text(
                                'Cerrar sesión',
                                style: new TextStyle(
                                    fontSize: responsive.ip(2),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  Widget _asistencia(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Asistencia',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(3),
                color: Colors.red),
          ),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[300],
              ),
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'bufeotec@gmail.com',
                        queryParameters: {
                          'subject': 'Contacto Equipo De Soporte'
                        });

                    // mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
                    if (await canLaunch("mailto:$_emailLaunchUri.toString()")) {
                      await launch(_emailLaunchUri.toString());
                    } else {
                      throw 'Could not launch';
                    }

                    //
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.commentAlt,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Contactar con el equipo de Soporte',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                InkWell(
                   onTap: () {
                      _launchInBrowser('http://play.google.com/store/apps/details?id=com.bufeotec.enchiladasapp');
                    },
                    
                  child: Padding(
                    padding: EdgeInsets.all(responsive.ip(1)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.comments,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Deja un Comentario',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _ordenes(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Órdenes',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(3),
                  color: Colors.red)),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          InkWell(
            onTap: () {
              final prefs = new Preferences();

              if (prefs.email != "" && prefs.email != null) {
                Navigator.pushNamed(context, 'ordenes');
              } else {
                utils.showToast('Debe estar registrado para ver esta opción', 2,
                    ToastGravity.TOP);
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[300])),
                child: Padding(
                  padding: EdgeInsets.all(responsive.ip(1.3)),
                  child: Row(children: <Widget>[
                    Icon(FontAwesomeIcons.archive,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: responsive.wp(1.5),
                    ),
                    Text(
                      'Órdenes Realizadas',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.ip(1.8)),
                    )
                  ]),
                )),
          )
        ],
      ),
    );
  }

  Widget _pedidos(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Pedidos',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(3),
                  color: Colors.red)),
          SizedBox(
            height: responsive.hp(1.5),
          ),
          InkWell(
            onTap: () {
              final prefs = new Preferences();

              if (prefs.email != "" && prefs.email != null) {
                Navigator.pushNamed(context, 'pedidosRepartidor');
              } else {
                utils.showToast('Debe estar registrado para ver esta opción', 2,
                    ToastGravity.TOP);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[300])),
              child: Padding(
                padding: EdgeInsets.all(responsive.ip(1.3)),
                child: Row(children: <Widget>[
                  Icon(
                    FontAwesomeIcons.archive,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: responsive.wp(1.5),
                  ),
                  Text(
                    'Pedidos Asignados',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: responsive.ip(1.8)),
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _aplicacion(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.wp(3)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Aplicación',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(3),
                    color: Colors.red)),
            SizedBox(
              height: responsive.hp(1.5),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]),
              ),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _launchInBrowser('https://politicas.lacasadelasenchiladas.pe/politicas-privacidad.html');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                        responsive.ip(1),
                      ),
                      child: Row(children: <Widget>[
                        Icon(
                          FontAwesomeIcons.voteYea,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Política De Privacidad',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      _launchInBrowser('https://politicas.lacasadelasenchiladas.pe/terminos-y-condiciones.html');
                    },
                    child: Padding(
                      padding: EdgeInsets.all(responsive.ip(1)),
                      child: Row(children: <Widget>[
                        Icon(
                          FontAwesomeIcons.clipboardList,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Text(
                          'Términos de servicio',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(
                      responsive.ip(1),
                    ),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.phone_android,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: responsive.ip(1.5),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'App Versión',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                          Text(
                            '1.0',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: responsive.ip(1.8),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
