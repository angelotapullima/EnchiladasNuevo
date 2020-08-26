import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    print('id pedido timeline $id');
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId(id);
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
                            ? _botonTracking(
                                context, snapshot.data[0].idPedido)
                            : Container(),
                        _TimelineDelivery(
                          id: int.parse(
                            snapshot.data[0].pedidoEstado,
                          ),
                        ),
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

    print('esto va del timeline a mapa tracking $id');
    final responsive = Responsive.of(context);
    return FlatButton(
      onPressed: () {
        Navigator.pushNamed(context, 'mapaCliente', arguments: id);
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
    }

    return Center(
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
              title: 'Order Recibida',
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
              title: 'Order Confirmed',
              message: 'Su pedido fue confirmado',
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
              title: 'Order Asignada ',
              message: 'Su pedido fue asigando al repartidor.',
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
              message: 'Su pedido Está en camino',
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
              title: 'Su pedido Fue entregado',
              message: 'El pedido se entrego correctamente',
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
                    precio,
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
