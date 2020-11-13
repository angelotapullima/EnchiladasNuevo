import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/models/argumentsWebview.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/utils/circle.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';

class Ticket extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    final ArgumentsWebview args = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    final pedidoBloc = ProviderBloc.pedido(context);

    pedidoBloc.obtenerPedidoPorId(args.idPedido);
    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(
          context,
          ModalRoute.withName('/'),
        );

        return null;
      },
      child: Scaffold(
        //backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            (args.codigo == '1')
                ? pedidoCorrecto(context, responsive, pedidoBloc)
                : Container(),
            (args.codigo == "2") ? pedidoCancelado(responsive) : Container(),
            (args.codigo == "3") ? pedidoRechazado(responsive) : Container(),
            (args.codigo == "4") ? pedidoError(responsive) : Container(),
          ],
        ),
      ),
    );
  }

  Widget pedidoCorrecto(
      BuildContext context, Responsive responsive, PedidoBloc pedidoBloc) {
    final carritoBloc = ProviderBloc.carrito(context);

    final carritoDatabase = CarritoDatabase();
    carritoDatabase.deleteCarritoDb();
    utils.agregarZona(context, '');
    carritoBloc.obtenerCarrito();
    pedidoBloc.obtenerPedidosPendientes(context);
    return Stack(children: <Widget>[
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
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: responsive.hp(2),
            horizontal: responsive.wp(2),
          ),
          child: FlutterTicketWidget(
            width: double.infinity,
            height: double.infinity,
            isCornerRounded: true,
            child: Padding(
              padding: EdgeInsets.only(
                top: responsive.hp(1),
              ),
              child: StreamBuilder(
                stream: pedidoBloc.pedidoIdStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PedidoServer>> snapshot) {
                  if (snapshot.hasData) {
                    return detalleTickets(responsive, snapshot.data[0]);
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: responsive.hp(8),
        left: responsive.wp(4),
        child: GestureDetector(
          child: CircleContainer(
            radius: responsive.ip(2.5),
            color: Colors.grey[100],
            widget: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onTap: () {

            Navigator.pushNamed(context, 'ordenesPago');

            /* Navigator.popUntil(
              context,
              ModalRoute.withName('/'),
            );  */
          },
        ),
      ),
    ]);
  }

  Widget detalleTickets(Responsive responsive, PedidoServer pedido) {
    var tipoPago;
    if (pedido.pedidoTipoComprobante == '6') {
      tipoPago = 'Boleta';
    } else if (pedido.pedidoTipoComprobante == '7'){
      tipoPago = 'Factura';
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: responsive.ip(9),
                width: responsive.ip(9),
                child: Image.asset('assets/logo_enchilada.png'),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(1),
            ),
            child: Center(
              child: Text(
                'Comprobante de Pago',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(2.5),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(2.5),
              left: responsive.wp(10),
              right: responsive.wp(10),
            ),
            child: Column(
              children: <Widget>[
                ticketDetailsWidget('Fecha', '${pedido.pedidoFecha}', 'Hora',
                    '${pedido.pedidoHora}', responsive),
                SizedBox(
                  height: responsive.hp(1.5),
                ),
                ticketDetailsWidget(
                    'Cliente', '${pedido.pedidoNombre}', '', '', responsive),
                SizedBox(
                  height: responsive.hp(1.5),
                ),
                ticketDetailsWidget('Tipo de Pago', '$tipoPago', 'Código',
                    '${pedido.pedidoCodigo}', responsive),
                SizedBox(
                  height: responsive.hp(1.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: responsive.hp(1)),
            child: Center(
              child: Text(
                'Productos',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: responsive.ip(2.5),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: responsive.hp(1),
                left: responsive.wp(10),
                right: responsive.wp(10)),
            child: listProducts(
                context, responsive, pedido.idPedido, pedido.pedidoTotal),
          ),
        ],
      ),
    );
  }

  Widget listProducts(
      BuildContext context, Responsive responsive, String id, String total) {
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerDetallePedido(id);

    return StreamBuilder(
        stream: pedidoBloc.detallePedidoStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return products(responsive, snapshot.data, total);
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        });
  }

  ListView products(
      Responsive responsive, List<ProductoServer> productos, String totalex) {

        var totalito = utils.format(double.parse(totalex));
    final total = Container(
        margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        child: Column(
          children: <Widget>[
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Total',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: responsive.wp(5),
                ),
                Text('S/ $totalito',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: responsive.ip(2.5),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ));
    return ListView.builder(
      itemCount: productos.length + 1,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, i) {
        if (i == productos.length) {
          return total;
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: responsive.hp(.5)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${productos[i].productoNombre} x ${productos[i].detalleCantidad}',
                  style: TextStyle(fontSize: responsive.ip(2)),
                ),
              ),
              SizedBox(
                width: responsive.wp(5),
              ),
              Text(
                'S/.${productos[i].detallePrecioTotal}',
                style: TextStyle(
                    fontSize: responsive.ip(2),
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      },
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc, Responsive responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              child: Text(
                firstDesc,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              secondTitle,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              child: Text(
                secondDesc,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget pedidoRechazado(Responsive responsive) {
    return Stack(
      children: <Widget>[
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
        Center(
          child: Text(
            'El págo Fue rechazado',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.ip(2),
            ),
          ),
        )
      ],
    );
  }

  Widget pedidoError(Responsive responsive) {
    return Stack(
      children: <Widget>[
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
        Center(
          child: Text(
            'Ocurrio un error con el págo',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.ip(2),
            ),
          ),
        )
      ],
    );
  }

  Widget pedidoCancelado(Responsive responsive) {
    return Stack(
      children: <Widget>[
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
        Center(
          child: Text(
            'El págo Fue Cancelado',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.ip(2),
            ),
          ),
        )
      ],
    );
  }
}
