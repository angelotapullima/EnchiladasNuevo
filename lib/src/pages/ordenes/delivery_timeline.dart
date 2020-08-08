import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId('37');
    return Scaffold(
        appBar: _AppBar(),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: pedidoBloc.pedidoIdStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      _Header(),
                      Expanded(child: _TimelineDelivery()),
                    ],
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
}

class _TimelineDelivery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.1,
            isFirst: true,
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: Colors.red,
              padding: EdgeInsets.all(6),
            ),
            rightChild: _RightChild(
              asset: 'assets/delivery/order_placed.png',
              title: 'Order Recibida',
              message: 'Su pedido fue procesado.',
            ),
            topLineStyle: LineStyle(
              color: Colors.red,
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.blue,
              padding: EdgeInsets.all(6),
            ),
            rightChild: const _RightChild(
              asset: 'assets/delivery/order_confirmed.png',
              title: 'Order Confirmed',
              message: 'Su pedido fue confirmado',
            ),
            topLineStyle: const LineStyle(
              color: Colors.yellow
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            rightChild: const _RightChild(
              asset: 'assets/delivery/order_processed.png',
              title: 'Order Asignada ',
              message: 'Su pedido fue asigando al repartidor.',
            ),
            topLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFF27AA69),
              padding: EdgeInsets.all(6),
            ),
            rightChild: const _RightChild(
              disabled: false,
              asset: 'assets/delivery/ready_to_pickup.png',
              title: 'Pedido en camino',
              message: 'Su pedido Está en camino',
            ),
            topLineStyle: const LineStyle(
              color: Color(0xFF27AA69),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineX: 0.1,
            isLast: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Color(0xFFDADADA),
              padding: EdgeInsets.all(6),
            ),
            rightChild: const _RightChild(
              disabled: true,
              asset: 'assets/delivery/ready_to_pickup.png',
              title: 'Su pedido Fue entregado',
              message: 'El pedido se entrego correctamente',
            ),
            topLineStyle: const LineStyle(
              color: Color(0xFFDADADA),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
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
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'ESTIMATED TIME',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFFA2A2A2),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '30 minutes',
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
                    'ORDER NUMBER',
                    style: GoogleFonts.yantramanav(
                      color: const Color(0xFFA2A2A2),
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '#2482011',
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
