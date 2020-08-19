import 'package:enchiladasapp/src/api/categorias_api.dart';
import 'package:enchiladasapp/src/api/ordenes_api.dart';
import 'package:enchiladasapp/src/api/usuario_api.dart';
import 'package:enchiladasapp/src/bloc/provider.dart';
import 'package:enchiladasapp/src/database/carrito_database.dart';
import 'package:enchiladasapp/src/database/direccion_database.dart';
import 'package:enchiladasapp/src/database/usuario_database.dart';
import 'package:enchiladasapp/src/models/carrito_model.dart';
import 'package:enchiladasapp/src/models/direccion_model.dart';
import 'package:enchiladasapp/src/models/pedido_server_model.dart';
import 'package:enchiladasapp/src/models/ruc_model.dart';
import 'package:enchiladasapp/src/models/user.dart';
import 'package:enchiladasapp/src/models/zona_model.dart';
import 'package:enchiladasapp/src/utils/responsive.dart';
import 'package:enchiladasapp/src/utils/utilidades.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DetallePago extends StatefulWidget {
  const DetallePago({Key key}) : super(key: key);

  @override
  _DetallePagoState createState() => _DetallePagoState();
}

class _DetallePagoState extends State<DetallePago> {
  int _comprobanteValue = 3;
  int _tipoPagoValue = 3;
  String ruc = "";
  String razonSocial = "";
  String montoPago = "";
  double precioPedido = 0;
  double vuelto = 0;
  String errorRuc = "";
  bool mostrarErrorRuc = false;
  bool pasoFactura = false;
  bool pasoefectivo = false;
  TextEditingController comprobanteController = TextEditingController();
  TextEditingController tipoPagoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  bool estadoDelivery = false;

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    comprobanteController.dispose();
    tipoPagoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  void _comprobanteRadioValue(BuildContext context, int value) {
    setState(() {
      _comprobanteValue = value;

      switch (_comprobanteValue) {
        case 0:
          ruc = "";
          //_result = ...
          break;
        case 1:
          dialogoValidarRuc();
          break;
      }
    });
  }

  void _tipoPagoRadioValue(
      BuildContext context, int value, Responsive responsive) {
    setState(() {
      _tipoPagoValue = value;

      switch (_tipoPagoValue) {
        case 0:
          //tipoPagoController.text="";
          print('0');
          //_result = ...
          break;
        case 1:
          print('1');
          dialogoIngresarMonto(context, responsive);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = new Responsive.of(context);
    final usuarioBloc = ProviderBloc.user(context);
    final carritoBloc = ProviderBloc.carrito(context);
    carritoBloc.obtenerCarrito();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Orden', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: carritoBloc.carritoIdStream,
        builder: (BuildContext context, AsyncSnapshot<List<Carrito>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _contenido(
                  context, responsive, snapshot.data, usuarioBloc);
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget _contenido(BuildContext context, Responsive responsive,
      List<Carrito> carrito, UsuarioBloc usuarioBloc) {
    final date = DateFormat("dd.MM.yyyy").format(DateTime.now());
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          /* left: responsive.wp(5),
            right: responsive.wp(5), */
          top: responsive.hp(1),
        ),
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.grey[200],
          ),
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(
              'Resumen de Orden',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: responsive.ip(2.5),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: Container(
                height: responsive.hp(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(date.toString(),
                        style: TextStyle(
                            color: Colors.black, fontSize: responsive.ip(2))),
                    Image.asset('assets/logo_enchilada.png'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: responsive.hp(2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: Text('Productos',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(2.5),
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: responsive.hp(2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: _listaProductos(responsive, carrito),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: _deliveryRapido(responsive, carrito),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              color: Colors.grey[200],
              child: Column(
                children: <Widget>[
                  _numeroTelefono(usuarioBloc, context, responsive),
                  Divider(),
                  _direccion(context, responsive),
                  Divider(),
                  _zona(context),
                  Divider(),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: _tipoComprobante(context, responsive),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: _tipoPago(responsive),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              child: _pagarCarrito(context, responsive),
            )
          ],
        ),
      ),
    );
  }

  Widget _listaProductos(Responsive responsive, List<Carrito> carrito) {
    final zonaBloc = ProviderBloc.zona(context);
    zonaBloc.obtenerUsuarioZona();

    return StreamBuilder(
        stream: zonaBloc.zonaUsuarioStream,
        builder: (BuildContext context, AsyncSnapshot<List<Zona>> snapshot) {
          double precio = 0;
          double precioSinDeliveryRapido = 0;
          var deliveryComision = 0.0;
          for (int i = 0; i < carrito.length; i++) {
            if (carrito[i].productoTipo == '1') {
              estadoDelivery = true;
            } else {
              precioSinDeliveryRapido = precioSinDeliveryRapido +
                  double.parse(carrito[i].productoCantidad) *
                      double.parse(carrito[i].productoPrecio);
            }
            precio = precio +
                double.parse(carrito[i].productoCantidad) *
                    double.parse(carrito[i].productoPrecio);
          }

          precioPedido = precio;

          var total = Column(
            children: <Widget>[
              (deliveryComision > 0)
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(vertical: responsive.hp(0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text('COMISIÓN POR DELIVERY',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: responsive.ip(1.5))),
                          ),
                          Text('S/.$precio',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.ip(1.5))),
                        ],
                      ),
                    )
                  : Container(),
              Container(
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
                    Text('S/.$precioPedido',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: responsive.ip(2),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          );

          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              if (precioSinDeliveryRapido >
                  double.parse(snapshot.data[0].zonaPedidoMinimo)) {
                deliveryComision = 0;
              } else {
                deliveryComision = double.parse(snapshot.data[0].zonaPrecio);
              }
              precioPedido = precioPedido + deliveryComision;
              total = Column(
                children: <Widget>[
                  (deliveryComision > 0)
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              vertical: responsive.hp(0.5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text('COMISIÓN POR DELIVERY',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: responsive.ip(1.5))),
                              ),
                              Text('S/.$deliveryComision',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: responsive.ip(1.5))),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
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
                        Text('S/.$precioPedido',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              );

              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: carrito.length + 1,
                  itemBuilder: (context, i) {
                    if (i == carrito.length) {
                      return total;
                    }
                    return _productos(responsive, carrito[i]);
                  });
            } else {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: carrito.length + 1,
                  itemBuilder: (context, i) {
                    if (i == carrito.length) {
                      return total;
                    }
                    return _productos(responsive, carrito[i]);
                  });
            }
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: carrito.length + 1,
                itemBuilder: (context, i) {
                  if (i == carrito.length) {
                    return total;
                  }
                  return _productos(responsive, carrito[i]);
                });
          }
        });
  }

  Widget _productos(Responsive responsive, Carrito carrito) {
    String nombre = "";
    double precio = double.parse(carrito.productoCantidad) *
        double.parse(carrito.productoPrecio);
    if (int.parse(carrito.productoCantidad) > 1) {
      nombre = "${carrito.productoNombre} x ${carrito.productoCantidad}";
    } else {
      nombre = "${carrito.productoNombre}";
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
          Text('S/.$precio',
              style:
                  TextStyle(color: Colors.black, fontSize: responsive.ip(1.5))),
        ],
      ),
    );
  }

  Widget _numeroTelefono(
      UsuarioBloc usuarioBloc, BuildContext context, Responsive responsive) {
    return StreamBuilder(
        stream: usuarioBloc.usuarioStream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          String telefono = '-';
          String agregar = 'Agregar';
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              if (snapshot.data[0].telefono != "") {
                telefono = snapshot.data[0].telefono;
                agregar = 'Cambiar';

                return _telefono(telefono, agregar, responsive);
              } else {
                return _telefono(telefono, agregar, responsive);
              }
            } else {
              return _telefono(telefono, agregar, responsive);
            }
          } else {
            return _telefono(telefono, agregar, responsive);
          }
        });
  }

  Widget _telefono(String telefono, String agregar, Responsive responsive) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Número de Teléfono',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2))),
              FlatButton(
                child: Text(
                  '$agregar',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  dialogoIngresarTelefono();
                },
              ),
            ],
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Text('+51 ',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2.1))),
            Text('$telefono',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2.1)))
          ])
        ]);
  }

  Widget _direccion(BuildContext context, Responsive responsive) {
    final direcionBloc = ProviderBloc.dire(context);
    direcionBloc.obtenerDireccion();

    return StreamBuilder(
      stream: direcionBloc.direccionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Direccion>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return direction(snapshot.data[snapshot.data.length - 1].direccion,
                snapshot.data[0].referencia, responsive);
          } else {
            return direction("", "", responsive);
          }
        } else {
          return direction("", "", responsive);
        }
      },
    );
  }

  Widget direction(String addres, String referencia, Responsive responsive) {
    String addresito;
    String agg;
    String ref;

    if (addres == "" || addres == null) {
      addresito = "-";
      agg = "Agregar";
    } else {
      addresito = addres;
      agg = "Cambiar";
    }
    if (referencia == "" || addres == null) {
      ref = "Sin Datos";
    } else {
      ref = referencia;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Dirección de envío',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(2))),
          FlatButton(
            child: Text(
              '$agg',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'sel_Direccion');
            },
          ),
        ],
      ),
      Text(
        '$addresito',
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: responsive.ip(2)),
      ),
      SizedBox(
        height: 5,
      ),
      Row(children: <Widget>[
        Text('Referencia : ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        Text('$ref'),
      ])
    ]);
  }

  Widget _tipoComprobante(BuildContext context, Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Comprobante de pago',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: responsive.ip(2),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _comprobanteRadioValue(context, 0);
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _comprobanteValue,
                      onChanged: (valor) {
                        _comprobanteRadioValue(context, valor);
                      },
                    ),
                    Text(
                      'Boleta',
                      style: new TextStyle(fontSize: responsive.ip(1.8)),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _comprobanteRadioValue(context, 1);
              },
              child: Container(
                  child: Row(
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: _comprobanteValue,
                    onChanged: (valor) {
                      _comprobanteRadioValue(context, valor);
                    },
                  ),
                  Text(
                    'Factura',
                    style: new TextStyle(
                      fontSize: responsive.ip(1.8),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
        (ruc != "")
            ? Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Razon Social : ',
                        style: TextStyle(
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                      Expanded(
                        child: Text('$razonSocial',
                            style: TextStyle(
                                fontSize: responsive.ip(1.8),
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Ruc : ',
                        style: new TextStyle(
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                      Text('$ruc',
                          style: new TextStyle(
                              fontSize: responsive.ip(1.8),
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              )
            : Text(
                '$errorRuc',
                style: new TextStyle(
                    fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
              )
      ],
    );
  }

  Widget _tipoPago(Responsive responsive) {
    montoPago = tipoPagoController.text;
    vuelto = 0;
    if (montoPago != null && montoPago != "") {
      vuelto = double.parse(montoPago) - precioPedido;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Tipo de pago',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(1.8))),
        GestureDetector(
          onTap: () {
            _tipoPagoRadioValue(context, 0, responsive);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _tipoPagoRadioValue(context, 0, responsive);
                },
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _tipoPagoValue,
                      onChanged: (valor) {
                        _tipoPagoRadioValue(context, valor, responsive);
                      },
                    ),
                    Text(
                      'Pago Online',
                      style: TextStyle(fontSize: responsive.ip(1.8)),
                    ),
                  ],
                )),
              ),
              GestureDetector(
                onTap: () {
                  _tipoPagoRadioValue(context, 1, responsive);
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: _tipoPagoValue,
                        onChanged: (valor) {
                          _tipoPagoRadioValue(context, valor, responsive);
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
        ),
        (montoPago != "" && montoPago != null)
            ? (vuelto < 0)
                ? Container(
                    child: Text(
                        'El monto de pago debe ser superior al precio de la orden',
                        style: TextStyle(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.bold)))
                : Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Monto de Pago : ',
                              style: TextStyle(
                                fontSize: responsive.ip(1.8),
                              )),
                          Expanded(
                            child: Text('$montoPago',
                                style: TextStyle(
                                    fontSize: responsive.ip(1.8),
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Vuelto ',
                              style: TextStyle(
                                fontSize: responsive.ip(1.8),
                              )),
                          Text('$vuelto',
                              style: TextStyle(
                                  fontSize: responsive.ip(1.8),
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  )
            : Container()
      ],
    );
  }

  Widget _pagarCarrito(BuildContext context, Responsive responsive) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(2)),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text(
                      'Realizar Pedido',
                      style: TextStyle(fontSize: responsive.ip(2)),
                    ),
                    onPressed: () {
                      _pagarcarrito();
                      //Navigator.pushNamed(context, 'detallePago');
                    }),
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  void dialogoIngresarMonto(BuildContext context, Responsive responsive) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Ingrese el monto con el que pagará'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: tipoPagoController,
                  keyboardType: TextInputType.number,
                ),
                //Text('Producto agregado al carrito correctamente'),
                SizedBox(
                  height: responsive.hp(1),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancelar')),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text('validar')),
            ],
          );
        });
  }

  void dialogoValidarRuc() {
    final usuarioApi = UsuarioApi();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Ingrese su número de RUC'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: comprobanteController,
                ),
                //Text('Producto agregado al carrito correctamente'),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancelar')),
              FlatButton(
                  onPressed: () async {
                    if (comprobanteController.text.length > 0) {
                      Navigator.pop(context);
                      showProcessingDialog();
                      final List<Ruc> dato = await usuarioApi
                          .consultarRuc(comprobanteController.text);

                      if (dato.length > 0) {
                        Navigator.pop(context);
                        ruc = dato[0].ruc;
                        razonSocial = dato[0].razonSocial;
                        mostrarErrorRuc = false;
                        setState(() {});
                      } else {
                        print('fue pe');
                        _comprobanteRadioValue(context, 0);
                        errorRuc = 'Ingrese un RUC válido';
                        mostrarErrorRuc = true;
                        Navigator.pop(context);
                      }
                    } else {
                      utils.showToast('el campo no debe estar vacio', 2);
                    }
                  },
                  child: Text('validar')),
            ],
          );
        });
  }

  void showProcessingDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                        Text("Validando...",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                color: Color(0xFF5B6978)))
                      ])));
        });
  }

  void dialogoIngresarTelefono() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (contextd) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Ingrese su número de Teléfono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: telefonoController,
                keyboardType: TextInputType.number,
              ),
              //Text('Producto agregado al carrito correctamente'),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            FlatButton(
              onPressed: () async {
                utils.agregarTelefono(context, telefonoController.text);

                Navigator.pop(context);
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  void _pagarcarrito() async {
    final pedidoApi = OrdenesApi();
    final usuarioDatabase = UsuarioDatabase();
    final direccionDatabase = DireccionDatabase();

    final user = await usuarioDatabase.obtenerUsUario();
    final direccion = await direccionDatabase.obtenerdireccion();

    if (direccion[0].direccion != "" && direccion[0].direccion != null) {
      if (user[0].idZona != "" && user[0].idZona != null) {
        if (user[0].telefono != "" && user[0].telefono != null) {
          PedidoServer pedido = new PedidoServer();
          if (_comprobanteValue == 0) {
            //selecciona Boleta
            pedido.pedidoTipoComprobante = "6";
            pedido.pedidoCodPersona = "1";
            pasoFactura = true;
          } else {
            //seleccciona Factura
            pedido.pedidoTipoComprobante = "7";
            pedido.pedidoCodPersona = "2";
            if (ruc == "") {
              pasoFactura = false;
            } else {
              pasoFactura = true;
            }
          }
          pedido.pedidoMontoFinal = precioPedido.toString();
          if (_tipoPagoValue == 0) {
            pedido.pedidoMontoPago = '0';
            pedido.pedidoVueltoPago = "0";
            pedido.pedidoFormaPago = "3";
            pedido.pedidoEstadoPago = "0";
            pasoefectivo = true;
          } else {
            pedido.pedidoMontoPago = montoPago;
            pedido.pedidoVueltoPago = vuelto.toString();
            pedido.pedidoFormaPago = "4";
            pedido.pedidoEstadoPago = "1";
            if (vuelto < 0) {
              pasoefectivo = false;
            } else {
              pasoefectivo = true;
            }
          }

          if (pasoefectivo) {
            if (pasoFactura) {
              showProcessingDialog();
              final res = await pedidoApi.enviarpedido(pedido);
              print('respuesta de la ptmr $res');
              if (res.resp == 1) {

                print(res.link);
                //final carritoBloc = ProviderBloc.carrito(context);
                Navigator.pop(context);
                pedidoCorrecto();
                /* final carritoDatabase = CarritoDatabase();
                carritoDatabase.deleteCarritoDb();
                utils.agregarZona(context, '');
                carritoBloc.obtenerCarrito(); */
              } else if (res == 8) {
                utils.showToast(
                    'Estamos actualizando los datos de los productos, intentelo más tarde',
                    2);
                //OCURRIO UNA ACTUALIZACION DE PRODUCTOS
                final categoriasApi = CategoriasApi();
                categoriasApi.obtenerAmbos();
                Navigator.pop(context);
              } else {
                utils.showToast('Ocurrio un error, intentelo más tarde', 2);
                //Ocurrio un error
                Navigator.pop(context);
              }
            } else {
              utils.showToast('Debe ingresar un Comprobante de pago válido', 2);
            }
          } else {
            utils.showToast('Debe ingresar un Tipo de pago válido', 2);
          }
        } else {
          utils.showToast('Ingrese un número de teléfono de entrega', 2);
        }
      } else {
        utils.showToast('Debe registrar una zona de entrega', 2);
      }
    } else {
      utils.showToast('Ingrese una dirección de entrega', 2);
    }
  }

  void pedidoCorrecto() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (contextd) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Su pedido fue ingresado Correctamente'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.of(context).pop();

                    final carritoBloc = ProviderBloc.carrito(context);
                    final carritoDatabase = CarritoDatabase();
                    carritoDatabase.deleteCarritoDb();
                    utils.agregarZona(context, '');
                    carritoBloc.obtenerCarrito();
                  },
                  child: Text('Continuar')),
            ],
          );
        });
  }

  Widget _zona(BuildContext context) {
    final zonaBloc = ProviderBloc.zona(context);
    //zonaBloc.obtenerUsuarioZona();

    return StreamBuilder(
      stream: zonaBloc.zonaUsuarioStream,
      builder: (BuildContext context, AsyncSnapshot<List<Zona>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return zonaDatos(context, 'Cambiar', snapshot.data);
          } else {
            return zonadatosFalsos(context);
          }
        } else {
          return zonadatosFalsos(context);
        }
      },
    );
  }

  Widget zonadatosFalsos(BuildContext context) {
    final responsive = Responsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Zona de entrega',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2))),
            FlatButton(
              child: Text(
                'Agregar',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'selZona', arguments: 'pago');
              },
            ),
          ],
        ),
        Text(
          'Elegir Zona',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(2)),
        ),
      ],
    );
  }

  Widget zonaDatos(BuildContext context, String agregar, List<Zona> zonas) {
    final responsive = Responsive.of(context);
    var zonacitos = 'Elegir zona';
    if (zonas != null) {
      if (zonas.length > 0) {
        zonacitos = zonas[0].zonaNombre;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Zona de entrega',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2))),
            FlatButton(
              child: Text(
                '$agregar',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'selZona', arguments: 'pago');
              },
            ),
          ],
        ),
        Text(
          '$zonacitos',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(2)),
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Text(
          'El monto de su pedido debe ser mayor a ${zonas[0].zonaPedidoMinimo}, sino se le agregará una comisión de ${zonas[0].zonaPrecio} soles.',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(1.3)),
        ),
      ],
    );
  }

  Widget _deliveryRapido(Responsive responsive, List<Carrito> carrito) {
    for (int i = 0; i < carrito.length; i++) {
      if (carrito[i].productoTipo == '1') {
        estadoDelivery = true;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Agregar entrega rápida',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2))),
            Switch.adaptive(
              value: estadoDelivery,
              onChanged: (bool state) async {
                print(state);
                estadoDelivery = state;

                if (estadoDelivery) {
                  utils.agregarDeliveryRapido(context);
                } else {
                  utils.quitarDeliveryRapido(context);
                }
                //setState(() {});
              },
            ),
          ],
        ),
        Text(
          'Tu pedido llegará en máximo 1 hora',
          textAlign: TextAlign.start,
        )
      ],
    );
  }
}
