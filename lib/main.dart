
import 'package:enchiladasapp/src/models/ReceivedNotification.dart';
import 'package:enchiladasapp/src/pages/detalle_productos.dart';
import 'package:enchiladasapp/src/pages/gestionar_direcciones.dart';
import 'package:enchiladasapp/src/pages/mapa_cliente.dart';
import 'package:enchiladasapp/src/pages/market_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/delivery_timeline.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_pago_page.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking_report.dart';
import 'package:enchiladasapp/src/pages/ticket.dart';
import 'package:enchiladasapp/src/pages/webview.dart';
import 'package:enchiladasapp/src/pages/zoom_foto_direccion.dart';
import 'package:enchiladasapp/src/pushProvider/push_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:enchiladasapp/src/pages/mapa_repartidor.dart';
import 'package:enchiladasapp/src/pages/categorias_especiales.dart';
import 'package:enchiladasapp/src/pages/detalle_pago.dart';
import 'package:enchiladasapp/src/pages/detalle_pedido.dart';
import 'package:enchiladasapp/src/pages/select_direction.dart';
import 'package:enchiladasapp/src/widgets/preferencias_usuario.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/pages/login_page.dart';
import 'package:enchiladasapp/src/pages/splash.dart';
import 'package:enchiladasapp/src/pages/home_page.dart';
import 'package:enchiladasapp/src/pages/desicion_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/ordenes_page.dart';
import 'package:enchiladasapp/src/pages/pedidos_repartidor_page.dart';
import 'package:enchiladasapp/src/pages/puzzle/home_puzzle.dart';
import 'package:enchiladasapp/src/pages/puzzle/puzzle.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

Future<void> showNotificationWithIconBadge(
    ReceivedNotification notification) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'icon badge channel', 'icon badge name', 'icon badge description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, '${notification.title}',
      '${notification.body}', platformChannelSpecifics,
      payload: notification.payload);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new Preferences();

  await prefs.initPrefs();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('logo');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

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
  final GlobalKey<NavigatorState> navigatorkey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();

    pushNotificationProvider.mensajes.listen((event) {
      navigatorkey.currentState.pushNamed('timeline', arguments: event);
    });

    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    /* final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();  */
    super.initState();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
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
            title: receivedNotification.title != null
                ? Text(receivedNotification.title)
                : null,
            content: receivedNotification.body != null
                ? Text(receivedNotification.body)
                : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await navigatorkey.currentState.pushNamed('timeline',
                      arguments: receivedNotification.payload);
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
        await navigatorkey.currentState
            .pushNamed('timeline', arguments: payload);
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
    return ProviderBloc(
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
          'HomePuzzle': (BuildContext context) => HomePuzzle(),
          'puzzle': (BuildContext context) => PuzzlePage(),
          'login': (BuildContext context) => LoginPage(),
          'splash': (BuildContext context) => Splash(),
          'desicion': (BuildContext context) => DesicionPage(),
          'detalleP': (BuildContext context) => DetalleProductitos(),
          //'detalleP': (BuildContext context) => DetalleProductitos(),
          'detallePago': (BuildContext context) => DetallePago(),
          'sel_Direccion': (BuildContext context) => MapsSample(),
          'combo': (BuildContext context) => CategoriasEspecialesPage(),
          'ordenes': (BuildContext context) => OrdenesPage(),
          'ordenesPago': (BuildContext context) => OrdenesPagoPage(),
          'detallePedido': (BuildContext context) => DetallePedido(),
          'pedidosRepartidor': (BuildContext context) => PedidosRepartidor(),
          'mapaRepartidor': (BuildContext context) => MapaRepartidor(),
          'mapaCliente': (BuildContext context) => MapaCliente(),
          'ranking': (BuildContext context) => RankingPage(),
          'rankingReport': (BuildContext context) => RankingReport(),
          'zoomDireccion': (BuildContext context) => ZoomFotoDireccion(),
          'market': (BuildContext context) => MarketPage(),
          'timeline': (BuildContext context) => DeliveryTimeline(),
          'webView': (BuildContext context) => WebViewExample(),
          'ticket': (BuildContext context) => Ticket(),
          'gestionarDirecciones': (BuildContext context) => GestionarDirecciones(),

/* 

          'r1': (BuildContext context) => RankingUno(),
          'r2': (BuildContext context) => RankingDos(),
          'r3': (BuildContext context) => RankingTres(),
          '>3': (BuildContext context) => Mayor3(), */
        },
      ),
    );
  }
}
