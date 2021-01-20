import 'dart:async';

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/arguments.dart';
import 'package:enchiladasapp/src/models/argumentsWebview.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/models/productos_model.dart';
import 'package:enchiladasapp/src/pages/blocMapa/mapa_page.dart';
import 'package:enchiladasapp/src/pages/categorias_especiales.dart';
import 'package:enchiladasapp/src/pages/detalle_producto2.dart';
import 'package:enchiladasapp/src/pages/home_page.dart';
import 'package:enchiladasapp/src/pages/rating_repartidor.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String notificationModel = ModalRoute.of(context).settings.arguments;

    print('notifissss   $notificationModel');

    final noti = notificationModel.split(';');
    final idPedido = noti[0].trim();
    final tipoNotificacion = noti[1].trim();
    final idMostrar = noti[2].trim();

    final pedidoParse = idPedido.split('=');
    String idPedidoVerdadero = pedidoParse[1].trim();

    final tipoNParse = tipoNotificacion.split('=');
    String tipoVerdadero = tipoNParse[1].trim();

    final idMostrarDato = idMostrar.split('=');
    String id = idMostrarDato[1].trim();

    print('bfbr $idPedidoVerdadero');

    switch (tipoVerdadero) {
      case "pedido":
        {
          return Scaffold(
            body: DeliveryTimelineNotification(
              id: idPedidoVerdadero,
            ),
          );
        }
        break;

      case "valoracion":
        {
          return Scaffold(
            body: RatingRepartidor(
              id: idPedidoVerdadero,
            ),
          );
        }
        break;

      case "categoria":
        {
          Arguments arg = new Arguments("Productos", '$id');

          return CategoriasEspecialesPage(arg: arg);
        }
        break;

      case "producto":
        ProductosData productosData = ProductosData();
        productosData.idProducto = id;
        {
          return DetalleProductitoss2(
            productosData: productosData,
            mostrarback: true,
          );
        }
        break;

      default:
        {
          return HomePage();
        }
        break;
    }
    /* return Scaffold(
      body: (tipoVerdadero == 'pedido')
          ? DeliveryTimelineNotification(
              id: idPedidoVerdadero,
            )
          : RatingRepartidor(
              id: idPedidoVerdadero,
            ),
    ); */
  }
}

class DeliveryTimelineNotification extends StatefulWidget {
  final id;

  const DeliveryTimelineNotification({Key key, @required this.id})
      : super(key: key);
  @override
  _DeliveryTimelineNotificationState createState() =>
      _DeliveryTimelineNotificationState();
}

class _DeliveryTimelineNotificationState
    extends State<DeliveryTimelineNotification> {
  Timer timer;

  bool banderaTimer = true;

  @override
  void dispose() {
    banderaTimer = false;
    print('dispose bb');

    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId(widget.id);

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (banderaTimer) {
        pedidoBloc.obtenerPedidoPorId(widget.id);
      } else {
        timer.cancel();
      }
    });
    return Scaffold(
        appBar: _AppBar(),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: pedidoBloc.pedidoIdStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<PedidoServer>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _Header(
                            precio: snapshot.data[0].pedidoTotal,
                            codigo: snapshot.data[0].pedidoCodigo),
                        (snapshot.data[0].pedidoEstado == '3')
                            ? _botonTracking(context, snapshot.data[0].idPedido)
                            : Container(),
                        (snapshot.data[0].pedidoEstado == '4')
                            ? _botonBoleta(context, snapshot.data[0].idPedido)
                            : Container(),
                        _TimelineDelivery(
                          id: int.parse(
                            snapshot.data[0].pedidoEstado,
                          ),
                        ),
                        SizedBox(
                          height: 500,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            } else {
              return Center(child: Text('No hay datos'));
            }
          },
        ));
  }

  Widget _botonTracking(BuildContext context, String id) {
    //print('esto va del timeline a mapa tracking $id');
    final responsive = Responsive.of(context);
    return FlatButton(
      onPressed: () {
        timer?.cancel();

        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              return MapaPage(
                idRepartidor: id,
              );
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        //Navigator.pushNamed(context, 'mapaCliente', arguments: id);
        //Navigator.pushNamed(context, 'mapaCliente',arguments: '${pedido[0].idPedido}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: responsive.ip(5), vertical: responsive.ip(1)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.red),
        child: Text('Ver ubicacion del repartidor',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _botonBoleta(BuildContext context, String id) {
    //print('esto va del timeline a mapa tracking $id');
    final responsive = Responsive.of(context);
    return FlatButton(
      onPressed: () {
        timer?.cancel();
        ArgumentsWebview argumentsWebview = ArgumentsWebview();
        argumentsWebview.idPedido = id;
        argumentsWebview.codigo = '1';

        Navigator.pushNamed(context, 'ticket', arguments: argumentsWebview);
        //Navigator.pushNamed(context, 'mapaCliente',arguments: '${pedido[0].idPedido}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: responsive.ip(5), vertical: responsive.ip(1)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.red),
        child: Text('Ver Ticket', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _TimelineDelivery extends StatelessWidget {
  final int id;

  const _TimelineDelivery({Key key, @required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    Color timeline0;
    Color timeline1;
    Color timeline2;
    Color timeline3;
    Color timeline4;
    bool disabled = false;
    bool disabled1 = false;
    bool disabled2 = false;
    bool disabled3 = false;
    bool disabled4 = false;

    bool cancelado = false;

    if (id == 0) {
      timeline0 = Colors.green;
      timeline1 = Colors.red;
      timeline2 = Colors.red;
      timeline3 = Colors.red;
      timeline4 = Colors.red;

      disabled = false;
      disabled1 = true;
      disabled2 = true;
      disabled3 = true;
      disabled4 = true;
    } else if (id == 1) {
      timeline0 = Colors.green;
      timeline1 = Colors.green;
      timeline2 = Colors.red;
      timeline3 = Colors.red;
      timeline4 = Colors.red;

      disabled = false;
      disabled1 = false;
      disabled2 = true;
      disabled3 = true;
      disabled4 = true;
    } else if (id == 2) {
      timeline0 = Colors.green;
      timeline1 = Colors.green;
      timeline2 = Colors.green;
      timeline3 = Colors.red;
      timeline4 = Colors.red;

      disabled = false;
      disabled1 = false;
      disabled2 = false;
      disabled3 = true;
      disabled4 = true;
    } else if (id == 3) {
      timeline0 = Colors.green;
      timeline1 = Colors.green;
      timeline2 = Colors.green;
      timeline3 = Colors.green;
      timeline4 = Colors.red;

      disabled = false;
      disabled1 = false;
      disabled2 = false;
      disabled3 = false;
      disabled4 = true;
    } else if (id == 4) {
      timeline0 = Colors.green;
      timeline1 = Colors.green;
      timeline2 = Colors.green;
      timeline3 = Colors.green;
      timeline4 = Colors.green;

      disabled = false;
      disabled1 = false;
      disabled2 = false;
      disabled3 = false;
      disabled4 = false;
    } else {
      timeline0 = Colors.yellow;
      timeline1 = Colors.yellow;
      timeline2 = Colors.yellow;
      timeline3 = Colors.yellow;
      timeline4 = Colors.yellow;

      cancelado = true;

      disabled = false;
      disabled1 = false;
      disabled2 = false;
      disabled3 = false;
      disabled4 = false;
    }

    return (cancelado)
        ? CanceladoNotification()
        : Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.1,
                  isFirst: true,
                  indicatorStyle: IndicatorStyle(
                    width: responsive.wp(5),
                    color: timeline0,
                    padding: EdgeInsets.all(6),
                  ),
                  rightChild: _RightChild(
                    disabled: disabled,
                    asset: 'assets/delivery/ENCHILADAS-02.svg',
                    title: 'Orden Recibida',
                    message: 'Su pedido fue procesado.',
                  ),
                  topLineStyle: LineStyle(
                    color: timeline0,
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.1,
                  indicatorStyle: IndicatorStyle(
                    width: responsive.wp(5),
                    color: timeline1,
                    padding: EdgeInsets.all(6),
                  ),
                  rightChild: _RightChild(
                    disabled: disabled1,
                    asset: 'assets/delivery/ENCHILADAS-03.svg',
                    title: 'Orden Confirmada',
                    message: 'Su pedido fue confirmado.',
                  ),
                  topLineStyle: LineStyle(
                    color: timeline1,
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.1,
                  indicatorStyle: IndicatorStyle(
                    width: responsive.wp(5),
                    color: timeline2,
                    padding: EdgeInsets.all(6),
                  ),
                  rightChild: _RightChild(
                    disabled: disabled2,
                    asset: 'assets/delivery/ENCHILADAS-04.svg',
                    title: 'Orden Asignada ',
                    message: 'Su pedido fue asignado al repartidor.',
                  ),
                  topLineStyle: LineStyle(
                    color: timeline2,
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.1,
                  indicatorStyle: IndicatorStyle(
                    width: responsive.wp(5),
                    color: timeline3,
                    padding: EdgeInsets.all(6),
                  ),
                  rightChild: _RightChild(
                    disabled: disabled3,
                    asset: 'assets/delivery/ENCHILADAS-05.svg',
                    title: 'Pedido en camino',
                    message: 'Su pedido está en camino.',
                  ),
                  topLineStyle: LineStyle(
                    color: timeline3,
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineX: 0.1,
                  isLast: true,
                  indicatorStyle: IndicatorStyle(
                    width: responsive.wp(5),
                    color: timeline4,
                    padding: EdgeInsets.all(6),
                  ),
                  rightChild: _RightChild(
                    disabled: disabled4,
                    asset: 'assets/delivery/ENCHILADAS-06.svg',
                    title: 'Su pedido fue entregado',
                    message: 'El pedido se entrego correctamente.',
                  ),
                  topLineStyle: LineStyle(
                    color: timeline4,
                  ),
                ),
              ],
            ),
          );
  }
}

class CanceladoNotification extends StatelessWidget {
  const CanceladoNotification({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: responsive.hp(3),
        ),
        Container(
          width: double.infinity,
          height: responsive.ip(20),
          child: Image.asset('assets/logo_enchilada.png'),
        ),
        SizedBox(
          height: responsive.hp(3),
        ),
        Text(
          'Su pedido fue cancelado',
          style: TextStyle(
            fontSize: responsive.ip(3),
          ),
        ),
      ],
    );
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Padding(
      padding: EdgeInsets.all(responsive.ip(1.8)),
      child: Row(
        children: <Widget>[
          Opacity(
            child: SvgPicture.asset(
              asset,
              height: responsive.hp(7),
            ), //Image.asset(asset, height: responsive.hp(7)),
            opacity: disabled ? 0.5 : 1,
          ),
          SizedBox(width: responsive.wp(4)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.yantramanav(
                    color: disabled
                        ? const Color(0xFFBABABA)
                        : const Color(0xFF636564),
                    fontSize: responsive.ip(2.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: responsive.hp(1)),
                Text(
                  message,
                  style: GoogleFonts.yantramanav(
                    color: disabled
                        ? const Color(0xFFD5D5D5)
                        : const Color(0xFF636564),
                    fontSize: responsive.ip(1.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String precio;
  final String codigo;

  const _Header({Key key, @required this.precio, @required this.codigo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9E9E9),
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Precio Pedido',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFFA2A2A2),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'S/. $precio',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFF636564),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Código Pedido',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFFA2A2A2),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    codigo,
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFF636564),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(
        'Seguimiento de pedido',
        style: GoogleFonts.notoSans(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
