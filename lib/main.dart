import 'package:enchiladasapp/src/pages/mapa_cliente.dart';
import 'package:enchiladasapp/src/pages/market_page.dart';
import 'package:enchiladasapp/src/pages/ordenes/delivery_timeline.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking.dart';
import 'package:enchiladasapp/src/pages/puzzle/ranking_report.dart';
import 'package:enchiladasapp/src/pages/seleccion_zona_page.dart';
import 'package:enchiladasapp/src/pages/zoom_foto_direccion.dart';
import 'package:enchiladasapp/src/pushProvider/push_notifications.dart';
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
import 'package:enchiladasapp/src/pages/detalle_producto.dart';
import 'package:enchiladasapp/src/pages/home_page.dart';
import 'package:enchiladasapp/src/pages/desicion_page.dart';
import 'package:enchiladasapp/src/pages/ordenes_page.dart';
import 'package:enchiladasapp/src/pages/pedidos_repartidor_page.dart';
import 'package:enchiladasapp/src/pages/puzzle/home_puzzle.dart';
import 'package:enchiladasapp/src/pages/puzzle/puzzle.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new Preferences();

  await prefs.initPrefs();
  initializeDateFormatting('es_MX').then((_) => runApp(MyApp()));

  //runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    /* final pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.initNotification();  */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
      child: MaterialApp(


        debugShowCheckedModeBanner: false,
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
          'detalleP': (BuildContext context) => DetalleProducto(),
          'detallePago': (BuildContext context) => DetallePago(),
          'sel_Direccion': (BuildContext context) => MapsSample(),
          'combo': (BuildContext context) => CategoriasEspecialesPage(),
          'ordenes': (BuildContext context) => OrdenesPage(),
          'detallePedido': (BuildContext context) => DetallePedido(),
          'pedidosRepartidor': (BuildContext context) => PedidosRepartidor(),
          'mapaRepartidor': (BuildContext context) => MapaRepartidor(),
          'mapaCliente': (BuildContext context) => MapaCliente(),
          'selZona': (BuildContext context) => SeleccionZona(),
          'ranking': (BuildContext context) => RankingPage(),
          'rankingReport': (BuildContext context) => RankingReport(),
          'zoomDireccion': (BuildContext context) => ZoomFotoDireccion(),
          'market': (BuildContext context) => MarketPage(),
          'timeline': (BuildContext context) => DeliveryTimeline(),
        },
      ),
    );
  }
}