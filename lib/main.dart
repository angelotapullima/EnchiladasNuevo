import 'package:enchiladasapp/src/bloc/cerrar_publicidad_bloc.dart';
import 'package:enchiladasapp/src/models/ReceivedNotification.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/home_local.dart';
import 'package:enchiladasapp/src/pages/AplicacionLocal/productos_categoria.dart';
import 'package:enchiladasapp/src/pages/blocMapa/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:enchiladasapp/src/pages/detallePedido/bloc_detalle_pago.dart';
import 'package:enchiladasapp/src/pages/detallePedido/detalle_pedido.dart';
import 'package:enchiladasapp/src/pages/detalle_producto_foto.dart';
import 'package:enchiladasapp/src/pages/gestionar_direcciones.dart';
import 'package:enchiladasapp/src/pages/mapa_cliente.dart';
import 'package:enchiladasapp/src/pages/notification_page.dart';
import 'package:enchiladasapp/src/pages/onboarding_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/delivery_timeline.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_pago_page.dart';
import 'package:enchiladasapp/src/pages/pantalla_delivery_opciones.dart';
import 'package:enchiladasapp/src/pages/detalle_promociones.dart';
import 'package:enchiladasapp/src/pages/ticket.dart';
import 'package:enchiladasapp/src/pages/webview.dart';
import 'package:enchiladasapp/src/pages/zoom_foto_direccion.dart';
import 'package:enchiladasapp/src/pushProvider/push_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/pages/detalle_pago.dart';
import 'package:enchiladasapp/src/pages/select_direction.dart';
import 'package:enchiladasapp/src/utils/preferencias_usuario.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/pages/login_page.dart';
import 'package:enchiladasapp/src/pages/splash.dart';
import 'package:enchiladasapp/src/pages/home_page.dart';
import 'package:enchiladasapp/src/pages/desicion_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'src/pages/blocMapa/mapa/mapa_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new Preferences();

  await prefs.initPrefs();

  final firebase = FirebaseInstance();

  firebase.initConfig();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  initializeDateFormatting('es_MX').then(
    (_) => runApp(
      Provider<AppleSignInAvailable>.value(
        value: appleSignInAvailable,
        child: MyApp(),
      ),
    ),
  );

  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorkey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    PushNotificationService.messagesStream.listen((event) {
      print('cuando la app esta abierta');
      navigatorkey.currentState.pushNamed('notificationPage', arguments: event);
    });
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    super.initState();
    /* final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();  */
    super.initState();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen(
      (ReceivedNotification receivedNotification) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: receivedNotification.title != null ? Text(receivedNotification.title) : null,
            content: receivedNotification.body != null ? Text(receivedNotification.body) : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  print('_configureDidReceiveLocalNotificationSubject');
                  Navigator.of(context, rootNavigator: true).pop();
                  await navigatorkey.currentState.pushNamed('onboarding', arguments: receivedNotification.payload);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        //esto funciona cuando tocas la notificacion que se genero con la app abierta
        print('esta te lleva la pantalla seleccionada cuando la app esta abierta $payload');
        await navigatorkey.currentState.pushNamed('notificationPage', arguments: payload);
      },
    );
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetallePedidoBloc>(
          create: (_) => DetallePedidoBloc(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MiUbicacionBloc(),
          ),
          BlocProvider(
            create: (_) => MapaBloc(),
          ),
          //BlocProvider(create: ( _ ) => BusquedaBloc() ),
        ],
        child: ChangeNotifierProvider(
          create: (_) => PrincipalChangeBloc(),
          child: ProviderBloc(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorkey,
              initialRoute: 'splash',
              theme: ThemeData(
                primarySwatch: Colors.red,
                scaffoldBackgroundColor: Colors.grey[50],
                canvasColor: Colors.transparent,
              ),
              routes: {
                '/': (BuildContext context) => HomePage(),
                'homeLocal': (BuildContext context) => HomeLocal(),
                
                'login': (BuildContext context) => LoginPage(),
                'splash': (BuildContext context) => Splash(),
                'desicion': (BuildContext context) => DesicionPage(),
                //'detalleP': (BuildContext context) => DetalleProductitoss(),
                'detallePago': (BuildContext context) => DetallePago(),
                'sel_Direccion': (BuildContext context) => MapsSample(),
                //'combo': (BuildContext context) => CategoriasEspecialesPage(),
                'ordenes': (BuildContext context) => OrdenesPage(),
                'ordenesPago': (BuildContext context) => OrdenesPagoPage(),
                'detallePedido': (BuildContext context) => DetallePedido(),
                /* 'pedidosRepartidor': (BuildContext context) => PedidosRepartidor(),
                'mapaRepartidor': (BuildContext context) => MapaRepartidor(), */
                'mapaCliente': (BuildContext context) => MapaCliente(),
                
                'zoomDireccion': (BuildContext context) => ZoomFotoDireccion(),

                'timeline': (BuildContext context) => DeliveryTimeline(),
                'webView': (BuildContext context) => WebViewExample(),
                'ticket': (BuildContext context) => Ticket(),
                'gestionarDirecciones': (BuildContext context) => GestionarDirecciones(),
                'detalleProductoFoto': (BuildContext context) => DetalleProductoFoto(),
                'detallePromociones': (BuildContext context) => DetallePromociones(),
                'onboarding': (BuildContext context) => OnboardingPage(),
                'productosCategoria': (BuildContext context) => ProductosCategoria(),
                /*  'detallePromocionesLocal': (BuildContext context) =>
                    DetallePromocionesLocal(), */
                'notificationPage': (BuildContext context) => NotificationPage(),
                'pantallaDeliveryOpciones': (BuildContext context) => PantallaDeliveryOpciones(),


                //puzzle:

                /* 'HomePuzzle': (BuildContext context) => HomePuzzle(),
                'puzzle': (BuildContext context) => PuzzlePage(),
                'ranking': (BuildContext context) => RankingPage(),
                'rankingReport': (BuildContext context) => RankingReport(), */
              },
            ),
          ),
        ),
      ),
    );
  }
}
