import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetallePedido extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final PedidoServer pedido = ModalRoute.of(context).settings.arguments;
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId(pedido.idPedido);
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
              stream: pedidoBloc.pedidoIdStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<PedidoServer>> snapshot) {
                if (snapshot.hasData) {
                  return _contenido(context, pedido.idPedido, snapshot.data);
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              })
        ],
      ),
    );
  }

  Widget _contenido(
      BuildContext context, String idPedido, List<PedidoServer> pedido) {
    final responsive = new Responsive.of(context);
    String referencia = "-";
    if (pedido[0].pedidoReferencia != "") {
      referencia = pedido[0].pedidoReferencia;
    }
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
                          topEnd: Radius.circular(13)),
                      color: Colors.grey[50]),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: responsive.wp(5),
                      right: responsive.wp(5),
                      top: responsive.hp(1)),
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.grey[200]),
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Text('Resumen de Pedido',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Container(
                        height: responsive.hp(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('${pedido[0].pedidoFecha}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: responsive.ip(2))),
                            Image.asset('assets/logo_enchilada.png'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Text('Productos',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      _productos(responsive, context, idPedido, pedido[0]),
                      Divider(),
                      Text('Telefono',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Text('${pedido[0].pedidoTelefono}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Divider(),
                      Text('Dirección',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2.5),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: responsive.hp(1),
                      ),
                      Text('${pedido[0].pedidoDireccion}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold)),
                      Text('$referencia',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold)),
                      Divider(),
                      FlatButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'timeline',arguments: '${pedido[0].idPedido}');
                          //Navigator.pushNamed(context, 'mapaCliente',arguments: '${pedido[0].idPedido}');
                        }, 
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: responsive.ip(5),vertical: responsive.ip(1)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red
                        ),
                        child: Text('Ver estado de pedido',style:TextStyle(color:Colors.white)),
                      ))
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
      PedidoServer pedido) {
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerDetallePedido(id);

    return StreamBuilder(
        stream: pedidoBloc.detallePedidoStream,
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
      List<ProductoServer> producto, PedidoServer pedido) {
    final total = Container(
        margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text('Total',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.bold)),
            ),
            Text('S/ ${pedido.pedidoTotal}',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: responsive.ip(2),
                    fontWeight: FontWeight.bold)),
          ],
        ));

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

  Widget _itemProducto(Responsive responsive, ProductoServer producto) {
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