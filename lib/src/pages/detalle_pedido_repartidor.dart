

import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DetallePedidoRepartidor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String pedido = ModalRoute.of(context).settings.arguments;
    final pedidoBloc = ProviderBloc.asignados(context);
    pedidoBloc.obtenerPedidoAsignadoPorId(pedido);
    final responsive = Responsive.of(context);
 
    

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: responsive.hp(70),
            width: double.infinity,
            color: Colors.red,
          ),
          StreamBuilder(
              stream: pedidoBloc.pedidoAsignadosStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<PedidoAsignados>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return _contenido(context, pedido, snapshot.data);
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              })
        ],
      ),
    );
  }

  Widget _contenido(
      BuildContext context, String idPedido, List<PedidoAsignados> pedido) {
        
    final responsive = new Responsive.of(context);
    String referencia = "-";
    if (pedido[0].pedidoReferencia != "") {
      referencia = pedido[0].pedidoReferencia;
    }
    

    // if (formaPago == '3' &&
    //     estadoPago == '0' &&
    //     pedido[0].pedidoLink != '' &&
    //     pedido[0].pedidoLink != null) {
    //   print('link de : ${pedido[0].pedidoLink}');
    //   completarPago = true;
    // }

    return SafeArea(
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: 0,
            title: Text('Pedido'),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(13),
                        topEnd: Radius.circular(13),
                      ),
                      color: Colors.grey[50]),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: responsive.wp(5),
                      right: responsive.wp(5),
                      top: responsive.hp(1)),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.grey[200]),
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Text(
                        'Resumen de Pedido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Container(
                        height: responsive.hp(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${pedido[0].pedidoFecha}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: responsive.ip(2),
                              ),
                            ),
                            Image.asset('assets/logo_enchilada.png'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Text(
                        'Productos',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      _productos(responsive, context, idPedido, pedido[0]),
                      Divider(),
                      Text(
                        'Teléfono',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Text(
                        '${pedido[0].pedidoTelefono}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Divider(),
                      Text(
                        'Dirección',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(2.5),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Text(
                        '${pedido[0].pedidoDireccion}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$referencia',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _productos(Responsive responsive, BuildContext context, String id,
      PedidoAsignados pedido) {
    final pedidoBloc = ProviderBloc.asignados(context);
    pedidoBloc.obtenerDetalleAsignadoPedido(id);

    return StreamBuilder(
        stream: pedidoBloc.detallePedidoAsignadosStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _listaProductos(
                  context, responsive, snapshot.data, pedido);
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        });
  }

  _listaProductos(BuildContext context, Responsive responsive,
      List<DetallePedidoAsignados> producto, PedidoAsignados pedido) {
    final total = Container(
      margin: EdgeInsets.symmetric(
        vertical: responsive.hp(1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              'Total',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: responsive.ip(2),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'S/ ${pedido.pedidoTotal}',
            style: TextStyle(
                color: Colors.red,
                fontSize: responsive.ip(2),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: producto.length + 1,
        itemBuilder: (context, i) {
          if (i == producto.length) {
            return total;
          }
          return _itemProducto(responsive, producto[i]);
        });
  }

  Widget _itemProducto(Responsive responsive, DetallePedidoAsignados producto) {
    String nombre = "";
    if (double.parse(producto.detalleCantidad) > 1) {
      nombre = "${producto.productoNombre} x ${producto.detalleCantidad}";
    } else {
      nombre = "${producto.productoNombre}";
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: responsive.hp(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text('$nombre',
                style: TextStyle(
                    color: Colors.black, fontSize: responsive.ip(1.5))),
          ),
          Text('S/.${producto.detallePrecioTotal}',
              style:
                  TextStyle(color: Colors.black, fontSize: responsive.ip(1.5))),
        ],
      ),
    );
  }
}