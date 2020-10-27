import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/pedidos_asignados_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PedidosRepartidor extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh(BuildContext context) async {
    // monitor network fetch
    print('_onRefresh');
    final pedidosAsignados = ProviderBloc.asignados(context);
    pedidosAsignados.obteberPedidosAsignados();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted(); 
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: responsive.hp(50),
            width: double.infinity,
            color: Colors.red,
          ),
          _contenidorOrdenes(context),
        ],
      ),
    );
  }

  Widget _contenidorOrdenes(BuildContext context) {
    final pedidosAsignados = ProviderBloc.asignados(context);
    pedidosAsignados.obteberPedidosAsignados();
    return SafeArea(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Pedidos Asignados'),
          elevation: 0,
          actions: <Widget>[],
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(13),
                topEnd: Radius.circular(13),
              ),
              color: Colors.grey[50]),
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: () {
              _onRefresh(context);
            },
            enablePullUp: true,
            child: StreamBuilder(
                stream: pedidosAsignados.pedidoAsignadosStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PedidoAsignados>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () {
                          _onRefresh(context);
                        },
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) =>
                              _itemPedido(context, snapshot.data[i]),
                        ),
                      );
                    } else {
                      //vacio
                      return Center(
                        child: Text('no hay Pedidos Asignados'),
                      );
                    }
                  } else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }),
          ),
        ))
      ],
    ));
  }

  Widget _itemPedido(BuildContext context, PedidoAsignados data) {
    final responsive = Responsive.of(context);

    var colores = Colors.black;
    var estadoItem = 'Enviado';

    if (data.pedidoEstado == '1') {
      colores = Colors.blue;
      estadoItem = 'Aceptado';
    } else if (data.pedidoEstado == '2') {
      colores = Colors.purple;
      estadoItem = 'Asignado';
    } else if (data.pedidoEstado == '3') {
      colores = Colors.orange;
      estadoItem = 'En camino';
    } else if (data.pedidoEstado == '4') {
      colores = Colors.green;
      estadoItem = 'Entregado';
    } else if (data.pedidoEstado == '5') {
      colores = Colors.red;
      estadoItem = 'cancelado';
    } else if (data.pedidoEstado == '0') {
      if (data.pedidoEstadoPago == '1') {
        colores = Colors.green;
        estadoItem = 'Pagado';
      }
    }

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
            color: Colors.grey[50]),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(3),
          vertical: responsive.hp(2),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(3),
          vertical: responsive.hp(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text('${data.pedidoCodigo} ${data.pedidoNombre}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.ip(2.5)))),
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)),
                      color: colores),
                  padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(1.5),
                      vertical: responsive.hp(0.5)),
                  child: Text(
                    '$estadoItem',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(1.5),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Dirección : ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(
                  child: Text('${data.pedidoDireccion} '),
                ),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Referencia : ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(
                  child: Text('${data.pedidoReferencia} '),
                ),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Teléfono : ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(
                  child: Text(' ${data.pedidoTelefono}'),
                ),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Fecha : ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(
                  child: Text(' ${data.pedidoFecha}'),
                ),
              ],
            ),
            SizedBox( 
              height: responsive.hp(1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'detallePedidoRepartidor',
                        arguments: data.idPedido);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.all(
                          Radius.circular(10),
                        ),
                        color: Colors.red),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(1.8),
                      vertical: responsive.hp(0.8),
                    ),
                    child: Text(
                      'Ver Detalle de Pedido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(2),
                      ),
                    ),
                  ),
                ),
                Text(
                  'S/. ${data.pedidoTotal}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(3),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'mapaRepartidor', arguments: data);
      },
    );
  }
}
