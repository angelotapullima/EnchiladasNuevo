import 'dart:async';

import 'package:enchiladasapp/src/api/ordenes_api.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/models/argumentDetallePedido.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/pages/detallePedido/bloc_detalle_pago.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DetallePedido extends StatefulWidget {
  @override
  _DetallePedidoState createState() => _DetallePedidoState();
}

class _DetallePedidoState extends State<DetallePedido> {
  TextEditingController controllerMonto = new TextEditingController();

  Timer timer;

  bool banderaTimer = true;
  @override
  void dispose() {
    banderaTimer = false;
    print('dispose bb');

    timer.cancel();

    controllerMonto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String pedido = ModalRoute.of(context).settings.arguments;
    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId(pedido);
    final responsive = Responsive.of(context);

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (banderaTimer) {
        print('detalle pedido true ');
        pedidoBloc.obtenerPedidoPorId(pedido);
      } else {
        print('detalle pedido false ');
        timer.cancel();
      }
    });

    final provider = Provider.of<DetallePedidoBloc>(context, listen: false);
    provider.showDetalle.value = false;

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
                  if (snapshot.data.length > 0) {
                    return _contenido(context, pedido, snapshot.data);
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              }),
          ValueListenableBuilder<bool>(
              valueListenable: provider.showDetalle,
              builder: (_, value, __) {
                return (value)
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: responsive.wp(20),
                          ),
                          height: responsive.hp(10),
                          width: double.infinity,
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  Widget _contenido(
      BuildContext context, String idPedido, List<PedidoServer> pedido) {
    final provider = Provider.of<DetallePedidoBloc>(context, listen: false);

    bool completarPago = false;
    final responsive = new Responsive.of(context);
    String referencia = "-";
    if (pedido[0].pedidoReferencia != "") {
      referencia = pedido[0].pedidoReferencia;
    }

    String formaPago = pedido[0].pedidoFormaPago;
    String estadoPago = pedido[0].pedidoEstadoPago;

    if (formaPago == '3' &&
        estadoPago == '0' &&
        pedido[0].pedidoLink != '' &&
        pedido[0].pedidoLink != null) {
      completarPago = true;
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
                      pedido[0].pedidoEstado == '5'
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1),
                              ),
                              child: Text(
                                'El pedido está cancelado',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(2)),
                              ))
                          : (!completarPago)
                              ? Column(
                                  children: <Widget>[
                                    (pedido[0].pedidoEstadoPago == '0')
                                        ? (pedido[0].pedidoFormaPago == '3')
                                            ? MaterialButton(
                                                onPressed: () async {
                                                  showProcessingDialog(context);
                                                  final ordenesApi =
                                                      OrdenesApi();
                                                  final res = await ordenesApi
                                                      .cancelarPedido(
                                                          '${pedido[0].idPedido}');
                                                  if (res == 1) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    final pedidoBloc =
                                                        ProviderBloc.pedido(
                                                            context);
                                                    pedidoBloc
                                                        .obtenerPedidosPendientes(
                                                            context);
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Container(
                                                  width: responsive.wp(70),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        responsive.ip(5),
                                                    vertical: responsive.ip(1),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.red),
                                                  child: Text('Cancelar pedido',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              )
                                            : Container()
                                        : Container(),
                                    MaterialButton(
                                      onPressed: () {
                                        banderaTimer = false;
                                        timer?.cancel();
                                        Navigator.pushNamed(context, 'timeline',
                                            arguments: '${pedido[0].idPedido}');
                                        //Navigator.pushNamed(context, 'mapaCliente',arguments: '${pedido[0].idPedido}');
                                      },
                                      child: Container(
                                        width: responsive.wp(70),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.ip(5),
                                          vertical: responsive.ip(1),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.red),
                                        child: Text(
                                          'Ver estado de pedido',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    (pedido[0].pedidoEstadoPago == '0')
                                        ? (pedido[0].pedidoFormaPago == '3')
                                            ? MaterialButton(
                                                onPressed: () {
                                                  _modalCambiarMetodoPago(
                                                      context,
                                                      responsive,
                                                      '${pedido[0].pedidoTotal}',
                                                      '${pedido[0].idPedido}');
                                                },
                                                child: Container(
                                                  width: responsive.wp(70),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        responsive.ip(5),
                                                    vertical: responsive.ip(1),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.red),
                                                  child: Text(
                                                    'Cambiar método de pago',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                        : Container(),
                                    (pedido[0].pedidoEstadoPago == '0')
                                        ? (pedido[0].pedidoFormaPago == '3')
                                            ? MaterialButton(
                                                onPressed: () async {
                                                  showProcessingDialog(context);
                                                  final ordenesApi =
                                                      OrdenesApi();
                                                  final res = await ordenesApi
                                                      .reintentarPedido(
                                                          '${pedido[0].idPedido}');
                                                  if (res.resp == 1) {
                                                    if (res.link != "") {
                                                      Navigator.pop(context);
                                                      ArgumentsDetallePago
                                                          argumentsDetallePago =
                                                          ArgumentsDetallePago();
                                                      argumentsDetallePago
                                                          .link = res.link;
                                                      argumentsDetallePago
                                                              .idPedido =
                                                          res.idPedido;
                                                      Navigator.pushNamed(
                                                          context, 'webView',
                                                          arguments:
                                                              argumentsDetallePago);
                                                    } else {
                                                      Navigator.pop(context);
                                                      //pedidoCorrecto();
                                                    }
                                                  } else {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Container(
                                                  width: responsive.wp(70),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        responsive.ip(5),
                                                    vertical: responsive.ip(1),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.red),
                                                  child: Text(
                                                    'Reintentar pago',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                        : Container()
                                  ],
                                )
                              : MaterialButton(
                                  onPressed: () async {
                                    final ordernesApi = OrdenesApi();

                                    provider.showDetalle.value = true;
                                    final listPedido = await ordernesApi
                                        .obtenerPedidoPorId(idPedido);

                                    provider.showDetalle.value = false;

                                    ArgumentsDetallePago argumentsDetallePago =
                                        ArgumentsDetallePago();
                                    argumentsDetallePago.link =
                                        listPedido[0].pedidoLink;
                                    argumentsDetallePago.idPedido =
                                        listPedido[0].idPedido;
                                    Navigator.pushNamed(context, 'webView',
                                        arguments: argumentsDetallePago);
                                  },
                                  child: Container(
                                    width: responsive.wp(70),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsive.ip(5),
                                      vertical: responsive.ip(1),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red),
                                    child: Text(
                                      'Completar el pago de pedido',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
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

  void _modalCambiarMetodoPago(
      context, Responsive responsive, String monto, String idPedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final nuevoMetodoPagoBloc = ProviderBloc.npago(context);

        return StreamBuilder(
          stream: nuevoMetodoPagoBloc.selectValorRadioStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return StreamBuilder(
              stream: nuevoMetodoPagoBloc.vueltoStream,
              builder: (BuildContext context, AsyncSnapshot snapshotvuelto) {
                double vuelto = 0;
                if (nuevoMetodoPagoBloc.valorVuelto == null) {
                } else {
                  vuelto = nuevoMetodoPagoBloc.valorVuelto;
                }
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: MediaQuery.of(context).viewInsets,
                    margin: EdgeInsets.only(top: responsive.hp(10)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20),
                          topStart: Radius.circular(20),
                        ),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: responsive.hp(2),
                        left: responsive.wp(5),
                        right: responsive.wp(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Seleccione un nuevo método de pago',
                            style: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  nuevoMetodoPagoBloc.changeValorRadio(0);
                                  //_tipoPagoRadioValue(context, 0, responsive);
                                },
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 0,
                                        groupValue:
                                            nuevoMetodoPagoBloc.valorRadio,
                                        onChanged: (valor) {
                                          nuevoMetodoPagoBloc
                                              .changeValorRadio(valor);
                                          //_tipoPagoRadioValue(context, valor, responsive);
                                        },
                                      ),
                                      Text(
                                        'Pago Con POS',
                                        style: TextStyle(
                                          fontSize: responsive.ip(1.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  nuevoMetodoPagoBloc.changeValorRadio(1);
                                  //_tipoPagoRadioValue(context, 1, responsive);
                                },
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: 1,
                                        groupValue:
                                            nuevoMetodoPagoBloc.valorRadio,
                                        onChanged: (valor) {
                                          nuevoMetodoPagoBloc
                                              .changeValorRadio(valor);
                                          //_tipoPagoRadioValue(context, valor, responsive);
                                        },
                                      ),
                                      Text(
                                        'Efectivo',
                                        style: TextStyle(
                                          fontSize: responsive.ip(1.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: responsive.hp(2),
                          ),
                          (nuevoMetodoPagoBloc.valorRadio.toString() == "1")
                              ? Text(
                                  'Ingresar el monto de pago',
                                  style: TextStyle(
                                      fontSize: responsive.ip(2),
                                      fontWeight: FontWeight.bold),
                                )
                              : Container(),
                          (nuevoMetodoPagoBloc.valorRadio.toString() == "1")
                              ? Row(
                                  children: <Widget>[
                                    Container(
                                      width: responsive.wp(5),
                                      child: Text('S/ '),
                                    ),
                                    Container(
                                      width: responsive.wp(60),
                                      child: TextField(
                                        controller: controllerMonto,
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          if (val.length > 0) {
                                            nuevoMetodoPagoBloc.validarPago(
                                                idPedido, val);
                                          } else {
                                            nuevoMetodoPagoBloc.validarPago(
                                                idPedido, '0');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: responsive.hp(2),
                          ),
                          (nuevoMetodoPagoBloc.valorRadio.toString() == "1")
                              ? Text('Precio : S/ $monto')
                              : Container(),
                          (nuevoMetodoPagoBloc.valorRadio.toString() == "1")
                              ? Row(
                                  children: <Widget>[
                                    (vuelto > 0)
                                        ? Text(
                                            'Vuelto : S/ $vuelto',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text('Vuelto : S/ $vuelto',
                                            style: TextStyle(color: Colors.red))
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: responsive.hp(2),
                          ),
                          (nuevoMetodoPagoBloc.valorRadio.toString() == "1" ||
                                  nuevoMetodoPagoBloc.valorRadio.toString() ==
                                      "0")
                              ? Center(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (nuevoMetodoPagoBloc.valorRadio
                                              .toString() ==
                                          '1') {
                                        if (double.parse(controllerMonto.text) >
                                            double.parse(monto)) {
                                          showProcessingDialog(context);
                                          final ordenesApi = OrdenesApi();
                                          final res = await ordenesApi
                                              .cambiarPagoEfectivo(
                                                  idPedido,
                                                  controllerMonto.text,
                                                  nuevoMetodoPagoBloc
                                                      .valorVuelto
                                                      .toString());
                                          if (res == 1) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            final pedidoBloc =
                                                ProviderBloc.pedido(context);
                                            pedidoBloc.obtenerPedidosPendientes(
                                                context);
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          utils.showToast(
                                              'El monto de pago debe superar el valor del pedido',
                                              2,
                                              ToastGravity.TOP);
                                        }
                                      } else {
                                        //PAgo con tarketa Pos
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.ip(5),
                                        vertical: responsive.ip(1),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.red),
                                      child: Text(
                                        'Confirmar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void showProcessingDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            width: 250.0,
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Validando...",
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    color: Color(0xFF5B6978),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
