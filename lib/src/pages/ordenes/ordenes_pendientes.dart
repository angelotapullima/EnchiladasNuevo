import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrdenesPendientes extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh(BuildContext context) async {
    print('_onRefresh');
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidosPendientes(context);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidosPendientes(context);
    final responsive = Responsive.of(context);

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: responsive.hp(70),
        width: double.infinity,
        color: Colors.red,
      ),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: _contenido(context, pedidoBloc),
      ),
    ]));
  }

  Widget _contenido(BuildContext context, PedidoBloc pedidoBloc) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(13), topEnd: Radius.circular(13)),
              color: Colors.grey[50]),
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: () {
              _onRefresh(context);
            },
            child: StreamBuilder(
                stream: pedidoBloc.pedidosPendientesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PedidoServer>> snapshot) {
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
                                _itemPedido(context, snapshot.data[i])),
                      );
                    } else {
                      return Center(
                        child: Text('No hay ordenes'),
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

  _itemPedido(BuildContext context, PedidoServer data) {
    final responsive = Responsive.of(context);
    var colores = Colors.black;
    var estadoItem = 'Enviado';

    if (data.pedidoEstado == '1') {
      colores = Colors.blue;
      estadoItem = 'Aceptado';
    } else if (data.pedidoEstado == '2') {
      colores = Colors.yellow;
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
    }else if(data.pedidoEstado == '0'){

      if(data.pedidoEstadoPago =='1'){
        colores = Colors.green;
      estadoItem = 'Pagado';
      }
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            color: Colors.grey[50]),
        padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(3), vertical: responsive.hp(2)),
        margin: EdgeInsets.symmetric(
            horizontal: responsive.wp(3), vertical: responsive.hp(0.2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text('${data.pedidoNombre}',
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
                  child: Text('$estadoItem',
                      style: TextStyle(
                          color: Colors.white, fontSize: responsive.ip(1.5))),
                )
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text('Dirección : ',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2))),
                Expanded(child: Text('${data.pedidoDireccion} ')),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text('Referencia : ',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2))),
                Expanded(child: Text('${data.pedidoReferencia} ')),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text('Teléfono : ',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2))),
                Expanded(child: Text(' ${data.pedidoTelefono}')),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text('Fecha : ',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(2))),
                Expanded(child: Text(' ${data.pedidoFecha}')),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Text('S/. ${data.pedidoTotal}',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(3)))
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'detallePedido', arguments: data);
      },
    );
  }
}
